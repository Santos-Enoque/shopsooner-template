import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:my_flutter_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:my_flutter_app/features/auth/domain/models/models.dart';
import 'package:my_flutter_app/features/auth/presentation/blocs/auth/auth_barrel.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthBloc _authBloc;
  late StreamSubscription<AuthState> _authSubscription;

  RegisterBloc({required AuthBloc authBloc})
      : _authBloc = authBloc,
        super(const RegisterState()) {
    on<RegisterNameChanged>(_onNameChanged);
    on<RegisterEmailChanged>(_onEmailChanged);
    on<RegisterPasswordChanged>(_onPasswordChanged);
    on<RegisterSubmitted>(_onSubmitted);
    on<RegisterAuthFailure>(_onAuthFailure);

    // Listen to auth state changes to catch auth failures
    _authSubscription = _authBloc.stream.listen((authState) {
      if (authState.status == AuthStatus.failure &&
          authState.errorMessage != null) {
        add(RegisterAuthFailure(message: authState.errorMessage!));
      }
    });
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }

  void _onNameChanged(
    RegisterNameChanged event,
    Emitter<RegisterState> emit,
  ) {
    final name = Name.dirty(event.name);
    emit(state.copyWith(
      name: name,
      isValid: Formz.validate([name, state.email, state.password]),
      status: FormzSubmissionStatus.initial,
    ));
  }

  void _onEmailChanged(
    RegisterEmailChanged event,
    Emitter<RegisterState> emit,
  ) {
    final email = Email.dirty(event.email);
    emit(state.copyWith(
      email: email,
      isValid: Formz.validate([state.name, email, state.password]),
      status: FormzSubmissionStatus.initial,
    ));
  }

  void _onPasswordChanged(
    RegisterPasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(state.copyWith(
      password: password,
      isValid: Formz.validate([state.name, state.email, password]),
      status: FormzSubmissionStatus.initial,
    ));
  }

  void _onAuthFailure(
    RegisterAuthFailure event,
    Emitter<RegisterState> emit,
  ) {
    // Format network errors for better user display
    String errorMessage = event.message;
    if (errorMessage.contains("Operation not permitted") ||
        errorMessage.contains("Connection failed")) {
      errorMessage =
          "No internet connection. Please check your network settings and try again.";
    }

    emit(state.copyWith(
      status: FormzSubmissionStatus.failure,
      errorMessage: errorMessage,
    ));
  }

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    final name = Name.dirty(state.name.value);
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    emit(state.copyWith(
      name: name,
      email: email,
      password: password,
      isValid: Formz.validate([name, email, password]),
    ));

    if (!state.isValid) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      _authBloc.add(AuthRegisterRequested(
        name: state.name.value,
        email: state.email.value,
        password: state.password.value,
      ));
      // Don't emit success here - let the auth subscription handle it
    } catch (e) {
      String errorMessage = e.toString();
      if (e is NetworkException) {
        errorMessage = e.message;
      }
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: errorMessage,
      ));
    }
  }
}
