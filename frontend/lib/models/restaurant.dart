// Restaurant class - represents a restaurant
// Simple data holder

class Restaurant {
  String id;
  String name;
  String description;
  String address;
  bool isOpen;
  int preparationTime;
  String approvalStatus; // PENDING, APPROVED, REJECTED
  bool isActive;

  // Constructor
  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.isOpen,
    required this.preparationTime,
    required this.approvalStatus,
    required this.isActive,
  });

  // Convert JSON to Restaurant object
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      isOpen: json['isOpen'] ?? true,
      preparationTime: json['preparationTime'] ?? 30,
      approvalStatus: json['approvalStatus'] ?? 'PENDING',
      isActive: json['isActive'] ?? true,
    );
  }
}
