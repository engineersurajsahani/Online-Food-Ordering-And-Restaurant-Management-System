# 🍕 Food Order App - Complete Project Documentation

A full-stack food ordering platform with Flutter frontend and Node.js backend, featuring role-based access for Users, Restaurant Owners, and Admins.

## 🌐 Live Deployments

**Frontend LIVE**: [https://jeevan-04.github.io/Flutter_Frontend/](https://jeevan-04.github.io/Flutter_Frontend/)  
**Backend LIVE**: [https://food-fc4q.onrender.com](https://food-fc4q.onrender.com)

---

## � App Preview

<div align="center">
  <img src="https://github.com/user-attachments/assets/8d228583-8259-4605-931f-9d033e407f5e" alt="Food Order App Screenshot" width="800"/>
  <br />
  <em>Food ordering platform with role-based access for Users, Restaurants, and Admins</em>
</div>
<div align="center">
  

https://github.com/user-attachments/assets/57505077-f85c-4ca6-b7c0-7e7f54bd0542


  <br />
  <em>Food ordering platform </em>
</div>

---

## �📋 Quick Start

### Run Both Frontend and Backend

```bash
# From project root
./start.sh
```

This script starts:
- **Backend**: Node.js Express API on `http://localhost:5001`
- **Frontend**: Flutter web app on Chrome

---

## 🏗️ Project Overview

```mermaid
graph TB
    subgraph "Frontend - Flutter"
        WebApp[Web App<br/>Chrome]
        MobileApp[Mobile App<br/>iOS/Android]
    end
    
    subgraph "Backend - Node.js"
        API[Express REST API<br/>Production: Render<br/>Local Dev: Port 5001]
    end
    
    subgraph "Database"
        MongoDB[(MongoDB Atlas)]
    end
    
    WebApp --> API
    MobileApp --> API
    API --> MongoDB
    
    style WebApp fill:#4caf50
    style API fill:#2196f3
    style MongoDB fill:#ff9800
```

---

## 📂 Project Structure

```
Project/
├── frontend/               # Flutter application
│   ├── lib/
│   │   ├── main.dart      # App entry point
│   │   ├── models/        # Data models
│   │   ├── services/      # API communication
│   │   ├── screens/       # All UI screens
│   │   ├── widgets/       # Reusable components
│   │   └── constants/     # App constants
│   └── ARCHITECTURE.md    # 📖 Detailed frontend docs
│
├── backend/               # Node.js API
│   ├── src/
│   │   ├── server.js      # Entry point
│   │   ├── app.js         # Express setup
│   │   ├── models/        # MongoDB schemas
│   │   ├── routes/        # API endpoints
│   │   ├── controllers/   # Request handlers
│   │   ├── services/      # Business logic
│   │   └── middlewares/   # Auth & role checks
│   └── ARCHITECTURE.md    # 📖 Detailed backend docs
│
└── start.sh               # Script to run both apps
```

---

## �️ System Architecture

### High-Level Architecture

```mermaid
graph TB
    subgraph "Client Layer"
        FlutterWeb[Flutter Web App]
        FlutterMobile[Flutter Mobile App]
    end
    
    subgraph "API Gateway"
        Express[Express.js Server]
        Auth[JWT Auth Middleware]
        RBAC[Role-Based Access Control]
    end
    
    subgraph "Business Logic Layer"
        AuthService[Auth Service]
        UserService[User Service]
        RestService[Restaurant Service]
        MenuService[Menu Service]
        OrderService[Order Service]
        AdminService[Admin Service]
    end
    
    subgraph "Data Layer"
        UserModel[(User Model)]
        RestModel[(Restaurant Model)]
        MenuModel[(MenuItem Model)]
        OrderModel[(Order Model)]
    end
    
    subgraph "Database"
        MongoDB[(MongoDB Atlas)]
    end
    
    FlutterWeb --> Express
    FlutterMobile --> Express
    Express --> Auth
    Auth --> RBAC
    
    RBAC --> AuthService
    RBAC --> UserService
    RBAC --> RestService
    RBAC --> MenuService
    RBAC --> OrderService
    RBAC --> AdminService
    
    AuthService --> UserModel
    UserService --> UserModel
    RestService --> RestModel
    MenuService --> MenuModel
    OrderService --> OrderModel
    AdminService --> UserModel
    AdminService --> RestModel
    AdminService --> OrderModel
    
    UserModel --> MongoDB
    RestModel --> MongoDB
    MenuModel --> MongoDB
    OrderModel --> MongoDB
    
    style FlutterWeb fill:#4caf50
    style Express fill:#2196f3
    style MongoDB fill:#ff9800
```

### Frontend Architecture

The Flutter frontend follows a clean architecture pattern with clear separation of concerns:

```mermaid
graph TB
    subgraph "UI Layer"
        Screens[Screens]
        Widgets[Reusable Widgets]
    end
    
    subgraph "Service Layer"
        API[API Service]
        Storage[Storage Helper]
    end
    
    subgraph "Data Layer"
        Models[Data Models]
    end
    
    subgraph "Configuration"
        Constants[App Constants]
        Theme[Theme Config]
    end
    
    Screens --> API
    Screens --> Widgets
    Screens --> Storage
    Screens --> Models
    Screens --> Theme
    
    Widgets --> Models
    
    API --> Models
    Storage --> Models
    
    style Screens fill:#4caf50
    style API fill:#2196f3
    style Models fill:#ff9800
```

**Key Components:**
- **Screens**: Role-based UI (User, Restaurant, Admin)
- **API Service**: Centralized HTTP client with token management
- **Storage Helper**: Session persistence using SharedPreferences
- **Models**: Strongly-typed data structures (User, Restaurant, MenuItem, Order)
- **Widgets**: Reusable UI components (MenuCard, OrderCard, etc.)

📖 **Detailed Frontend Docs**: [frontend/ARCHITECTURE.md](frontend/ARCHITECTURE.md)

---

### Backend Architecture

The Node.js backend follows MVC + Services pattern for maintainability:

```mermaid
graph TB
    subgraph "Entry Point"
        Server[server.js]
    end
    
    subgraph "Express Application"
        App[app.js]
        Routes[Routes]
    end
    
    subgraph "Middleware Layer"
        ErrorMW[Error Middleware]
        AuthMW[Auth Middleware]
        RoleMW[Role Middleware]
        CORS[CORS Middleware]
    end
    
    subgraph "Controller Layer"
        AuthCtrl[Auth Controller]
        UserCtrl[User Controller]
        RestCtrl[Restaurant Controller]
        MenuCtrl[Menu Controller]
        OrderCtrl[Order Controller]
        AdminCtrl[Admin Controller]
    end
    
    subgraph "Service Layer"
        AuthSvc[Auth Service]
        UserSvc[User Service]
        RestSvc[Restaurant Service]
        MenuSvc[Menu Service]
        OrderSvc[Order Service]
        AdminSvc[Admin Service]
    end
    
    subgraph "Data Layer"
        UserModel[(User Model)]
        RestModel[(Restaurant Model)]
        MenuModel[(MenuItem Model)]
        OrderModel[(Order Model)]
    end
    
    Server --> App
    App --> Routes
    App --> CORS
    
    Routes --> ErrorMW
    Routes --> AuthMW
    Routes --> RoleMW
    
    AuthMW --> AuthCtrl
    AuthMW --> UserCtrl
    RoleMW --> RestCtrl
    RoleMW --> MenuCtrl
    RoleMW --> OrderCtrl
    RoleMW --> AdminCtrl
    
    AuthCtrl --> AuthSvc
    UserCtrl --> UserSvc
    RestCtrl --> RestSvc
    MenuCtrl --> MenuSvc
    OrderCtrl --> OrderSvc
    AdminCtrl --> AdminSvc
    
    AuthSvc --> UserModel
    UserSvc --> UserModel
    RestSvc --> RestModel
    MenuSvc --> MenuModel
    OrderSvc --> OrderModel
    AdminSvc --> UserModel
    AdminSvc --> RestModel
    
    style Server fill:#4caf50
    style Routes fill:#2196f3
    style AuthMW fill:#ff9800
```

**Architecture Layers:**
1. **Entry Point**: Server initialization and database connection
2. **Express App**: Route registration and middleware setup
3. **Middleware**: Authentication, authorization, error handling, CORS
4. **Controllers**: HTTP request/response handling
5. **Services**: Business logic and data processing
6. **Models**: MongoDB schemas and data validation

📖 **Detailed Backend Docs**: [backend/ARCHITECTURE.md](backend/ARCHITECTURE.md)

---

### Request Flow Example: Place Order

```mermaid
sequenceDiagram
    participant User as Flutter App
    participant API as Express Server
    participant Auth as Auth Middleware
    participant Role as Role Middleware
    participant Ctrl as Order Controller
    participant Svc as Order Service
    participant DB as MongoDB
    
    User->>API: POST /api/orders<br/>{items, restaurantId}
    API->>Auth: Verify JWT Token
    Auth->>Auth: Decode & Validate
    Auth->>Role: Check USER role
    Role->>Ctrl: Forward request
    Ctrl->>Svc: placeOrder(data)
    Svc->>DB: Find Restaurant
    DB->>Svc: Restaurant data
    Svc->>DB: Check menu items
    DB->>Svc: Menu items valid
    Svc->>Svc: Calculate total
    Svc->>DB: Create Order
    DB->>Svc: Order saved
    Svc->>Ctrl: Return order
    Ctrl->>API: HTTP 201 response
    API->>User: {order: {...}}
    
    Note over User,DB: All protected routes follow this pattern
```

---

### Data Flow Architecture

```mermaid
graph LR
    subgraph "Frontend State"
        UI[User Interface]
        State[Local State]
        Cache[Storage Cache]
    end
    
    subgraph "Network Layer"
        HTTP[HTTP Client]
        Token[JWT Token]
    end
    
    subgraph "Backend API"
        Routes[REST Endpoints]
        Logic[Business Logic]
    end
    
    subgraph "Database"
        Collections[MongoDB Collections]
    end
    
    UI -->|User Action| State
    State -->|API Call| HTTP
    HTTP -->|Bearer Token| Token
    Token -->|Authenticated Request| Routes
    Routes -->|Process| Logic
    Logic -->|Query/Update| Collections
    Collections -->|Response Data| Logic
    Logic -->|JSON Response| Routes
    Routes -->|HTTP Response| HTTP
    HTTP -->|Update State| State
    State -->|Re-render| UI
    State -->|Persist| Cache
    Cache -->|Load on Start| State
    
    style UI fill:#4caf50
    style Routes fill:#2196f3
    style Collections fill:#ff9800
```

---

### Security Architecture

```mermaid
graph TB
    subgraph "Frontend Security"
        TokenStorage[Secure Token Storage]
        SessionPersist[Session Persistence]
        RoleNav[Role-Based Navigation]
    end
    
    subgraph "Backend Security"
        JWT[JWT Authentication]
        BCrypt[Password Hashing]
        RBAC[Role-Based Access]
        Validation[Input Validation]
    end
    
    subgraph "Database Security"
        Encryption[At-Rest Encryption]
        AccessControl[Atlas Access Control]
        UniqueConstraints[Unique Constraints]
    end
    
    TokenStorage --> JWT
    SessionPersist --> JWT
    RoleNav --> RBAC
    
    JWT --> BCrypt
    JWT --> RBAC
    RBAC --> Validation
    
    BCrypt --> Encryption
    Validation --> UniqueConstraints
    RBAC --> AccessControl
    
    style JWT fill:#4caf50
    style BCrypt fill:#2196f3
    style RBAC fill:#ff9800
```

**Security Features:**
- ✅ JWT token-based authentication
- ✅ Bcrypt password hashing (10 salt rounds)
- ✅ Role-based access control (USER, RESTAURANT, ADMIN)
- ✅ Protected routes with middleware
- ✅ Session persistence with secure storage
- ✅ CORS configuration
- ✅ Input validation
- ✅ MongoDB Atlas security

---

## �🎭 User Roles & Features

### 👤 User (Customer)

**Can:**
- Browse all restaurants and menu items
- Search and filter food items by category
- Place orders from available restaurants
- View order history and track status
- See personal statistics

**Screens:**
- Home: Browse menu with search/filter
- Restaurant Menu: View specific restaurant
- My Orders: Order history

---

### 🍽️ Restaurant Owner

**Can:**
- Create and manage restaurant profile
- Add, edit, delete menu items
- Toggle restaurant open/closed status
- View incoming orders
- Update order status (confirm, prepare, ready, deliver)
- View restaurant statistics

**Screens:**
- Dashboard: Stats and overview
- Manage Menu: CRUD operations
- Orders: Incoming order management

---

### 👨‍💼 Admin

**Can:**
- Approve or reject restaurant registrations
- View all users, restaurants, and orders
- Monitor platform-wide statistics
- Manage system activity

**Screens:**
- Admin Dashboard with 4 tabs:
  - Overview: Platform statistics
  - Restaurants: Approval management
  - Users: User list
  - Orders: All orders

---

## 🔄 Complete User Flow

```mermaid
graph TD
    Start[User Opens App] --> Splash[Splash Screen<br/>Check Session]
    
    Splash -->|No Session| Login[Login Screen]
    Splash -->|Valid Session| RoleCheck{Check Role}
    
    Login --> Register[Can Register]
    Register --> Login
    
    Login --> LoginSuccess[Login Success]
    LoginSuccess --> RoleCheck
    
    RoleCheck -->|USER| UserFlow[User Flow]
    RoleCheck -->|RESTAURANT| RestFlow[Restaurant Flow]
    RoleCheck -->|ADMIN| AdminFlow[Admin Flow]
    
    UserFlow --> Browse[Browse Restaurants]
    Browse --> SelectItem[Select Menu Items]
    SelectItem --> PlaceOrder[Place Order]
    PlaceOrder --> TrackOrder[Track Order Status]
    
    RestFlow --> CreateRest[Create/Manage Restaurant]
    CreateRest --> ManageMenu[Manage Menu Items]
    ManageMenu --> ReceiveOrders[Receive Orders]
    ReceiveOrders --> UpdateStatus[Update Order Status]
    
    AdminFlow --> ViewAll[View All Data]
    ViewAll --> ApproveRest[Approve Restaurants]
    ApproveRest --> Monitor[Monitor Platform]
    
    style UserFlow fill:#4caf50
    style RestFlow fill:#2196f3
    style AdminFlow fill:#9c27b0
```

---

## 🔐 Authentication Flow

```mermaid
sequenceDiagram
    participant User
    participant Frontend
    participant Backend
    participant MongoDB
    
    User->>Frontend: Enter credentials
    Frontend->>Backend: POST /api/auth/login
    Backend->>MongoDB: Find user
    MongoDB-->>Backend: User data
    Backend->>Backend: Verify password hash
    Backend->>Backend: Generate JWT token
    Backend-->>Frontend: {token, user}
    Frontend->>Frontend: Save to localStorage
    
    Note over Frontend,Backend: All future requests
    Frontend->>Backend: Request + Bearer token
    Backend->>Backend: Verify token
    Backend-->>Frontend: Authorized response
```

---

## 📡 API Architecture

### Backend API Structure

```mermaid
graph TB
    Client[Flutter Frontend] --> Express[Express Server]
    
    Express --> Auth[Auth Routes<br/>/api/auth]
    Express --> Users[User Routes<br/>/api/users]
    Express --> Rest[Restaurant Routes<br/>/api/restaurants]
    Express --> Menu[Menu Routes<br/>/api/menus]
    Express --> Orders[Order Routes<br/>/api/orders]
    Express --> Admin[Admin Routes<br/>/api/admin]
    
    Auth --> AuthCtrl[Controllers]
    Users --> UserCtrl[Controllers]
    Rest --> RestCtrl[Controllers]
    Menu --> MenuCtrl[Controllers]
    Orders --> OrderCtrl[Controllers]
    Admin --> AdminCtrl[Controllers]
    
    AuthCtrl --> Services[Services<br/>Business Logic]
    UserCtrl --> Services
    RestCtrl --> Services
    MenuCtrl --> Services
    OrderCtrl --> Services
    AdminCtrl --> Services
    
    Services --> Models[Mongoose Models]
    Models --> MongoDB[(MongoDB)]
```

---

## 🗄️ Database Models

### Entity Relationships

```mermaid
erDiagram
    User ||--o{ Order : places
    User ||--o| Restaurant : owns
    Restaurant ||--o{ MenuItem : has
    Restaurant ||--o{ Order : receives
    Order ||--|{ OrderItem : contains
    
    User {
        string id
        string name
        string email
        string role
    }
    
    Restaurant {
        string id
        string ownerId
        string name
        string approvalStatus
        boolean isOpen
    }
    
    MenuItem {
        string id
        string restaurantId
        string name
        number price
        boolean isAvailable
    }
    
    Order {
        string id
        string userId
        string restaurantId
        array items
        number totalAmount
        string status
    }
```

---

## 🚀 Installation & Setup

### Prerequisites

**Frontend:**
- Flutter SDK (latest stable)
- Dart SDK
- Chrome browser or mobile emulator

**Backend:**
- Node.js (v18+)
- npm or yarn
- MongoDB Atlas account

---

### Backend Setup

```bash
cd backend

# Install dependencies
npm install

# Create .env file
cat > .env << EOF
PORT=5001
MONGODB_URI=your_mongodb_connection_string_here
JWT_SECRET=your_super_secret_key_here
JWT_EXPIRES_IN=7d
EOF

# Start server
npm start
```

**Backend runs on:**
- **Production**: `https://food-fc4q.onrender.com`
- **Local Development**: `http://localhost:5001`

---

### Frontend Setup

```bash
cd frontend

# Install dependencies
flutter pub get

# API URL is configured in lib/services/api_service.dart
# Production: https://food-fc4q.onrender.com/api
# For local development, change to: http://localhost:5001/api

# Run on Chrome
flutter run -d chrome

# Or run on mobile
flutter run
```

---

### Quick Start (Both at Once)

```bash
# From project root
./start.sh
```

---

## 🎨 Technology Stack

### Frontend Stack

| Technology | Purpose |
|------------|---------|
| **Flutter** | Cross-platform UI framework |
| **Dart** | Programming language |
| **http** | REST API communication |
| **shared_preferences** | Local data persistence |
| **Material Design** | UI components |

### Backend Stack

| Technology | Purpose |
|------------|---------|
| **Node.js** | JavaScript runtime |
| **Express.js** | Web framework |
| **MongoDB** | NoSQL database |
| **Mongoose** | MongoDB ODM |
| **JWT** | Authentication |
| **bcrypt** | Password hashing |

---

## 📊 Order Status Flow

```mermaid
stateDiagram-v2
    [*] --> PLACED: User places order
    
    PLACED --> CONFIRMED: Restaurant confirms
    PLACED --> CANCELLED: Cancelled
    
    CONFIRMED --> PREPARING: Start cooking
    CONFIRMED --> CANCELLED: Cancelled
    
    PREPARING --> READY: Food ready
    PREPARING --> CANCELLED: Cancelled
    
    READY --> DELIVERED: Order completed
    READY --> CANCELLED: Timeout
    
    DELIVERED --> [*]
    CANCELLED --> [*]
```

---

## 🔒 Security Features

### Implemented Security

```mermaid
graph TD
    Security[Security Measures]
    
    Security --> Backend[Backend Security]
    Security --> Frontend[Frontend Security]
    
    Backend --> JWT[JWT Authentication]
    Backend --> Hash[Password Hashing<br/>bcrypt]
    Backend --> RBAC[Role-Based Access]
    Backend --> Middleware[Protected Routes]
    
    Frontend --> TokenStorage[Secure Token Storage]
    Frontend --> SessionPersist[Session Persistence]
    Frontend --> RoleNav[Role-Based Navigation]
```

**Features:**
- ✅ JWT token authentication
- ✅ Bcrypt password hashing (10 salt rounds)
- ✅ Role-based access control (USER, RESTAURANT, ADMIN)
- ✅ Protected API routes with middleware
- ✅ Session persistence with local storage
- ✅ CORS configuration
- ✅ Environment variable protection

---

## 📖 Detailed Documentation

### 📘 Frontend Architecture

**Location:** [`frontend/ARCHITECTURE.md`](frontend/ARCHITECTURE.md)

**Contains:**
- Complete widget tree diagrams
- Screen-by-screen breakdown
- Data flow diagrams
- State management explanation
- API service architecture
- Navigation flow
- All Flutter code already has simple English comments

**Mermaid Diagrams Include:**
- Overall architecture
- Widget hierarchies (MyApp → Scaffold → Components)
- User flow diagrams
- Authentication flow
- Order placement flow
- Role-based navigation

---

### 📗 Backend Architecture

**Location:** [`backend/ARCHITECTURE.md`](backend/ARCHITECTURE.md)

**Contains:**
- Complete API architecture
- Request processing pipeline
- Database schema with ERD
- Service layer breakdown
- Middleware pipeline
- Order lifecycle
- All Node.js code already has simple English comments

**Mermaid Diagrams Include:**
- Overall system architecture
- Request flow diagrams
- Database relationships
- JWT authentication flow
- Order status state machine
- Middleware pipeline

---

## 🎯 Key Features

### For Users
- 🔍 Search and filter menu items
- 🏪 Browse all restaurants
- 🛒 Place orders easily
- 📊 View order history
- 📈 Personal statistics
- 📱 Responsive design

### For Restaurant Owners
- 🏢 Restaurant profile management
- 📋 Menu CRUD operations
- 🔔 Incoming order notifications
- ✅ Order status management
- 📊 Restaurant statistics
- 🔄 Open/Close toggle

### For Admins
- 👥 User management
- 🏪 Restaurant approval system
- 📦 Order monitoring
- 📊 Platform-wide statistics
- 🎛️ Complete dashboard

---

## � Code Structure Explained - File by File

This section provides a detailed code-wise explanation of every file in the project.

---

### 🎨 Frontend Code Structure

#### **Entry Point**

##### `lib/main.dart`
**Purpose**: Application entry point and root widget configuration

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiService.loadToken(); // Load saved JWT token
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // Root widget that sets up:
  // - Material app configuration
  // - Theme data (colors, fonts)
  // - Initial route (SplashScreen)
  // - All app routes
}
```

**Key Features:**
- Initializes app and loads persisted session
- Defines Material theme with custom colors
- Sets up navigation routes for all screens
- Disables debug banner

---

#### **📱 Screens - Authentication**

##### `lib/screens/auth/splash_screen.dart`
**Purpose**: Auto-login screen that checks for existing session

```dart
class SplashScreen extends StatefulWidget {
  // On startup:
  // 1. Check if user data exists in storage
  // 2. If yes -> navigate to role-based home screen
  // 3. If no -> navigate to login screen
  
  Future<void> _checkLoginStatus() async {
    final user = await StorageHelper.getUser();
    if (user != null) {
      // Navigate based on role: USER, RESTAURANT, or ADMIN
    } else {
      // Navigate to login
    }
  }
}
```

**Flow:**
- Displays logo for 2 seconds
- Checks local storage for user session
- Routes to appropriate screen based on role

##### `lib/screens/auth/login_screen.dart`
**Purpose**: User authentication screen

```dart
class LoginScreen extends StatefulWidget {
  // Handles:
  // - Email & password input
  // - Form validation
  // - API call to /auth/login
  // - Save token and user data
  // - Navigate to role-based home
  
  Future<void> _login() async {
    final response = await ApiService.login(email, password);
    await StorageHelper.saveToken(response.token);
    await StorageHelper.saveUser(response.user);
    // Navigate based on user.role
  }
}
```

**Features:**
- Form validation (email format, password length)
- Loading state during API call
- Error handling with SnackBar
- Link to registration screen

##### `lib/screens/auth/register_screen.dart`
**Purpose**: New user registration

```dart
class RegisterScreen extends StatefulWidget {
  // Collects:
  // - Name, email, phone, password
  // - Role selection (USER, RESTAURANT, ADMIN)
  // - Calls /auth/register API
  // - Auto-login after successful registration
  
  Future<void> _register() async {
    await ApiService.register(name, email, phone, password, role);
    // Auto-login
    await _login();
  }
}
```

**Features:**
- Dropdown for role selection
- Password confirmation validation
- Phone number format validation
- Redirects to login after registration

---

#### **📱 Screens - User Role**

##### `lib/screens/user/user_home_screen.dart`
**Purpose**: Main screen for customers to browse restaurants and menu items

```dart
class UserHomeScreen extends StatefulWidget {
  // Features:
  // - Search bar for filtering menu items
  // - Category filter (All, Pizza, Burger, etc.)
  // - Grid of menu items from all approved restaurants
  // - Add to cart functionality
  // - Bottom navigation (Home, My Orders, Profile)
  
  Future<void> _loadMenuItems() async {
    final restaurants = await ApiService.getAllRestaurants();
    // Combine all menu items from all restaurants
    setState(() => menuItems = ...);
  }
}
```

**Key Sections:**
- **AppBar**: Search, cart icon, logout
- **Category Chips**: Filter by food category
- **Menu Grid**: Displays MenuItemCard widgets
- **Cart**: Floating action button shows cart
- **BottomNav**: Navigate between screens

##### `lib/screens/user/restaurant_menu_screen.dart`
**Purpose**: View specific restaurant's full menu

```dart
class RestaurantMenuScreen extends StatefulWidget {
  // Displays:
  // - Restaurant name, description, status (Open/Closed)
  // - Full menu list with prices and categories
  // - Add to cart for each item
  // - Only allows ordering if restaurant is OPEN
  
  Future<void> _loadRestaurantMenu(String restaurantId) async {
    final menu = await ApiService.getRestaurantMenu(restaurantId);
    setState(() => menuItems = menu);
  }
}
```

**Features:**
- Restaurant header with status badge
- Categorized menu items
- Add to cart with quantity selection
- Place order button
- Handles closed restaurant state

##### `lib/screens/user/my_orders_screen.dart`
**Purpose**: View order history and track status

```dart
class MyOrdersScreen extends StatefulWidget {
  // Shows:
  // - List of all user's orders
  // - Order details (items, quantity, total)
  // - Status badges (PLACED, CONFIRMED, PREPARING, READY, DELIVERED)
  // - Timestamp for each order
  
  Future<void> _loadOrders() async {
    final orders = await ApiService.getUserOrders();
    setState(() => orders = orders);
  }
}
```

**Order Display:**
- Color-coded status badges
- Restaurant name
- Item list with quantities
- Total amount
- Order date/time
- Pull-to-refresh

---

#### **📱 Screens - Restaurant Owner Role**

##### `lib/screens/restaurant/restaurant_home_screen.dart`
**Purpose**: Dashboard for restaurant owners

```dart
class RestaurantHomeScreen extends StatefulWidget {
  // Shows:
  // - Statistics cards (total orders, revenue, pending orders)
  // - Restaurant status toggle (Open/Close)
  // - Quick actions (Manage Menu, View Orders)
  // - Recent orders list
  
  Future<void> _loadDashboardData() async {
    final restaurant = await ApiService.getMyRestaurant();
    final stats = await ApiService.getRestaurantStats();
    setState(() => ...);
  }
  
  Future<void> _toggleRestaurantStatus() async {
    await ApiService.toggleRestaurantStatus();
    // Refresh data
  }
}
```

**Statistics Displayed:**
- Total orders today
- Total revenue
- Pending orders count
- Restaurant approval status

##### `lib/screens/restaurant/manage_menu_screen.dart`
**Purpose**: CRUD operations for menu items

```dart
class ManageMenuScreen extends StatefulWidget {
  // Functions:
  // - Create new menu item
  // - Edit existing items
  // - Delete items
  // - Toggle item availability
  // - Categorize items
  
  Future<void> _addMenuItem() async {
    await ApiService.createMenuItem(
      name, description, price, category, isVeg, isAvailable
    );
    _refreshMenu();
  }
  
  Future<void> _updateMenuItem(String id) async {
    await ApiService.updateMenuItem(id, data);
  }
  
  Future<void> _deleteMenuItem(String id) async {
    await ApiService.deleteMenuItem(id);
  }
}
```

**Features:**
- Add menu item dialog
- Edit inline or in dialog
- Delete with confirmation
- Toggle available/unavailable
- Filter by category

##### `lib/screens/restaurant/restaurant_orders_screen.dart`
**Purpose**: Manage incoming orders

```dart
class RestaurantOrdersScreen extends StatefulWidget {
  // Features:
  // - Real-time order list
  // - Update order status workflow
  // - Order details view
  // - Filter by status (Pending, Confirmed, Preparing, etc.)
  
  Future<void> _updateOrderStatus(String orderId, String status) async {
    await ApiService.updateOrderStatus(orderId, status);
    _refreshOrders();
  }
}
```

**Order Workflow:**
- PLACED → CONFIRMED (Accept order)
- CONFIRMED → PREPARING (Start cooking)
- PREPARING → READY (Food ready)
- READY → DELIVERED (Order complete)
- Any status → CANCELLED (Cancel order)

---

#### **📱 Screens - Admin Role**

##### `lib/screens/admin/admin_home_screen.dart`
**Purpose**: Admin dashboard with tabs for platform management

```dart
class AdminHomeScreen extends StatefulWidget {
  // 4 Tabs:
  // 1. Overview - Platform statistics
  // 2. Restaurants - Approve/reject pending restaurants
  // 3. Users - View all users
  // 4. Orders - Monitor all orders
  
  Future<void> _loadAdminData() async {
    final stats = await ApiService.getAdminStats();
    final restaurants = await ApiService.getAllRestaurants();
    final users = await ApiService.getAllUsers();
    final orders = await ApiService.getAllOrders();
  }
  
  Future<void> _approveRestaurant(String id) async {
    await ApiService.approveRestaurant(id);
  }
  
  Future<void> _rejectRestaurant(String id) async {
    await ApiService.rejectRestaurant(id);
  }
}
```

**Admin Functions:**
- View platform-wide statistics
- Approve/reject restaurant registrations
- View all users with roles
- Monitor all orders across platform
- Search and filter capabilities

---

#### **🔌 Services Layer**

##### `lib/services/api_service.dart`
**Purpose**: Centralized HTTP client for all backend communication

```dart
class ApiService {
  static const String baseUrl = 'https://food-fc4q.onrender.com/api';
  static String? _token;
  
  // Token Management
  static void setToken(String token) => _token = token;
  static Future<void> loadToken() async {
    _token = await StorageHelper.getToken();
  }
  
  // Helper: Add Authorization header
  static Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }
  
  // Auth APIs
  static Future<Map<String, dynamic>> register(...) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: _getHeaders(),
      body: jsonEncode({...}),
    );
    return jsonDecode(response.body);
  }
  
  static Future<Map<String, dynamic>> login(...) async { }
  
  // Restaurant APIs
  static Future<List<Restaurant>> getAllRestaurants() async { }
  static Future<Restaurant> getMyRestaurant() async { }
  static Future<void> createRestaurant(...) async { }
  static Future<void> toggleRestaurantStatus() async { }
  
  // Menu APIs
  static Future<List<MenuItem>> getRestaurantMenu(String id) async { }
  static Future<void> createMenuItem(...) async { }
  static Future<void> updateMenuItem(...) async { }
  static Future<void> deleteMenuItem(String id) async { }
  
  // Order APIs
  static Future<Order> placeOrder(...) async { }
  static Future<List<Order>> getUserOrders() async { }
  static Future<List<Order>> getRestaurantOrders() async { }
  static Future<void> updateOrderStatus(String id, String status) async { }
  
  // Admin APIs
  static Future<Map<String, dynamic>> getAdminStats() async { }
  static Future<void> approveRestaurant(String id) async { }
  static Future<void> rejectRestaurant(String id) async { }
}
```

**Key Features:**
- Single source of truth for API calls
- Automatic token attachment
- Error handling and parsing
- Type-safe responses using models
- Clean async/await pattern

##### `lib/utils/storage_helper.dart`
**Purpose**: Local storage for session persistence

```dart
class StorageHelper {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  
  // Save JWT token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }
  
