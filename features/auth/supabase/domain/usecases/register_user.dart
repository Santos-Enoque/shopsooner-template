import 'package:tictask/features/auth/domain/entities/user_entity.dart';
import 'package:tictask/features/auth/domain/repositories/auth_repository.dart';

class RegisterUser {
  final AuthRepository repository;

  RegisterUser(this.repository);

  Future<UserEntity> call(String name, String email, String password) async {
    return await repository.register(name, email, password);
  }
}