// Simple User class - represents a user in our app
// This is like a blueprint for user data

class User {
  String id;
  String name;
  String email;
  String role; // Can be USER, RESTAURANT, or ADMIN

  // Constructor - how we create a new User object
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  // Convert JSON from backend to User object
  // This helps us read data from API
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['userId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'USER',
    );
  }
}
