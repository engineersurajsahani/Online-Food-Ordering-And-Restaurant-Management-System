# Frontend Architecture Documentation

## 📱 Food Order App - Flutter Frontend

A comprehensive Flutter application for food ordering with role-based access for Users, Restaurants, and Admins.

---

## 🏗️ Architecture Overview

```mermaid
graph TB
    subgraph "App Entry"
        Main[main.dart<br/>MyApp Widget]
        Main --> MaterialApp[MaterialApp<br/>- Theme Configuration<br/>- Route Management]
    end
    
    subgraph "Core Services"
        API[ApiService<br/>HTTP Client]
        Storage[StorageHelper<br/>Local Storage]
    end
    
    subgraph "Data Models"
        User[User Model]
        Restaurant[Restaurant Model]
        MenuItem[MenuItem Model]
        Order[Order Model]
    end
    
    subgraph "Screens"
        Auth[Auth Screens<br/>- Splash<br/>- Login<br/>- Register]
        UserScreens[User Screens<br/>- Home<br/>- Menu<br/>- Orders]
        RestaurantScreens[Restaurant Screens<br/>- Home<br/>- Menu Management<br/>- Orders]
        AdminScreens[Admin Screens<br/>- Dashboard<br/>- Approve Restaurants<br/>- Manage Users]
    end
    
    subgraph "Reusable Widgets"
        Button[CustomButton]
        TextField[CustomTextField]
        MenuCard[MenuItemCard]
    end
    
    MaterialApp --> Auth
    Auth --> UserScreens
    Auth --> RestaurantScreens
    Auth --> AdminScreens
    
    UserScreens --> API
    RestaurantScreens --> API
    AdminScreens --> API
    
    API --> User
    API --> Restaurant
    API --> MenuItem
    API --> Order
    
    Auth --> Storage
    Storage --> User
    
    UserScreens --> Button
    UserScreens --> TextField
    UserScreens --> MenuCard
```

---

## 🎯 Widget Tree Structure

### Main App Widget Hierarchy

```mermaid
graph TD
    MyApp[MyApp<br/>StatelessWidget]
    MyApp --> MaterialApp
    
    MaterialApp --> Theme[ThemeData<br/>Orange Color Scheme]
    MaterialApp --> Routes[Route Management<br/>onGenerateRoute]
    
    Routes --> Splash[SplashScreen<br/>Session Check]
    Routes --> Login[LoginScreen]
    Routes --> Register[RegisterScreen]
    Routes --> UserHome[UserHomeScreen]
    Routes --> RestHome[RestaurantHomeScreen]
    Routes --> AdminHome[AdminHomeScreen]
    
    style MyApp fill:#ff9800
    style MaterialApp fill:#ffb74d
    style Routes fill:#ffe0b2
```

### Typical Screen Structure

```mermaid
graph TD
    Screen[Any Screen<br/>StatefulWidget]
    Screen --> Scaffold
    
    Scaffold --> AppBar[AppBar<br/>Title + Actions]
    Scaffold --> Body[Body]
    Scaffold --> FAB[FloatingActionButton<br/>optional]
    
    Body --> Column
    Column --> Header[Header Widgets]
    Column --> Content[Content Area]
    
    Content --> ListView[ListView<br/>Scrollable List]
    Content --> GridView[GridView<br/>Grid Layout]
    
    ListView --> Card[Card Widgets]
    GridView --> Card
    
    Card --> CustomWidgets[Custom Widgets<br/>MenuItemCard, etc.]
    
    style Scaffold fill:#4caf50
    style Body fill:#81c784
    style Card fill:#c8e6c9
```

---

## 📂 Project Structure

