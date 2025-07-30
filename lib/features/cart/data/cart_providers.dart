import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:f_commerce/features/cart/data/cart_model.dart';
import 'package:f_commerce/features/products/data/product_model.dart';
import 'package:f_commerce/core/providers/providers.dart';
import 'package:f_commerce/features/cart/data/cart_repository.dart';

// Cart state
class CartState {
  final List<CartItem> items;
  final bool isLoading;
  final String? errorMessage;

  CartState({this.items = const [], this.isLoading = false, this.errorMessage});

  double get total =>
      items.fold(0, (sum, item) => sum + (item.price ?? 0) * item.quantity);

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  CartState copyWith({
    List<CartItem>? items,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class CartNotifier extends StateNotifier<CartState> {
  final CartRepository _cartRepository;

  CartNotifier(this._cartRepository) : super(CartState()) {
    _loadCart();
  }

  Future<void> _loadCart() async {
    try {
      final items = _cartRepository.getLocalCart();
      state = state.copyWith(items: items);
    } catch (e) {
      state = state.copyWith(
        errorMessage: "Failed to load cart: ${e.toString()}",
      );
    }
  }

  Future<void> addToCart(Product product, int quantity) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      await _cartRepository.addToCart(product, quantity);

      // Reload cart
      await _loadCart();

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Failed to add item: ${e.toString()}",
      );
    }
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      await _cartRepository.updateCartItemQuantity(productId, quantity);

      // Reload cart
      await _loadCart();

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Failed to update quantity: ${e.toString()}",
      );
    }
  }

  Future<void> removeItem(int productId) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      await _cartRepository.removeFromCart(productId);

      // Reload cart
      await _loadCart();

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Failed to remove item: ${e.toString()}",
      );
    }
  }

  Future<void> clearCart() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      await _cartRepository.clearCart();

      state = state.copyWith(isLoading: false, items: []);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Failed to clear cart: ${e.toString()}",
      );
    }
  }

  Future<void> checkout(int userId) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      await _cartRepository.createOrder(userId);

      state = state.copyWith(isLoading: false, items: []);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Checkout failed: ${e.toString()}",
      );
    }
  }
}

// Cart providers
final cartStateProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  final cartRepository = ref.watch(cartRepositoryProvider);
  return CartNotifier(cartRepository);
});

// Orders provider
final userOrdersProvider = FutureProvider.family<List<Cart>, int>((
  ref,
  userId,
) async {
  final repository = ref.watch(cartRepositoryProvider);
  return repository.getUserOrders(userId);
});
