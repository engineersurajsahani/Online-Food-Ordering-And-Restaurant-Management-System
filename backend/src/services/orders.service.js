// Order Service - business logic for order management
// This is the heart of our food ordering system!

import Order from "../models/Order.js";
import MenuItem from "../models/MenuItem.js";
import Restaurant from "../models/Restaurant.js";
import { ORDER_STATUS, PAYMENT_STATUS } from "../models/Order.js";

// Place a new order
export const placeOrder = async (userId, restaurantId, items) => {
  // Check if restaurant exists and is open
  const restaurant = await Restaurant.findById(restaurantId);
  
  if (!restaurant) {
    throw new Error("Restaurant not found");
  }

  if (!restaurant.isOpen) {
    throw new Error("Restaurant is currently closed");
  }

  // Validate and calculate total
  let totalAmount = 0;
  const orderItems = [];

  for (const item of items) {
    // Get menu item from database
    const menuItem = await MenuItem.findById(item.menuItemId);

    if (!menuItem) {
      throw new Error(`Menu item ${item.menuItemId} not found`);
    }

    if (!menuItem.isAvailable) {
      throw new Error(`${menuItem.name} is not available right now`);
    }

    if (menuItem.restaurantId.toString() !== restaurantId) {
      throw new Error(`Item ${menuItem.name} doesn't belong to this restaurant`);
    }

    // Add to order with snapshot (price can't change later)
    orderItems.push({
      menuItemId: menuItem._id,
      nameSnapshot: menuItem.name,
      priceSnapshot: menuItem.price,
      quantity: item.quantity
    });

    // Calculate total
    totalAmount += menuItem.price * item.quantity;
  }

  // Create the order
  const order = await Order.create({
    userId,
    restaurantId,
    items: orderItems,
    totalAmount,
    status: ORDER_STATUS.PLACED,
    paymentStatus: PAYMENT_STATUS.PENDING
  });

  return order;
};

// Cancel order (user can only cancel if not yet accepted)
export const cancelOrder = async (userId, orderId) => {
  const order = await Order.findById(orderId);

  if (!order) {
    throw new Error("Order not found");
  }

  // Check if this order belongs to the user
  if (order.userId.toString() !== userId) {
    throw new Error("You can't cancel someone else's order");
  }

  // Check if order can be cancelled
  if (order.status !== ORDER_STATUS.PLACED) {
    throw new Error("Order can only be cancelled when it's in PLACED status");
  }

  // Cancel the order
  order.status = ORDER_STATUS.CANCELLED;
  await order.save();

  return order;
};

// Update order status (restaurant only)
export const updateOrderStatus = async (restaurantId, orderId, newStatus) => {
  const order = await Order.findById(orderId);

  if (!order) {
    throw new Error("Order not found");
  }

  // Check if order belongs to this restaurant
  // Convert both to strings for comparison
  if (order.restaurantId.toString() !== restaurantId.toString()) {
    throw new Error("This order doesn't belong to your restaurant");
  }

  // Update status
  order.status = newStatus;
  
  // Auto-complete payment for COD when delivered
  if (newStatus === ORDER_STATUS.DELIVERED) {
    order.paymentStatus = PAYMENT_STATUS.PAID;
  }
  
  await order.save();

  return order;
};

// Get all orders for a user
export const getUserOrders = async (userId) => {
  const orders = await Order.find({ userId })
    .populate("restaurantId", "name address")
    .sort({ createdAt: -1 });

  return orders;
};

// Get all orders for a restaurant
export const getRestaurantOrders = async (restaurantId) => {
  const orders = await Order.find({ restaurantId })
    .populate("userId", "name phone email")
    .sort({ createdAt: -1 });

  return orders;
};

// Get restaurant statistics (dashboard)
export const getRestaurantStats = async (restaurantId) => {
  const orders = await Order.find({ restaurantId });
  
  // Count orders by status
  const stats = {
    pending: 0,
    confirmed: 0,
    preparing: 0,
    ready: 0,
    delivered: 0,
    cancelled: 0,
    totalOrders: orders.length,
    totalRevenue: 0,
    platformFee: 0, // 20% commission
    restaurantEarnings: 0 // 80% after commission
  };
  
  orders.forEach(order => {
    // Count by status
    switch (order.status) {
      case ORDER_STATUS.PLACED:
        stats.pending++;
        break;
      case ORDER_STATUS.CONFIRMED:
        stats.confirmed++;
        break;
      case ORDER_STATUS.PREPARING:
        stats.preparing++;
        break;
      case ORDER_STATUS.READY:
        stats.ready++;
        break;
      case ORDER_STATUS.DELIVERED:
        stats.delivered++;
        break;
      case ORDER_STATUS.CANCELLED:
        stats.cancelled++;
        break;
    }
    
    // Calculate revenue (only from delivered orders)
    if (order.status === ORDER_STATUS.DELIVERED) {
      stats.totalRevenue += order.totalAmount;
    }
  });
  
  // Calculate platform fee (20%) and restaurant earnings (80%)
  stats.platformFee = stats.totalRevenue * 0.20;
  stats.restaurantEarnings = stats.totalRevenue * 0.80;
  
  return stats;
};

// Get user statistics (dashboard)
export const getUserStats = async (userId) => {
  const orders = await Order.find({ userId });
  
  const now = new Date();
  const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
  const startOfYear = new Date(now.getFullYear(), 0, 1);
  
  // Count orders by status
  const stats = {
    totalOrders: orders.length,
    pending: 0,
    confirmed: 0,
    preparing: 0,
    ready: 0,
    delivered: 0,
    cancelled: 0,
    totalSpent: 0,
    thisMonthSpent: 0,
    thisYearSpent: 0,
    avgOrderValue: 0
  };
  
  orders.forEach(order => {
    // Count by status
    switch (order.status) {
      case ORDER_STATUS.PLACED:
        stats.pending++;
        break;
      case ORDER_STATUS.CONFIRMED:
        stats.confirmed++;
        break;
      case ORDER_STATUS.PREPARING:
        stats.preparing++;
        break;
      case ORDER_STATUS.READY:
        stats.ready++;
        break;
      case ORDER_STATUS.DELIVERED:
        stats.delivered++;
        break;
      case ORDER_STATUS.CANCELLED:
        stats.cancelled++;
        break;
    }
    
    // Calculate spending (only from delivered orders)
    if (order.status === ORDER_STATUS.DELIVERED) {
      stats.totalSpent += order.totalAmount;
      
      // This month
      if (order.createdAt >= startOfMonth) {
        stats.thisMonthSpent += order.totalAmount;
      }
      
      // This year
      if (order.createdAt >= startOfYear) {
        stats.thisYearSpent += order.totalAmount;
      }
    }
  });
  
  // Calculate average order value
  stats.avgOrderValue = stats.delivered > 0 ? stats.totalSpent / stats.delivered : 0;
  
  return stats;
};
