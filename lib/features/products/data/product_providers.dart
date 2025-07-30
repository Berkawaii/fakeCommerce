import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:f_commerce/features/products/data/product_model.dart';
import 'package:f_commerce/core/providers/providers.dart';

// Product providers
final productListProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getAllProducts();
});

final productCategoriesProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getAllCategories();
});

final categoryProductsProvider = FutureProvider.family<List<Product>, String>((ref, category) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProductsByCategory(category);
});

final productDetailsProvider = FutureProvider.family<Product, int>((ref, productId) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProductById(productId);
});