```
frontend/
├── lib/
│   ├── main.dart                    # App entry point, routing configuration
│   │
│   ├── constants/                   # App-wide constants
│   │   ├── app_constants.dart       # Static values, colors, roles
│   │   └── categories.dart          # Food categories list
│   │
│   ├── models/                      # Data structures
│   │   ├── user.dart                # User model with JSON parsing
│   │   ├── restaurant.dart          # Restaurant model
│   │   ├── menu_item.dart           # Food item model
│   │   └── order.dart               # Order and OrderItem models
│   │
│   ├── services/                    # Business logic & API calls
│   │   └── api_service.dart         # All backend HTTP requests
│   │
│   ├── utils/                       # Helper utilities
│   │   └── storage_helper.dart      # Local data persistence
│   │
│   ├── screens/                     # All UI screens
│   │   ├── auth/                    # Authentication screens
│   │   │   ├── splash_screen.dart   # Initial loading & session check
│   │   │   ├── login_screen.dart    # User login
│   │   │   └── register_screen.dart # New user registration
│   │   │
│   │   ├── user/                    # Customer screens
│   │   │   ├── user_home_screen.dart        # Browse restaurants/menu
│   │   │   ├── restaurant_menu_screen.dart  # View specific restaurant
│   │   │   └── my_orders_screen.dart        # Order history
│   │   │
│   │   ├── restaurant/              # Restaurant owner screens
│   │   │   ├── restaurant_home_screen.dart  # Owner dashboard
│   │   │   ├── manage_menu_screen.dart      # Add/edit menu items
│   │   │   └── restaurant_orders_screen.dart # Incoming orders
│   │   │
│   │   └── admin/                   # Admin screens
│   │       └── admin_home_screen.dart # Admin dashboard
│   │
│   └── widgets/                     # Reusable UI components
│       ├── custom_button.dart       # Styled button widget
│       ├── custom_textfield.dart    # Input field widget
│       └── menu_item_card.dart      # Food item display card
│
├── pubspec.yaml                     # Dependencies & assets
└── web/                            # Web platform specific files
```

---

## 🔄 Data Flow Architecture

### Authentication Flow

```mermaid
sequenceDiagram
    participant User
    participant LoginScreen
    participant ApiService
    participant StorageHelper
    participant Backend
    participant HomeScreen
    
    User->>LoginScreen: Enter credentials
    LoginScreen->>ApiService: login(email, password)
    ApiService->>Backend: POST /api/auth/login
    Backend-->>ApiService: {success, token, user}
    ApiService->>StorageHelper: saveToken(token)
    ApiService->>StorageHelper: saveUser(user)
    ApiService->>ApiService: setToken(token)
    LoginScreen->>HomeScreen: Navigate based on role
```

### Order Placement Flow

```mermaid
sequenceDiagram
    participant User
    participant UserHomeScreen
    participant ApiService
    participant Backend
    participant RestaurantOwner
    
    User->>UserHomeScreen: Browse menu items
    User->>UserHomeScreen: Select item + quantity
    UserHomeScreen->>ApiService: placeOrder(items, restaurantId)
    ApiService->>Backend: POST /api/orders
    Backend-->>ApiService: {success, order}
    ApiService-->>UserHomeScreen: Order created
    UserHomeScreen->>User: Show success message
    Backend->>RestaurantOwner: New order notification
```

### Session Persistence Flow

```mermaid
sequenceDiagram
    participant App
    participant SplashScreen
    participant StorageHelper
    participant ApiService
    participant HomeScreen
    
    App->>SplashScreen: App starts
    SplashScreen->>StorageHelper: getToken()
    SplashScreen->>StorageHelper: getUser()
    
    alt Token exists
        StorageHelper-->>SplashScreen: {token, user}
        SplashScreen->>ApiService: setToken(token)
        SplashScreen->>HomeScreen: Navigate to role-based home
    else No token
        StorageHelper-->>SplashScreen: null
        SplashScreen->>LoginScreen: Navigate to login
    end
```

---

## 🎨 UI Components Breakdown

### LoginScreen Widget Tree

```mermaid
graph TD
    LoginScreen[LoginScreen<br/>StatefulWidget]
    LoginScreen --> Scaffold1[Scaffold]
    
    Scaffold1 --> Body1[Body<br/>Center + SingleChildScrollView]
    Body1 --> Container1[Container<br/>Max width constraint]
    
    Container1 --> Column1[Column]
    Column1 --> Icon1[Icon<br/>Restaurant icon]
    Column1 --> Title1[Text<br/>'Login']
    Column1 --> EmailField[CustomTextField<br/>Email input]
    Column1 --> PasswordField[CustomTextField<br/>Password input]
    Column1 --> LoginButton[CustomButton<br/>Login action]
    Column1 --> RegisterLink[TextButton<br/>Go to Register]
    
    style LoginScreen fill:#2196f3
    style CustomTextField fill:#64b5f6
    style CustomButton fill:#42a5f5
```

### UserHomeScreen Widget Tree

