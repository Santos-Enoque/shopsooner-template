import 'package:tictask/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> register(String name, String email, String password);
  Future<void> logout();
  Future<UserEntity?> getCurrentUser();
  Future<void> resendVerificationEmail(String email);
}