  // Retrieve JWT token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
  
  // Save user object
  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }
  
  // Get user object
  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }
  
  // Clear all data (logout)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
```

---

#### **📊 Data Models**

##### `lib/models/user.dart`
**Purpose**: User data structure

```dart
class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String role; // USER, RESTAURANT, ADMIN
  
  User({required this.id, required this.name, ...});
  
  // Parse JSON from API
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
    );
  }
  
  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
    };
  }
}
```

##### `lib/models/restaurant.dart`
**Purpose**: Restaurant data structure

```dart
class Restaurant {
  final String id;
  final String name;
  final String description;
  final String address;
  final String ownerId;
  final String approvalStatus; // PENDING, APPROVED, REJECTED
  final bool isOpen;
  final int preparationTime;
  
  Restaurant({required this.id, ...});
  
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
      ownerId: json['ownerId'],
      approvalStatus: json['approvalStatus'],
      isOpen: json['isOpen'] ?? false,
      preparationTime: json['preparationTime'] ?? 30,
    );
  }
}
```

##### `lib/models/menu_item.dart`
**Purpose**: Menu item data structure

```dart
class MenuItem {
  final String id;
  final String restaurantId;
  final String name;
  final String description;
  final double price;
  final String category; // Pizza, Burger, Dessert, etc.
  final bool isVeg;
  final bool isAvailable;
  final String? imageUrl;
  
