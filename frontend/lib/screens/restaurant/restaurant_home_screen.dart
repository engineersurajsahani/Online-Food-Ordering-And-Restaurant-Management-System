// Restaurant Home Screen - dashboard for restaurant owners
// Shows their restaurant info and navigation to menu/orders

import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/restaurant.dart';
import '../../constants/app_constants.dart';
import '../../utils/storage_helper.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class RestaurantHomeScreen extends StatefulWidget {
  const RestaurantHomeScreen({super.key});

  
  State<RestaurantHomeScreen> createState() => _RestaurantHomeScreenState();
}

class _RestaurantHomeScreenState extends State<RestaurantHomeScreen> {
  Restaurant? _restaurant;
  bool _isLoading = true;
  bool _showCreateForm = false;
  Map<String, dynamic> _stats = {};

  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _addressController = TextEditingController();

  
  void initState() {
    super.initState();
    _loadRestaurant();
    _loadStats();
  }

  Future<void> _loadRestaurant() async {
    setState(() => _isLoading = true);
    try {
      final restaurant = await ApiService.getMyRestaurant();
      setState(() {
        _restaurant = restaurant;
        _isLoading = false;
        _showCreateForm = restaurant == null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _showCreateForm = true; // Show create form on error (likely no restaurant)
      });
    }
  }

  Future<void> _loadStats() async {
    try {
      final stats = await ApiService.getRestaurantStats();
      setState(() {
        _stats = stats;
      });
    } catch (e) {
      // Ignore stats loading errors
    }
  }

