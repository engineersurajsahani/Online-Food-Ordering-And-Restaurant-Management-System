# Role-Based Access Control & Approval Workflow

## Complete Feature Implementation

### 🔐 Three User Roles

#### 1. **USER (Customer)**
**Capabilities:**
- ✅ Browse only APPROVED restaurants
- ✅ View menu items from approved restaurants
- ✅ Place orders
- ✅ Track order status
- ✅ View order history

**Restrictions:**
- ❌ Cannot see pending/rejected restaurants
- ❌ Cannot create restaurants
- ❌ No admin functions

---

#### 2. **RESTAURANT (Owner)**
**Capabilities:**
- ✅ Create restaurant (auto-set to PENDING approval)
- ✅ **Edit restaurant details** (name, description, address)
- ✅ Add/edit menu items
- ✅ Toggle menu item availability
- ✅ View incoming orders
- ✅ Update order status (Confirmed → Preparing → Ready → Delivered)
- ✅ View approval status banner
- ✅ Restaurant auto-closed until admin approval

**Workflow:**
1. Restaurant owner registers
2. Creates restaurant → **Status: PENDING**
3. Waits for admin approval
4. Once approved → **Status: APPROVED**, restaurant opens
5. Can now receive orders from customers
6. Can edit restaurant details anytime

**Restrictions:**
- ❌ Cannot approve own restaurant
- ❌ Cannot bypass approval process
- ❌ If rejected, cannot reopen without admin action

---

#### 3. **ADMIN**
**Full System Control:**
- ✅ View ALL restaurants (PENDING, APPROVED, REJECTED, inactive)
- ✅ **Approve restaurants** → Sets status to APPROVED, auto-opens restaurant
- ✅ **Reject restaurants** → Requires reason, closes restaurant
- ✅ **Deactivate any restaurant** → Removes from user visibility
- ✅ **Reactivate restaurants** → Restores restaurant
- ✅ View statistics (total, pending, approved)
- ✅ Filter restaurants by status
- ✅ Add approval notes

**Admin Dashboard Features:**
- **Stats Cards**: Total, Pending, Approved counts
- **Filter Chips**: ALL | PENDING | APPROVED | REJECTED
- **Restaurant Cards** showing:
  - Name, address, description
  - Approval status badge
  - Action buttons based on status

**Admin Actions:**
- For **PENDING** restaurants:
  - ✅ Approve (with optional notes)
  - ✅ Reject (requires reason)
  
- For **ALL** restaurants:
  - ✅ Deactivate (with optional reason)
  - ✅ Reactivate (if deactivated)

---

## 🔄 Complete Approval Workflow

### Restaurant Creation Flow
```
1. RESTAURANT user creates restaurant
   ↓
2. Backend sets:
   - approvalStatus: "PENDING"
   - isOpen: false
   - isActive: true
   ↓
3. Restaurant shows PENDING banner to owner
   ↓
4. Admin sees restaurant in dashboard
   ↓
5. Admin decides:
   
   Option A: APPROVE
   - approvalStatus → "APPROVED"
   - isOpen → true
   - approvedBy → adminId
   - approvedAt → current date
   - Visible to customers ✅
   
   Option B: REJECT
   - approvalStatus → "REJECTED"
   - isOpen → false
   - adminNotes → rejection reason
   - NOT visible to customers ❌
   
   Option C: DEACTIVATE
   - isActive → false
   - isOpen → false
   - NOT visible to customers ❌
```

---

## 📋 Database Schema Updates

### Restaurant Model Fields
```javascript
{
  ownerId: ObjectId,
  name: String,
  description: String,
  address: String,
  isOpen: Boolean,
  preparationTime: Number,
  
  // NEW APPROVAL FIELDS
  approvalStatus: "PENDING" | "APPROVED" | "REJECTED",
  isActive: Boolean,
  adminNotes: String,
  approvedBy: ObjectId (ref: User),
  approvedAt: Date,
  
  createdAt: Date,
  updatedAt: Date
}
```

---

## 🌐 API Endpoints

### Public Endpoints
- `GET /api/restaurants` - Get approved restaurants only (for customers)

### Restaurant Owner Endpoints
- `POST /api/restaurants` - Create restaurant (auto-PENDING)
- `GET /api/restaurants/my-restaurant` - Get own restaurant
- `PATCH /api/restaurants/my-restaurant` - **Edit restaurant details**
- `PATCH /api/restaurants/toggle-status` - Toggle open/closed
- `GET /api/menus` - Get own menu
- `POST /api/menus` - Add menu item
- `GET /api/orders/restaurant-orders` - Get orders

### Admin Endpoints
- `GET /api/restaurants/admin/all` - Get ALL restaurants (no filter)
- `PATCH /api/restaurants/admin/:id/approve` - Approve restaurant
- `PATCH /api/restaurants/admin/:id/reject` - Reject restaurant
- `PATCH /api/restaurants/admin/:id/deactivate` - Deactivate restaurant
- `PATCH /api/restaurants/admin/:id/reactivate` - Reactivate restaurant

---

## 🎨 Frontend Components

