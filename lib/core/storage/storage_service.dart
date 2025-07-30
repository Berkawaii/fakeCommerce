import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  // Box names
  static const String _settingsBox = 'settings';
  static const String _cartBox = 'cart';
  static const String _wishlistBox = 'wishlist';
  static const String _userBox = 'user';
  static const String _productsBox = 'products';
  static const String _reviewsBox = 'reviews';

  // Secure storage keys
  static const String _authTokenKey = 'auth_token';
  static const String _userId = 'user_id';

  Future<void> initialize() async {
    await Hive.initFlutter();
    
    // Open boxes
    await Hive.openBox(_settingsBox);
    await Hive.openBox(_cartBox);
    await Hive.openBox(_wishlistBox);
    await Hive.openBox(_userBox);
    await Hive.openBox(_productsBox);
    await Hive.openBox(_reviewsBox);
  }

  // Theme settings
  Future<void> saveThemeMode(String mode) async {
    final box = Hive.box(_settingsBox);
    await box.put('theme_mode', mode);
  }

  String? getThemeMode() {
    final box = Hive.box(_settingsBox);
    return box.get('theme_mode');
  }

  // Authentication
  Future<void> saveAuthToken(String token) async {
    await _secureStorage.write(key: _authTokenKey, value: token);
  }

  Future<String?> getAuthToken() async {
    return await _secureStorage.read(key: _authTokenKey);
  }

  Future<void> deleteAuthToken() async {
    await _secureStorage.delete(key: _authTokenKey);
  }

  Future<void> saveUserId(String id) async {
    await _secureStorage.write(key: _userId, value: id);
  }

  Future<String?> getUserId() async {
    return await _secureStorage.read(key: _userId);
  }

  // Cart
  Future<void> saveCart(List<Map<String, dynamic>> cart) async {
    final box = Hive.box(_cartBox);
    await box.put('current_cart', cart);
  }

  List<Map<String, dynamic>> getCart() {
    final box = Hive.box(_cartBox);
    final dynamic rawCart = box.get('current_cart');
    if (rawCart == null) return [];
    return List<Map<String, dynamic>>.from(rawCart);
  }

  Future<void> clearCart() async {
    final box = Hive.box(_cartBox);
    await box.clear();
  }

  // Wishlist
  Future<void> toggleWishlistItem(int productId) async {
    final box = Hive.box(_wishlistBox);
    final List<int> wishlist = await getWishlist();

    if (wishlist.contains(productId)) {
      wishlist.remove(productId);
    } else {
      wishlist.add(productId);
    }

    await box.put('wishlist', wishlist);
  }

  Future<List<int>> getWishlist() async {
    final box = Hive.box(_wishlistBox);
    final dynamic rawWishlist = box.get('wishlist');
    if (rawWishlist == null) return [];
    return List<int>.from(rawWishlist);
  }

  bool isInWishlist(int productId) {
    final box = Hive.box(_wishlistBox);
    final dynamic rawWishlist = box.get('wishlist');
    if (rawWishlist == null) return false;
    
    final List<int> wishlist = List<int>.from(rawWishlist);
    return wishlist.contains(productId);
  }

  // User data
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final box = Hive.box(_userBox);
    await box.put('current_user', userData);
  }

  Map<String, dynamic>? getUserData() {
    final box = Hive.box(_userBox);
    final dynamic rawData = box.get('current_user');
    if (rawData == null) return null;
    return Map<String, dynamic>.from(rawData);
  }

  Future<void> clearUserData() async {
    final box = Hive.box(_userBox);
    await box.clear();
  }

  // Product caching
  Future<void> cacheProducts(List<Map<String, dynamic>> products) async {
    final box = Hive.box(_productsBox);
    await box.put('all_products', products);
    await box.put('last_updated', DateTime.now().toIso8601String());
  }

  List<Map<String, dynamic>>? getCachedProducts() {
    final box = Hive.box(_productsBox);
    final dynamic rawProducts = box.get('all_products');
    if (rawProducts == null) return null;
    return List<Map<String, dynamic>>.from(rawProducts);
  }

  DateTime? getProductsCacheTime() {
    final box = Hive.box(_productsBox);
    final String? dateString = box.get('last_updated');
    if (dateString == null) return null;
    return DateTime.parse(dateString);
  }

  bool isCacheExpired() {
    final lastUpdated = getProductsCacheTime();
    if (lastUpdated == null) return true;
    
    final now = DateTime.now();
    final difference = now.difference(lastUpdated);
    // Cache expires after 1 hour
    return difference.inHours >= 1;
  }

  // Reviews (locally stored)
  Future<void> saveReview(int productId, Map<String, dynamic> review) async {
    final box = Hive.box(_reviewsBox);
    List<Map<String, dynamic>> reviews = getProductReviews(productId);
    reviews.add(review);
    await box.put('product_$productId', reviews);
  }

  List<Map<String, dynamic>> getProductReviews(int productId) {
    final box = Hive.box(_reviewsBox);
    final dynamic rawReviews = box.get('product_$productId');
    if (rawReviews == null) return [];
    return List<Map<String, dynamic>>.from(rawReviews);
  }

  // Clear all data (logout)
  Future<void> clearAllData() async {
    await deleteAuthToken();
    await Hive.box(_cartBox).clear();
    await Hive.box(_userBox).clear();
    // Keep wishlist, product cache, reviews, and settings
  }
}
