# Food Ordering & Restaurant Management System - Backend

A simple, well-structured backend for a multi-vendor food ordering platform built with Node.js, Express, and MongoDB.

## 📁 Project Structure

```
src/
├── app.js                    # Main Express app setup
├── server.js                 # Server entry point
├── config/                   # Configuration files
│   ├── db.js                # MongoDB connection
│   └── roles.js             # User roles definition
├── middlewares/              # Express middlewares
│   ├── auth.middleware.js   # JWT authentication
│   ├── role.middleware.js   # Role-based access control
│   └── error.middleware.js  # Global error handler
├── models/                   # Database models (Mongoose schemas)
│   ├── User.js              # User schema
│   ├── Restaurant.js        # Restaurant schema
│   ├── MenuItem.js          # Menu item schema
│   └── Order.js             # Order schema
├── controllers/              # Request handlers (HTTP layer)
│   ├── auth.controller.js   # Authentication endpoints
│   ├── users.controller.js  # User endpoints
│   ├── restaurants.controller.js
│   ├── menus.controller.js
│   ├── orders.controller.js
│   ├── admin.controller.js
│   └── payments.controller.js
├── services/                 # Business logic layer
│   ├── auth.service.js      # Authentication logic
│   ├── users.service.js     # User operations
│   ├── restaurants.service.js
│   ├── menus.service.js
│   ├── orders.service.js
│   ├── admin.service.js
│   └── payments.service.js
├── routes/                   # API route definitions
│   ├── auth.routes.js       # /auth endpoints
│   ├── users.routes.js      # /users endpoints
│   ├── restaurants.routes.js # /restaurants endpoints
│   ├── menus.routes.js      # /menus endpoints
│   ├── orders.routes.js     # /orders endpoints
│   ├── admin.routes.js      # /admin endpoints
│   └── payments.routes.js   # /payments endpoints
└── utils/                    # Utility functions
    ├── response.js          # Standard API responses
    └── logger.js            # Simple logging
```

## 🚀 Features

### User Roles
- **USER**: Regular customers who place food orders
- **RESTAURANT**: Restaurant owners who manage menus and orders
- **ADMIN**: System administrators with full visibility

### Core Functionality
- ✅ User authentication with JWT
- ✅ Role-based access control
- ✅ Multi-vendor restaurant support
- ✅ Menu management (CRUD operations)
- ✅ Order lifecycle management
- ✅ Restaurant dashboard with stats
- ✅ Admin reports and analytics
- ✅ Payment status tracking (stub)

## 🛠️ Tech Stack

- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: MongoDB (Mongoose)
- **Authentication**: JWT (jsonwebtoken)
- **Password Hashing**: bcrypt

## 📦 Installation

1. Install dependencies:
```bash
npm install
```

2. Create a `.env` file:
```env
PORT=5001
MONGO_URI=your_mongodb_connection_string
JWT_SECRET=your_secret_key
```

3. Start the server:
```bash
# Development (with auto-reload)
npm run dev

# Production
npm start
```

## 📡 API Endpoints

### Authentication
```
POST /auth/register - Register a new user
POST /auth/login    - Login user
```

### Users (USER role)
```
GET  /users/profile - Get my profile
GET  /users/orders  - Get my order history
```

### Restaurants (RESTAURANT role)
```
POST  /restaurants           - Create a restaurant
GET   /restaurants/my        - Get my restaurant details
GET   /restaurants/orders    - Get orders for my restaurant
PATCH /restaurants/status    - Toggle open/close status
GET   /restaurants/dashboard - Get dashboard statistics
```

### Menus (RESTAURANT role)
```
POST   /menus                          - Add menu item
GET    /menus/my                       - Get my restaurant's menu
GET    /menus/restaurant/:restaurantId - Get menu for any restaurant
PUT    /menus/:itemId                  - Update menu item
PATCH  /menus/:itemId/availability     - Toggle item availability
DELETE /menus/:itemId                  - Delete menu item
```

### Orders
```
POST  /orders                    - Place order (USER)
PATCH /orders/:orderId/cancel    - Cancel order (USER)
PATCH /orders/:orderId/status    - Update order status (RESTAURANT)
```

### Admin (ADMIN role)
```
GET /admin/users           - Get all users
GET /admin/restaurants     - Get all restaurants
GET /admin/orders          - Get all orders
GET /admin/reports         - Get system reports
GET /admin/revenue/daily   - Get daily revenue data
```

### Payments (Stub)
```
POST /payments/:orderId/mark-paid - Mark order as paid
GET  /payments/:orderId/status    - Get payment status
```

## 🔐 Authentication

All protected routes require a JWT token in the header:
```
Authorization: Bearer <your_jwt_token>
```

## 📊 Order Status Flow

```
PLACED → ACCEPTED → PREPARING → READY
       ↓
    REJECTED
       ↓
    CANCELLED (only when PLACED)
```

**Rules:**
- Users can only cancel when status is PLACED
- Restaurants can change status following the valid transitions
- Order items and prices are saved as snapshots (immutable)

## 🎯 API Response Format

### Success Response
```json
{
  "success": true,
  "message": "Operation successful",
  "data": { ... }
}
```

### Error Response
```json
{
  "success": false,
  "message": "Error description",
  "data": null
}
```

## 💡 Key Design Decisions

1. **Simple Code**: Written like a beginner would - easy to understand
2. **Well Organized**: Each module has its own folder (service, controller, routes)
3. **Clear Comments**: Every file has explanatory comments
4. **Role-Based Access**: Strict role checking via middleware
5. **Order Snapshots**: Menu items saved in orders to prevent price changes
6. **No Over-Engineering**: Straightforward, functional code

## 🧪 Testing the API

Use Postman, Thunder Client, or curl to test endpoints.

Example: Register a user
```bash
# Production
curl -X POST https://food-fc4q.onrender.com/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "phone": "1234567890",
    "password": "password123",
    "role": "USER"
  }'

# Local Development
# curl -X POST http://localhost:5001/api/auth/register \
#   -H "Content-Type: application/json" \
#   -d '{ ... }'
```

## 👥 Authors

Ashlin, Roshni, Prabodh, Jeevan