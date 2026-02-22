# API Testing Examples

**Base URLs:**
- **Production**: `https://food-fc4q.onrender.com`
- **Local Dev**: `http://localhost:5001`

Examples below use production URL. For local dev, replace with `http://localhost:5001`.

---

## Test 1: Health Check
```bash
curl https://food-fc4q.onrender.com/api/health
```

## Test 2: Register a new USER
```bash
curl -X POST https://food-fc4q.onrender.com/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "phone": "1234567890",
    "password": "password123",
    "role": "USER"
  }'
```

## Test 3: Login as USER
```bash
curl -X POST https://food-fc4q.onrender.com/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "password123"
  }'
```

## Test 4: Register a RESTAURANT owner
```bash
curl -X POST https://food-fc4q.onrender.com/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Pizza Palace",
    "email": "pizza@example.com",
    "phone": "9876543210",
    "password": "password123",
    "role": "RESTAURANT"
  }'
```

## Test 5: Login as RESTAURANT and save token
```bash
curl -X POST https://food-fc4q.onrender.com/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "pizza@example.com",
    "password": "password123"
  }'
```

## Test 6: Create a restaurant (use token from Test 5)
```bash
curl -X POST https://food-fc4q.onrender.com/api/restaurants \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -d '{
    "name": "Pizza Palace",
    "description": "Best pizza in town",
    "address": "123 Main St",
    "preparationTime": 30
  }'
```

## Test 7: Add menu items
```bash
curl -X POST https://food-fc4q.onrender.com/api/menus \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_RESTAURANT_TOKEN" \
  -d '{
    "name": "Margherita Pizza",
    "description": "Classic tomato and cheese",
    "price": 299,
    "isVeg": true,
    "category": "Pizza"
  }'
```

## Test 8: Get restaurant menu (public - no auth needed)
```bash
curl https://food-fc4q.onrender.com/api/menus/restaurant/RESTAURANT_ID
```

## Test 9: Place an order (as USER)
```bash
curl -X POST https://food-fc4q.onrender.com/api/orders \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_USER_TOKEN" \
  -d '{
    "restaurantId": "RESTAURANT_ID",
    "items": [
      {
        "menuItemId": "MENU_ITEM_ID",
        "quantity": 2
      }
    ]
  }'
```

## Test 10: Get user's order history
```bash
curl https://food-fc4q.onrender.com/api/users/orders \
  -H "Authorization: Bearer YOUR_USER_TOKEN"
```

## Test 11: Get restaurant orders (RESTAURANT)
```bash
curl https://food-fc4q.onrender.com/api/restaurants/orders \
  -H "Authorization: Bearer YOUR_RESTAURANT_TOKEN"
```

## Test 12: Update order status (RESTAURANT)
```bash
curl -X PATCH https://food-fc4q.onrender.com/api/orders/ORDER_ID/status \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_RESTAURANT_TOKEN" \
  -d '{
    "status": "ACCEPTED"
  }'
```

## Test 13: Register ADMIN
```bash
curl -X POST https://food-fc4q.onrender.com/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Admin User",
    "email": "admin@example.com",
    "phone": "5555555555",
    "password": "admin123",
    "role": "ADMIN"
  }'
```

## Test 14: Get admin reports
```bash
curl https://food-fc4q.onrender.com/api/admin/reports \
  -H "Authorization: Bearer YOUR_ADMIN_TOKEN"
```

## Notes:
- Replace YOUR_TOKEN_HERE, RESTAURANT_ID, MENU_ITEM_ID, ORDER_ID with actual values
- Tokens are returned in the login response
- IDs are returned when you create resources
