// Restaurant Service - business logic for restaurant operations

import Restaurant from "../models/Restaurant.js";
import Order from "../models/Order.js";
import { ORDER_STATUS } from "../models/Order.js";

// Get all restaurants (for customers to browse)
export const getAllRestaurants = async (includeUnapproved = false) => {
  let query = {};
  
  // Regular users only see approved and active restaurants
  if (!includeUnapproved) {
    query = { 
      isActive: true,
      approvalStatus: "APPROVED" 
    };
  }
  // Admin sees ALL restaurants regardless of status
  
  const restaurants = await Restaurant.find(query)
    .populate("ownerId", "name email")
    .sort({ createdAt: -1 });
  return restaurants;
};

// Create a new restaurant (when RESTAURANT user registers)
export const createRestaurant = async (ownerId, name, description, address, preparationTime) => {
  // Check if this owner already has a restaurant
  const existingRestaurant = await Restaurant.findOne({ ownerId });
  if (existingRestaurant) {
    throw new Error("You already have a restaurant");
  }

  // Create new restaurant with pending approval
  const restaurant = await Restaurant.create({
    ownerId,
    name,
    description,
    address,
    preparationTime: preparationTime || 30,
    approvalStatus: "PENDING",
    isOpen: false // Closed until approved
  });

  return restaurant;
};

// Get restaurant owned by this user
export const getMyRestaurant = async (ownerId) => {
  const restaurant = await Restaurant.findOne({ ownerId });
  
  // Return null if no restaurant found (not an error - user hasn't created one yet)
  return restaurant;
};

// Get all orders for my restaurant
export const getRestaurantOrders = async (restaurantId) => {
  // Get all orders for this restaurant
  const orders = await Order.find({ restaurantId })
    .populate("userId", "name phone email")
    .sort({ createdAt: -1 });  // Newest first

  return orders;
};

// Update restaurant details
export const updateRestaurant = async (ownerId, updates) => {
  const restaurant = await Restaurant.findOne({ ownerId });
  
  if (!restaurant) {
    throw new Error("Restaurant not found");
  }

  // Update allowed fields
  if (updates.name) restaurant.name = updates.name;
  if (updates.description !== undefined) restaurant.description = updates.description;
  if (updates.address) restaurant.address = updates.address;
  if (updates.preparationTime) restaurant.preparationTime = updates.preparationTime;

  await restaurant.save();
  return restaurant;
};

// Update restaurant open/close status
export const toggleRestaurantStatus = async (ownerId, isOpen) => {
  const restaurant = await Restaurant.findOne({ ownerId });
  
  if (!restaurant) {
    throw new Error("Restaurant not found");
  }

  // Check if restaurant is approved
  if (restaurant.approvalStatus !== "APPROVED") {
    throw new Error("Restaurant must be approved by admin before you can open/close it");
  }

  restaurant.isOpen = isOpen;
  await restaurant.save();

  return restaurant;
};

// Get restaurant dashboard stats
export const getRestaurantDashboard = async (restaurantId) => {
  // Count total orders
  const totalOrders = await Order.countDocuments({ restaurantId });

  // Count pending orders (PLACED status)
  const pendingOrders = await Order.countDocuments({ 
    restaurantId, 
    status: ORDER_STATUS.PLACED 
  });

  // Count today's orders
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  
  const todayOrders = await Order.countDocuments({
    restaurantId,
    createdAt: { $gte: today }
  });

  // Calculate total revenue (only READY orders)
  const revenueData = await Order.aggregate([
    {
      $match: { 
        restaurantId, 
        status: ORDER_STATUS.READY 
      }
    },
    {
      $group: {
        _id: null,
        totalRevenue: { $sum: "$totalAmount" }
      }
    }
  ]);

  const totalRevenue = revenueData.length > 0 ? revenueData[0].totalRevenue : 0;

  return {
    totalOrders,
    pendingOrders,
    todayOrders,
    totalRevenue
  };
};

// Admin: Approve restaurant
export const approveRestaurant = async (restaurantId, adminId, notes) => {
  const restaurant = await Restaurant.findById(restaurantId);
  
  if (!restaurant) {
    throw new Error("Restaurant not found");
  }

  restaurant.approvalStatus = "APPROVED";
  restaurant.adminNotes = notes || "Approved";
  restaurant.isActive = true;
  restaurant.isOpen = true; // Open restaurant once approved
  restaurant.approvedBy = adminId;
  restaurant.approvedAt = new Date();

  await restaurant.save();

  return restaurant;
};

// Admin: Reject restaurant
export const rejectRestaurant = async (restaurantId, adminId, reason) => {
  const restaurant = await Restaurant.findById(restaurantId);
  
  if (!restaurant) {
    throw new Error("Restaurant not found");
  }

  // Only reject the restaurant, NOT the user account
  // User can still login and create a new restaurant if needed
  restaurant.approvalStatus = "REJECTED";
  restaurant.adminNotes = reason;
  restaurant.isActive = false;
  restaurant.isOpen = false; // Close the restaurant
  restaurant.rejectedBy = adminId;
  restaurant.rejectedAt = new Date();

  await restaurant.save();

  // User account remains active, only restaurant is rejected
  return restaurant;
};

// Admin: Deactivate restaurant (different from rejection)
export const deactivateRestaurant = async (restaurantId, reason) => {
  const restaurant = await Restaurant.findById(restaurantId);
  
  if (!restaurant) {
    throw new Error("Restaurant not found");
  }

  restaurant.isActive = false;
  restaurant.isOpen = false;
  restaurant.adminNotes = reason;

  await restaurant.save();

  return restaurant;
};

// Admin: Reactivate restaurant
export const reactivateRestaurant = async (restaurantId) => {
  const restaurant = await Restaurant.findById(restaurantId);
  
  if (!restaurant) {
    throw new Error("Restaurant not found");
  }

  // Only reactivate if it was previously approved
  if (restaurant.approvalStatus !== "APPROVED") {
    throw new Error("Restaurant must be approved first");
  }

  restaurant.isActive = true;
  restaurant.isOpen = true;

  await restaurant.save();

  return restaurant;
};
