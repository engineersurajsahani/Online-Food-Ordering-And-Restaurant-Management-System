// MenuItem class - represents food items in menu
// Like pizza, burger, etc.

class MenuItem {
  String id;
  String name;
  String description;
  double price;
  bool isVeg;
  String category;
  bool isAvailable;
  String image; // URL of food image

  // Constructor
  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.isVeg,
    required this.category,
    required this.isAvailable,
    required this.image,
  });

  // Convert JSON to MenuItem object
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      isVeg: json['isVeg'] ?? true,
      category: json['category'] ?? 'Other',
      isAvailable: json['isAvailable'] ?? true,
      image: json['image'] ?? 'https://via.placeholder.com/300x200?text=Food+Item',
    );
  }
}
