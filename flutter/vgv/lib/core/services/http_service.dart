import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vgv/config/app_config.dart';
import 'package:vgv/core/exceptions/network_exception.dart';

/// HTTP service for making API requests
class HttpService {
  /// Creates a new HTTP service with the given app configuration
  HttpService({required this.config});

  /// Application configuration
  final AppConfig config;

  /// HTTP client
  final http.Client _client = http.Client();

  /// Make a GET request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse('${config.apiBaseUrl}$endpoint');
      final response = await _client.get(uri, headers: headers);
      return _handleResponse(response);
    } catch (e) {
      throw NetworkException('Failed to perform GET request: $e');
    }
  }

  /// Make a POST request
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse('${config.apiBaseUrl}$endpoint');
      final response = await _client.post(
        uri,
        body: body != null ? jsonEncode(body) : null,
        headers: headers,
      );
      return _handleResponse(response);
    } catch (e) {
      throw NetworkException('Failed to perform POST request: $e');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw NetworkException(
        'Request failed with status code: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
  }
}