  MenuItem({required this.id, ...});
  
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['_id'],
      restaurantId: json['restaurantId'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      category: json['category'],
      isVeg: json['isVeg'] ?? false,
      isAvailable: json['isAvailable'] ?? true,
      imageUrl: json['imageUrl'],
    );
  }
}
```

##### `lib/models/order.dart`
**Purpose**: Order data structure

```dart
class Order {
  final String id;
  final String userId;
  final String restaurantId;
  final List<OrderItem> items;
  final double totalAmount;
  final String status; // PLACED, CONFIRMED, PREPARING, READY, DELIVERED, CANCELLED
  final DateTime createdAt;
  final String? deliveryAddress;
  
  Order({required this.id, ...});
  
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'],
      userId: json['userId'],
      restaurantId: json['restaurantId'],
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      totalAmount: json['totalAmount'].toDouble(),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      deliveryAddress: json['deliveryAddress'],
    );
  }
}

class OrderItem {
  final String menuItemId;
  final String name;
  final int quantity;
  final double price;
  
  OrderItem({required this.menuItemId, ...});
  
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      menuItemId: json['menuItemId'],
      name: json['name'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
    );
  }
}
```

---

#### **🧩 Reusable Widgets**

##### `lib/widgets/custom_button.dart`
**Purpose**: Reusable styled button

```dart
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? color;
  
  // Creates consistent button style across app
  // Handles loading state automatically
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Theme.of(context).primaryColor,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        shape: RoundedRectangleBorder(...),
      ),
      child: isLoading
          ? CircularProgressIndicator()
          : Text(text, style: TextStyle(fontSize: 18)),
    );
  }
}
```

##### `lib/widgets/custom_textfield.dart`
**Purpose**: Reusable form input

```dart
class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  
  // Provides consistent form field styling
  // Built-in validation support
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(...),
        // Consistent styling
      ),
    );
  }
}
```

##### `lib/widgets/menu_item_card.dart`
**Purpose**: Display menu item with image and actions

```dart
class MenuItemCard extends StatelessWidget {
  final MenuItem menuItem;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  
  // Displays:
  // - Item image
  // - Name and description
  // - Price
  // - Veg/Non-veg badge
  // - Add to cart button
  // - Available/Unavailable status
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          // Image
          if (menuItem.imageUrl != null) Image.network(menuItem.imageUrl!),
          // Details
          Text(menuItem.name, style: TextStyle(fontWeight: FontWeight.bold)),
          Text('₹${menuItem.price}'),
          // Veg indicator
          Icon(menuItem.isVeg ? Icons.circle : Icons.circle_outlined,
              color: menuItem.isVeg ? Colors.green : Colors.red),
          // Add button
          if (onAddToCart != null)
            IconButton(icon: Icon(Icons.add_shopping_cart), onPressed: onAddToCart),
        ],
      ),
    );
  }
}
```

---

### ⚙️ Backend Code Structure

#### **Entry Point**

##### `src/server.js`
**Purpose**: Server initialization and database connection

```javascript
const app = require('./app');
const connectDB = require('./config/db');

