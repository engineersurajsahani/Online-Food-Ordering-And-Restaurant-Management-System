// Splash Screen - checks for existing session on app startup
// Auto-logins user if valid token exists

import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../utils/storage_helper.dart';
import '../../services/api_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    // Wait a moment for splash effect
    await Future.delayed(const Duration(seconds: 1));

    try {
      // Check if we have a saved token
      final token = await StorageHelper.getToken();
      final user = await StorageHelper.getUser();

      if (token != null && user != null) {
        // We have a token, set it in API service
        ApiService.setToken(token);

        // Token exists and user data saved, navigate directly
        // The individual screens will handle loading their data
        if (!mounted) return;
        _navigateToHome(user.role);
        return;
      }

      // No valid session, go to login
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      // Error checking session, go to login
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _navigateToHome(String role) {
    String route;
    switch (role) {
      case 'ADMIN':
        route = '/admin-home';
        break;
      case 'RESTAURANT':
        route = '/restaurant-home';
        break;
      default:
        route = '/user-home';
    }

    Navigator.pushReplacementNamed(context, route);
  }

  
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App icon
            Icon(
              Icons.restaurant_menu,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            
            // App name
            const Text(
              AppConstants.appName,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 48),
            
            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
