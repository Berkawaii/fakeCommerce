import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:f_commerce/core/api/api_client.dart';
import 'package:f_commerce/core/storage/storage_service.dart';
import 'package:f_commerce/features/auth/data/auth_repository.dart';
import 'package:f_commerce/features/cart/data/cart_repository.dart';
import 'package:f_commerce/features/products/data/product_repository.dart';

// Core providers
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

// Repository providers
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    apiClient: ref.watch(apiClientProvider),
    storageService: ref.watch(storageServiceProvider),
  );
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(
    apiClient: ref.watch(apiClientProvider),
    storageService: ref.watch(storageServiceProvider),
  );
});

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepository(
    apiClient: ref.watch(apiClientProvider),
    storageService: ref.watch(storageServiceProvider),
  );
});