const PORT = process.env.PORT || 5001;

// Connect to MongoDB
connectDB();

// Start Express server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('SIGTERM received, shutting down gracefully');
  process.exit(0);
});
```

**Key Functions:**
- Loads environment variables
- Connects to MongoDB Atlas
- Starts HTTP server
- Handles graceful shutdown

---

##### `src/app.js`
**Purpose**: Express application configuration

```javascript
const express = require('express');
const cors = require('cors');
const app = express();

// Middleware
app.use(cors()); // Enable CORS for Flutter app
app.use(express.json()); // Parse JSON bodies
app.use(express.urlencoded({ extended: true }));

// Routes
app.use('/api/auth', require('./routes/auth.routes'));
app.use('/api/users', require('./routes/users.routes'));
app.use('/api/restaurants', require('./routes/restaurants.routes'));
app.use('/api/menus', require('./routes/menus.routes'));
app.use('/api/orders', require('./routes/orders.routes'));
app.use('/api/admin', require('./routes/admin.routes'));
app.use('/api/payments', require('./routes/payments.routes'));

// Health check
app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date() });
});

// Error handling middleware
app.use(require('./middlewares/error.middleware'));

module.exports = app;
```

**Configuration:**
- CORS enabled for cross-origin requests
- JSON body parser
- Route registration
- Global error handler

---

#### **🗄️ Database Models**

##### `src/models/User.js`
**Purpose**: User schema and authentication methods

```javascript
const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const userSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true, lowercase: true },
  phone: { type: String },
  password: { type: String, required: true },
  role: {
    type: String,
    enum: ['USER', 'RESTAURANT', 'ADMIN'],
    default: 'USER'
  },
  createdAt: { type: Date, default: Date.now }
}, { timestamps: true });