  Future<void> _createRestaurant() async {
    final name = _nameController.text.trim();
    final desc = _descController.text.trim();
    final address = _addressController.text.trim();

    if (name.isEmpty || address.isEmpty) {
      _showMessage('Name and address required', isError: true);
      return;
    }

    try {
      final response = await ApiService.createRestaurant(name, desc, address);

      if (response['success'] == true) {
        _showMessage('Restaurant created!');
        _loadRestaurant();
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

  void _logout() async {
    await StorageHelper.clearAll();
    ApiService.clearToken();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _toggleRestaurantStatus(bool newStatus) async {
    try {
      final response = await ApiService.toggleRestaurantStatus(newStatus);
      
      if (response['success'] == true) {
        setState(() {
          _restaurant!.isOpen = newStatus;
        });
        _showMessage(newStatus ? 'Restaurant opened for orders' : 'Restaurant closed for orders');
        _loadStats(); // Reload stats
      } else {
        _showMessage(response['message'] ?? 'Failed to update status', isError: true);
        // Reload to get correct state from server
        _loadRestaurant();
      }
    } catch (e) {
      _showMessage('Error toggling status: $e', isError: true);
      // Reload to get correct state from server
      _loadRestaurant();
    }
  }

  Future<void> _submitForApproval() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit for Approval'),
        content: const Text(
          'Submit your restaurant for admin review? You can continue adding menu items while waiting for approval.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Submit'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      _showMessage('Restaurant already submitted for approval');
    }
  }

  void _showEditDialog() {
    _nameController.text = _restaurant!.name;
    _descController.text = _restaurant!.description;
    _addressController.text = _restaurant!.address;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Restaurant'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                label: 'Restaurant Name',
                controller: _nameController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Description',
                controller: _descController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Address',
                controller: _addressController,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final name = _nameController.text.trim();
              final desc = _descController.text.trim();
              final address = _addressController.text.trim();

              if (name.isEmpty || address.isEmpty) {
                _showMessage('Name and address required', isError: true);
                return;
              }

              Navigator.pop(context);

              try {
                final response = await ApiService.updateRestaurant(
                  name,
                  desc,
                  address,
                );

                if (response['success'] == true) {
                  _showMessage('Restaurant updated!');
                  _loadRestaurant();
                } else {
                  _showMessage(response['message'] ?? 'Failed', isError: true);
                }
              } catch (e) {
                _showMessage('Error: $e', isError: true);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Restaurant Dashboard'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _showCreateForm
              ? _buildCreateForm()
              : _buildDashboard(),
    );
  }

  Widget _buildCreateForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create Your Restaurant',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          CustomTextField(
            label: 'Restaurant Name',
            controller: _nameController,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Description',
            controller: _descController,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Address',
            controller: _addressController,
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Create Restaurant',
            onPressed: _createRestaurant,
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Approval status banner
          if (_restaurant!.approvalStatus != 'APPROVED')
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: _restaurant!.approvalStatus == 'PENDING'
                    ? Colors.orange[100]
                    : Colors.red[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _restaurant!.approvalStatus == 'PENDING'
                      ? Colors.orange
                      : Colors.red,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _restaurant!.approvalStatus == 'PENDING'
                        ? Icons.pending
                        : Icons.cancel,
                    color: _restaurant!.approvalStatus == 'PENDING'
                        ? Colors.orange
                        : Colors.red,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _restaurant!.approvalStatus == 'PENDING'
                              ? '⏳ Pending Admin Approval'
                              : '❌ Restaurant Rejected',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _restaurant!.approvalStatus == 'PENDING'
                                ? Colors.orange[900]
                                : Colors.red[900],
                          ),
                        ),
                        Text(
                          _restaurant!.approvalStatus == 'PENDING'
                              ? 'Your restaurant is under review. You\'ll be notified once approved.'
                              : 'Please contact support for more information.',
                          style: TextStyle(
                            fontSize: 12,
                            color: _restaurant!.approvalStatus == 'PENDING'
                                ? Colors.orange[800]
                                : Colors.red[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Restaurant info card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _restaurant!.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showEditDialog(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _restaurant!.description,
                    style: TextStyle(color: AppColors.textLight),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: AppColors.textLight),
                      const SizedBox(width: 4),
                      Text(_restaurant!.address),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Open/Close Toggle
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _restaurant!.isOpen
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _restaurant!.isOpen ? Colors.green : Colors.red,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _restaurant!.isOpen ? Icons.store : Icons.store_mall_directory_outlined,
                          color: _restaurant!.isOpen ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _restaurant!.isOpen ? 'Restaurant Open' : 'Restaurant Closed',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _restaurant!.isOpen ? Colors.green[900] : Colors.red[900],
                                ),
                              ),
                              Text(
                                _restaurant!.isOpen
                                    ? 'Accepting orders now'
                                    : 'Not accepting orders',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _restaurant!.isOpen ? Colors.green[700] : Colors.red[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _restaurant!.isOpen,
                          onChanged: _restaurant!.approvalStatus == 'APPROVED'
                              ? _toggleRestaurantStatus
                              : null,
                          activeColor: Colors.green,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 12,
                        color: _restaurant!.isOpen ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _restaurant!.isOpen ? 'Open' : 'Closed',
                        style: TextStyle(
                          color: _restaurant!.isOpen ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Statistics Dashboard
          if (_restaurant!.approvalStatus == 'APPROVED') ...[
            const Text(
              'Statistics',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            // Order counts by status
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Orders Overview',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatBox(
                            'Pending',
                            _stats['pending']?.toString() ?? '0',
                            Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildStatBox(
                            'Confirmed',
                            _stats['confirmed']?.toString() ?? '0',
                            Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatBox(
                            'Preparing',
                            _stats['preparing']?.toString() ?? '0',
                            Colors.purple,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildStatBox(
                            'Ready',
                            _stats['ready']?.toString() ?? '0',
                            Colors.teal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatBox(
                            'Delivered',
                            _stats['delivered']?.toString() ?? '0',
                            Colors.green,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildStatBox(
                            'Cancelled',
                            _stats['cancelled']?.toString() ?? '0',
                            Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Earnings Dashboard
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Earnings',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Total Revenue
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Revenue (Delivered)',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '₹${(_stats['totalRevenue'] ?? 0).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Platform Fee (20%)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange[200]!),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Platform Fee (20%)',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.info_outline,
                                size: 16,
                                color: Colors.orange[700],
                              ),
                            ],
                          ),
                          Text(
                            '₹${(_stats['platformFee'] ?? 0).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[900],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Restaurant Earnings (80%)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green[300]!),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Your Earnings (80%)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '₹${(_stats['restaurantEarnings'] ?? 0).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[900],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Action buttons
          _buildActionCard(
            icon: Icons.restaurant_menu,
            title: 'Manage Menu',
            subtitle: 'Add or edit menu items',
            onTap: () {
              Navigator.pushNamed(context, '/manage-menu');
            },
          ),
          const SizedBox(height: 12),
          _buildActionCard(
            icon: Icons.receipt_long,
            title: 'View Orders',
            subtitle: 'Check incoming orders',
            onTap: () {
              Navigator.pushNamed(context, '/restaurant-orders');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppColors.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: AppColors.textLight),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
