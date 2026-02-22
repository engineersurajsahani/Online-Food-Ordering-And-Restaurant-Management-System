# Backend Architecture Documentation

## 🍕 Food Order App - Node.js Backend API

A comprehensive REST API for food ordering platform with role-based access control, built with Node.js, Express, and MongoDB.

---

## 🏗️ Overall Architecture

```mermaid
graph TB
    subgraph "Client Layer"
        Flutter[Flutter Frontend]
        Mobile[Mobile Apps]
        Web[Web Browser]
    end
    
    subgraph "API Gateway"
        Express[Express Server<br/>Port 5001]
    end
    
    subgraph "Middleware Layer"
        CORS[CORS]
        JSON[Body Parser]
        Auth[JWT Auth]
        Role[Role Check]
        Error[Error Handler]
    end
    
    subgraph "Route Layer"
        AuthRoutes[Auth Routes]
        UserRoutes[User Routes]
        RestRoutes[Restaurant Routes]
        MenuRoutes[Menu Routes]
        OrderRoutes[Order Routes]
        AdminRoutes[Admin Routes]
    end
    
    subgraph "Business Logic"
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
    
    Flutter --> Express
    Mobile --> Express
    Web --> Express
    
    Express --> CORS
    Express --> JSON
    CORS --> Auth
    JSON --> Auth
    Auth --> Role
    Role --> AuthRoutes
    Role --> UserRoutes
    Role --> RestRoutes
    Role --> MenuRoutes
    Role --> OrderRoutes
    Role --> AdminRoutes
    
    AuthRoutes --> AuthService
    UserRoutes --> UserService
    RestRoutes --> RestService
    MenuRoutes --> MenuService
    OrderRoutes --> OrderService
    AdminRoutes --> AdminService
    
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
    
    Error -.-> Express
```

---

## 📂 Project Structure

```
backend/
├── src/
│   ├── server.js                    # Entry point - starts the server
│   ├── app.js                       # Express app configuration & routes setup
│   │
│   ├── config/                      # Configuration files
│   │   ├── db.js                    # MongoDB connection setup
│   │   └── roles.js                 # User role constants
│   │
│   ├── models/                      # MongoDB schemas (database structure)
│   │   ├── User.js                  # User schema (customers, owners, admins)
│   │   ├── Restaurant.js            # Restaurant schema
│   │   ├── MenuItem.js              # Menu item schema
│   │   └── Order.js                 # Order schema with items
│   │
│   ├── routes/                      # API endpoint definitions
│   │   ├── auth.routes.js           # POST /register, /login
│   │   ├── users.routes.js          # GET /profile, /stats
│   │   ├── restaurants.routes.js    # CRUD for restaurants
│   │   ├── menus.routes.js          # CRUD for menu items
│   │   ├── orders.routes.js         # Place & manage orders
│   │   ├── admin.routes.js          # Admin management endpoints
│   │   ├── payments.routes.js       # Payment endpoints (stub)
│   │   └── proxy.routes.js          # Image proxy for CORS
│   │
│   ├── controllers/                 # Request handlers (receive & respond)
│   │   ├── auth.controller.js       # Handle register/login requests
│   │   ├── users.controller.js      # Handle user profile requests
│   │   ├── restaurants.controller.js # Handle restaurant requests
│   │   ├── menus.controller.js      # Handle menu requests
│   │   ├── orders.controller.js     # Handle order requests
│   │   ├── admin.controller.js      # Handle admin requests
│   │   └── payments.controller.js   # Handle payment requests
│   │
│   ├── services/                    # Business logic (the brain)
│   │   ├── auth.service.js          # Registration, login, token generation
│   │   ├── users.service.js         # User operations
│   │   ├── restaurants.service.js   # Restaurant operations
│   │   ├── menus.service.js         # Menu operations
│   │   ├── orders.service.js        # Order processing logic
│   │   ├── admin.service.js         # Admin operations
│   │   └── payments.service.js      # Payment logic (stub)
│   │
│   ├── middlewares/                 # Request interceptors
│   │   ├── auth.middleware.js       # JWT token verification
│   │   ├── role.middleware.js       # Role-based access control
│   │   └── error.middleware.js      # Global error handler
│   │
│   └── utils/                       # Helper functions
│       ├── logger.js                # Console logging utility
│       └── response.js              # Standard response formatters
│
├── package.json                     # Dependencies & scripts
├── .env                            # Environment variables (not in git)
└── README.md                       # Basic readme
```

