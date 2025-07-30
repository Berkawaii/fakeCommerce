import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:f_commerce/features/products/presentation/screens/products_screen.dart';
import 'package:f_commerce/features/cart/presentation/screens/cart_screen.dart';
import 'package:f_commerce/features/auth/presentation/screens/profile_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const ProductsScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
      themeMode: NeumorphicTheme.isUsingDark(context)
          ? ThemeMode.dark
          : ThemeMode.light,
      theme: NeumorphicTheme.currentTheme(context),
      child: Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        body: _screens[_selectedIndex],
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: 5, // Reduced depth for more subtle effect
        intensity: 0.5, // Reduced intensity for muted look
        boxShape: NeumorphicBoxShape.roundRect(
          const BorderRadius.only(
            topLeft: Radius.circular(20), // Slightly smaller radius
            topRight: Radius.circular(20),
          ),
        ),
      ),
      child: Container(
        height: 65.h, // Slightly smaller height
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
        ), // Slightly more horizontal padding
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home_outlined, "Home"),
            _buildNavItem(1, Icons.shopping_cart_outlined, "Cart"),
            _buildNavItem(2, Icons.person_outline, "Profile"),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = index == _selectedIndex;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NeumorphicIcon(
            icon,
            size: 24.sp, // Slightly smaller icon
            style: NeumorphicStyle(
              depth: isSelected ? 2 : 0, // Reduced depth for more subtle effect
              intensity: isSelected
                  ? 0.6
                  : 0.4, // Reduced intensity for muted look
              color: isSelected
                  ? NeumorphicTheme.accentColor(context)
                  : NeumorphicTheme.defaultTextColor(
                      context,
                    ).withOpacity(0.7), // More muted unselected color
            ),
          ),
          SizedBox(height: 3.h), // Slightly reduced spacing
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp, // Slightly smaller text
              fontWeight: isSelected
                  ? FontWeight.w500
                  : FontWeight.w400, // Less bold for more refined look
              color: isSelected
                  ? NeumorphicTheme.accentColor(context)
                  : NeumorphicTheme.defaultTextColor(
                      context,
                    ).withOpacity(0.7), // More muted unselected color
            ),
          ),
        ],
      ),
    );
  }
}

// We're now using the actual CartScreen imported from features/cart/presentation/screens/cart_screen.dart
// We're now using the actual ProfileScreen imported from features/auth/presentation/screens/profile_screen.dart