// Hash password before saving
userSchema.pre('save', async function(next) {
  if (!this.isModified('password')) return next();
  this.password = await bcrypt.hash(this.password, 10);
  next();
});

// Method to compare passwords
userSchema.methods.comparePassword = async function(candidatePassword) {
  return await bcrypt.compare(candidatePassword, this.password);
};

module.exports = mongoose.model('User', userSchema);
```

**Features:**
- Automatic password hashing
- Email validation and uniqueness
- Role-based user types
- Password comparison method

##### `src/models/Restaurant.js`
**Purpose**: Restaurant data schema

```javascript
const mongoose = require('mongoose');

const restaurantSchema = new mongoose.Schema({
  name: { type: String, required: true },
  description: { type: String },
  address: { type: String, required: true },
  phone: { type: String },
  ownerId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  approvalStatus: {
    type: String,
    enum: ['PENDING', 'APPROVED', 'REJECTED'],
    default: 'PENDING'
  },
  isOpen: { type: Boolean, default: false },
  preparationTime: { type: Number, default: 30 }, // minutes
  rating: { type: Number, default: 0 },
  createdAt: { type: Date, default: Date.now }
}, { timestamps: true });

// Index for faster queries
restaurantSchema.index({ ownerId: 1 });
restaurantSchema.index({ approvalStatus: 1, isOpen: 1 });

