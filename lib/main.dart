import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_routes.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';
import 'package:flutter_application_1/shared/widgets/bottom_nav.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/profile_register_screen.dart';
import 'package:flutter_application_1/screens/passwords_screen.dart';
import 'package:flutter_application_1/form/form_password_page.dart';
import 'package:flutter_application_1/screens/settings_screen.dart';
import 'package:flutter_application_1/shared/services/password_service.dart';
import 'package:flutter_application_1/core/theme/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  

  final passwordService = PasswordService();
  final storageAvailable = await passwordService.isStorageAvailable();
  
  if (!storageAvailable) {
    debugPrint('Warning: Secure storage may not be available');
  }
  
  final themeService = ThemeService.instance;
  await themeService.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = ThemeService.instance;
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeService.themeMode,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'PassMan - Password Manager',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: mode,
          initialRoute: AppRoutes.bottomNav,
          routes: {
            AppRoutes.bottomNav: (context) {
              final args = ModalRoute.of(context)?.settings.arguments;
              return BottomNav(startIndex: args is int ? args : 0);
            },
            AppRoutes.login: (context) => const LoginScreen(),
            AppRoutes.register: (context) => const ProfileRegisterScreen(),
            AppRoutes.passwords: (context) => const PasswordsScreen(),
            AppRoutes.addPassword: (context) => const FormPasswordPage(),
            AppRoutes.settings: (context) => const SettingsScreen(),
          },
        );
      },
    );
  }
}
