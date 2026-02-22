// Admin Home Screen - comprehensive admin dashboard
// Manages restaurants, users, orders, and statistics

import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../utils/storage_helper.dart';
import '../../services/api_service.dart';
import '../../models/restaurant.dart';
import '../../models/user.dart';
import '../../models/order.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Restaurant tab
  List<Restaurant> _restaurants = [];
  bool _loadingRestaurants = true;
  String _filter = 'ALL';
  
  // Users tab
  List<User> _users = [];
  bool _loadingUsers = true;
  
  // Orders tab
  List<Order> _orders = [];
  bool _loadingOrders = true;
  
  // Stats
  Map<String, dynamic> _stats = {};

  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadAllData();
  }

  
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAllData() async {
    _loadRestaurants();
    _loadUsers();
    _loadOrders();
    _loadStats();
  }

  Future<void> _loadRestaurants() async {
    setState(() => _loadingRestaurants = true);
    try {
      final restaurants = await ApiService.getAllRestaurantsAdmin();
      setState(() {
        _restaurants = restaurants;
        _loadingRestaurants = false;
      });
    } catch (e) {
      setState(() => _loadingRestaurants = false);
      _showMessage('Error loading restaurants: $e', isError: true);
    }
  }

  Future<void> _loadUsers() async {
    setState(() => _loadingUsers = true);
    try {
      final users = await ApiService.getAllUsers();
      setState(() {
        _users = users;
        _loadingUsers = false;
      });
    } catch (e) {
      setState(() => _loadingUsers = false);
      _showMessage('Error loading users: $e', isError: true);
    }
  }

  Future<void> _loadOrders() async {
    setState(() => _loadingOrders = true);
    try {
      final orders = await ApiService.getAllOrdersAdmin();
      setState(() {
        _orders = orders;
        _loadingOrders = false;
      });
    } catch (e) {
      setState(() => _loadingOrders = false);
      _showMessage('Error loading orders: $e', isError: true);
    }
  }

  Future<void> _loadStats() async {
    try {
      final stats = await ApiService.getAdminStats();
      setState(() => _stats = stats);
    } catch (e) {
      _showMessage('Error loading stats: $e', isError: true);
    }
  }

  List<Restaurant> get _filteredRestaurants {
    if (_filter == 'ALL') return _restaurants;
    return _restaurants
        .where((r) => r.approvalStatus == _filter)
        .toList();
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

  Future<void> _approveRestaurant(Restaurant restaurant) async {
    final notesController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve Restaurant'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Approve "${restaurant.name}"?'),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'Approval Notes (optional)',
                hintText: 'Add any notes...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Approve'),
          ),
        ],
      ),
    );

    if (result == true) {
      try {
        final response = await ApiService.approveRestaurant(
          restaurant.id,
          notesController.text.trim().isEmpty
              ? 'Approved by admin'
              : notesController.text.trim(),
        );

        if (response['success'] == true) {
          _showMessage('Restaurant approved!');
          _loadRestaurants();
        } else {
          _showMessage(response['message'] ?? 'Failed', isError: true);
        }
      } catch (e) {
        _showMessage('Error: $e', isError: true);
      }
    }
  }

  Future<void> _rejectRestaurant(Restaurant restaurant) async {
    final reasonController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Restaurant'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reject "${restaurant.name}"?'),
            const SizedBox(height: 8),
            const Text(
              'This will close the restaurant and notify the owner.',
              style: TextStyle(fontSize: 12, color: Colors.red),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Rejection Reason *',
                hintText: 'Enter reason...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Reason is required'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              Navigator.pop(context, true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reject'),
          ),
        ],
      ),
    );

    if (result == true && reasonController.text.trim().isNotEmpty) {
      try {
        final response = await ApiService.rejectRestaurant(
          restaurant.id,
          reasonController.text.trim(),
        );

        if (response['success'] == true) {
          _showMessage('Restaurant rejected');
          _loadRestaurants();
        } else {
          _showMessage(response['message'] ?? 'Failed', isError: true);
        }
      } catch (e) {
        _showMessage('Error: $e', isError: true);
      }
    }
  }

  Future<void> _deactivateRestaurant(Restaurant restaurant) async {
    final reasonController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deactivate Restaurant'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Deactivate "${restaurant.name}"?'),
            const SizedBox(height: 8),
            const Text(
              'Restaurant will be hidden from customers until reactivated.',
              style: TextStyle(fontSize: 12, color: Colors.orange),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason (optional)',
                hintText: 'Enter reason...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );

    if (result == true) {
      try {
        final response = await ApiService.deactivateRestaurant(
          restaurant.id,
          reasonController.text.trim().isEmpty
              ? 'Deactivated by admin'
              : reasonController.text.trim(),
        );

        if (response['success'] == true) {
          _showMessage('Restaurant deactivated');
          _loadRestaurants();
        } else {
          _showMessage(response['message'] ?? 'Failed', isError: true);
        }
      } catch (e) {
        _showMessage('Error: $e', isError: true);
      }
    }
  }

  Future<void> _reactivateRestaurant(Restaurant restaurant) async {
    try {
      final response = await ApiService.reactivateRestaurant(restaurant.id);

      if (response['success'] == true) {
        _showMessage('Restaurant reactivated');
        _loadRestaurants();
      } else {
        _showMessage(response['message'] ?? 'Failed', isError: true);
      }
    } catch (e) {
      _showMessage('Error: $e', isError: true);
    }
  }

  void _showRestaurantDetails(Restaurant restaurant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(restaurant.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Status', restaurant.approvalStatus),
              _buildDetailRow('Active', restaurant.isActive ? 'Yes' : 'No'),
              _buildDetailRow('Address', restaurant.address),
              _buildDetailRow('Description', restaurant.description),
              _buildDetailRow(
                'Open',
                restaurant.isOpen ? 'Yes' : 'No',
              ),
              _buildDetailRow(
                'Prep Time',
                '${restaurant.preparationTime} mins',
              ),
              if (restaurant.approvalStatus != 'PENDING')
                _buildDetailRow('Created', restaurant.id),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.restaurant), text: 'Restaurants'),
            Tab(icon: Icon(Icons.people), text: 'Users'),
            Tab(icon: Icon(Icons.receipt), text: 'Orders'),
            Tab(icon: Icon(Icons.analytics), text: 'Stats'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAllData,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRestaurantsTab(),
          _buildUsersTab(),
          _buildOrdersTab(),
          _buildStatsTab(),
        ],
      ),
    );
  }

  // ========== RESTAURANTS TAB ==========
  Widget _buildRestaurantsTab() {
    final pendingCount = _restaurants.where((r) => r.approvalStatus == 'PENDING').length;
    final approvedCount = _restaurants.where((r) => r.approvalStatus == 'APPROVED').length;

    return Column(
      children: [
        // Stats cards
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total',
                  _restaurants.length.toString(),
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Pending',
                  pendingCount.toString(),
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Approved',
                  approvedCount.toString(),
                  Colors.green,
                ),
              ),
            ],
          ),
        ),

        // Filter chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildFilterChip('ALL', 'All'),
              _buildFilterChip('PENDING', 'Pending'),
              _buildFilterChip('APPROVED', 'Approved'),
              _buildFilterChip('REJECTED', 'Rejected'),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Restaurant list
        Expanded(
          child: _loadingRestaurants
              ? const Center(child: CircularProgressIndicator())
              : _filteredRestaurants.isEmpty
                  ? Center(
                      child: Text(
                        'No ${_filter == 'ALL' ? '' : _filter.toLowerCase()} restaurants',
                        style: TextStyle(color: AppColors.textLight),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredRestaurants.length,
                      itemBuilder: (context, index) {
                        return _buildRestaurantCard(_filteredRestaurants[index]);
                      },
                    ),
        ),
      ],
    );
  }

  // ========== USERS TAB ==========
  Widget _buildUsersTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Users',
                  _users.length.toString(),
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Customers',
                  _users.where((u) => u.role == 'USER').length.toString(),
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Restaurants',
                  _users.where((u) => u.role == 'RESTAURANT').length.toString(),
                  Colors.orange,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _loadingUsers
              ? const Center(child: CircularProgressIndicator())
              : _users.isEmpty
                  ? const Center(child: Text('No users found'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _users.length,
                      itemBuilder: (context, index) {
                        return _buildUserCard(_users[index]);
                      },
                    ),
        ),
      ],
    );
  }

  // ========== ORDERS TAB ==========
  Widget _buildOrdersTab() {
    final pendingOrders = _orders.where((o) => o.status == 'Pending').length;
    final completedOrders = _orders.where((o) => o.status == 'Delivered').length;
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total',
                  _orders.length.toString(),
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Pending',
                  pendingOrders.toString(),
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Completed',
                  completedOrders.toString(),
                  Colors.green,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _loadingOrders
              ? const Center(child: CircularProgressIndicator())
              : _orders.isEmpty
                  ? const Center(child: Text('No orders found'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _orders.length,
                      itemBuilder: (context, index) {
                        return _buildOrderCard(_orders[index]);
                      },
                    ),
        ),
      ],
    );
  }

  // ========== STATS TAB ==========
  Widget _buildStatsTab() {
    final totalRevenue = _stats['totalRevenue'] ?? 0;
    final platformRevenue = _stats['platformRevenue'] ?? 0;
    final restaurantRevenue = _stats['restaurantRevenue'] ?? 0;
    final monthlyRevenue = _stats['monthlyRevenue'] ?? 0;
    final monthlyPlatformRevenue = _stats['monthlyPlatformRevenue'] ?? 0;
    final totalOrders = _stats['totalOrders'] ?? 0;
    final totalUsers = _stats['totalUsers'] ?? 0;
    final totalRestaurants = _stats['totalRestaurants'] ?? 0;
    final avgOrderValue = _stats['avgOrderValue'] ?? 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Platform Statistics',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          
          // Platform Revenue (Admin Earnings)
          Card(
            color: Colors.green[50],
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.account_balance_wallet, color: Colors.green[700]),
                      const SizedBox(width: 8),
                      const Text(
                        'Platform Revenue',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '₹${platformRevenue.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '20% commission from all delivered orders',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Orders Revenue', style: TextStyle(fontSize: 11)),
                          Text(
                            '₹${totalRevenue.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Restaurant Share (80%)', style: TextStyle(fontSize: 11)),
                          Text(
                            '₹${restaurantRevenue.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // This month's revenue
          Card(
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.blue[700]),
                      const SizedBox(width: 8),
                      const Text(
                        'This Month Revenue',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '₹${monthlyPlatformRevenue.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total monthly orders: ₹${monthlyRevenue.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Icon(Icons.shopping_bag, size: 40, color: Colors.blue),
                        const SizedBox(height: 12),
                        Text(
                          '$totalOrders',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const Text('Total Orders', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Icon(Icons.attach_money, size: 40, color: Colors.orange),
                        const SizedBox(height: 12),
                        Text(
                          '₹${avgOrderValue.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const Text('Avg Order Value', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Icon(Icons.restaurant, size: 40, color: Colors.purple),
                        const SizedBox(height: 12),
                        Text(
                          '$totalRestaurants',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const Text('Restaurants', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Icon(Icons.people, size: 40, color: Colors.teal),
                        const SizedBox(height: 12),
                        Text(
                          '$totalUsers',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const Text('Users', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          const Text(
            'Quick Stats',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          _buildQuickStatRow('Restaurants', _restaurants.length),
          _buildQuickStatRow('Pending Approvals', _restaurants.where((r) => r.approvalStatus == 'PENDING').length),
          _buildQuickStatRow('Total Orders', _orders.length),
          _buildQuickStatRow('Completed Orders', _orders.where((o) => o.status == 'Delivered').length),
          _buildQuickStatRow('Total Customers', _users.where((u) => u.role == 'USER').length),
          _buildQuickStatRow('Restaurant Owners', _users.where((u) => u.role == 'RESTAURANT').length),
        ],
      ),
    );
  }

  Widget _buildQuickStatRow(String label, int value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 16)),
            Text(
              value.toString(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: _filter == value,
        onSelected: (selected) {
          setState(() => _filter = value);
        },
      ),
    );
  }

  Widget _buildRestaurantCard(Restaurant restaurant) {
    Color statusColor;
    switch (restaurant.approvalStatus) {
      case 'APPROVED':
        statusColor = Colors.green;
        break;
      case 'REJECTED':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.orange;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        restaurant.address,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    restaurant.approvalStatus,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              restaurant.description,
              style: TextStyle(color: AppColors.textLight),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),

            // Action buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _showRestaurantDetails(restaurant),
                  icon: const Icon(Icons.info, size: 16),
                  label: const Text('Details'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
                if (restaurant.approvalStatus == 'PENDING')
                  ElevatedButton.icon(
                    onPressed: () => _approveRestaurant(restaurant),
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Approve'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                if (restaurant.approvalStatus == 'PENDING')
                  ElevatedButton.icon(
                    onPressed: () => _rejectRestaurant(restaurant),
                    icon: const Icon(Icons.close, size: 16),
                    label: const Text('Reject'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                if (restaurant.isActive && restaurant.approvalStatus == 'APPROVED')
                  OutlinedButton.icon(
                    onPressed: () => _deactivateRestaurant(restaurant),
                    icon: const Icon(Icons.block, size: 16),
                    label: const Text('Deactivate'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  )
                else if (!restaurant.isActive)
                  OutlinedButton.icon(
                    onPressed: () => _reactivateRestaurant(restaurant),
                    icon: const Icon(Icons.check_circle, size: 16),
                    label: const Text('Reactivate'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(User user) {
    Color roleColor;
    switch (user.role) {
      case 'ADMIN':
        roleColor = Colors.purple;
        break;
      case 'RESTAURANT':
        roleColor = Colors.orange;
        break;
      default:
        roleColor = Colors.blue;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: roleColor,
          child: Text(
            user.name[0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(user.name),
        subtitle: Text(user.email),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: roleColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            user.role,
            style: TextStyle(
              color: roleColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    Color statusColor;
    switch (order.status) {
      case 'Delivered':
        statusColor = Colors.green;
        break;
      case 'Preparing':
      case 'Ready':
        statusColor = Colors.blue;
        break;
      case 'Confirmed':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.grey;
    }

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
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    order.status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${order.items.length} items',
              style: TextStyle(color: AppColors.textLight),
            ),
            const SizedBox(height: 4),
            Text(
              '₹${order.totalAmount.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