module.exports = mongoose.model('Restaurant', restaurantSchema);
```

**Features:**
- Owner reference (foreign key to User)
- Approval workflow states
- Open/closed status toggle
- Indexed for performance

##### `src/models/MenuItem.js`
**Purpose**: Menu item schema

```javascript
const mongoose = require('mongoose');

const menuItemSchema = new mongoose.Schema({
  restaurantId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Restaurant',
    required: true
  },
  name: { type: String, required: true },
  description: { type: String },
  price: { type: Number, required: true },
  category: { type: String, required: true }, // Pizza, Burger, etc.
  isVeg: { type: Boolean, default: false },
  isAvailable: { type: Boolean, default: true },
  imageUrl: { type: String },
  createdAt: { type: Date, default: Date.now }
}, { timestamps: true });

// Compound index for restaurant menu queries
menuItemSchema.index({ restaurantId: 1, isAvailable: 1 });

module.exports = mongoose.model('MenuItem', menuItemSchema);
```

##### `src/models/Order.js`
**Purpose**: Order schema with items and status tracking

```javascript
const mongoose = require('mongoose');

const orderSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  restaurantId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Restaurant',
    required: true
  },
  items: [{
    menuItemId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'MenuItem'
    },
    name: String,
    quantity: { type: Number, required: true },
    price: { type: Number, required: true }
  }],
  totalAmount: { type: Number, required: true },
  status: {
    type: String,
    enum: ['PLACED', 'CONFIRMED', 'PREPARING', 'READY', 'DELIVERED', 'CANCELLED'],
    default: 'PLACED'
  },
  deliveryAddress: { type: String },
  paymentStatus: {
    type: String,
    enum: ['PENDING', 'COMPLETED', 'FAILED'],
    default: 'PENDING'
  },
  createdAt: { type: Date, default: Date.now }
}, { timestamps: true });

// Indexes for queries
orderSchema.index({ userId: 1, createdAt: -1 });
orderSchema.index({ restaurantId: 1, status: 1 });

module.exports = mongoose.model('Order', orderSchema);
```

**Features:**
- Embedded order items
- Status state machine
- Payment tracking
- Indexed for user and restaurant queries

---

#### **🛣️ Routes**

##### `src/routes/auth.routes.js`
**Purpose**: Authentication endpoints

```javascript
const express = require('express');
const router = express.Router();
const authController = require('../controllers/auth.controller');

// POST /api/auth/register - Create new account
router.post('/register', authController.register);

// POST /api/auth/login - Authenticate user
router.post('/login', authController.login);

module.exports = router;
```

##### `src/routes/restaurants.routes.js`
**Purpose**: Restaurant management endpoints

```javascript
const express = require('express');
const router = express.Router();
const restaurantController = require('../controllers/restaurants.controller');
const { authenticate } = require('../middlewares/auth.middleware');
const { authorize } = require('../middlewares/role.middleware');

// Public routes
router.get('/', restaurantController.getAllRestaurants);
router.get('/:id', restaurantController.getRestaurantById);

// Protected routes - RESTAURANT role
router.use(authenticate); // All routes below require authentication
router.post('/', authorize(['RESTAURANT']), restaurantController.create);
router.get('/my-restaurant', authorize(['RESTAURANT']), restaurantController.getMyRestaurant);
router.patch('/toggle-status', authorize(['RESTAURANT']), restaurantController.toggleStatus);

module.exports = router;
```

**Route Protection:**
- Public: GET all restaurants
- RESTAURANT role: Create, update, toggle status
- ADMIN role: Approve/reject (in admin.routes.js)

##### `src/routes/orders.routes.js`
**Purpose**: Order management endpoints

```javascript
const express = require('express');
const router = express.Router();
const orderController = require('../controllers/orders.controller');
const { authenticate } = require('../middlewares/auth.middleware');
const { authorize } = require('../middlewares/role.middleware');

router.use(authenticate); // All order routes require authentication

// USER role - place order and view own orders
router.post('/', authorize(['USER']), orderController.placeOrder);
router.get('/my-orders', authorize(['USER']), orderController.getUserOrders);

// RESTAURANT role - view and update restaurant orders
router.get('/restaurant-orders', authorize(['RESTAURANT']), orderController.getRestaurantOrders);
router.patch('/:id/status', authorize(['RESTAURANT', 'ADMIN']), orderController.updateStatus);

module.exports = router;
```

---

#### **🎮 Controllers**

##### `src/controllers/auth.controller.js`
**Purpose**: Handle authentication requests

```javascript
const authService = require('../services/auth.service');
const { successResponse, errorResponse } = require('../utils/response');

exports.register = async (req, res) => {
  try {
    const { name, email, phone, password, role } = req.body;
    
    // Call service layer
    const result = await authService.register({ name, email, phone, password, role });
    
    return successResponse(res, result, 'User registered successfully', 201);
  } catch (error) {
    return errorResponse(res, error.message, 400);
  }
};

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;
    
    const result = await authService.login({ email, password });
    
    return successResponse(res, result, 'Login successful');
  } catch (error) {
    return errorResponse(res, error.message, 401);
  }
};
```

**Responsibilities:**
- Validate request body
- Call service layer
- Return formatted response
- Handle errors

##### `src/controllers/orders.controller.js`
**Purpose**: Handle order-related requests

```javascript
const orderService = require('../services/orders.service');
const { successResponse, errorResponse } = require('../utils/response');

exports.placeOrder = async (req, res) => {
  try {
    const { restaurantId, items, deliveryAddress } = req.body;
    const userId = req.user.id; // From auth middleware
    
    const order = await orderService.placeOrder({
      userId,
      restaurantId,
      items,
      deliveryAddress
    });
    
    return successResponse(res, { order }, 'Order placed successfully', 201);
  } catch (error) {
    return errorResponse(res, error.message, 400);
  }
};

exports.updateStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;
    
    const order = await orderService.updateOrderStatus(id, status);
    
    return successResponse(res, { order }, 'Order status updated');
  } catch (error) {
    return errorResponse(res, error.message, 400);
  }
};
```

---

#### **💼 Services (Business Logic)**

##### `src/services/auth.service.js`
**Purpose**: Authentication business logic

```javascript
const User = require('../models/User');
const jwt = require('jsonwebtoken');

