import 'package:vgv/core/constants/api_constants.dart';
import 'package:vgv/core/services/http_service.dart';
import 'package:vgv/shared/models/user.dart';

/// Repository for user-related operations
class UserRepository {
  /// Creates a new user repository
  const UserRepository({required this.httpService});

  /// HTTP service for API requests
  final HttpService httpService;

  /// Get a list of users
  Future<List<User>> getUsers() async {
    final response = await httpService.get(ApiConstants.endpoints.users);
    final users = (response['data'] as List)
        .map((json) => User.fromJson(json as Map<String, dynamic>))
        .toList();
    return users;
  }

  /// Get a user by ID
  Future<User> getUserById(String id) async {
    final response =
        await httpService.get('${ApiConstants.endpoints.users}/$id');
    return User.fromJson(response['data'] as Map<String, dynamic>);
  }

  /// Create a new user
  Future<User> createUser(User user) async {
    final response = await httpService.post(
      ApiConstants.endpoints.users,
      body: user.toJson(),
      headers: ApiConstants.headers.json,
    );
    return User.fromJson(response['data'] as Map<String, dynamic>);
  }
}