```mermaid
graph TD
    UserHome[UserHomeScreen<br/>StatefulWidget]
    UserHome --> Scaffold2[Scaffold]
    
    Scaffold2 --> AppBar2[AppBar<br/>+ Orders icon<br/>+ Logout icon]
    Scaffold2 --> Body2[Body Column]
    
    Body2 --> StatsCard[Statistics Card<br/>Orders, Spending]
    Body2 --> SearchBar[Search TextField]
    Body2 --> CategoryFilter[Category Chips<br/>Horizontal scroll]
    Body2 --> MenuGrid[GridView<br/>Menu items display]
    
    MenuGrid --> MenuItemCard1[MenuItemCard]
    MenuGrid --> MenuItemCard2[MenuItemCard]
    MenuGrid --> MenuItemCard3[MenuItemCard]
    
    MenuItemCard1 --> ItemImage[Image]
    MenuItemCard1 --> ItemName[Text - Name]
    MenuItemCard1 --> ItemPrice[Text - Price]
    MenuItemCard1 --> AddButton[IconButton - Add to cart]
    
    style UserHome fill:#4caf50
    style MenuGrid fill:#81c784
    style MenuItemCard1 fill:#c8e6c9
```

### AdminHomeScreen Widget Tree

```mermaid
graph TD
    AdminHome[AdminHomeScreen<br/>StatefulWidget]
    AdminHome --> Scaffold3[Scaffold]
    
    Scaffold3 --> AppBar3[AppBar<br/>Admin Dashboard]
    Scaffold3 --> TabBarView[TabBarView<br/>4 Tabs]
    
    TabBarView --> Tab1[Overview Tab<br/>Statistics Cards]
    TabBarView --> Tab2[Restaurants Tab<br/>Approval Management]
    TabBarView --> Tab3[Users Tab<br/>User List]
    TabBarView --> Tab4[Orders Tab<br/>All Orders]
    
    Tab1 --> StatCards[Row of Stat Cards]
    StatCards --> TotalRestaurants[Card - Total Restaurants]
    StatCards --> ActiveRestaurants[Card - Active]
    StatCards --> TotalOrders[Card - Orders]
    StatCards --> Revenue[Card - Revenue]
    
    Tab2 --> FilterChips[Filter Chips<br/>All/Pending/Approved/Rejected]
    Tab2 --> RestaurantList[ListView<br/>Restaurant Cards]
    
    style AdminHome fill:#9c27b0
    style TabBarView fill:#ba68c8
    style Tab1 fill:#e1bee7
```

---

## 🔌 API Service Architecture

### ApiService Class Structure

```mermaid
classDiagram
    class ApiService {
        -String baseUrl$
        -String? _token$
        +setToken(String)$
        +loadToken()$
        +clearToken()$
        -_getHeaders()$ Map
        
        +register()$ Future
        +login()$ Future
        
        +getAllRestaurants()$ Future
        +getMyRestaurant()$ Future
        +createRestaurant()$ Future
        +toggleRestaurantStatus()$ Future
        
        +getRestaurantMenu()$ Future
        +addMenuItem()$ Future
        +updateMenuItem()$ Future
        +deleteMenuItem()$ Future
        
        +placeOrder()$ Future
        +getMyOrders()$ Future
        +updateOrderStatus()$ Future
        
        +getAllRestaurantsAdmin()$ Future
        +getAllUsers()$ Future
        +getAllOrdersAdmin()$ Future
        +approveRestaurant()$ Future
        +rejectRestaurant()$ Future
    }
    
    ApiService --> User : Returns
    ApiService --> Restaurant : Returns
    ApiService --> MenuItem : Returns
    ApiService --> Order : Returns
```

### API Endpoints Used

| Category | Method | Endpoint | Purpose |
|----------|--------|----------|---------|
| **Auth** | POST | `/api/auth/register` | Create new account |
| | POST | `/api/auth/login` | User login |
| **Restaurants** | GET | `/api/restaurants` | List all restaurants |
| | GET | `/api/restaurants/my-restaurant` | Get owner's restaurant |
| | POST | `/api/restaurants` | Create restaurant |
| | PATCH | `/api/restaurants/toggle-status` | Open/Close restaurant |
| **Menu** | GET | `/api/menus/restaurant/:id` | Get restaurant menu |
| | POST | `/api/menus` | Add menu item |
| | PUT | `/api/menus/:id` | Update menu item |
| | DELETE | `/api/menus/:id` | Delete menu item |
| **Orders** | POST | `/api/orders` | Place order |
| | GET | `/api/orders/my-orders` | Get user orders |
| | GET | `/api/orders/restaurant-orders` | Get restaurant orders |
| | PATCH | `/api/orders/:id/status` | Update order status |
| **Admin** | GET | `/api/admin/restaurants` | All restaurants |
| | GET | `/api/admin/users` | All users |
| | GET | `/api/admin/orders` | All orders |
| | POST | `/api/admin/restaurants/:id/approve` | Approve restaurant |
| | POST | `/api/admin/restaurants/:id/reject` | Reject restaurant |

---

## 💾 State Management

### Local State (setState)

The app uses simple Flutter state management with `setState()`:

```mermaid
graph LR
    UserAction[User Action] --> EventHandler[Event Handler Method]
    EventHandler --> APICall[API Call]
    APICall --> UpdateState[setState Update]
    UpdateState --> Rebuild[Widget Rebuild]
    Rebuild --> UI[Updated UI]
```

**Example:**
```dart
void _loadRestaurants() async {
  setState(() => _isLoading = true);  // Show loading
  
  final restaurants = await ApiService.getAllRestaurants();
  
  setState(() {
    _restaurants = restaurants;      // Update data
    _isLoading = false;             // Hide loading
  });
}
```

### Persistent State (SharedPreferences)

```mermaid
graph TD
    Login[User Login] --> Save[StorageHelper.saveToken]
    Save --> SharedPrefs[(SharedPreferences)]
    
    AppRestart[App Restart] --> Load[StorageHelper.getToken]
    SharedPrefs --> Load
    Load --> AutoLogin[Auto Login]
```

---

## 🎭 Role-Based Navigation

```mermaid
graph TD
    Start[App Start] --> Splash[SplashScreen]
    Splash --> CheckToken{Token<br/>Exists?}
    
    CheckToken -->|No| Login[LoginScreen]
    CheckToken -->|Yes| CheckRole{User<br/>Role?}
    
    Login --> LoginSuccess[Login Success]
    LoginSuccess --> CheckRole
    
    CheckRole -->|USER| UserHome[UserHomeScreen<br/>Browse & Order]
    CheckRole -->|RESTAURANT| RestHome[RestaurantHomeScreen<br/>Manage Menu & Orders]
    CheckRole -->|ADMIN| AdminHome[AdminHomeScreen<br/>Approve & Monitor]
    
    UserHome --> UserMenu[RestaurantMenuScreen]
    UserHome --> MyOrders[MyOrdersScreen]
    
    RestHome --> ManageMenu[ManageMenuScreen]
    RestHome --> RestOrders[RestaurantOrdersScreen]
    
    style Start fill:#e0e0e0
    style UserHome fill:#4caf50
    style RestHome fill:#2196f3
    style AdminHome fill:#9c27b0
```

---

## 🔒 Authentication & Security

### Token Management

```mermaid
sequenceDiagram
    participant User
    participant App
    participant ApiService
    participant StorageHelper
    participant Backend
    
    User->>App: Login with credentials
    App->>Backend: POST /auth/login
    Backend-->>App: JWT Token + User Data
    App->>StorageHelper: saveToken(token)
    App->>StorageHelper: saveUser(userData)
    App->>ApiService: setToken(token)
    
    Note over App,ApiService: Token stored in memory
    Note over StorageHelper: Token persisted locally
    
    App->>Backend: API Request
    ApiService->>Backend: Header: Bearer {token}
    Backend-->>App: Authorized Response
```

### Session Persistence

1. **On Login**: Token saved to SharedPreferences + memory
2. **On App Restart**: Token loaded from SharedPreferences
3. **On API Call**: Token attached to Authorization header
4. **On Logout**: Token cleared from both locations

---

## 📦 Dependencies

### Core Flutter Packages

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # HTTP Client for API calls
  http: ^1.1.0
  
  # Local storage for session persistence
  shared_preferences: ^2.2.2
```

### Why These Packages?

- **http**: Simple REST API communication
- **shared_preferences**: Persistent key-value storage for tokens

---

## 🎯 Key Features by Role

### 👤 User (Customer)

```mermaid
graph LR
    A[User Features] --> B[Browse Restaurants]
    A --> C[Search Menu Items]
    A --> D[Filter by Category]
    A --> E[Place Orders]
    A --> F[View Order History]
    A --> G[Track Order Status]
    A --> H[View Statistics]
```

**Screens:**
- `UserHomeScreen`: Browse all menu items with search/filter
- `RestaurantMenuScreen`: View specific restaurant menu
- `MyOrdersScreen`: Order history and tracking

### 🍽️ Restaurant Owner

```mermaid
graph LR
    A[Restaurant Features] --> B[Create Restaurant]
    A --> C[Manage Menu Items]
    A --> D[Add/Edit/Delete Items]
    A --> E[Toggle Open/Closed]
    A --> F[View Incoming Orders]
    A --> G[Update Order Status]
    A --> H[View Statistics]
```

**Screens:**
- `RestaurantHomeScreen`: Dashboard with stats
- `ManageMenuScreen`: CRUD operations for menu
- `RestaurantOrdersScreen`: Order management

### 👨‍💼 Admin

```mermaid
graph LR
    A[Admin Features] --> B[Approve Restaurants]
    A --> C[Reject Restaurants]
    A --> D[View All Users]
    A --> E[View All Orders]
    A --> F[Platform Statistics]
    A --> G[Monitor Activity]
