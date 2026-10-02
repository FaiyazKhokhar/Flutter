import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import 'features/auth/signup_screen.dart';

void main() => runApp(const DevCadeApp());

class DevCadeApp extends StatelessWidget {
  const DevCadeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DevCade',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: const ColorScheme.dark(primary: AppColors.primary),
      ),
      home: const SignUpScreen(),
    );
  }
}