// My Orders Screen - shows user's order history
// Simple list of all orders

import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/order.dart';
import '../../constants/app_constants.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  List<Order> _orders = [];
  bool _isLoading = true;

  
  void initState() {
    super.initState();
    _loadOrders();
    // Auto-refresh every 10 seconds to show updated status
    _startAutoRefresh();
  }

  
  void dispose() {
    _stopAutoRefresh();
    super.dispose();
  }

  void _startAutoRefresh() {
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        _loadOrders();
        _startAutoRefresh();
      }
    });
  }

  void _stopAutoRefresh() {
    // Timer will stop when widget is disposed
  }

  Future<void> _loadOrders() async {
    try {
      final orders = await ApiService.getMyOrders();
      if (mounted) {
        setState(() {
          _orders = orders;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showMessage('Error loading orders: $e', isError: true);
      }
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

  Color _getStatusColor(String status) {
    switch (status) {
      case AppConstants.orderDelivered:
        return Colors.green;
      case AppConstants.orderCancelled:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
              ? const Center(child: Text('No orders yet'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _orders.length,
                  itemBuilder: (context, index) {
                    final order = _orders[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  order.restaurantName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(order.status)
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    order.status,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _getStatusColor(order.status),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ...order.items.map((item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    '${item.name} x ${item.quantity}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textLight,
                                    ),
                                  ),
                                )),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total: ₹${order.totalAmount.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green[50],
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.green[300]!),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.payments, 
                                        size: 14, 
                                        color: Colors.green[700]
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Cash on Delivery',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.green[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
