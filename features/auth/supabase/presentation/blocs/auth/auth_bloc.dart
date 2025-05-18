import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_app/features/auth/domain/entities/user_entity.dart';
import 'package:my_flutter_app/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:my_flutter_app/features/auth/domain/usecases/login_user.dart';
import 'package:my_flutter_app/features/auth/domain/usecases/logout_user.dart';
import 'package:my_flutter_app/features/auth/domain/usecases/register_user.dart';
import 'package:my_flutter_app/features/auth/domain/usecases/resend_verification_email.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final LogoutUser logoutUser;
  final RegisterUser registerUser;
  final CheckAuthStatusUseCase checkAuthStatus;
  final ResendVerificationEmail resendVerificationEmail;

  AuthBloc({
    required this.loginUser,
    required this.logoutUser,
    required this.registerUser,
    required this.checkAuthStatus,
    required this.resendVerificationEmail,
  }) : super(const AuthState(status: AuthStatus.initial)) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthResendVerificationEmailRequested>(
        _onResendVerificationEmailRequested);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = await loginUser(event.email, event.password);

      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await logoutUser();
      emit(const AuthState(status: AuthStatus.unauthenticated));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = await registerUser(event.name, event.email, event.password);

      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = await checkAuthStatus();

      if (user != null) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
        ));
      } else {
        emit(const AuthState(status: AuthStatus.unauthenticated));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onResendVerificationEmailRequested(
    AuthResendVerificationEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await resendVerificationEmail(event.email);

      // On success, emit a message but keep current state
      emit(state.copyWith(
        verificationEmailSent: true,
      ));

      // Reset the flag after a short delay
      await Future.delayed(const Duration(seconds: 5));
      emit(state.copyWith(
        verificationEmailSent: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: state.status, // Keep current status
        errorMessage: 'Failed to resend verification email: ${e.toString()}',
      ));
    }
  }
}
