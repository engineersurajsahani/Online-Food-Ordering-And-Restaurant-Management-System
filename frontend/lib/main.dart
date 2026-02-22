// Main App Entry Point - connects all screens with simple routes
// This is where the app starts

import 'package:flutter/material.dart';
import 'constants/app_constants.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/user/user_home_screen.dart';
import 'screens/user/restaurant_menu_screen.dart';
import 'screens/user/my_orders_screen.dart';
import 'screens/restaurant/restaurant_home_screen.dart';
import 'screens/restaurant/manage_menu_screen.dart';
import 'screens/restaurant/restaurant_orders_screen.dart';
import 'screens/admin/admin_home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  Widget build(BuildContext context) {
    return MaterialApp(
      // App name
      title: AppConstants.appName,
      
      // Theme - simple orange color scheme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      
      // Start with splash screen to check existing session
      initialRoute: '/',
      
      // Dynamic routes with parameters
      onGenerateRoute: (settings) {
        // Parse route name and parameters
        final uri = Uri.parse(settings.name ?? '/');
        final path = uri.path;
        final params = uri.queryParameters;
        
        switch (path) {
          case '/':
            return MaterialPageRoute(builder: (_) => const SplashScreen());
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/register':
            return MaterialPageRoute(builder: (_) => const RegisterScreen());
          case '/user-home':
            return MaterialPageRoute(builder: (_) => const UserHomeScreen());
          case '/restaurant-menu':
            final restaurantId = params['id'];
            final restaurantName = params['name'];
            if (restaurantId == null || restaurantName == null) {
              return MaterialPageRoute(builder: (_) => const UserHomeScreen());
            }
            return MaterialPageRoute(
              builder: (_) => RestaurantMenuScreen(
                restaurantId: restaurantId,
                restaurantName: restaurantName,
              ),
            );
          case '/my-orders':
            return MaterialPageRoute(builder: (_) => const MyOrdersScreen());
          case '/restaurant-home':
            return MaterialPageRoute(builder: (_) => const RestaurantHomeScreen());
          case '/manage-menu':
            return MaterialPageRoute(builder: (_) => const ManageMenuScreen());
          case '/restaurant-orders':
            return MaterialPageRoute(builder: (_) => const RestaurantOrdersScreen());
          case '/admin-home':
            return MaterialPageRoute(builder: (_) => const AdminHomeScreen());
          default:
            return MaterialPageRoute(builder: (_) => const SplashScreen());
        }
      },
    );
  }
}
