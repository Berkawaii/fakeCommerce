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
        depth: 10,
        boxShape: NeumorphicBoxShape.roundRect(
          const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
      ),
      child: Container(
        height: 70.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
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
            size: 28.sp,
            style: NeumorphicStyle(
              depth: isSelected ? 4 : 0,
              intensity: isSelected ? 0.8 : 0.5,
              color: isSelected 
                  ? NeumorphicTheme.accentColor(context)
                  : NeumorphicTheme.defaultTextColor(context),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected 
                  ? NeumorphicTheme.accentColor(context)
                  : NeumorphicTheme.defaultTextColor(context),
            ),
          ),
        ],
      ),
    );
  }
}

// We're now using the actual CartScreen imported from features/cart/presentation/screens/cart_screen.dart
// We're now using the actual ProfileScreen imported from features/auth/presentation/screens/profile_screen.dart
