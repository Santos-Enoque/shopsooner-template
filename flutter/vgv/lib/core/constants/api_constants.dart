/// API related constants
class ApiConstants {
  /// API endpoints
  static const endpoints = _Endpoints();

  /// API headers
  static const headers = _Headers();
}

/// API endpoints
class _Endpoints {
  const _Endpoints();

  /// Users API endpoint
  String get users => '/users';

  /// Posts API endpoint
  String get posts => '/posts';
}

/// API headers
class _Headers {
  const _Headers();

  /// Content type JSON header
  Map<String, String> get json => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// Authorization header
  Map<String, String> authorization(String token) => {
        ...json,
        'Authorization': 'Bearer $token',
      };
}
