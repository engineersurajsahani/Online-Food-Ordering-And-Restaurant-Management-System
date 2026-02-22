// Register Screen - new users sign up here
// Has role selection dropdown

import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../constants/app_constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = AppConstants.roleUser;
  bool _isLoading = false;

  // Handle register button press
  void _handleRegister() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Validation
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showMessage('Please fill all fields', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await ApiService.register(name, email, password, _selectedRole);

      if (response['success'] == true) {
        _showMessage('Registration successful! Please login.');
        if (!mounted) return;
        Navigator.pop(context); // Go back to login
      } else {
        _showMessage(response['message'] ?? 'Registration failed', isError: true);
      }
    } catch (e) {
      _showMessage('Error: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              children: [
                // Name field
                CustomTextField(
                  label: 'Full Name',
                  controller: _nameController,
                ),
                const SizedBox(height: 16),

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
                const SizedBox(height: 16),

                // Role dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedRole,
                    isExpanded: true,
                    underline: Container(),
                    items: const [
                      DropdownMenuItem(
                        value: AppConstants.roleUser,
                        child: Text('Customer'),
                      ),
                      DropdownMenuItem(
                        value: AppConstants.roleRestaurant,
                        child: Text('Restaurant Owner'),
                      ),
                      DropdownMenuItem(
                        value: AppConstants.roleAdmin,
                        child: Text('Admin'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() => _selectedRole = value!);
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Register button
                CustomButton(
                  text: 'Register',
                  onPressed: _handleRegister,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
