// User Service - handles business logic for user operations
// Things like getting profile, viewing order history

import User from "../models/User.js";
import Order from "../models/Order.js";

// Get user profile by ID
export const getUserProfile = async (userId) => {
  // Find user in database
  const user = await User.findById(userId).select("-passwordHash");
  
  if (!user) {
    throw new Error("User not found");
  }

  return user;
};

// Get all orders for a user
export const getUserOrders = async (userId) => {
  // Find all orders for this user
  // Also get restaurant details for each order
  const orders = await Order.find({ userId })
    .populate("restaurantId", "name address")
    .sort({ createdAt: -1 });  // Newest first

  return orders;
};
