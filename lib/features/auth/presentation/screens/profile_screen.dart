import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:f_commerce/core/theme/app_theme.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = NeumorphicTheme.isUsingDark(context);

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              _buildHeader(),
              SizedBox(height: 20.h),
              _buildProfileAvatar(),
              SizedBox(height: 16.h),
              _buildProfileName('John Doe'),
              SizedBox(height: 8.h),
              _buildProfileEmail('john.doe@example.com'),
              SizedBox(height: 32.h),
              _buildMenuSection(context),
              SizedBox(height: 16.h),
              _buildThemeToggle(context, isDarkMode),
              SizedBox(height: 32.h),
              _buildLogoutButton(context),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Profile',
        style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: 8,
        intensity: 0.7,
        boxShape: NeumorphicBoxShape.circle(),
      ),
      child: Container(
        width: 120.w,
        height: 120.w,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: Icon(Icons.person, size: 80.sp, color: Colors.grey),
      ),
    );
  }

  Widget _buildProfileName(String name) {
    return Text(
      name,
      style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildProfileEmail(String email) {
    return Text(
      email,
      style: TextStyle(fontSize: 16.sp, color: Colors.grey),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Column(
      children: [
        _buildMenuItem(context, 'My Orders', Icons.shopping_bag_outlined),
        SizedBox(height: 16.h),
        _buildMenuItem(context, 'Shipping Address', Icons.location_on_outlined),
        SizedBox(height: 16.h),
        _buildMenuItem(context, 'Payment Methods', Icons.credit_card_outlined),
        SizedBox(height: 16.h),
        _buildMenuItem(context, 'Settings', Icons.settings_outlined),
        SizedBox(height: 16.h),
        _buildMenuItem(context, 'Help & Support', Icons.help_outline),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon) {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: 4,
        intensity: 0.7,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Row(
          children: [
            Icon(icon, size: 24.sp),
            SizedBox(width: 16.w),
            Text(
              title,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, size: 16.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context, bool isDarkMode) {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: 4,
        intensity: 0.7,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Row(
          children: [
            Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode, size: 24.sp),
            SizedBox(width: 16.w),
            Text(
              'Dark Mode',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            NeumorphicSwitch(
              value: isDarkMode,
              style: const NeumorphicSwitchStyle(
                lightSource: LightSource.topLeft,
              ),
              onChanged: (value) {
                NeumorphicTheme.of(context)?.themeMode = value
                    ? ThemeMode.dark
                    : ThemeMode.light;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return NeumorphicButton(
      style: NeumorphicStyle(
        depth: 4,
        intensity: 0.8,
        color: AppTheme.errorColor.withOpacity(0.1),
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
      ),
      onPressed: () {
        // For demo purposes, just show a dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // In a real app, we would call auth service to logout
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logged out successfully')),
                  );
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        );
      },
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Text(
          'Logout',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.errorColor,
          ),
        ),
      ),
    );
  }
}
