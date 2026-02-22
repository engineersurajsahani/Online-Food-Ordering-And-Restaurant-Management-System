# 🚀 Quick Reference Guide

## Common Commands

### Start Everything
```bash
./start.sh
```

### Backend Only
```bash
cd backend
npm start
```

### Frontend Only
```bash
cd frontend
flutter run -d chrome
```

---

## API Endpoints Quick Reference

### Authentication (Public)
```
POST   /api/auth/register          # Create account
POST   /api/auth/login             # Get JWT token
```

### Users (Authenticated)
```
GET    /api/users/profile          # Get user info
GET    /api/users/stats            # User statistics (USER role)
```

### Restaurants
```
GET    /api/restaurants                    # List all (public)
GET    /api/restaurants/my-restaurant      # Owner's restaurant (RESTAURANT)
POST   /api/restaurants                    # Create restaurant (RESTAURANT)
PATCH  /api/restaurants/toggle-status      # Open/Close (RESTAURANT)
```

### Menu Items
```
GET    /api/menus/restaurant/:id   # Get restaurant menu
POST   /api/menus                  # Add menu item (RESTAURANT)
PUT    /api/menus/:id              # Update menu item (RESTAURANT)
DELETE /api/menus/:id              # Delete menu item (RESTAURANT)
```

### Orders
```
POST   /api/orders                        # Place order (USER)
GET    /api/orders/my-orders              # User's orders (USER)
GET    /api/orders/restaurant-orders      # Restaurant orders (RESTAURANT)
PATCH  /api/orders/:id/status             # Update status (RESTAURANT/ADMIN)
```

### Admin (ADMIN role only)
```
GET    /api/admin/restaurants             # All restaurants
GET    /api/admin/users                   # All users
GET    /api/admin/orders                  # All orders
GET    /api/admin/stats                   # Platform statistics
POST   /api/admin/restaurants/:id/approve # Approve restaurant
POST   /api/admin/restaurants/:id/reject  # Reject restaurant
```

---

## Order Status Flow

```
PLACED → CONFIRMED → PREPARING → READY → DELIVERED
   ↓         ↓           ↓          ↓
CANCELLED ← ← ← ← ← ← ← ← ← ← ← ← ← ←
```

---

## User Roles

| Role | Can Do |
|------|--------|
| **USER** | Browse, order, track orders |
| **RESTAURANT** | Manage restaurant, menu, orders |
| **ADMIN** | Approve restaurants, view all data |

---

## File Locations

### Frontend
```
lib/
  main.dart              # Start here
  services/api_service.dart   # API calls
  models/                # Data structures
  screens/               # All UI
  widgets/               # Reusable components
```

### Backend
```
src/
  server.js              # Entry point
  app.js                 # Express setup
  routes/                # API endpoints
  controllers/           # Request handlers
  services/              # Business logic
  models/                # Database schemas
  middlewares/           # Auth & roles
```

---

## Environment Variables

### Backend (.env)
```env
PORT=5001
MONGODB_URI=mongodb+srv://...
JWT_SECRET=your-secret-key
JWT_EXPIRES_IN=7d
```

### Frontend
Configured in `lib/services/api_service.dart`:
```dart
// Production
static const String baseUrl = 'https://food-fc4q.onrender.com/api';

// For local development, use:
// static const String baseUrl = 'http://localhost:5001/api';
```

---

## Testing with cURL

### Register
```bash
curl -X POST https://food-fc4q.onrender.com/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "password": "password123",
    "role": "USER"
  }'
```

### Login
```bash
curl -X POST https://food-fc4q.onrender.com/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "password123"
  }'
```

### Use Protected Endpoint
```bash
curl https://food-fc4q.onrender.com/api/users/profile \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

---

## Common Issues

### Backend won't start (local development)
- Check MongoDB connection string
- Verify .env file exists
- Ensure port 5001 is free

### Frontend can't connect
- Verify backend is running
- Check API URL in api_service.dart
- Ensure CORS is enabled in backend

### Order fails
- Restaurant must be APPROVED
- Restaurant must be OPEN
- Menu items must be AVAILABLE

---

## Documentation Links

📘 **Frontend Details**: [frontend/ARCHITECTURE.md](frontend/ARCHITECTURE.md)  
📗 **Backend Details**: [backend/ARCHITECTURE.md](backend/ARCHITECTURE.md)  
📖 **Main README**: [README.md](README.md)

---

## Backend URLs

- **Production**: `https://food-fc4q.onrender.com`
- **Local Development**: `http://localhost:5001`
- **Frontend (dev)**: Varies (check terminal)
- **MongoDB**: Atlas cloud

---

## Default Test Accounts

Create via registration or use:

```javascript
// Admin (create manually in MongoDB)
{
  email: "admin@foodapp.com",
  role: "ADMIN"
}

// Restaurant (register normally)
{
  email: "restaurant@test.com",
  role: "RESTAURANT"
}

// User (register normally)
{
  email: "user@test.com",
  role: "USER"
}
```
