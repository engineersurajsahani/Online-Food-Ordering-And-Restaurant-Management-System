// Manage Menu Screen - restaurant owner manages menu items
// Can add new items and see existing ones

import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/menu_item.dart';
import '../../constants/app_constants.dart';
import '../../constants/categories.dart';
import '../../widgets/menu_item_card.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class ManageMenuScreen extends StatefulWidget {
  const ManageMenuScreen({super.key});

  
  State<ManageMenuScreen> createState() => _ManageMenuScreenState();
}

class _ManageMenuScreenState extends State<ManageMenuScreen> {
  List<MenuItem> _menuItems = [];
  bool _isLoading = true;
  bool _showAddForm = false;

  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();
  bool _isVeg = true;
  String _selectedCategory = 'Other';

  
  void initState() {
    super.initState();
    _loadMenu();
  }

  Future<void> _loadMenu() async {
    try {
      final items = await ApiService.getMyMenu();
      setState(() {
        _menuItems = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showMessage('Error: $e', isError: true);
    }
  }

  Future<void> _addItem() async {
    final name = _nameController.text.trim();
    final desc = _descController.text.trim();
    final priceStr = _priceController.text.trim();
    final image = _imageController.text.trim();

    if (name.isEmpty || priceStr.isEmpty) {
      _showMessage('Name and price required', isError: true);
      return;
    }

    final price = double.tryParse(priceStr);
    if (price == null || price < 0) {
      _showMessage('Invalid price', isError: true);
      return;
    }

    try {
      final response = await ApiService.addMenuItem(
        name,
        desc,
        price,
        _isVeg,
        _selectedCategory,
        image.isEmpty ? 'https://via.placeholder.com/300x200?text=Food' : image,
      );

      if (response['success'] == true) {
        _showMessage('Item added!');
        _clearForm();
        setState(() => _showAddForm = false);
        _loadMenu();
      } else {
        _showMessage(response['message'] ?? 'Failed', isError: true);
      }
    } catch (e) {
      _showMessage('Error: $e', isError: true);
    }
  }

  void _clearForm() {
    _nameController.clear();
    _descController.clear();
    _priceController.clear();
    _imageController.clear();
    _isVeg = true;
    _selectedCategory = 'Other';
  }

  Future<void> _toggleAvailability(MenuItem item) async {
    try {
      final response = await ApiService.toggleMenuItemAvailability(item.id);
      if (response['success'] == true) {
        _showMessage('Availability updated');
        _loadMenu();
      } else {
        _showMessage(response['message'] ?? 'Failed', isError: true);
      }
    } catch (e) {
      _showMessage('Error: $e', isError: true);
    }
  }

  Future<void> _editItem(MenuItem item) async {
    _nameController.text = item.name;
    _descController.text = item.description;
    _priceController.text = item.price.toString();
    _imageController.text = item.image;
    _isVeg = item.isVeg;
    _selectedCategory = item.category;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Menu Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                label: 'Item Name',
                controller: _nameController,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Description',
                controller: _descController,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Price',
                controller: _priceController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              const Text('Category', style: TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 4),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: FOOD_CATEGORIES.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedCategory = value!);
                },
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Image URL (optional)',
                controller: _imageController,
              ),
              const SizedBox(height: 4),
              Text(
                'Example: https://images.unsplash.com/photo-abc123\nLeave empty for default image',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textLight,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Checkbox(
                    value: _isVeg,
                    onChanged: (value) {
                      setState(() => _isVeg = value!);
                    },
                  ),
                  const Text('Vegetarian'),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result == true) {
      final name = _nameController.text.trim();
      final priceStr = _priceController.text.trim();

      if (name.isEmpty || priceStr.isEmpty) {
        _showMessage('Name and price required', isError: true);
        return;
      }

      final price = double.tryParse(priceStr);
      if (price == null || price < 0) {
        _showMessage('Invalid price', isError: true);
        return;
      }

      try {
        final response = await ApiService.updateMenuItem(
          item.id,
          name,
          _descController.text.trim(),
          price,
          _isVeg,
          _selectedCategory,
          _imageController.text.trim(),
        );

        if (response['success'] == true) {
          _showMessage('Item updated!');
          _clearForm();
          _loadMenu();
        } else {
          _showMessage(response['message'] ?? 'Failed', isError: true);
        }
      } catch (e) {
        _showMessage('Error: $e', isError: true);
      }
    } else {
      _clearForm();
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
        title: const Text('Manage Menu'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_showAddForm ? Icons.close : Icons.add),
            onPressed: () {
              setState(() => _showAddForm = !_showAddForm);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_showAddForm) _buildAddForm(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _menuItems.isEmpty
                    ? const Center(child: Text('No menu items yet'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _menuItems.length,
                        itemBuilder: (context, index) {
                          final item = _menuItems[index];
                          return MenuItemCard(
                            item: item,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    item.isAvailable
                                        ? Icons.toggle_on
                                        : Icons.toggle_off,
                                    color: item.isAvailable
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                  onPressed: () => _toggleAvailability(item),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 20),
                                  onPressed: () => _editItem(item),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add New Item',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Item Name',
              controller: _nameController,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              label: 'Description',
              controller: _descController,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              label: 'Price',
              controller: _priceController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            const Text('Category', style: TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 4),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: FOOD_CATEGORIES.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedCategory = value!);
              },
            ),
            const SizedBox(height: 12),
            CustomTextField(
              label: 'Image URL (optional)',
              controller: _imageController,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  value: _isVeg,
                  onChanged: (value) {
                    setState(() => _isVeg = value!);
                  },
                ),
                const Text('Vegetarian'),
              ],
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Add Item',
              onPressed: _addItem,
            ),
          ],
        ),
      ),
    );
  }
}
