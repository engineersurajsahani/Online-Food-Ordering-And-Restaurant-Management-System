# Quick Start Guide

## Prerequisites
- Node.js v22+ installed
- Flutter SDK installed
- MongoDB Atlas account (or local MongoDB)
- Chrome browser for Flutter web

---

## 1. Backend Setup

### Install Dependencies
```bash
cd backend
npm install
```

### Configure Environment
Create/edit `.env` file:
```env
PORT=5001
MONGODB_URI=mongodb+srv://jeevan04:your-password@cluster0.vlk2gka.mongodb.net/auth_app
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
```

### Start Backend Server
```bash
node src/server.js
```

Expected output:
```
🚀 Server is running on port 5001
✅ MongoDB Connected Successfully!
```

Backend will be available at: **http://localhost:5001**

---

## 2. Frontend Setup

### Install Dependencies
```bash
cd backend/frontend
flutter pub get
```

### Run Flutter Web App
```bash
flutter run -d chrome
```

Or for hot reload in VS Code:
1. Open frontend folder in VS Code
2. Press F5
3. Select "Chrome"

Frontend will open in Chrome automatically

---

## 3. Testing the Application

### Register a Customer
1. Click "Register" on login screen
2. Fill in:
   - Name: Test User
   - Email: user@test.com
   - Password: password123
   - Role: Customer
3. Click Register
4. Login with these credentials

### Register a Restaurant Owner
1. Register with:
   - Name: Restaurant Owner
   - Email: owner@test.com
   - Password: password123
   - Role: Restaurant Owner
2. Login
3. Create a restaurant:
   - Name: Test Restaurant
   - Description: Best food in town
   - Address: 123 Main St
4. Add menu items with images

### Test the Flow
1. **As Restaurant Owner**:
   - Add 3-4 menu items with different images
   - Example image URL: `https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=300`

2. **As Customer**:
   - Browse restaurants
   - View restaurant menu
   - Add items to cart
   - Place order
   - Check "My Orders"

3. **As Restaurant Owner**:
   - View incoming orders
   - Update order status: Confirmed → Preparing → Ready → Delivered

---

## 4. API Testing (Optional)

### Using cURL

#### Register
```bash
curl -X POST http://localhost:5001/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@test.com",
    "password": "password123",
    "role": "USER"
  }'
```

#### Login
```bash
curl -X POST http://localhost:5001/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@test.com",
    "password": "password123"
  }'
```

#### Get All Restaurants
```bash
curl -X GET http://localhost:5001/api/restaurants \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

---

## 5. Project Structure

```
FOOD/
└── backend/
    ├── src/                    # Backend source code
    │   ├── models/            # Database schemas
    │   ├── controllers/       # Request handlers
    │   ├── services/          # Business logic
    │   ├── routes/            # API routes
    │   ├── middlewares/       # Auth, roles, errors
    │   ├── config/            # DB & configs
    │   ├── utils/             # Helpers
    │   ├── app.js            # Express setup
    │   └── server.js         # Entry point
    ├── frontend/              # Flutter web app
    │   └── lib/
    │       ├── main.dart     # App entry
    │       ├── constants/    # App constants
    │       ├── models/       # Data models
    │       ├── services/     # API calls
    │       ├── utils/        # Helpers
    │       ├── widgets/      # Reusable UI
    │       └── screens/      # All screens
    │           ├── auth/
    │           ├── user/
    │           ├── restaurant/
    │           └── admin/
    ├── package.json
    ├── .env
    └── README.md
```

---

## 6. Troubleshooting

### Backend won't start
- **Port 5001 in use**: Change PORT in `.env`
- **MongoDB connection failed**: Check MONGODB_URI in `.env`
- **Module not found**: Run `npm install`

### Frontend won't run
- **Flutter not found**: Install Flutter SDK
- **Package errors**: Run `flutter pub get`
- **Chrome not found**: Run `flutter devices` to see available devices

### Cannot login
- **Check backend is running**: Visit http://localhost:5001/health
- **CORS errors**: Backend already has CORS enabled
- **Wrong credentials**: Make sure you registered first

---

## 7. Default Test Accounts

After registration, you can create test accounts:

**Customer**
- Email: customer@test.com
- Password: test123
- Role: USER

**Restaurant Owner**
- Email: owner@test.com
- Password: test123
- Role: RESTAURANT

**Admin**
- Email: admin@test.com
- Password: test123
- Role: ADMIN

---

## 8. Sample Menu Item Images

Use these free image URLs when adding menu items:

- Pizza: `https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=300`
- Burger: `https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300`
- Pasta: `https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=300`
- Salad: `https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=300`
- Coffee: `https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=300`

---

## 9. Features to Test

✅ **Authentication**
- Register new users
- Login with different roles
- Token persistence

✅ **Customer Flow**
- Browse restaurants (grid view)
- View menu with images
- Add to cart with quantity
- Place orders
- View order history
- See order status updates

✅ **Restaurant Flow**
- Create restaurant
- Add menu items (with image URLs)
- View incoming orders
- Update order status
- Toggle restaurant open/closed
- Toggle item availability

✅ **Admin Flow**
- View dashboard
- (More features can be added)

---

## 10. Next Steps

1. **Add More Menu Items**: Create a diverse menu with images
2. **Test Order Flow**: Complete an order from start to finish
3. **Try Different Roles**: Login as different user types
4. **Customize**: Change colors in `app_constants.dart`
5. **Extend**: Add new features like ratings, reviews, etc.

---

## Support

For issues or questions:
1. Check console logs in browser (F12)
2. Check backend terminal for errors
3. Verify MongoDB connection
4. Ensure both backend and frontend are running

---

**Happy Coding!** 🎉