---

## 🔄 Request Flow Architecture

### Complete Request Journey

```mermaid
sequenceDiagram
    participant Client as Flutter App
    participant Express as Express Server
    participant Middleware as Auth/Role Middleware
    participant Controller as Controller
    participant Service as Service Layer
    participant Model as Mongoose Model
    participant DB as MongoDB
    
    Client->>Express: HTTP Request + JWT Token
    Express->>Middleware: Verify Token
    
    alt Invalid Token
        Middleware-->>Client: 401 Unauthorized
    else Valid Token
        Middleware->>Middleware: Check Role
        
        alt Insufficient Permission
            Middleware-->>Client: 403 Forbidden
        else Authorized
            Middleware->>Controller: Process Request
            Controller->>Service: Call Business Logic
            Service->>Model: Query/Update Data
            Model->>DB: MongoDB Operation
            DB-->>Model: Data Result
            Model-->>Service: Data
            Service-->>Controller: Processed Result
            Controller-->>Client: JSON Response
        end
    end
```

### Example: Place Order Flow

```mermaid
sequenceDiagram
    participant User as User App
    participant API as Express API
    participant Auth as Auth Middleware
    participant OrderCtrl as Order Controller
    participant OrderSvc as Order Service
    participant RestSvc as Restaurant Service
    participant MenuSvc as Menu Service
    participant DB as MongoDB
    
    User->>API: POST /api/orders<br/>{items, restaurantId}
    API->>Auth: Verify JWT Token
    Auth->>OrderCtrl: Token Valid (USER role)
    OrderCtrl->>OrderSvc: placeOrder(userId, data)
    
    OrderSvc->>RestSvc: getRestaurantById(restaurantId)
    RestSvc->>DB: Find Restaurant
    DB-->>RestSvc: Restaurant Data
    RestSvc-->>OrderSvc: Restaurant
    
    OrderSvc->>OrderSvc: Validate restaurant is open & approved
    
    OrderSvc->>MenuSvc: getMenuItemById(itemId)
    MenuSvc->>DB: Find MenuItem
    DB-->>MenuSvc: MenuItem Data
    MenuSvc-->>OrderSvc: MenuItem with current price
    
    OrderSvc->>OrderSvc: Calculate total amount
    OrderSvc->>DB: Create Order Document
    DB-->>OrderSvc: Order Created
    OrderSvc-->>OrderCtrl: Order Object
    OrderCtrl-->>User: 201 Created + Order Data
```

---

## 🗄️ Database Schema Architecture

### Entity Relationship Diagram

```mermaid
erDiagram
    User ||--o{ Order : places
    User ||--o| Restaurant : owns
    Restaurant ||--o{ MenuItem : has
    Restaurant ||--o{ Order : receives
    Order ||--|{ OrderItem : contains
    MenuItem ||--o{ OrderItem : "referenced by"
    
    User {
        ObjectId _id PK
        string name
        string email UK
        string phone
        string passwordHash
        enum role
        boolean isActive
        datetime createdAt
        datetime updatedAt
    }
    
    Restaurant {
        ObjectId _id PK
        ObjectId ownerId FK
        string name
        string description
        string address
        boolean isOpen
        int preparationTime
        enum approvalStatus
        string approvalNotes
        boolean isActive
        datetime createdAt
        datetime updatedAt
    }
    
    MenuItem {
        ObjectId _id PK
        ObjectId restaurantId FK
        string name
        string description
        number price
        boolean isVeg
        string category
        string image
        boolean isAvailable
        datetime createdAt
        datetime updatedAt
    }
    
    Order {
        ObjectId _id PK
        ObjectId userId FK
        ObjectId restaurantId FK
        array items
        number totalAmount
        enum status
        enum paymentStatus
        datetime createdAt
        datetime updatedAt
    }
    
    OrderItem {
        ObjectId menuItemId FK
        string nameSnapshot
        number priceSnapshot
        int quantity
    }
```

