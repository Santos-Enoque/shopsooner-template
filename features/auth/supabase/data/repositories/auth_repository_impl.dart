import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:vgv/features/auth/data/datasources/auth_datasource.dart';
import 'package:vgv/features/auth/domain/entities/user_entity.dart';
import 'package:vgv/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

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

    // For web platform, we rely only on connectivity_plus result
    if (kIsWeb) {
      return connectivityResult != ConnectivityResult.none;
    }

    // If connectivity_plus reports we have connectivity, let's verify with a simple lookup
    if (connectivityResult != ConnectivityResult.none) {
      try {
        // On macOS, perform a simple HTTP request instead of DNS lookup
        if (Platform.isMacOS) {
          try {
            // Use a reliable endpoint with a GET request and short timeout
            final response = await http.get(
              Uri.parse('https://www.google.com'),
              headers: {'Connection': 'close'},
            ).timeout(const Duration(seconds: 5));

            return response.statusCode >= 200 && response.statusCode < 300;
          } catch (_) {
            // If HTTP request fails, try one more reliable endpoint
            try {
              final response = await http.get(
                Uri.parse('https://www.apple.com'),
                headers: {'Connection': 'close'},
              ).timeout(const Duration(seconds: 5));

              return response.statusCode >= 200 && response.statusCode < 300;
            } catch (_) {
              return false;
            }
          }
        } else {
          // For other platforms (iOS, Android), perform the lookup as before
          final result = await InternetAddress.lookup('google.com')
              .timeout(const Duration(seconds: 5));
          return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
        }
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
