import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:f_commerce/features/auth/data/auth_providers.dart';
import 'package:f_commerce/features/auth/presentation/screens/login_screen.dart';
import 'package:f_commerce/features/products/presentation/screens/home_screen.dart';

class AuthCheckScreen extends ConsumerStatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  ConsumerState<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends ConsumerState<AuthCheckScreen> {
  @override
  void initState() {
    super.initState();
    // Add a short delay to allow the UI to render before navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthAndNavigate();
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    final authState = ref.read(authStateProvider);

    if (authState.isAuthenticated) {
      // User is authenticated, navigate to home
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    } else {
      // User is not authenticated, navigate to login
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading screen while checking auth status
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            NeumorphicIcon(
              Icons.shopping_bag_outlined,
              size: 80.r,
              style: NeumorphicStyle(depth: 8, intensity: 0.8),
            ),
            SizedBox(height: 24.h),

            // App Name
            Text(
              'F-Commerce',
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40.h),

            // Loading Indicator
            SizedBox(
              width: 200.w,
              child: const NeumorphicProgressIndeterminate(),
            ),
          ],
        ),
      ),
    );
  }
}