### Model Relationships

```mermaid
graph TD
    User[User Model] -->|ownerId| Restaurant[Restaurant Model]
    User -->|userId| Order[Order Model]
    Restaurant -->|restaurantId| MenuItem[MenuItem Model]
    Restaurant -->|restaurantId| Order
    MenuItem -.->|menuItemId reference| OrderItem[Order.items<br/>Embedded OrderItem]
    Order -->|contains| OrderItem
    
    style User fill:#4caf50
    style Restaurant fill:#2196f3
    style MenuItem fill:#ff9800
    style Order fill:#9c27b0
    style OrderItem fill:#e1bee7
```

---

## 🔐 Authentication & Authorization

### JWT Token Flow

```mermaid
sequenceDiagram
    participant User as User
    participant Frontend as Frontend
    participant API as Backend API
    participant JWT as JWT Service
    participant DB as MongoDB
    
    User->>Frontend: Enter email & password
    Frontend->>API: POST /api/auth/login
    API->>DB: Find user by email
    DB-->>API: User data
    API->>API: Compare password hash
    
    alt Password Valid
        API->>JWT: Generate JWT Token
        Note over JWT: Payload: {userId, role}
        JWT-->>API: Signed Token
        API-->>Frontend: {success, token, user}
        Frontend->>Frontend: Store token locally
        
        Note over Frontend,API: All subsequent requests
        Frontend->>API: Request + Authorization: Bearer {token}
        API->>JWT: Verify token signature
        JWT-->>API: Decoded payload
        API->>API: Attach user to req.user
    else Password Invalid
        API-->>Frontend: {success: false, message}
    end
```

### Role-Based Access Control

```mermaid
graph TD
    Request[Incoming Request] --> AuthMiddleware[Auth Middleware<br/>verifyToken]
    
    AuthMiddleware -->|No Token| Reject1[401 Unauthorized]
    AuthMiddleware -->|Invalid Token| Reject2[401 Invalid Token]
    AuthMiddleware -->|Valid Token| RoleMiddleware[Role Middleware<br/>allowRoles]
    
    RoleMiddleware -->|Role Not Allowed| Reject3[403 Forbidden]
    RoleMiddleware -->|Role Allowed| Controller[Controller]
    
    Controller --> Service[Service]
    Service --> Response[Success Response]
    
    style AuthMiddleware fill:#4caf50
    style RoleMiddleware fill:#2196f3
    style Reject1 fill:#f44336
    style Reject2 fill:#f44336
    style Reject3 fill:#ff9800
```

### Protected Routes Example

| Route | Method | Roles Allowed |
|-------|--------|---------------|
| `/api/auth/register` | POST | Public (no auth) |
| `/api/auth/login` | POST | Public (no auth) |
| `/api/users/profile` | GET | USER, RESTAURANT, ADMIN |
| `/api/restaurants` | POST | RESTAURANT only |
| `/api/orders` | POST | USER only |
| `/api/admin/users` | GET | ADMIN only |
| `/api/orders/:id/status` | PATCH | RESTAURANT, ADMIN |

---

## 📡 API Endpoints Overview

### Authentication Endpoints

```mermaid
graph LR
    Auth[/api/auth] --> Register[POST /register<br/>Create new account]
    Auth --> Login[POST /login<br/>Get JWT token]
    
    Register --> Response1[201: User created + token]
    Login --> Response2[200: Login success + token]
```

### User Endpoints

```mermaid
graph LR
    Users[/api/users] --> Profile[GET /profile<br/>Get user info]
    Users --> Stats[GET /stats<br/>Order statistics]
    
    Profile --> Auth1[Requires: JWT Token]
    Stats --> Auth2[Requires: JWT Token + USER role]
```

### Restaurant Endpoints

```mermaid
graph LR
    Rest[/api/restaurants] --> GetAll[GET /<br/>List all restaurants]
    Rest --> GetMy[GET /my-restaurant<br/>Owner's restaurant]
    Rest --> Create[POST /<br/>Create restaurant]
    Rest --> Toggle[PATCH /toggle-status<br/>Open/Close]
    
    GetMy --> RoleR[RESTAURANT role]
    Create --> RoleR
    Toggle --> RoleR
```

