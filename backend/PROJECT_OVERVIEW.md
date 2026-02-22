# Food Ordering System - Project Overview

## ✅ Successfully Completed Restructuring!

The backend has been reorganized into a clean, professional folder structure that's easy to understand and maintain.

---

## 📂 New Folder Structure

```
src/
├── app.js                     # Main Express app (routes + middleware)
├── server.js                  # Server entry point
│
├── config/                    # Configuration files
│   ├── db.js                 # MongoDB connection setup
│   └── roles.js              # User role definitions (USER, RESTAURANT, ADMIN)
│
├── middlewares/               # Express middlewares
│   ├── auth.middleware.js    # JWT token verification
│   ├── role.middleware.js    # Role-based access control
│   └── error.middleware.js   # Global error handling
│
├── models/                    # Database schemas (Mongoose)
│   ├── User.js               # User model
│   ├── Restaurant.js         # Restaurant model
│   ├── MenuItem.js           # Menu item model
│   └── Order.js              # Order model
│
├── controllers/               # HTTP request handlers
│   ├── auth.controller.js    # Handle register/login requests
│   ├── users.controller.js   # Handle user profile/orders requests
│   ├── restaurants.controller.js
│   ├── menus.controller.js
│   ├── orders.controller.js
│   ├── admin.controller.js
│   └── payments.controller.js
│
├── services/                  # Business logic layer
│   ├── auth.service.js       # Authentication logic
│   ├── users.service.js      # User operations logic
│   ├── restaurants.service.js
│   ├── menus.service.js
│   ├── orders.service.js
│   ├── admin.service.js
│   └── payments.service.js
│
├── routes/                    # API endpoint definitions
│   ├── auth.routes.js        # POST /auth/register, /auth/login
│   ├── users.routes.js       # GET /users/profile, /users/orders
│   ├── restaurants.routes.js # Restaurant endpoints
│   ├── menus.routes.js       # Menu CRUD endpoints
│   ├── orders.routes.js      # Order management endpoints
│   ├── admin.routes.js       # Admin dashboard endpoints
│   └── payments.routes.js    # Payment endpoints (stub)
│
└── utils/                     # Helper utilities
    ├── response.js           # Standard success/error responses
    └── logger.js             # Simple logging functions
```

---

## 🎯 How It Works (Request Flow)

```
1. Client Request
   ↓
2. Route (routes/*.routes.js)
   ↓
3. Middleware (auth, role checks)
   ↓
4. Controller (controllers/*.controller.js)
   ↓
5. Service (services/*.service.js)
   ↓
6. Database Model (models/*.js)
   ↓
7. Response back to Client
```

### Example: User Login Flow

```
POST /auth/login
  ↓
auth.routes.js → forwards to auth.controller.login()
  ↓
auth.controller.js → calls authService.loginUser()
  ↓
auth.service.js → queries User model, validates password, creates JWT
  ↓
User.js (model) → finds user in MongoDB
  ↓
Returns: { success: true, data: { token, user } }
```

---

## 🔑 Key Features

### 1. Separation of Concerns
- **Routes**: Define API endpoints
- **Controllers**: Handle HTTP requests/responses
- **Services**: Contain business logic
- **Models**: Define data structure

### 2. Easy to Navigate
- All controllers in one folder
- All services in one folder
- All routes in one folder
- No more digging through nested modules!

### 3. Simple to Extend
Want to add a new feature? Just create:
1. A model (if needed)
2. A service file
3. A controller file
4. A routes file
5. Register route in app.js

---

## 🚀 Current Status

✅ Server running on port 5001
✅ MongoDB connected
✅ All 7 modules working:
   - auth (register, login)
   - users (profile, orders)
   - restaurants (dashboard, management)
   - menus (CRUD operations)
   - orders (place, cancel, update status)
   - admin (reports, analytics)
   - payments (stub)

---

## 📝 File Naming Convention

- **Models**: Singular PascalCase (User.js, Order.js)
- **Controllers**: feature.controller.js
- **Services**: feature.service.js
- **Routes**: feature.routes.js
- **Middlewares**: purpose.middleware.js

---

## 💡 Benefits of This Structure

1. **Beginner-Friendly**: Easy to understand where everything is
2. **Scalable**: Can add more features without mess
3. **Maintainable**: Each file has one clear responsibility
4. **Professional**: Industry-standard organization
5. **Team-Ready**: Multiple developers can work without conflicts

---

## 📚 Next Steps

1. Test all API endpoints
2. Add input validation (Zod schemas)
3. Add more admin reports
4. Integrate real payment gateway
5. Add file uploads (menu images)
6. Add search and filters
7. Add pagination

---

## 🎓 Learning Points

This structure teaches:
- MVC pattern (Model-View-Controller)
- Layered architecture
- Separation of concerns
- Clean code organization
- Professional Node.js practices

Perfect for showing to friends, professors, or in interviews!

---

**Built with:** Node.js, Express, MongoDB, JWT, bcrypt
**Authors:** Ashlin, Roshni, Prabodh, Jeevan
