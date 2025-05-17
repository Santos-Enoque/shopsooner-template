import 'package:equatable/equatable.dart';
import 'package:tictask/features/auth/domain/entities/user_entity.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, failure }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? errorMessage;
  final UserEntity? user;
  final bool verificationEmailSent;

  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.user,
    this.verificationEmailSent = false,
  });

  bool get isAuthenticated => status == AuthStatus.authenticated;

  String? get userId => user?.id;
  String? get userEmail => user?.email;
  String? get userName => user?.name;

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    UserEntity? user,
    bool? verificationEmailSent,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
      verificationEmailSent:
          verificationEmailSent ?? this.verificationEmailSent,
    );
  }

  @override
  List<Object?> get props =>
      [status, errorMessage, user, verificationEmailSent];
}
