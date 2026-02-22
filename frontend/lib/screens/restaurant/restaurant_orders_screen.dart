// Restaurant Orders Screen - shows incoming orders
// Restaurant owner can update order status

import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/order.dart';
import '../../constants/app_constants.dart';

class RestaurantOrdersScreen extends StatefulWidget {
  const RestaurantOrdersScreen({super.key});

  
  State<RestaurantOrdersScreen> createState() => _RestaurantOrdersScreenState();
}

class _RestaurantOrdersScreenState extends State<RestaurantOrdersScreen> {
  List<Order> _orders = [];
  bool _isLoading = true;

  
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final orders = await ApiService.getRestaurantOrders();
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showMessage('Error: $e', isError: true);
    }
  }

  Future<void> _updateStatus(String orderId, String newStatus) async {
    try {
      final response = await ApiService.updateOrderStatus(orderId, newStatus);

      if (response['success'] == true) {
        _showMessage('Order status updated!');
        _loadOrders();
      } else {
        _showMessage(response['message'] ?? 'Failed', isError: true);
      }
    } catch (e) {
      _showMessage('Error: $e', isError: true);
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
        title: const Text('Orders'),
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
                                  'Order #${order.id.substring(0, 8)}',
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
                            const SizedBox(height: 12),
                            const Text(
                              'Items:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            ...order.items.map((item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    '${item.name} x ${item.quantity} - ₹${(item.price * item.quantity).toStringAsFixed(0)}',
                                    style: TextStyle(color: AppColors.textLight),
                                  ),
                                )),
                            const SizedBox(height: 8),
                            Text(
                              'Total: ₹${order.totalAmount.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Status update buttons
                            if (order.status != AppConstants.orderDelivered &&
                                order.status != AppConstants.orderCancelled)
                              Wrap(
                                spacing: 8,
                                children: [
                                  if (order.status == AppConstants.orderPlaced)
                                    ElevatedButton(
                                      onPressed: () => _updateStatus(
                                          order.id, AppConstants.orderConfirmed),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('Confirm'),
                                    ),
                                  if (order.status == AppConstants.orderConfirmed)
                                    ElevatedButton(
                                      onPressed: () => _updateStatus(
                                          order.id, AppConstants.orderPreparing),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('Preparing'),
                                    ),
                                  if (order.status == AppConstants.orderPreparing)
                                    ElevatedButton(
                                      onPressed: () => _updateStatus(
                                          order.id, AppConstants.orderReady),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('Ready'),
                                    ),
                                  if (order.status == AppConstants.orderReady)
                                    ElevatedButton(
                                      onPressed: () => _updateStatus(
                                          order.id, AppConstants.orderDelivered),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('Delivered'),
                                    ),
                                  ElevatedButton(
                                    onPressed: () => _updateStatus(
                                        order.id, AppConstants.orderCancelled),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Cancel'),
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
