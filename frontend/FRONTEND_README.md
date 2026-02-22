# Flutter Food Ordering App - Frontend

## Overview
A simple and modular Flutter web application for food ordering, connecting to the Node.js/Express backend.

## Folder Structure

```
lib/
├── main.dart                    # App entry point with all routes
├── constants/                   # App-wide constants
│   └── app_constants.dart      # Colors, roles, statuses
├── models/                      # Data models
│   ├── user.dart               # User model
│   ├── restaurant.dart         # Restaurant model
│   ├── menu_item.dart          # Menu item model (with image field)
│   └── order.dart              # Order & OrderItem models
├── services/                    # API communication
│   └── api_service.dart        # All backend API calls
├── utils/                       # Helper utilities
│   └── storage_helper.dart     # Local storage (token, user data)
├── widgets/                     # Reusable UI components
│   ├── custom_button.dart      # Orange button widget
│   ├── custom_textfield.dart   # Input field widget
│   └── menu_item_card.dart     # Menu item display card
└── screens/                     # All app screens
    ├── auth/                    # Authentication screens
    │   ├── login_screen.dart   # Login page
    │   └── register_screen.dart # Registration page
    ├── user/                    # Customer screens
    │   ├── user_home_screen.dart         # Browse restaurants
    │   ├── restaurant_menu_screen.dart   # View menu & order
    │   └── my_orders_screen.dart         # Order history
    ├── restaurant/              # Restaurant owner screens
    │   ├── restaurant_home_screen.dart   # Dashboard
    │   ├── manage_menu_screen.dart       # Add/edit menu items
    │   └── restaurant_orders_screen.dart # Manage orders
    └── admin/                   # Admin screens
        └── admin_home_screen.dart        # Admin dashboard
```

## Features

### Authentication
- Login with email/password
- Register as Customer or Restaurant Owner
- Token-based authentication (JWT)
- Auto-navigation based on user role

### Customer Features
- Browse all restaurants in a grid view
- View restaurant menu with images
- Add items to cart with quantity controls
- Place orders
- View order history with status

### Restaurant Owner Features
- Create restaurant profile
- Add menu items with:
  - Name, description, price
  - Image URL
  - Category
  - Veg/Non-veg indicator
  - Availability toggle
- View and manage incoming orders
- Update order status (Confirmed → Preparing → Ready → Delivered)
- Cancel orders

### Admin Features
- Simple admin dashboard (placeholder)

## Key Technologies

- **Flutter**: Web framework
- **http**: API communication
- **shared_preferences**: Local data storage
- **Material Design 3**: UI components

## Color Scheme

- Primary: Orange
- Secondary: Deep Orange
- Background: Light Gray (#F5F5F5)
- Success: Green
- Error: Red

## Running the App

1. Backend is available at:
   - **Production**: https://food-fc4q.onrender.com
   - **Local Dev**: http://localhost:5001 (if running locally)

2. Run Flutter web app:
```bash
cd frontend
flutter run -d chrome
```

3. Or build for production:
```bash
flutter build web
```

## Code Style

- Extensive comments explaining each file's purpose
- Beginner-friendly variable names
- Simple, straightforward logic
- Modular structure with clear separation of concerns

## API Integration

All backend communication is centralized in `api_service.dart`:
- **Production URL**: https://food-fc4q.onrender.com/api
- **Local Dev URL**: http://localhost:5001/api
- Token management
- Error handling
- JSON parsing

## Models

All models have `fromJson` factory methods to parse backend responses:
- User: id, name, email, role
- Restaurant: id, name, description, address, isOpen
- MenuItem: id, name, description, price, isVeg, isAvailable, **image**
- Order: id, items, totalAmount, status, paymentStatus

## Routes

- `/login` - Login screen
- `/register` - Registration screen
- `/user-home` - Customer dashboard
- `/restaurant-menu` - View restaurant menu
- `/my-orders` - Customer order history
- `/restaurant-home` - Restaurant owner dashboard
- `/manage-menu` - Menu management
- `/restaurant-orders` - Restaurant order management
- `/admin-home` - Admin dashboard

## Notes

- Image URLs are stored as strings (placeholder: https://via.placeholder.com/300x200?text=Food+Item)
- Order uses snapshot pattern (stores item name/price at order time)
- Simple role-based navigation after login
- No complex state management - using StatefulWidgets
- Designed to be beginner-friendly with clear structure
