import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:tictask/features/auth/data/datasources/auth_datasource.dart';
import 'package:tictask/features/auth/domain/entities/user_entity.dart';
import 'package:tictask/features/auth/domain/repositories/auth_repository.dart';

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);

  @override
  String toString() => message;
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource dataSource;
  final Connectivity connectivity = Connectivity();

  AuthRepositoryImpl({required this.dataSource});

  Future<bool> _checkConnectivity() async {
    // First, check connectivity status using connectivity_plus
    final connectivityResult = await connectivity.checkConnectivity();

    // If connectivity_plus reports we have connectivity, let's verify with a simple lookup
    if (connectivityResult != ConnectivityResult.none) {
      try {
        // Try to access a reliable domain with a short timeout to verify actual connectivity
        // This is especially important for macOS where connectivity_plus might report
        // connected even when the network is not fully functional
        final result = await InternetAddress.lookup('google.com')
            .timeout(const Duration(seconds: 5));

        return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } catch (_) {
        // If we can't reach google.com, assume no connectivity
        return false;
      }
    }

    return false;
  }

  @override
  Future<UserEntity> login(String email, String password) async {
    if (!await _checkConnectivity()) {
      throw NetworkException(
          'No internet connection. Please check your network settings and try again.');
    }
    return await dataSource.login(email, password);
  }

  @override
  Future<UserEntity> register(
      String name, String email, String password) async {
    if (!await _checkConnectivity()) {
      throw NetworkException(
          'No internet connection. Please check your network settings and try again.');
    }
    return await dataSource.register(name, email, password);
  }

  @override
  Future<void> logout() async {
    if (!await _checkConnectivity()) {
      throw NetworkException(
          'No internet connection. Please check your network settings and try again.');
    }
    await dataSource.logout();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    // For getCurrentUser, we can try to return cached data even without connectivity
    try {
      return await dataSource.getCurrentUser();
    } catch (e) {
      if (!await _checkConnectivity()) {
        throw NetworkException(
            'No internet connection. Please check your network settings and try again.');
      }
      rethrow;
    }
  }

  @override
  Future<void> resendVerificationEmail(String email) async {
    if (!await _checkConnectivity()) {
      throw NetworkException(
          'No internet connection. Please check your network settings and try again.');
    }
    await dataSource.resendVerificationEmail(email);
  }
}
