import 'package:f_commerce/core/api/api_client.dart';
import 'package:f_commerce/core/storage/storage_service.dart';
import 'package:f_commerce/features/cart/data/cart_model.dart';
import 'package:f_commerce/features/products/data/product_model.dart';

class CartRepository {
  final ApiClient _apiClient;
  final StorageService _storageService;

  CartRepository({
    required ApiClient apiClient,
    required StorageService storageService,
  }) : _apiClient = apiClient,
       _storageService = storageService;

  // Get cart from local storage
  List<CartItem> getLocalCart() {
    final cartData = _storageService.getCart();
    return cartData.map((item) => CartItem.fromJson(item)).toList();
  }

  // Add item to cart
  Future<void> addToCart(Product product, int quantity) async {
    final List<CartItem> cart = getLocalCart();

    // Check if product already exists in cart
    final existingIndex = cart.indexWhere(
      (item) => item.productId == product.id,
    );

    if (existingIndex >= 0) {
      // Update quantity
      final existingItem = cart[existingIndex];
      final updatedItem = CartItem(
        productId: existingItem.productId,
        quantity: existingItem.quantity + quantity,
        price: product.price,
        title: product.title,
        imageUrl: product.imageUrl,
      );
      cart[existingIndex] = updatedItem;
    } else {
      // Add new item
      cart.add(
        CartItem(
          productId: product.id,
          quantity: quantity,
          price: product.price,
          title: product.title,
          imageUrl: product.imageUrl,
        ),
      );
    }

    // Save to storage
    await _storageService.saveCart(cart.map((item) => item.toJson()).toList());
  }

  // Update item quantity
  Future<void> updateCartItemQuantity(int productId, int quantity) async {
    final List<CartItem> cart = getLocalCart();

    final index = cart.indexWhere((item) => item.productId == productId);

    if (index >= 0) {
      if (quantity <= 0) {
        // Remove item if quantity is zero or negative
        cart.removeAt(index);
      } else {
        // Update quantity
        final item = cart[index];
        cart[index] = CartItem(
          productId: item.productId,
          quantity: quantity,
          price: item.price,
          title: item.title,
          imageUrl: item.imageUrl,
        );
      }

      // Save to storage
      await _storageService.saveCart(
        cart.map((item) => item.toJson()).toList(),
      );
    }
  }

  // Remove item from cart
  Future<void> removeFromCart(int productId) async {
    final List<CartItem> cart = getLocalCart();
    cart.removeWhere((item) => item.productId == productId);

    // Save to storage
    await _storageService.saveCart(cart.map((item) => item.toJson()).toList());
  }

  // Clear cart
  Future<void> clearCart() async {
    await _storageService.clearCart();
  }

  // Create order from cart (checkout)
  Future<Cart> createOrder(int userId) async {
    final localCart = getLocalCart();

    // Convert local cart to API format
    final orderData = {
      'userId': userId,
      'date': DateTime.now().toIso8601String(),
      'products': localCart
          .map(
            (item) => {'productId': item.productId, 'quantity': item.quantity},
          )
          .toList(),
    };

    // Create order via API
    final response = await _apiClient.post<Cart>(
      endpoint: '/carts',
      data: orderData,
      converter: (data) => Cart.fromJson(data as Map<String, dynamic>),
    );

    // Clear local cart after successful order
    await clearCart();

    return response;
  }

  // Get user orders
  Future<List<Cart>> getUserOrders(int userId) async {
    return _apiClient.get<List<Cart>>(
      endpoint: '/carts/user/$userId',
      converter: (data) {
        final List<dynamic> cartList = data as List<dynamic>;
        return cartList
            .map((json) => Cart.fromJson(json as Map<String, dynamic>))
            .toList();
      },
    );
  }
}
