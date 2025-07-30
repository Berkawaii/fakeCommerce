import 'package:f_commerce/core/api/api_client.dart';
import 'package:f_commerce/core/storage/storage_service.dart';
import 'package:f_commerce/features/auth/data/auth_model.dart';
import 'package:f_commerce/features/auth/data/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final StorageService _storageService;

  AuthRepository({
    required ApiClient apiClient,
    required StorageService storageService,
  }) : _apiClient = apiClient,
       _storageService = storageService;

  // Login user
  Future<AuthResponse> login(String username, String password) async {
    final authRequest = AuthRequest(username: username, password: password);

    final response = await _apiClient.post<AuthResponse>(
      endpoint: '/auth/login',
      data: authRequest.toJson(),
      converter: (data) => AuthResponse.fromJson(data as Map<String, dynamic>),
    );

    // Save token
    await _storageService.saveAuthToken(response.token);

    // Update API client with the token
    _apiClient.setAuthToken(response.token);

    return response;
  }

  // Register user
  Future<User> register(User user) async {
    return _apiClient.post<User>(
      endpoint: '/users',
      data: user.toJson(),
      converter: (data) => User.fromJson(data as Map<String, dynamic>),
    );
  }

  // Get user details
  Future<User> getUserDetails(int userId) async {
    return _apiClient.get<User>(
      endpoint: '/users/$userId',
      converter: (data) => User.fromJson(data as Map<String, dynamic>),
    );
  }

  // Update user
  Future<User> updateUser(int userId, User user) async {
    return _apiClient.put<User>(
      endpoint: '/users/$userId',
      data: user.toJson(),
      converter: (data) => User.fromJson(data as Map<String, dynamic>),
    );
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _storageService.getAuthToken();
    return token != null;
  }

  // Logout
  Future<void> logout() async {
    await _storageService.clearAllData();
  }
}
