import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:f_commerce/core/storage/storage_service.dart';
import 'package:f_commerce/core/theme/app_theme.dart';
import 'package:f_commerce/core/theme/theme_provider.dart' as theme_provider;
import 'package:f_commerce/core/routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage
  final storageService = StorageService();
  await storageService.initialize();

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(theme_provider.themeProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812), // Design size based on iPhone X
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return NeumorphicApp(
          title: 'F-Commerce',
          debugShowCheckedModeBanner: false,
          themeMode: _getThemeMode(themeMode),
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: '/',
        );
      },
    );
  }

  ThemeMode _getThemeMode(theme_provider.ThemeMode mode) {
    switch (mode) {
      case theme_provider.ThemeMode.light:
        return ThemeMode.light;
      case theme_provider.ThemeMode.dark:
        return ThemeMode.dark;
      case theme_provider.ThemeMode.system:
        return ThemeMode.system;
    }
  }
}