exports.register = async ({ name, email, phone, password, role }) => {
  // Check if user already exists
  const existingUser = await User.findOne({ email });
  if (existingUser) {
    throw new Error('Email already registered');
  }
  
  // Create user (password auto-hashed by model)
  const user = await User.create({ name, email, phone, password, role });
  
  // Generate JWT token
  const token = jwt.sign(
    { id: user._id, role: user.role },
    process.env.JWT_SECRET,
    { expiresIn: process.env.JWT_EXPIRES_IN }
  );
  
  return {
    token,
    user: {
      id: user._id,
      name: user.name,
      email: user.email,
      role: user.role
    }
  };
};

exports.login = async ({ email, password }) => {
  // Find user
  const user = await User.findOne({ email });
  if (!user) {
    throw new Error('Invalid credentials');
  }
  
  // Verify password
  const isMatch = await user.comparePassword(password);
  if (!isMatch) {
    throw new Error('Invalid credentials');
  }
  
  // Generate token
  const token = jwt.sign(
    { id: user._id, role: user.role },
    process.env.JWT_SECRET,
    { expiresIn: process.env.JWT_EXPIRES_IN }
  );
  
  return {
    token,
    user: {
      id: user._id,
      name: user.name,
      email: user.email,
      role: user.role
    }
  };
};
```

##### `src/services/orders.service.js`
**Purpose**: Order processing business logic

```javascript
const Order = require('../models/Order');
const Restaurant = require('../models/Restaurant');
const MenuItem = require('../models/MenuItem');

exports.placeOrder = async ({ userId, restaurantId, items, deliveryAddress }) => {
  // Validate restaurant
  const restaurant = await Restaurant.findById(restaurantId);
  if (!restaurant) {
    throw new Error('Restaurant not found');
  }
  if (restaurant.approvalStatus !== 'APPROVED') {
    throw new Error('Restaurant is not approved');
  }
  if (!restaurant.isOpen) {
    throw new Error('Restaurant is currently closed');
  }
  
  // Validate and calculate total
  let totalAmount = 0;
  const orderItems = [];
  
  for (const item of items) {
    const menuItem = await MenuItem.findById(item.menuItemId);
    if (!menuItem) {
      throw new Error(`Menu item ${item.menuItemId} not found`);
    }
    if (!menuItem.isAvailable) {
      throw new Error(`${menuItem.name} is not available`);
    }
    
    orderItems.push({
      menuItemId: menuItem._id,
      name: menuItem.name,
      quantity: item.quantity,
      price: menuItem.price
    });
    
    totalAmount += menuItem.price * item.quantity;
  }
  
  // Create order
  const order = await Order.create({
    userId,
    restaurantId,
    items: orderItems,
    totalAmount,
    deliveryAddress,
    status: 'PLACED'
  });
  
  return order;
};

exports.updateOrderStatus = async (orderId, newStatus) => {
  const order = await Order.findById(orderId);
  if (!order) {
    throw new Error('Order not found');
  }
  
  // Validate status transition
  const validTransitions = {
    'PLACED': ['CONFIRMED', 'CANCELLED'],
    'CONFIRMED': ['PREPARING', 'CANCELLED'],
    'PREPARING': ['READY', 'CANCELLED'],
    'READY': ['DELIVERED', 'CANCELLED'],
  };
  
  if (!validTransitions[order.status]?.includes(newStatus)) {
    throw new Error(`Cannot transition from ${order.status} to ${newStatus}`);
  }
  
  order.status = newStatus;
  await order.save();
  
  return order;
};
```

**Business Rules:**
- Restaurant must be approved and open
- Menu items must be available
- Calculate total from actual menu prices
- Validate status transitions

---

#### **🛡️ Middlewares**

##### `src/middlewares/auth.middleware.js`
**Purpose**: JWT token verification

```javascript
const jwt = require('jsonwebtoken');
const User = require('../models/User');

exports.authenticate = async (req, res, next) => {
  try {
    // Get token from header
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ message: 'No token provided' });
    }
    
    const token = authHeader.split(' ')[1];
    
    // Verify token
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    
    // Attach user to request
    const user = await User.findById(decoded.id).select('-password');
    if (!user) {
      return res.status(401).json({ message: 'Invalid token' });
    }
    
    req.user = user;
    next();
  } catch (error) {
    return res.status(401).json({ message: 'Token verification failed' });
  }
};
```

##### `src/middlewares/role.middleware.js`
**Purpose**: Role-based access control

```javascript
exports.authorize = (allowedRoles) => {
  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({ message: 'Authentication required' });
    }
    
    if (!allowedRoles.includes(req.user.role)) {
      return res.status(403).json({
        message: `Access denied. Required role: ${allowedRoles.join(' or ')}`
      });
    }
    
    next();
  };
};
```

**Usage:**
```javascript
// Only RESTAURANT role can access
router.post('/', authenticate, authorize(['RESTAURANT']), controller.create);

// Both RESTAURANT and ADMIN can access
router.patch('/:id', authenticate, authorize(['RESTAURANT', 'ADMIN']), controller.update);
```

##### `src/middlewares/error.middleware.js`
**Purpose**: Global error handler

```javascript
module.exports = (err, req, res, next) => {
  console.error('Error:', err);
  
  // Mongoose validation error
  if (err.name === 'ValidationError') {
    const errors = Object.values(err.errors).map(e => e.message);
    return res.status(400).json({ message: 'Validation failed', errors });
  }
  
  // Mongoose duplicate key error
  if (err.code === 11000) {
    return res.status(400).json({ message: 'Duplicate entry' });
  }
  
  // JWT errors
  if (err.name === 'JsonWebTokenError') {
    return res.status(401).json({ message: 'Invalid token' });
  }
  
  // Default error
  res.status(err.statusCode || 500).json({
    message: err.message || 'Internal server error',
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
  });
};
```

---

#### **🔧 Utilities**

##### `src/utils/response.js`
**Purpose**: Standardized API responses

```javascript
exports.successResponse = (res, data, message = 'Success', statusCode = 200) => {
  return res.status(statusCode).json({
    success: true,
    message,
    data
  });
};

exports.errorResponse = (res, message = 'Error', statusCode = 500, errors = null) => {
  return res.status(statusCode).json({
    success: false,
    message,
    ...(errors && { errors })
  });
};
```

**Consistent Response Format:**
```json
// Success
{
  "success": true,
  "message": "Order placed successfully",
  "data": { "order": {...} }
}

// Error
{
  "success": false,
  "message": "Restaurant is closed",
  "errors": []
}
```

##### `src/config/db.js`
**Purpose**: MongoDB connection setup

```javascript
const mongoose = require('mongoose');

const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    
    console.log('MongoDB connected successfully');
    
    // Connection events
    mongoose.connection.on('error', (err) => {
      console.error('MongoDB connection error:', err);
    });
    
    mongoose.connection.on('disconnected', () => {
      console.log('MongoDB disconnected');
    });
  } catch (error) {
    console.error('MongoDB connection failed:', error);
    process.exit(1);
  }
};