### Admin Endpoints

```mermaid
graph LR
    Admin[/api/admin] --> Users[GET /users<br/>All users]
    Admin --> Restaurants[GET /restaurants<br/>All restaurants]
    Admin --> Orders[GET /orders<br/>All orders]
    Admin --> Approve[POST /restaurants/:id/approve]
    Admin --> Reject[POST /restaurants/:id/reject]
    Admin --> Stats[GET /stats<br/>Platform statistics]
    
    Users --> AdminRole[ADMIN role required]
    Restaurants --> AdminRole
    Orders --> AdminRole
    Approve --> AdminRole
    Reject --> AdminRole
    Stats --> AdminRole
```

---

## 🎯 Service Layer Architecture

### Layered Architecture Pattern

```mermaid
graph TB
    subgraph "Presentation Layer"
        Routes[Routes<br/>Define endpoints]
        Controllers[Controllers<br/>Handle requests & responses]
    end
    
    subgraph "Business Logic Layer"
        Services[Services<br/>Core business logic]
    end
    
    subgraph "Data Access Layer"
        Models[Mongoose Models<br/>Database schemas]
    end
    
    subgraph "External Layer"
        DB[(MongoDB)]
    end
    
    Routes --> Controllers
    Controllers --> Services
    Services --> Models
    Models --> DB
    
    Controllers -.->|Never directly| Models
    Routes -.->|Never directly| Services
```

### Service Responsibilities

**Auth Service:**
- Hash passwords using bcrypt
- Generate JWT tokens
- Validate credentials
- Create new user accounts

**Restaurant Service:**
- Create restaurants
- Validate restaurant ownership
- Toggle open/closed status
- Get restaurant details

**Menu Service:**
- Add menu items
- Update item details
- Delete items
- Validate restaurant ownership

**Order Service:**
- Validate restaurant status
- Calculate total amounts
- Create orders with snapshots
- Update order status
- Validate status transitions

**Admin Service:**
- Approve/reject restaurants
- Get platform-wide statistics
- Manage users and orders
- Generate reports

---

## 📊 Data Flow Patterns

### Create Order Data Flow

```mermaid
graph TD
    A[Client: Order Request] --> B[Controller: Validate Input]
    B --> C[Service: Check Restaurant]
    C --> D{Restaurant<br/>Open & Approved?}
    
    D -->|No| E[Error: Restaurant Unavailable]
    D -->|Yes| F[Service: Validate Menu Items]
    
    F --> G{Items<br/>Available?}
    G -->|No| H[Error: Item Not Available]
    G -->|Yes| I[Service: Calculate Total]
    
    I --> J[Service: Create Order<br/>with Price Snapshots]
    J --> K[Model: Save to MongoDB]
    K --> L[Controller: Return Success]
    
    E --> M[Client: Error Response]
    H --> M
    L --> N[Client: Order Created]
```

### Update Order Status Flow

```mermaid
graph TD
    A[Restaurant/Admin: Update Status] --> B[Controller: Verify Identity]
    B --> C{Is Restaurant Owner<br/>or Admin?}
    
    C -->|No| D[Error: Forbidden]
    C -->|Yes| E[Service: Get Order]
    
    E --> F{Order<br/>Exists?}
    F -->|No| G[Error: Not Found]
    F -->|Yes| H[Service: Validate Status Transition]
    
    H --> I{Valid<br/>Transition?}
    I -->|No| J[Error: Invalid Status]
    I -->|Yes| K[Service: Update Order]
    
    K --> L[Model: Save Changes]
    L --> M[Controller: Success Response]
    
    D --> N[Client: Error]
    G --> N
    J --> N
    M --> O[Client: Updated Order]
```

---

## 🛡️ Middleware Pipeline

### Request Processing Pipeline

