import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:my_flutter_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:my_flutter_app/features/auth/domain/models/models.dart';
import 'package:my_flutter_app/features/auth/presentation/blocs/auth/auth_barrel.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthBloc _authBloc;
  late StreamSubscription<AuthState> _authSubscription;

  LoginBloc({required AuthBloc authBloc})
      : _authBloc = authBloc,
        super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
    on<LoginAuthFailure>(_onAuthFailure);

    // Listen to auth state changes to catch auth failures
    _authSubscription = _authBloc.stream.listen((authState) {
      if (authState.status == AuthStatus.failure &&
          authState.errorMessage != null) {
        add(LoginAuthFailure(message: authState.errorMessage!));
      }
    });
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }

  void _onEmailChanged(
    LoginEmailChanged event,
    Emitter<LoginState> emit,
  ) {
    final email = Email.dirty(event.email);
    emit(state.copyWith(
      email: email,
      isValid: Formz.validate([email, state.password]),
      status: FormzSubmissionStatus.initial,
    ));
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(state.copyWith(
      password: password,
      isValid: Formz.validate([state.email, password]),
      status: FormzSubmissionStatus.initial,
    ));
  }

  void _onAuthFailure(
    LoginAuthFailure event,
    Emitter<LoginState> emit,
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
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    emit(state.copyWith(
      email: email,
      password: password,
      isValid: Formz.validate([email, password]),
    ));

    if (!state.isValid) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      _authBloc.add(AuthLoginRequested(
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
