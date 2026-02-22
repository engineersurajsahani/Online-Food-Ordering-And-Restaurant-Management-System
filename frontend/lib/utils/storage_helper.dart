// Storage Helper - save and load data locally
// Uses shared_preferences to remember user info

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';

class StorageHelper {
  // Keys for storing data
  static const String _keyToken = 'token';
  static const String _keyUser = 'user';

  // Save token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
  }

  // Get token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  // Save user data
  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode({
      'userId': user.id,
      'name': user.name,
      'email': user.email,
      'role': user.role,
    });
    await prefs.setString(_keyUser, userJson);
  }

  // Get user data
  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_keyUser);

    if (userJson != null) {
      final data = jsonDecode(userJson);
      return User.fromJson(data);
    }

    return null;
  }

  // Clear all data (on logout)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
