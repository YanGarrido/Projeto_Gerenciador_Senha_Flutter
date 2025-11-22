import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_routes.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';
import 'package:flutter_application_1/shared/widgets/bottom_nav.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/profile_register_screen.dart';
import 'package:flutter_application_1/screens/passwords_screen.dart';
import 'package:flutter_application_1/form/form_password_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PassMan - Password Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
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
      },
    );
  }
}
