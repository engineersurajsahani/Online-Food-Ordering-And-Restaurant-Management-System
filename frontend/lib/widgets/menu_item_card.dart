// Menu Item Card - shows a food item in a card
// Used in menu lists

import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../constants/app_constants.dart';

class MenuItemCard extends StatelessWidget {
  final MenuItem item;
  final VoidCallback? onTap;
  final Widget? trailing;

  const MenuItemCard({
    super.key,
    required this.item,
    this.onTap,
    this.trailing,
  });

  
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Food image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Builder(
                  builder: (context) {
                    if (item.image.isEmpty) {
                      return Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.fastfood,
                          size: 40,
                          color: Colors.grey,
                        ),
                      );
                    }
                    
                    // Use backend proxy for all external images to bypass CORS
                    String imageUrl = item.image;
                    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
                      // Route through backend proxy to bypass CORS
                      imageUrl = 'https://food-fc4q.onrender.com/api/proxy/image?url=${Uri.encodeComponent(item.image)}';
                    }
                    
                    return Image.network(
                      imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        // Show fallback icon if image fails to load
                        return Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.fastfood,
                            size: 40,
                            color: Colors.grey,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              // Item details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Veg/Non-veg indicator
                        Icon(
                          Icons.circle,
                          size: 16,
                          color: item.isVeg ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textLight,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '₹${item.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (!item.isAvailable)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Not Available',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.red,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              // Trailing widget (like add button)
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
