// API Service - handles all backend communication
// This is the only file that talks to our backend server

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restaurant.dart';
import '../models/menu_item.dart';
import '../models/order.dart';
import '../models/user.dart';
import '../utils/storage_helper.dart';

class ApiService {
  // Backend URL - change this to your deployed backend URL
  static const String baseUrl = 'https://food-fc4q.onrender.com/api';

  // Store the JWT token here after login
  static String? _token;

  // Set token after login
  static void setToken(String token) {
    _token = token;
  }

  // Load token from storage (for session persistence)
  static Future<void> loadToken() async {
    final token = await StorageHelper.getToken();
    if (token != null) {
      _token = token;
    }
  }

  // Clear token on logout
  static void clearToken() {
    _token = null;
  }

  // Helper to get headers with token
  static Map<String, String> _getHeaders() {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }

    return headers;
  }

  // ========== AUTH APIs ==========

  // Register a new user
  static Future<Map<String, dynamic>> register(
      String name, String email, String password, String role) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      // Check if response is valid JSON
      if (response.body.isEmpty) {
        return {'success': false, 'message': 'Empty response from server'};
      }

      // Try to parse JSON
      try {
        return jsonDecode(response.body);
      } catch (e) {
        return {
          'success': false,
          'message': 'Invalid response from server: ${response.body.substring(0, 100)}'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Login user
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      // Check if response is valid JSON
      if (response.body.isEmpty) {
        return {'success': false, 'message': 'Empty response from server'};
      }

      // Try to parse JSON
      Map<String, dynamic> data;
      try {
        data = jsonDecode(response.body);
      } catch (e) {
        return {
          'success': false,
          'message': 'Invalid response from server: ${response.body.substring(0, 100)}'
        };
      }

      // Save token if login successful
      if (data['success'] == true && data['data']?['token'] != null) {
        setToken(data['data']['token']);
      }

      return data;
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // ========== RESTAURANT APIs ==========

  // Create a new restaurant (for RESTAURANT role users)
  static Future<Map<String, dynamic>> createRestaurant(
      String name, String description, String address) async {
    final response = await http.post(
      Uri.parse('$baseUrl/restaurants'),
      headers: _getHeaders(),
      body: jsonEncode({
        'name': name,
        'description': description,
        'address': address,
      }),
    );

    return jsonDecode(response.body);
  }

  // Get all restaurants (for customers)
  static Future<List<Restaurant>> getAllRestaurants() async {
    final response = await http.get(
      Uri.parse('$baseUrl/restaurants'),
      headers: _getHeaders(),
    );

    final data = jsonDecode(response.body);

    if (data['success'] == true) {
      List<Restaurant> restaurants = (data['data'] as List)
          .map((json) => Restaurant.fromJson(json))
          .toList();
      return restaurants;
    }

    return [];
  }

  // Get my restaurant (for restaurant owners)
  static Future<Restaurant?> getMyRestaurant() async {
    final response = await http.get(
      Uri.parse('$baseUrl/restaurants/my-restaurant'),
      headers: _getHeaders(),
    );

    final data = jsonDecode(response.body);

    if (data['success'] == true && data['data'] != null) {
      return Restaurant.fromJson(data['data']);
    }

    return null;
  }

  // Toggle restaurant open/close status
  static Future<Map<String, dynamic>> toggleRestaurantStatus(bool isOpen) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/restaurants/toggle-status'),
      headers: _getHeaders(),
      body: jsonEncode({
        'isOpen': isOpen,
      }),
    );

    return jsonDecode(response.body);
  }

  // ========== MENU APIs ==========

  // Get menu for a restaurant
  static Future<List<MenuItem>> getRestaurantMenu(String restaurantId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/menus/restaurant/$restaurantId'),
      headers: _getHeaders(),
    );

    final data = jsonDecode(response.body);

    if (data['success'] == true) {
      List<MenuItem> items = (data['data'] as List)
          .map((json) => MenuItem.fromJson(json))
          .toList();
      return items;
    }

    return [];
  }

  // Add menu item (for restaurant owners)
  static Future<Map<String, dynamic>> addMenuItem(
      String name,
      String description,
      double price,
      bool isVeg,
      String category,
      String image) async {
    final response = await http.post(
      Uri.parse('$baseUrl/menus'),
      headers: _getHeaders(),
      body: jsonEncode({
        'name': name,
        'description': description,
        'price': price,
        'isVeg': isVeg,
        'category': category,
        'image': image,
      }),
    );

    return jsonDecode(response.body);
  }

  // Get my menu (for restaurant owners)
  static Future<List<MenuItem>> getMyMenu() async {
    final response = await http.get(
      Uri.parse('$baseUrl/menus/my'),
      headers: _getHeaders(),
    );

    final data = jsonDecode(response.body);

    if (data['success'] == true) {
      List<MenuItem> items = (data['data'] as List)
          .map((json) => MenuItem.fromJson(json))
          .toList();
      return items;
    }

    return [];
  }

  // ========== ORDER APIs ==========

  // Place an order
  static Future<Map<String, dynamic>> placeOrder(
      String restaurantId, List<Map<String, dynamic>> items) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: _getHeaders(),
      body: jsonEncode({
        'restaurantId': restaurantId,
        'items': items,
      }),
    );

    return jsonDecode(response.body);
  }

  // Get my orders (for customers)
  static Future<List<Order>> getMyOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders/my-orders'),
        headers: _getHeaders(),
      );
      
      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        List<Order> orders =
            (data['data'] as List).map((json) => Order.fromJson(json)).toList();
        return orders;
      }

      return [];
    } catch (e) {
      throw Exception('Failed to load orders: $e');
    }
  }

  // Get orders for my restaurant (for restaurant owners)
  static Future<List<Order>> getRestaurantOrders() async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders/restaurant-orders'),
      headers: _getHeaders(),
    );

    final data = jsonDecode(response.body);

    if (data['success'] == true) {
      List<Order> orders =
          (data['data'] as List).map((json) => Order.fromJson(json)).toList();
      return orders;
    }

    return [];
  }

  // Get restaurant statistics (for restaurant owners)
  static Future<Map<String, dynamic>> getRestaurantStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders/restaurant-stats'),
        headers: _getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        return data['data'];
      }

      return {};
    } catch (e) {
      return {};
    }
  }

  // Get user statistics (for users)
  static Future<Map<String, dynamic>> getUserStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders/user-stats'),
        headers: _getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        return data['data'];
      }

      return {};
    } catch (e) {
      return {};
    }
  }

  // Update order status (for restaurant owners)
  static Future<Map<String, dynamic>> updateOrderStatus(
      String orderId, String status) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/orders/$orderId/status'),
      headers: _getHeaders(),
      body: jsonEncode({
        'status': status,
      }),
    );

    return jsonDecode(response.body);
  }

  // Update menu item
  static Future<Map<String, dynamic>> updateMenuItem(
    String itemId,
    String name,
    String description,
    double price,
    bool isVeg,
    String category,
    String image,
  ) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/menus/$itemId'),
      headers: _getHeaders(),
      body: jsonEncode({
        'name': name,
        'description': description,
        'price': price,
        'isVeg': isVeg,
        'category': category,
        'image': image,
      }),
    );

    return jsonDecode(response.body);
  }

  // Toggle menu item availability
  static Future<Map<String, dynamic>> toggleMenuItemAvailability(
      String itemId) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/menus/$itemId/toggle'),
      headers: _getHeaders(),
    );

    return jsonDecode(response.body);
  }

  // ========== ADMIN APIs ==========

  // Get all restaurants including pending (for admin)
  static Future<List<Restaurant>> getAllRestaurantsAdmin() async {
    final response = await http.get(
      Uri.parse('$baseUrl/restaurants/admin/all'),
      headers: _getHeaders(),
    );

    final data = jsonDecode(response.body);

    if (data['success'] == true) {
      List<Restaurant> restaurants = (data['data'] as List)
          .map((json) => Restaurant.fromJson(json))
          .toList();
      return restaurants;
    }

    return [];
  }

  // Approve restaurant (admin)
  static Future<Map<String, dynamic>> approveRestaurant(
      String restaurantId, String notes) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/restaurants/admin/$restaurantId/approve'),
      headers: _getHeaders(),
      body: jsonEncode({
        'notes': notes,
      }),
    );

    return jsonDecode(response.body);
  }

  // Reject restaurant (admin)
  static Future<Map<String, dynamic>> rejectRestaurant(
      String restaurantId, String reason) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/restaurants/admin/$restaurantId/reject'),
      headers: _getHeaders(),
      body: jsonEncode({
        'reason': reason,
      }),
    );

    return jsonDecode(response.body);
  }

  // Deactivate restaurant (admin)
  static Future<Map<String, dynamic>> deactivateRestaurant(
      String restaurantId, String reason) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/restaurants/admin/$restaurantId/deactivate'),
      headers: _getHeaders(),
      body: jsonEncode({
        'reason': reason,
      }),
    );

    return jsonDecode(response.body);
  }

  // Reactivate restaurant (admin)
  static Future<Map<String, dynamic>> reactivateRestaurant(
      String restaurantId) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/restaurants/admin/$restaurantId/reactivate'),
      headers: _getHeaders(),
    );

    return jsonDecode(response.body);
  }

  // Update restaurant details (for restaurant owners)
  static Future<Map<String, dynamic>> updateRestaurant(
      String name, String description, String address) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/restaurants/my-restaurant'),
      headers: _getHeaders(),
      body: jsonEncode({
        'name': name,
        'description': description,
        'address': address,
      }),
    );

    return jsonDecode(response.body);
  }

  // Get all users (admin)
  static Future<List<User>> getAllUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/admin/users'),
        headers: _getHeaders(),
      );
      
      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        List<User> users = (data['data'] as List)
            .map((json) => User.fromJson(json))
            .toList();
        return users;
      }

      return [];
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }

  // Get all orders (admin)
  static Future<List<Order>> getAllOrdersAdmin() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/orders'),
      headers: _getHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load orders: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);

    if (data['success'] == true) {
      List<Order> orders = (data['data'] as List)
          .map((json) => Order.fromJson(json))
          .toList();
      return orders;
    }

    return [];
  }

  // Get admin statistics
  static Future<Map<String, dynamic>> getAdminStats() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/reports'),
      headers: _getHeaders(),
    );

    final data = jsonDecode(response.body);

    if (data['success'] == true) {
      return data['data'] as Map<String, dynamic>;
    }

    return {};
  }
}
