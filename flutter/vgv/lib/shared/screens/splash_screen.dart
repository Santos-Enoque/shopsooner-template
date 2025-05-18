import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vgv/navigation/routes.dart';
import 'package:vgv/shared/theme/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo or icon
            Icon(
              Icons.check_circle_outline,
              size: 80,
              color: AppColors.darkPrimary,
            ),
            SizedBox(height: 24),
            // App name
            Text(
              'Splash Screen',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.darkOnSurface,
              ),
            ),
            SizedBox(height: 48),
            // Loading indicator
            CircularProgressIndicator(
              color: AppColors.darkPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
