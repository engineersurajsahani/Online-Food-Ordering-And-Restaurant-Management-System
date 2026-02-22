// Login Screen - where users sign in
// Simple form with email and password

import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../utils/storage_helper.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../constants/app_constants.dart';
import '../../models/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  // Handle login button press
  void _handleLogin() async {
    // Get input values
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Simple validation
    if (email.isEmpty || password.isEmpty) {
      _showMessage('Please fill all fields', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Call API
      final response = await ApiService.login(email, password);

      if (response['success'] == true) {
        // Save user data and token
        final userData = response['data']['user'];
        final token = response['data']['token'];
        final user = User.fromJson(userData);
        
        await StorageHelper.saveUser(user);
        await StorageHelper.saveToken(token);
        ApiService.setToken(token); // Set token in API service

        if (!mounted) return;

        // Go to appropriate screen based on role
        _navigateBasedOnRole(user.role);
      } else {
        _showMessage(response['message'] ?? 'Login failed', isError: true);
      }
    } catch (e) {
      _showMessage('Error: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Navigate to screen based on user role
  void _navigateBasedOnRole(String role) {
    if (role == AppConstants.roleUser) {
      Navigator.pushReplacementNamed(context, '/user-home');
    } else if (role == AppConstants.roleRestaurant) {
      Navigator.pushReplacementNamed(context, '/restaurant-home');
    } else if (role == AppConstants.roleAdmin) {
      Navigator.pushReplacementNamed(context, '/admin-home');
    }
  }

  // Show message to user
  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
      ),
    );
  }

  
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App logo/icon
                Icon(
                  Icons.restaurant_menu,
                  size: 80,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 24),

                // Title
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),

                // Email field
                CustomTextField(
                  label: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // Password field
                CustomTextField(
                  label: 'Password',
                  controller: _passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 24),

                // Login button
                CustomButton(
                  text: 'Login',
                  onPressed: _handleLogin,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 16),

                // Go to register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account? '),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text('Register'),
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