```

**Screens:**
- `AdminHomeScreen`: Complete dashboard with tabs
  - Overview: Platform statistics
  - Restaurants: Approval management
  - Users: User list
  - Orders: All orders monitoring

---

## 🎨 Design Patterns Used

### 1. **Model-View Pattern**
- **Models**: Data classes (User, Restaurant, Order)
- **Views**: Screen widgets
- **Service Layer**: ApiService for business logic

### 2. **Singleton Pattern**
- `ApiService`: Static methods, shared token

### 3. **Factory Pattern**
- Model classes use factory constructors for JSON parsing
```dart
factory User.fromJson(Map<String, dynamic> json) { ... }
```

### 4. **Repository Pattern**
- `StorageHelper`: Abstraction for local storage
- `ApiService`: Abstraction for remote data

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable)
- Dart SDK
- Web browser or mobile emulator

### Installation

```bash
# Navigate to frontend directory
cd frontend

# Install dependencies
flutter pub get

# Run on Chrome
flutter run -d chrome

# Or run on mobile emulator
flutter run
```

### Configuration

Update backend URL in [api_service.dart](lib/services/api_service.dart):

```dart
static const String baseUrl = 'http://localhost:5001/api';
```

---

## 📱 Screen Flow Diagram

```mermaid
stateDiagram-v2
    [*] --> Splash
    Splash --> Login: No Token
    Splash --> UserHome: Token + USER role
    Splash --> RestHome: Token + RESTAURANT role
    Splash --> AdminHome: Token + ADMIN role
    
    Login --> Register: Sign Up
    Register --> Login: Back
    
    Login --> UserHome: USER login
    Login --> RestHome: RESTAURANT login
    Login --> AdminHome: ADMIN login
    
    UserHome --> RestaurantMenu: View Restaurant
    UserHome --> MyOrders: My Orders
    RestaurantMenu --> UserHome: Back
    MyOrders --> UserHome: Back
    
    RestHome --> ManageMenu: Manage Menu
    RestHome --> RestOrders: View Orders
    ManageMenu --> RestHome: Back
    RestOrders --> RestHome: Back
    
    UserHome --> Login: Logout
    RestHome --> Login: Logout
    AdminHome --> Login: Logout
```

---

## 🔍 Code Organization Principles

### 1. **Separation of Concerns**
- **UI**: Screen widgets only handle display
- **Logic**: Services handle business logic
- **Data**: Models represent data structures
- **Storage**: Utils handle persistence

### 2. **Reusability**
- Custom widgets (CustomButton, CustomTextField)
- Shared constants (AppConstants, AppColors)
- Centralized API service

### 3. **Consistency**
- All screens follow similar structure
- Consistent naming conventions
- Standard error handling patterns

---

## 📊 Performance Considerations

### Optimization Strategies

1. **Efficient Widget Building**
   - Use `const` constructors where possible
   - Avoid rebuilding entire trees

2. **API Call Optimization**
   - Load data only when needed
   - Cache responses in state when appropriate

3. **Image Loading**
   - Use placeholder images
   - Network image caching by Flutter

---

## 🐛 Error Handling

### Error Handling Pattern

```dart
try {
  final response = await ApiService.someCall();
  
  if (response['success'] == true) {
    // Handle success
  } else {
    _showMessage(response['message'], isError: true);
  }
} catch (e) {
  _showMessage('Error: $e', isError: true);
}
```

### User Feedback

- **Success**: Green SnackBar
- **Error**: Red SnackBar
- **Loading**: CircularProgressIndicator

---

## 📝 Comments Style Guide

All code follows simple, clear commenting:

```dart
// Brief description of what this does
// Explains the "why" not just the "what"
```

**Examples:**
- `// Save token to local storage for next app launch`
- `// Check if restaurant is open before allowing orders`
- `// Filter menu items based on search query and category`

---

## 🔄 Future Enhancements

Potential improvements:

1. **State Management**: Implement Provider or Riverpod
2. **Offline Support**: Add offline caching with SQLite
3. **Real-time Updates**: WebSocket for live order updates
4. **Image Upload**: Camera/gallery integration
5. **Push Notifications**: Order status notifications
6. **Payment Integration**: Actual payment gateway
7. **Map Integration**: Restaurant location on map

---

## 📚 Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Material Design Guidelines](https://material.io/design)

---

## 👥 Authors

Ashlin, Roshni, Prabodh, Jeevan

**Last Updated**: February 2026  
**Version**: 1.0.0  
**Author**: Food Order App Team
