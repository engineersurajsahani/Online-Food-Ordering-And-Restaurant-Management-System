// Order class - represents a food order
// Tracks what user ordered and its status

class Order {
  String id;
  String restaurantId;
  String restaurantName;
  List<OrderItem> items;
  double totalAmount;
  String status;
  String paymentStatus;
  String createdAt;

  // Constructor
  Order({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.paymentStatus,
    required this.createdAt,
  });

  // Convert JSON to Order object
  factory Order.fromJson(Map<String, dynamic> json) {
    var itemsList = (json['items'] as List?)
            ?.map((item) => OrderItem.fromJson(item))
            .toList() ??
        [];

    // Handle restaurantId - can be either String or populated object
    String restaurantId = '';
    String restaurantName = 'Unknown Restaurant';
    
    if (json['restaurantId'] != null) {
      if (json['restaurantId'] is String) {
        restaurantId = json['restaurantId'];
      } else if (json['restaurantId'] is Map) {
        restaurantId = json['restaurantId']['_id']?.toString() ?? '';
        restaurantName = json['restaurantId']['name'] ?? 'Unknown Restaurant';
      }
    }

    return Order(
      id: json['_id']?.toString() ?? '',
      restaurantId: restaurantId,
      restaurantName: restaurantName,
      items: itemsList,
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      status: json['status'] ?? 'PLACED',
      paymentStatus: json['paymentStatus'] ?? 'PENDING',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }
}

// OrderItem class - individual items in an order
class OrderItem {
  String menuItemId;
  String name;
  double price;
  int quantity;

  OrderItem({
    required this.menuItemId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      menuItemId: json['menuItemId']?.toString() ?? '',
      name: json['nameSnapshot']?.toString() ?? '',
      price: (json['priceSnapshot'] ?? 0).toDouble(),
      quantity: (json['quantity'] is int) 
          ? json['quantity'] 
          : int.tryParse(json['quantity']?.toString() ?? '1') ?? 1,
    );
  }
}
