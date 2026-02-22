// Restaurant Menu Screen - shows menu items for selected restaurant
// User can add items to cart and place order

import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/restaurant.dart';
import '../../models/menu_item.dart';
import '../../constants/app_constants.dart';
import '../../widgets/menu_item_card.dart';
import '../../widgets/custom_button.dart';

class RestaurantMenuScreen extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;
  
  const RestaurantMenuScreen({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
  });

  
  State<RestaurantMenuScreen> createState() => _RestaurantMenuScreenState();
}

class _RestaurantMenuScreenState extends State<RestaurantMenuScreen> {
  List<MenuItem> _menuItems = [];
  Map<String, int> _cart = {}; // itemId -> quantity
  bool _isLoading = true;

  
  void initState() {
    super.initState();
    _loadMenu(widget.restaurantId);
  }

  Future<void> _loadMenu(String restaurantId) async {
    try {
      final items = await ApiService.getRestaurantMenu(restaurantId);
      setState(() {
        _menuItems = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showMessage('Error loading menu: $e', isError: true);
    }
  }

  void _addToCart(MenuItem item) {
    if (!item.isAvailable) {
      _showMessage('This item is not available', isError: true);
      return;
    }

    setState(() {
      _cart[item.id] = (_cart[item.id] ?? 0) + 1;
    });
    _showMessage('${item.name} added to cart');
  }

  void _removeFromCart(String itemId) {
    setState(() {
      if (_cart[itemId] != null && _cart[itemId]! > 1) {
        _cart[itemId] = _cart[itemId]! - 1;
      } else {
        _cart.remove(itemId);
      }
    });
  }

  double get _totalAmount {
    double total = 0;
    _cart.forEach((itemId, quantity) {
      final item = _menuItems.firstWhere((i) => i.id == itemId);
      total += item.price * quantity;
    });
    return total;
  }

  void _placeOrder() async {
    if (_cart.isEmpty) {
      _showMessage('Cart is empty', isError: true);
      return;
    }

    // Prepare order items
    List<Map<String, dynamic>> orderItems = [];
    _cart.forEach((itemId, quantity) {
      orderItems.add({
        'menuItemId': itemId,
        'quantity': quantity,
      });
    });

    try {
      final response = await ApiService.placeOrder(widget.restaurantId, orderItems);

      if (response['success'] == true) {
        _showMessage('Order placed successfully!');
        setState(() => _cart.clear());
      } else {
        _showMessage(response['message'] ?? 'Failed to place order', isError: true);
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

  
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.restaurantName),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Menu list
                Expanded(
                  child: _menuItems.isEmpty
                      ? const Center(child: Text('No items in menu'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _menuItems.length,
                          itemBuilder: (context, index) {
                            final item = _menuItems[index];
                            final quantity = _cart[item.id] ?? 0;

                            return MenuItemCard(
                              item: item,
                              onTap: () => _addToCart(item),
                              trailing: quantity > 0
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            onTap: () => _removeFromCart(item.id),
                                            child: const Icon(
                                              Icons.remove,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                            child: Text(
                                              '$quantity',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () => _addToCart(item),
                                            child: const Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : null,
                            );
                          },
                        ),
                ),

                // Cart summary and order button
                if (_cart.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_cart.length} items',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              '₹${_totalAmount.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        CustomButton(
                          text: 'Place Order',
                          onPressed: _placeOrder,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}