module.exports = connectDB;
```

---

## 🔗 How It All Works Together

### Complete Request Flow Example: User Places Order

**Frontend → Backend → Database:**

1. **User Action** (Flutter UI)
   ```dart
   // user_home_screen.dart
   onPressed: () async {
     await ApiService.placeOrder(restaurantId, cartItems);
   }
   ```

2. **API Service** (HTTP Client)
   ```dart
   // api_service.dart
   static Future<Order> placeOrder(...) async {
     final response = await http.post(
       Uri.parse('$baseUrl/orders'),
       headers: _getHeaders(), // Includes JWT token
       body: jsonEncode({...}),
     );
     return Order.fromJson(response.body);
   }
   ```

3. **Backend Route** (Express)
   ```javascript
   // orders.routes.js
   router.post('/', authenticate, authorize(['USER']), orderController.placeOrder);
   ```

4. **Middleware Chain**
   ```javascript
   // auth.middleware.js - Verify JWT
   const decoded = jwt.verify(token, JWT_SECRET);
   req.user = await User.findById(decoded.id);
   
   // role.middleware.js - Check role
   if (!allowedRoles.includes(req.user.role)) throw Error;
   ```

5. **Controller** (Request Handler)
   ```javascript
   // orders.controller.js
   exports.placeOrder = async (req, res) => {
     const order = await orderService.placeOrder(req.body);
     return successResponse(res, { order }, 'Order placed');
   };
   ```

6. **Service** (Business Logic)
   ```javascript
   // orders.service.js
   exports.placeOrder = async (data) => {
     // Validate restaurant is open
     // Validate menu items exist
     // Calculate total
     // Create order in database
     return await Order.create({...});
   };
   ```

7. **Model** (Database)
   ```javascript
   // Order.js
   const order = await Order.create({
     userId, restaurantId, items, totalAmount, status: 'PLACED'
   });
   // Saves to MongoDB
   ```

8. **Response Back to Frontend**
   ```json
   {
     "success": true,
     "message": "Order placed successfully",
     "data": {
       "order": {
         "id": "...",
         "status": "PLACED",
         "totalAmount": 599
       }
     }
   }
   ```

9. **Update UI** (Flutter)
   ```dart
   // Update state and navigate
   setState(() => orders.add(newOrder));
   Navigator.push(context, MyOrdersScreen());
   ```

---

## 📋 Code Organization Principles

### Frontend (Flutter)
- **Separation of Concerns**: UI (screens/widgets) separate from logic (services)
- **Single Responsibility**: Each widget/service has one clear purpose
- **Reusability**: Common widgets extracted to `/widgets`
- **Type Safety**: Strong typing with Dart models
- **Error Handling**: Try-catch in all async operations

### Backend (Node.js)
- **MVC + Services Pattern**: Routes → Controllers → Services → Models
- **Middleware Pipeline**: Authentication → Authorization → Business Logic
- **Single Responsibility**: Each layer has distinct responsibility
- **Error Handling**: Global error middleware catches all errors
- **Validation**: Input validation at controller level, business rules at service level

### Common Patterns
- **Async/Await**: Consistent async handling (no callbacks)
- **DRY Principle**: Shared utilities and helpers
- **Environment Config**: All secrets in environment variables
- **Consistent Naming**: Clear, descriptive function and variable names
- **Comments**: Simple English explaining "why", not "what"

---

## �🔧 Configuration

### Backend Environment Variables

```env
# Server
PORT=5001

# Database
MONGODB_URI=mongodb+srv://user:pass@cluster.mongodb.net/foodapp

# JWT
JWT_SECRET=your-super-secret-key-here
JWT_EXPIRES_IN=7d
```

### Frontend API Configuration

Current configuration in `frontend/lib/services/api_service.dart`:

```dart
static const String baseUrl = 'https://food-fc4q.onrender.com/api';
```

**Note**: The app is configured for production. For local development, change to `'http://localhost:5001/api'`.

---

## 🧪 Testing the API

### Using cURL

```bash
# Register
curl -X POST https://food-fc4q.onrender.com/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","email":"test@example.com","password":"password123","role":"USER"}'

# Login
curl -X POST https://food-fc4q.onrender.com/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'

# Get restaurants (with token)
curl https://food-fc4q.onrender.com/api/restaurants \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

---

## 📱 Screen Previews

### User Journey
1. **Splash Screen** → Auto-login if session exists
2. **Login Screen** → Sign in or register
3. **User Home** → Browse menu with search/filter
4. **Restaurant Menu** → View specific restaurant items
5. **My Orders** → Track order status

### Restaurant Owner Journey
1. **Restaurant Home** → Dashboard with statistics
2. **Manage Menu** → Add/edit/delete menu items
3. **Restaurant Orders** → Manage incoming orders

### Admin Journey
1. **Admin Dashboard** → 4-tab interface
   - Overview: Platform stats
   - Restaurants: Approve/reject
   - Users: User management
   - Orders: Monitor all orders

---

## 🚀 Deployment

### Backend Deployment (Example: Heroku/Railway)

```bash
# Build ready for production
npm install --production

# Set environment variables on hosting platform:
# - PORT
# - MONGODB_URI
# - JWT_SECRET
# - JWT_EXPIRES_IN

# Deploy
git push heroku main
```

### Frontend Deployment (Example: Firebase Hosting)

```bash
# Build for web
flutter build web

# Deploy to Firebase
firebase deploy
```

Remember to update API URL in frontend to production backend URL.

---

## 🐛 Troubleshooting

### Backend Won't Start

```bash
# Check MongoDB connection
# Verify .env file exists with correct values
# Ensure port 5001 is not in use (for local development)

# Check logs
npm start
```

### Frontend Can't Connect to Backend

```bash
# Verify backend is accessible:
# - Production: https://food-fc4q.onrender.com
# - Local: http://localhost:5001
# Check CORS is enabled in backend
# Verify API URL in lib/services/api_service.dart
```

### Order Not Placing

- Check restaurant is APPROVED
- Check restaurant is OPEN
- Check menu items are AVAILABLE
- Check user has valid token

---

## 🔄 Future Enhancements

### Planned Features
1. **Real-time Updates**: WebSocket for live order tracking
2. **Payment Integration**: Stripe/Razorpay
3. **Image Upload**: Restaurant and menu item photos
4. **Push Notifications**: Order status updates
5. **Maps Integration**: Restaurant location
6. **Reviews & Ratings**: User feedback system
7. **Delivery Tracking**: Real-time delivery location
8. **Coupons & Discounts**: Promotional system
9. **Multiple Addresses**: User address management
10. **Order History Export**: Download receipts

---

## 📚 Learning Resources

### Flutter
- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language](https://dart.dev/)
- [Material Design](https://material.io/)

### Backend
- [Node.js Docs](https://nodejs.org/docs/)
- [Express.js Guide](https://expressjs.com/)
- [MongoDB Manual](https://docs.mongodb.com/)
- [Mongoose Docs](https://mongoosejs.com/)

---

## 👥 Contributing

### Code Style
- **Frontend**: Follow Dart/Flutter conventions
- **Backend**: Follow Node.js best practices
- **Comments**: Simple English explaining "why" not "what"
- **Commits**: Clear, descriptive messages

### Pull Request Process
1. Fork the repository
2. Create feature branch
3. Make changes with tests
4. Submit PR with description

---

## 📄 License

This project is for educational purposes.

---

## 📞 Support

For questions or issues:
1. Check detailed architecture docs:
   - [`frontend/ARCHITECTURE.md`](frontend/ARCHITECTURE.md)
   - [`backend/ARCHITECTURE.md`](backend/ARCHITECTURE.md)
2. Review code comments (all in simple English)
3. Check troubleshooting section above

---

## ✅ Project Status

- ✅ Backend API complete with all features
- ✅ Frontend Flutter app complete
- ✅ Authentication & authorization working
- ✅ Role-based access implemented
- ✅ Order management system functional
- ✅ Admin dashboard operational
- ✅ Session persistence working
- ✅ Comprehensive documentation with diagrams
- ✅ Simple English comments throughout codebase

---

## 👥 Authors

Ashlin, Roshni, Prabodh, Jeevan

**Version:** 1.0.0  
**Last Updated:** February 2026  
**Built with:** ❤️ Flutter & Node.js
