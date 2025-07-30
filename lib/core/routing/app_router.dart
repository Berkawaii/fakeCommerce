import 'package:flutter/material.dart';
import 'package:f_commerce/features/auth/presentation/screens/login_screen.dart';
import 'package:f_commerce/features/auth/presentation/screens/register_screen.dart';
import 'package:f_commerce/features/products/presentation/screens/product_detail_screen.dart';
import 'package:f_commerce/features/products/data/product_model.dart';
import 'package:f_commerce/features/cart/presentation/screens/cart_screen.dart';
import 'package:f_commerce/features/cart/presentation/screens/checkout_screen.dart';
import 'package:f_commerce/features/auth/presentation/screens/profile_screen.dart';
import 'package:f_commerce/core/screens/auth_check_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        // Check auth status from storage and redirect accordingly
        return MaterialPageRoute(builder: (_) => const AuthCheckScreen());

      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case '/product-detail':
        final product = settings.arguments as Product;
        return MaterialPageRoute(
          builder: (_) => ProductDetailScreen(product: product),
        );

      case '/cart':
        return MaterialPageRoute(builder: (_) => const CartScreen());

      case '/checkout':
        return MaterialPageRoute(builder: (_) => const CheckoutScreen());

      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
