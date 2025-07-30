import 'package:f_commerce/core/api/api_client.dart';
import 'package:f_commerce/core/storage/storage_service.dart';
import 'package:f_commerce/features/products/data/product_model.dart';

class ProductRepository {
  final ApiClient _apiClient;
  final StorageService _storageService;

  ProductRepository({
    required ApiClient apiClient,
    required StorageService storageService,
  })  : _apiClient = apiClient,
        _storageService = storageService;

  // Fetch all products
  Future<List<Product>> getAllProducts() async {
    // Check cache first
    if (!_storageService.isCacheExpired()) {
      final cachedProducts = _storageService.getCachedProducts();
      if (cachedProducts != null) {
        return cachedProducts
            .map((json) => Product.fromJson(json))
            .toList();
      }
    }

    // Fetch from API
    return _apiClient.get<List<Product>>(
      endpoint: '/products',
      converter: (data) {
        final List<dynamic> productList = data as List<dynamic>;
        final products = productList
            .map((json) => Product.fromJson(json as Map<String, dynamic>))
            .toList();
        
        // Cache products
        _storageService.cacheProducts(
          products.map((product) => product.toJson()).toList(),
        );
        
        return products;
      },
    );
  }

  // Fetch a single product
  Future<Product> getProductById(int id) async {
    // Check cache first
    if (!_storageService.isCacheExpired()) {
      final cachedProducts = _storageService.getCachedProducts();
      if (cachedProducts != null) {
        final productJson = cachedProducts.firstWhere(
          (json) => json['id'] == id,
          orElse: () => {},
        );
        if (productJson.isNotEmpty) {
          return Product.fromJson(productJson);
        }
      }
    }

    // Fetch from API
    return _apiClient.get<Product>(
      endpoint: '/products/$id',
      converter: (data) => Product.fromJson(data as Map<String, dynamic>),
    );
  }

  // Fetch products by category
  Future<List<Product>> getProductsByCategory(String category) async {
    // Check cache first
    if (!_storageService.isCacheExpired()) {
      final cachedProducts = _storageService.getCachedProducts();
      if (cachedProducts != null) {
        final categoryProducts = cachedProducts
            .where((json) => json['category'] == category)
            .map((json) => Product.fromJson(json))
            .toList();
        
        if (categoryProducts.isNotEmpty) {
          return categoryProducts;
        }
      }
    }

    // Fetch from API
    return _apiClient.get<List<Product>>(
      endpoint: '/products/category/$category',
      converter: (data) {
        final List<dynamic> productList = data as List<dynamic>;
        return productList
            .map((json) => Product.fromJson(json as Map<String, dynamic>))
            .toList();
      },
    );
  }

  // Get all categories
  Future<List<String>> getAllCategories() async {
    return _apiClient.get<List<String>>(
      endpoint: '/products/categories',
      converter: (data) {
        final List<dynamic> categoryList = data as List<dynamic>;
        return categoryList.map((category) => category.toString()).toList();
      },
    );
  }

  // Add product (admin only)
  Future<Product> addProduct(Product product) async {
    return _apiClient.post<Product>(
      endpoint: '/products',
      data: product.toJson(),
      converter: (data) => Product.fromJson(data as Map<String, dynamic>),
    );
  }

  // Update product (admin only)
  Future<Product> updateProduct(int id, Product product) async {
    return _apiClient.put<Product>(
      endpoint: '/products/$id',
      data: product.toJson(),
      converter: (data) => Product.fromJson(data as Map<String, dynamic>),
    );
  }

  // Delete product (admin only)
  Future<bool> deleteProduct(int id) async {
    return _apiClient.delete<bool>(
      endpoint: '/products/$id',
      converter: (data) => true,
    );
  }
}
