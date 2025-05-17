import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tictask/features/auth/data/models/user_model.dart';

abstract class AuthDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
  Future<void> resendVerificationEmail(String email);
}

class AuthDataSourceImpl implements AuthDataSource {
  final SupabaseClient _supabaseClient;

  AuthDataSourceImpl(this._supabaseClient);

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Login failed. User not found.');
      }

      return UserModel.fromSupabaseUser(response.user!);
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    try {
      // Step 1: Create user in Supabase Auth with name in user metadata
      // Add the name directly during signup to avoid the separate updateUser call
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': name}, // Include user metadata directly
      );

      if (response.user == null) {
        throw Exception('Registration failed. User not created.');
      }

      // Step 2: Create entry in users table - we need to wait for user to be fully created
      try {
        await _supabaseClient.from('users').insert({
          'id': response.user!.id,
          'email': email,
          'full_name': name,
          'created_at': DateTime.now().toIso8601String(),
        });
      } catch (tableError) {
        // If there was an error adding to the users table, we'll still return the created user
        // and log the error but not fail the registration
        print('Warning: Could not add user to users table: $tableError');
      }

      return UserModel.fromSupabaseUser(response.user!);
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _supabaseClient.auth.signOut();
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final currentUser = _supabaseClient.auth.currentUser;

      if (currentUser == null) {
        return null;
      }

      return UserModel.fromSupabaseUser(currentUser);
    } catch (e) {
      throw Exception('Get current user failed: ${e.toString()}');
    }
  }

  @override
  Future<void> resendVerificationEmail(String email) async {
    try {
      await _supabaseClient.auth.resend(
        type: OtpType.email,
        email: email,
      );
    } catch (e) {
      throw Exception('Failed to resend verification email: ${e.toString()}');
    }
  }
}
