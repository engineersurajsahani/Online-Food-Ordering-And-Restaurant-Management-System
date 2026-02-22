// User Home Screen - Browse restaurants and menu items
// Shows all dishes with search and category filters

import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/restaurant.dart';
import '../../models/menu_item.dart';
import '../../constants/app_constants.dart';
import '../../constants/categories.dart';
import '../../utils/storage_helper.dart';
import '../../widgets/menu_item_card.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  List<Restaurant> _restaurants = [];
  List<MenuItem> _allMenuItems = [];
  List<MenuItem> _filteredMenuItems = [];
  Map<String, String> _itemRestaurants = {}; // menuItemId -> restaurantId
  bool _isLoading = true;
  String _searchQuery = '';
  String? _selectedCategory;
  Map<String, dynamic> _stats = {};

  final TextEditingController _searchController = TextEditingController();

  
  void initState() {
    super.initState();
    _loadData();
    _loadStats();
  }

  
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final restaurants = await ApiService.getAllRestaurants();
      
      // Load menu items from all restaurants
      List<MenuItem> allItems = [];
      Map<String, String> itemRestaurants = {};
      
      for (var restaurant in restaurants) {
        try {
          final items = await ApiService.getRestaurantMenu(restaurant.id);
          for (var item in items) {
            itemRestaurants[item.id] = restaurant.id;
          }
          allItems.addAll(items);
        } catch (e) {
          // Skip if menu fails to load
        }
      }

      setState(() {
        _restaurants = restaurants;
        _allMenuItems = allItems;
        _filteredMenuItems = allItems;
        _itemRestaurants = itemRestaurants;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showMessage('Error loading data: $e', isError: true);
    }
  }

  Future<void> _loadStats() async {
    try {
      final stats = await ApiService.getUserStats();
      setState(() {
        _stats = stats;
      });
    } catch (e) {
      // Ignore stats loading errors
    }
  }

  void _filterItems() {
    setState(() {
      _filteredMenuItems = _allMenuItems.where((item) {
        final matchesSearch = _searchQuery.isEmpty ||
            item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            item.description.toLowerCase().contains(_searchQuery.toLowerCase());
        
        final matchesCategory = _selectedCategory == null || 
            item.category == _selectedCategory;
        
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _onSearchChanged(String value) {
    setState(() => _searchQuery = value);
    _filterItems();
  }

  void _onCategorySelected(String? category) {
    setState(() => _selectedCategory = category);
    _filterItems();
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
      ),
    );
  }

  void _logout() async {
    await StorageHelper.clearAll();
    ApiService.clearToken();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _placeOrder(MenuItem item) {
    final restaurantId = _itemRestaurants[item.id];
    if (restaurantId == null) {
      _showMessage('Restaurant not found', isError: true);
      return;
    }

    // Check if restaurant is open
    final restaurant = _restaurants.firstWhere(
      (r) => r.id == restaurantId,
      orElse: () => _restaurants.first,
    );

    if (!restaurant.isOpen) {
      _showMessage('This restaurant is currently closed', isError: true);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => _OrderDialog(
        item: item,
        restaurantId: restaurantId,
        onOrderPlaced: () => _showMessage('Order placed successfully!'),
      ),
    );
  }

  
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Order Food'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long),
            onPressed: () => Navigator.pushNamed(context, '/my-orders'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Statistics Card
                if (_stats.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatItem(
                              'Total Orders',
                              _stats['totalOrders']?.toString() ?? '0',
                              Icons.shopping_bag,
                            ),
                            _buildStatItem(
                              'Delivered',
                              _stats['delivered']?.toString() ?? '0',
                              Icons.check_circle,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatItem(
                              'This Month',
                              '₹${(_stats['thisMonthSpent'] ?? 0).toStringAsFixed(0)}',
                              Icons.calendar_today,
                            ),
                            _buildStatItem(
                              'Total Spent',
                              '₹${(_stats['totalSpent'] ?? 0).toStringAsFixed(0)}',
                              Icons.account_balance_wallet,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                
                // Search bar
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search for dishes...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _onSearchChanged('');
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                
                // Category chips
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildCategoryChip('All', null),
                      ...FOOD_CATEGORIES.map((category) => 
                        _buildCategoryChip(category, category)
                      ),
                    ],
                  ),
                ),

                // Restaurants section (compact)
                if (_restaurants.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Restaurants',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 90,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _restaurants.length,
                            itemBuilder: (context, index) {
                              return _buildRestaurantChip(_restaurants[index]);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                const Divider(height: 1),

                // All dishes list
                Expanded(
                  child: _filteredMenuItems.isEmpty
                      ? Center(
                          child: Text(
                            _searchQuery.isNotEmpty || _selectedCategory != null
                                ? 'No dishes found'
                                : 'No dishes available',
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredMenuItems.length,
                          itemBuilder: (context, index) {
                            final item = _filteredMenuItems[index];
                            final restaurantId = _itemRestaurants[item.id];
                            final restaurant = _restaurants.firstWhere(
                              (r) => r.id == restaurantId,
                              orElse: () => _restaurants.first,
                            );
                            final isOpen = restaurant.isOpen;
                            
                            return MenuItemCard(
                              item: item,
                              onTap: isOpen ? () => _placeOrder(item) : null,
                              trailing: isOpen
                                  ? Icon(
                                      Icons.add_shopping_cart,
                                      color: AppColors.primary,
                                    )
                                  : Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red[100],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'Closed',
                                        style: TextStyle(
                                          color: Colors.red[700],
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildCategoryChip(String label, String? category) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => _onCategorySelected(category),
        backgroundColor: Colors.white,
        selectedColor: AppColors.primary.withOpacity(0.2),
        checkmarkColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildRestaurantChip(Restaurant restaurant) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/restaurant-menu?id=${restaurant.id}&name=${Uri.encodeComponent(restaurant.name)}',
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.restaurant,
                  color: restaurant.isOpen ? AppColors.primary : Colors.grey,
                  size: 28,
                ),
                const SizedBox(height: 4),
                Text(
                  restaurant.name,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                if (!restaurant.isOpen)
                  Text(
                    'Closed',
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.red[700],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Order Dialog
class _OrderDialog extends StatefulWidget {
  final MenuItem item;
  final String restaurantId;
  final VoidCallback onOrderPlaced;

  const _OrderDialog({
    required this.item,
    required this.restaurantId,
    required this.onOrderPlaced,
  });

  
  State<_OrderDialog> createState() => _OrderDialogState();
}

class _OrderDialogState extends State<_OrderDialog> {
  int _quantity = 1;
  bool _isPlacingOrder = false;

  Future<void> _placeOrder() async {
    setState(() => _isPlacingOrder = true);

    try {
      final response = await ApiService.placeOrder(
        widget.restaurantId,
        [
          {
            'menuItemId': widget.item.id,
            'quantity': _quantity,
          }
        ],
      );

      if (response['success'] == true) {
        widget.onOrderPlaced();
        if (!mounted) return;
        Navigator.pop(context);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Failed to place order'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isPlacingOrder = false);
      }
    }
  }

  
  Widget build(BuildContext context) {
    final total = widget.item.price * _quantity;

    return AlertDialog(
      title: Text(widget.item.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.item.description),
          const SizedBox(height: 16),
          Text(
            '₹${widget.item.price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Quantity: '),
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: _quantity > 1
                    ? () => setState(() => _quantity--)
                    : null,
              ),
              Text(
                '$_quantity',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => setState(() => _quantity++),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Total: ₹${total.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.payment, color: Colors.green[700], size: 20),
                const SizedBox(width: 8),
                Text(
                  'Cash on Delivery',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isPlacingOrder ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isPlacingOrder ? null : _placeOrder,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          child: _isPlacingOrder
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Text('Place Order'),
        ),
      ],
    );
  }
}
