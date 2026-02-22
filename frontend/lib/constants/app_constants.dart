// App Constants - all fixed values in one place
// Makes it easy to change colors, sizes, etc.

import 'package:flutter/material.dart';

class AppConstants {
  // App name
  static const String appName = 'Food Order App';

  // User roles
  static const String roleUser = 'USER';
  static const String roleRestaurant = 'RESTAURANT';
  static const String roleAdmin = 'ADMIN';

  // Order statuses
  static const String orderPlaced = 'PLACED';
  static const String orderConfirmed = 'CONFIRMED';
  static const String orderPreparing = 'PREPARING';
  static const String orderReady = 'READY';
  static const String orderDelivered = 'DELIVERED';
  static const String orderCancelled = 'CANCELLED';

  // Payment statuses
  static const String paymentPending = 'PENDING';
  static const String paymentCompleted = 'COMPLETED';
  static const String paymentFailed = 'FAILED';
}

// App Colors - simple color scheme
class AppColors {
  static const Color primary = Colors.orange;
  static const Color secondary = Colors.deepOrange;
  static const Color background = Color(0xFFF5F5F5);
  static const Color cardColor = Colors.white;
  static const Color textDark = Colors.black87;
  static const Color textLight = Colors.black54;
  static const Color success = Colors.green;
  static const Color error = Colors.red;
  static const Color warning = Colors.amber;
}
