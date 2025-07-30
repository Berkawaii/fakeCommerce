import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:f_commerce/features/auth/data/auth_providers.dart';
import 'package:f_commerce/core/theme/app_colors.dart';
import 'package:f_commerce/features/auth/presentation/screens/register_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login';

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(authStateProvider.notifier)
          .login(
            _usernameController.text.trim(),
            _passwordController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40.h),

                // Logo & Title
                Center(
                  child: NeumorphicIcon(
                    Icons.shopping_bag_outlined,
                    size: 80.r,
                    style: NeumorphicStyle(depth: 8, color: AppColors.primary),
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'Welcome to F-Commerce',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Log in to continue',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40.h),

                // Error message
                if (authState.errorMessage != null)
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: NeumorphicContainer(
                      padding: EdgeInsets.all(12.r),
                      child: Text(
                        authState.errorMessage!,
                        style: TextStyle(color: Colors.red[700]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                // Username field
                NeumorphicTextField(
                  controller: _usernameController,
                  labelText: 'Username',
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                // Password field
                NeumorphicTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),

                // Login button
                NeumorphicButton(
                  onPressed: authState.isLoading ? null : _login,
                  style: NeumorphicStyle(
                    depth: 8,
                    intensity: 0.8,
                    boxShape: NeumorphicBoxShape.roundRect(
                      BorderRadius.circular(12.r),
                    ),
                    color: AppColors.primary,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: authState.isLoading
                      ? Center(
                          child: SizedBox(
                            height: 24.h,
                            width: 24.h,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.r,
                            ),
                          ),
                        )
                      : Text(
                          'Log In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                ),
                SizedBox(height: 16.h),

                // Register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RegisterScreen.routeName);
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NeumorphicContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const NeumorphicContainer({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: -3,
        intensity: 0.8,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12.r)),
      ),
      padding: EdgeInsets.all(8.r),
      child: Padding(
        padding: padding is EdgeInsets
            ? padding as EdgeInsets
            : EdgeInsets.zero,
        child: child,
      ),
    );
  }
}

class NeumorphicTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;

  const NeumorphicTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: -3,
        intensity: 0.8,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12.r)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 4.r),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(prefixIcon, color: AppColors.textSecondary),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          labelStyle: TextStyle(color: AppColors.textSecondary),
        ),
        validator: validator,
      ),
    );
  }
}