```mermaid
graph LR
    Request[HTTP Request] --> CORS[CORS Middleware]
    CORS --> JSON[Body Parser]
    JSON --> Router[Route Matching]
    
    Router --> Public{Public<br/>Route?}
    Public -->|Yes| Controller1[Controller]
    Public -->|No| Auth[Auth Middleware<br/>verifyToken]
    
    Auth --> Valid{Valid<br/>Token?}
    Valid -->|No| Error1[401 Error]
    Valid -->|Yes| RoleCheck[Role Middleware<br/>allowRoles]
    
    RoleCheck --> HasRole{Has<br/>Required Role?}
    HasRole -->|No| Error2[403 Error]
    HasRole -->|Yes| Controller2[Controller]
    
    Controller1 --> Response
    Controller2 --> Response
    
    Response --> ErrorHandler{Error<br/>Occurred?}
    ErrorHandler -->|Yes| ErrorMiddleware[Error Middleware]
    ErrorHandler -->|No| Success[Success Response]
    
    ErrorMiddleware --> ErrorResponse[Error Response]
    
    style Auth fill:#4caf50
    style RoleCheck fill:#2196f3
    style ErrorMiddleware fill:#ff9800
```

---

## 🔧 Configuration Management

### Environment Variables

```mermaid
graph TD
    ENV[.env File] --> Server[Server Configuration]
    ENV --> DB[Database Configuration]
    ENV --> JWT[JWT Configuration]
    
    Server --> PORT[PORT=5001]
    DB --> MONGO_URI[MONGODB_URI]
    JWT --> SECRET[JWT_SECRET<br/>JWT_EXPIRES_IN]
    
    style ENV fill:#ff9800
```

**Required Environment Variables:**

```bash
# Server
PORT=5001

# Database
MONGODB_URI=mongodb+srv://user:pass@cluster.mongodb.net/foodapp

# JWT Authentication
JWT_SECRET=your-super-secret-key-change-this-in-production
JWT_EXPIRES_IN=7d
```

---

## 📈 Order Status State Machine

```mermaid
stateDiagram-v2
    [*] --> PLACED: User places order
    
    PLACED --> CONFIRMED: Restaurant confirms
    PLACED --> CANCELLED: User/Restaurant cancels
    
    CONFIRMED --> PREPARING: Restaurant starts cooking
    CONFIRMED --> CANCELLED: Restaurant cancels
    
    PREPARING --> READY: Food is ready
    PREPARING --> CANCELLED: Emergency cancel
    
    READY --> DELIVERED: Order completed
    READY --> CANCELLED: Pickup timeout
    
    DELIVERED --> [*]: Order complete
    CANCELLED --> [*]: Order terminated
```

**Valid Status Transitions:**
- `PLACED` → `CONFIRMED`, `CANCELLED`
- `CONFIRMED` → `PREPARING`, `CANCELLED`
- `PREPARING` → `READY`, `CANCELLED`
- `READY` → `DELIVERED`, `CANCELLED`
- `CANCELLED` → (final state)
- `DELIVERED` → (final state)

---

## 🎨 Response Format Standards

### Success Response Structure

```json
{
  "success": true,
  "message": "Operation successful",
  "data": {
    // Response data here
  }
}
```

### Error Response Structure

```json
{
  "success": false,
  "message": "Error description",
  "error": "Detailed error message"
}
```

### Common HTTP Status Codes

| Code | Meaning | Usage |
|------|---------|-------|
| 200 | OK | Successful GET, PUT, PATCH |
| 201 | Created | Successful POST |
| 400 | Bad Request | Invalid input data |
| 401 | Unauthorized | No token or invalid token |
| 403 | Forbidden | Valid token but insufficient permissions |
| 404 | Not Found | Resource doesn't exist |
| 500 | Server Error | Unexpected server error |

---

## 🧪 API Testing Examples

### Register New User

```bash
POST http://localhost:5001/api/auth/register
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "role": "USER"
}
```

### Login

```bash
POST http://localhost:5001/api/auth/login
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "password123"
}
```

### Create Restaurant (Protected)

```bash
POST http://localhost:5001/api/restaurants
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "name": "Pizza Palace",
  "description": "Best pizza in town",
  "address": "123 Main St"
}
```

### Place Order (Protected)

```bash
POST http://localhost:5001/api/orders
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "restaurantId": "65f1234567890abcdef12345",
  "items": [
    {
      "menuItemId": "65f1234567890abcdef12346",
      "quantity": 2
    }
  ]
}
```

---

## 🔍 Mongoose Schema Details

