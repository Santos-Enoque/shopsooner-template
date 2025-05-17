import 'package:tictask/features/auth/domain/repositories/auth_repository.dart';

class ResendVerificationEmail {
  final AuthRepository repository;

  ResendVerificationEmail(this.repository);

  Future<void> call(String email) async {
    await repository.resendVerificationEmail(email);
  }
}