### Restaurant Owner Dashboard
```dart
// Shows approval status banner
if (approvalStatus == "PENDING")
  → Orange banner: "Pending Admin Approval"
  
if (approvalStatus == "REJECTED")
  → Red banner: "Restaurant Rejected"
  
// Edit button on restaurant card
→ Opens dialog to edit name, description, address
→ Calls PATCH /api/restaurants/my-restaurant
```

### Admin Dashboard
```dart
// Stats cards showing counts
Total | Pending | Approved

// Filter chips
ALL | PENDING | APPROVED | REJECTED

// Restaurant cards with action buttons
For PENDING:
  - [Approve] button (green)
  - [Reject] button (red) - requires reason dialog
  
For ALL:
  - [Deactivate] button (red) - optional reason dialog
  - [Reactivate] button (green) - if deactivated
```

---

## 🔒 Security & Validation

### Role-Based Middleware
```javascript
// Applied to all routes
verifyToken() → Checks JWT
allowRoles(ROLES.ADMIN) → Checks user role

// Example
router.patch(
  "/admin/:id/approve",
  verifyToken,           // Must be logged in
  allowRoles(ROLES.ADMIN), // Must be admin
  approveRestaurant
);
```

### Business Logic Validation
- ✅ Restaurant owner can only edit their own restaurant
- ✅ Admin can approve/reject/deactivate any restaurant
- ✅ Customers only see approved & active restaurants
- ✅ Rejected restaurants cannot be reopened by owner
- ✅ Deactivated restaurants hidden from all users

---

## 📱 User Experience Flows

### Customer Flow
1. Login as USER
2. Browse restaurants → sees only APPROVED
3. Select restaurant → view menu
4. Add items to cart → place order
5. Track order status

### Restaurant Owner Flow
1. Login/Register as RESTAURANT
2. Create restaurant
3. See PENDING banner → wait for approval
4. Once approved → add menu items
5. Edit restaurant details anytime via edit button
6. Manage incoming orders
7. Update order statuses

### Admin Flow
1. Login as ADMIN
2. See dashboard with stats
3. Filter by status (ALL/PENDING/APPROVED/REJECTED)
4. For pending restaurants:
   - Review details
   - Approve → restaurant goes live
   - Reject → provide reason
5. For any restaurant:
   - Deactivate → removes from platform
   - Reactivate → restores restaurant

---

## ✨ Key Features Implemented

### Restaurant Management
- ✅ **Editable restaurant details** - name, description, address
- ✅ **Approval workflow** - PENDING → APPROVED/REJECTED
- ✅ **Admin control** - approve, reject, deactivate, reactivate
- ✅ **Status indicators** - colored badges and banners
- ✅ **Auto-close on creation** - opens only after approval

### Admin Dashboard
- ✅ **Statistics** - total, pending, approved counts
- ✅ **Filters** - view by status
- ✅ **Batch management** - handle multiple restaurants
- ✅ **Reason tracking** - admin notes for rejections
- ✅ **Audit trail** - approvedBy, approvedAt fields

### Security
- ✅ **Role-based access** - different permissions per role
- ✅ **JWT authentication** - secure token-based auth
- ✅ **Middleware protection** - route-level security
- ✅ **Business logic validation** - server-side checks

---

## 🚀 Testing the System

### Test as Restaurant Owner
```bash
1. Register as RESTAURANT role
2. Create restaurant → Check PENDING banner appears
3. Try to edit details → Should work
4. Check that restaurant is closed (isOpen: false)
```

### Test as Admin
```bash
1. Register/Login as ADMIN
2. Go to admin dashboard
3. See the pending restaurant
4. Click Approve → Restaurant becomes APPROVED
5. Verify restaurant now shows in customer view
6. Test Deactivate → Restaurant disappears
7. Test Reactivate → Restaurant reappears
```

### Test as Customer
```bash
1. Register/Login as USER
2. Browse restaurants → Should only see APPROVED
3. Try to access pending/rejected → Should not appear
```

---

## 📊 Database Queries

### For Customers
```javascript
// Only approved & active restaurants
Restaurant.find({ 
  approvalStatus: "APPROVED",
  isActive: true 
})
```

### For Admin
```javascript
// All restaurants
Restaurant.find({ isActive: true })

// Or include inactive
Restaurant.find({}) // All including deactivated
```

### For Restaurant Owner
```javascript
// Own restaurant only
Restaurant.findOne({ ownerId: userId })
```

---

## 🎯 Complete System Features

✅ **3 distinct user roles** with different capabilities  
✅ **Approval workflow** with PENDING → APPROVED/REJECTED states  
✅ **Editable restaurant details** for owners  
✅ **Admin approval controls** with reasons and notes  
✅ **Restaurant deactivation** by admin  
✅ **Status indicators** in UI (banners, badges)  
✅ **Role-based API endpoints** with proper security  
✅ **Complete admin dashboard** with stats and filters  
✅ **Audit trail** (approvedBy, approvedAt, adminNotes)  
✅ **Auto-close on creation** until approval  

**The system is now production-ready with full role-based access control!** 🎉