### User Schema

```javascript
{
  name: String (required),
  email: String (required, unique, indexed),
  phone: String,
  passwordHash: String (required),
  role: Enum ['USER', 'RESTAURANT', 'ADMIN'],
  isActive: Boolean (default: true),
  timestamps: { createdAt, updatedAt }
}
```

### Restaurant Schema

```javascript
{
  ownerId: ObjectId (ref: User, required),
  name: String (required),
  description: String,
  address: String (required),
  isOpen: Boolean (default: true),
  preparationTime: Number (default: 30),
  approvalStatus: Enum ['PENDING', 'APPROVED', 'REJECTED'],
  approvalNotes: String,
  isActive: Boolean (default: true),
  timestamps: { createdAt, updatedAt }
}
```

### MenuItem Schema

```javascript
{
  restaurantId: ObjectId (ref: Restaurant, required),
  name: String (required),
  description: String,
  price: Number (required, min: 0),
  isVeg: Boolean (default: true),
  category: String (default: 'Other'),
  image: String (URL),
  isAvailable: Boolean (default: true),
  timestamps: { createdAt, updatedAt }
}
```

### Order Schema

```javascript
{
  userId: ObjectId (ref: User, required),
  restaurantId: ObjectId (ref: Restaurant, required),
  items: [
    {
      menuItemId: ObjectId (ref: MenuItem),
      nameSnapshot: String,      // Price at order time
      priceSnapshot: Number,     // Prevents price changes
      quantity: Number
    }
  ],
  totalAmount: Number (required),
  status: Enum ['PLACED', 'CONFIRMED', 'PREPARING', 'READY', 'DELIVERED', 'CANCELLED'],
  paymentStatus: Enum ['PENDING', 'COMPLETED', 'FAILED'],
  timestamps: { createdAt, updatedAt }
}
```

---

## 🚀 Getting Started

### Prerequisites
- Node.js (v18 or higher)
- MongoDB Atlas account or local MongoDB
- npm or yarn

### Installation

```bash
# Navigate to backend directory
cd backend

# Install dependencies
npm install

# Create .env file
cat > .env << EOF
PORT=5001
MONGODB_URI=your_mongodb_connection_string
JWT_SECRET=your_super_secret_key
JWT_EXPIRES_IN=7d
EOF

# Start server
npm start
```

### Running in Development

```bash
# With auto-reload
npm run dev
```

---

## 📦 Dependencies

### Core Dependencies

```json
{
  "express": "^4.18.2",        // Web framework
  "mongoose": "^8.0.0",        // MongoDB ODM
  "cors": "^2.8.5",           // CORS middleware
  "dotenv": "^16.3.1",        // Environment variables
  "bcryptjs": "^2.4.3",       // Password hashing
  "jsonwebtoken": "^9.0.2"    // JWT tokens
}
```

### Why These Packages?

- **Express**: Fast, minimal web framework
- **Mongoose**: Elegant MongoDB object modeling
- **CORS**: Enable cross-origin requests from frontend
- **dotenv**: Manage environment variables
- **bcryptjs**: Secure password hashing
- **jsonwebtoken**: Stateless authentication

---

## 🛡️ Security Best Practices

### Implemented Security Measures

```mermaid
graph TD
    Security[Security Measures]
    
    Security --> Auth[Authentication]
    Security --> Authz[Authorization]
    Security --> Data[Data Protection]
    Security --> Input[Input Validation]
    
    Auth --> JWT[JWT Tokens]
    Auth --> Hash[Password Hashing<br/>bcrypt]
    
    Authz --> RBAC[Role-Based Access]
    Authz --> Middleware[Protected Routes]
    
    Data --> NoPlainPW[No Plain Passwords]
    Data --> HTTPS[HTTPS Ready]
    
    Input --> Validation[Input Validation]
    Input --> Sanitization[Data Sanitization]
```

### Security Checklist

- ✅ Passwords hashed with bcrypt (salt rounds: 10)
- ✅ JWT tokens for stateless authentication
- ✅ Role-based access control (RBAC)
- ✅ Protected routes with middleware
- ✅ Environment variables for secrets
- ✅ CORS configured for specific origins
- ✅ Input validation in services
- ✅ Error messages don't leak sensitive info

