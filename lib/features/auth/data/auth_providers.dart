import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:f_commerce/features/auth/data/user_model.dart';
import 'package:f_commerce/core/providers/providers.dart';
import 'package:f_commerce/features/auth/data/auth_repository.dart';

// Auth state
class AuthState {
  final bool isAuthenticated;
  final User? user;
  final String? errorMessage;
  final bool isLoading;

  AuthState({
    this.isAuthenticated = false,
    this.user,
    this.errorMessage,
    this.isLoading = false,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    User? user,
    String? errorMessage,
    bool? isLoading,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      errorMessage: errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(AuthState()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final isLoggedIn = await _authRepository.isLoggedIn();
      if (isLoggedIn) {
        state = state.copyWith(isAuthenticated: true);
      }
    } catch (e) {
      state = state.copyWith(
        isAuthenticated: false,
        errorMessage: "Authentication error",
      );
    }
  }

  Future<void> login(String username, String password) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      await _authRepository.login(username, password);

      // Here we would typically fetch user data after login
      // For simplicity, we're just updating the auth state
      state = state.copyWith(isAuthenticated: true, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> register(User user) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      await _authRepository.register(user);

      // Automatically login after registration
      await login(user.username, user.password!);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> logout() async {
    try {
      state = state.copyWith(isLoading: true);
      await _authRepository.logout();
      state = AuthState();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

// Auth providers
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository);
});