---

## 📊 Admin Statistics Implementation

### Stats Calculation Flow

```mermaid
graph TD
    AdminRequest[Admin Requests Stats] --> Service[Admin Service]
    
    Service --> CountUsers[Count Users by Role]
    Service --> CountRest[Count Restaurants by Status]
    Service --> CountOrders[Count Orders by Status]
    Service --> CalcRevenue[Calculate Total Revenue]
    
    CountUsers --> MongoDB1[(MongoDB<br/>User Collection)]
    CountRest --> MongoDB2[(MongoDB<br/>Restaurant Collection)]
    CountOrders --> MongoDB3[(MongoDB<br/>Order Collection)]
    CalcRevenue --> MongoDB3
    
    MongoDB1 --> Aggregate[Aggregate Results]
    MongoDB2 --> Aggregate
    MongoDB3 --> Aggregate
    
    Aggregate --> Response[Return Stats Object]
```

---

## 🔄 Order Lifecycle

### Complete Order Journey

```mermaid
sequenceDiagram
    participant User
    participant Frontend
    participant API
    participant RestaurantOwner
    participant Admin
    
    User->>Frontend: Browse menu & select items
    Frontend->>API: POST /api/orders (PLACE order)
    API-->>RestaurantOwner: New order notification
    
    RestaurantOwner->>API: PATCH /api/orders/:id/status (CONFIRMED)
    API-->>User: Order confirmed notification
    
    RestaurantOwner->>API: PATCH /api/orders/:id/status (PREPARING)
    API-->>User: Food is being prepared
    
    RestaurantOwner->>API: PATCH /api/orders/:id/status (READY)
    API-->>User: Food ready for pickup
    
    RestaurantOwner->>API: PATCH /api/orders/:id/status (DELIVERED)
    API-->>User: Order completed
    
    Note over User,RestaurantOwner: At any point (before READY)
    alt Cancellation
        User->>API: PATCH /api/orders/:id/status (CANCELLED)
        API-->>RestaurantOwner: Order cancelled
    end
```

---

## 🏆 Best Practices Implemented

### Code Organization

1. **Separation of Concerns**
   - Routes handle HTTP
   - Controllers handle request/response
   - Services handle business logic
   - Models handle data structure

2. **DRY Principle**
   - Reusable response utilities
   - Shared middleware
   - Common validation logic

3. **Error Handling**
   - Global error middleware
   - Consistent error responses
   - Proper HTTP status codes

### API Design

1. **RESTful Conventions**
   - Proper HTTP verbs (GET, POST, PUT, PATCH, DELETE)
   - Resource-based URLs
   - Standard status codes

2. **Consistent Responses**
   - Always `{success, message, data}` format
   - Clear error messages
   - Proper status codes

---

## 📝 Comments Style Guide

All backend code uses clear, simple comments:

```javascript
// Brief explanation of what this does
// Focuses on "why" not just "what"
```

**Examples:**
- `// Hash password before saving to database`
- `// Check if restaurant is approved before allowing orders`
- `// Calculate total by summing all item prices * quantities`

---

## 🔄 Future Enhancements

Potential improvements:

1. **Real-time Features**: Socket.io for live order updates
2. **File Uploads**: Multer for restaurant/menu images
3. **Email Notifications**: Nodemailer for order confirmations
4. **Payment Integration**: Stripe/Razorpay
5. **Rate Limiting**: Express-rate-limit for API protection
6. **Caching**: Redis for frequently accessed data
7. **Logging**: Winston or Morgan for better logging
8. **Testing**: Jest for unit and integration tests
9. **API Documentation**: Swagger/OpenAPI
10. **Validation**: Joi or express-validator

---

## 📚 Additional Resources

- [Express.js Documentation](https://expressjs.com/)
- [Mongoose Documentation](https://mongoosejs.com/)
- [MongoDB Manual](https://docs.mongodb.com/)
- [JWT.io](https://jwt.io/)
- [Node.js Best Practices](https://github.com/goldbergyoni/nodebestpractices)

---

**Last Updated**: February 2026  
**Version**: 1.0.0  
**Author**: Food Order App Team
