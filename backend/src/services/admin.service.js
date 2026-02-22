// Admin Service - business logic for admin operations
// Admin can see everything and generate reports

import User from "../models/User.js";
import Restaurant from "../models/Restaurant.js";
import Order from "../models/Order.js";
import { ORDER_STATUS } from "../models/Order.js";

// Get all users
export const getAllUsers = async () => {
  const users = await User.find().select("-passwordHash");
  return users;
};

// Get all restaurants
export const getAllRestaurants = async () => {
  const restaurants = await Restaurant.find()
    .populate("ownerId", "name email phone");
  return restaurants;
};

// Get all orders
export const getAllOrders = async () => {
  const orders = await Order.find()
    .populate("userId", "name email phone")
    .populate("restaurantId", "name address")
    .sort({ createdAt: -1 });
  
  return orders;
};

// Get system reports
export const getSystemReports = async () => {
  // Total counts
  const totalUsers = await User.countDocuments({ role: "USER" });
  const totalRestaurants = await Restaurant.countDocuments();
  const totalOrders = await Order.countDocuments();

  // Order status breakdown
  const ordersByStatus = await Order.aggregate([
    {
      $group: {
        _id: "$status",
        count: { $sum: 1 }
      }
    }
  ]);

  // Calculate total revenue (from DELIVERED orders only)
  const revenueData = await Order.aggregate([
    {
      $match: { status: ORDER_STATUS.DELIVERED }
    },
    {
      $group: {
        _id: null,
        totalRevenue: { $sum: "$totalAmount" }
      }
    }
  ]);

  const totalRevenue = revenueData.length > 0 ? revenueData[0].totalRevenue : 0;
  const platformRevenue = totalRevenue * 0.20; // 20% platform commission
  const restaurantRevenue = totalRevenue * 0.80; // 80% goes to restaurants

  // This month's revenue
  const now = new Date();
  const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
  const monthlyRevenueData = await Order.aggregate([
    {
      $match: {
        status: ORDER_STATUS.DELIVERED,
        createdAt: { $gte: startOfMonth }
      }
    },
    {
      $group: {
        _id: null,
        totalRevenue: { $sum: "$totalAmount" }
      }
    }
  ]);

  const monthlyRevenue = monthlyRevenueData.length > 0 ? monthlyRevenueData[0].totalRevenue : 0;
  const monthlyPlatformRevenue = monthlyRevenue * 0.20;

  // Top restaurants by order count
  const topRestaurants = await Order.aggregate([
    {
      $match: { status: ORDER_STATUS.DELIVERED }
    },
    {
      $group: {
        _id: "$restaurantId",
        orderCount: { $sum: 1 },
        totalRevenue: { $sum: "$totalAmount" }
      }
    },
    {
      $sort: { orderCount: -1 }
    },
    {
      $limit: 5
    },
    {
      $lookup: {
        from: "restaurants",
        localField: "_id",
        foreignField: "_id",
        as: "restaurant"
      }
    },
    {
      $unwind: "$restaurant"
    },
    {
      $project: {
        restaurantName: "$restaurant.name",
        orderCount: 1,
        totalRevenue: 1,
        platformCommission: { $multiply: ["$totalRevenue", 0.20] },
        restaurantEarnings: { $multiply: ["$totalRevenue", 0.80] }
      }
    }
  ]);

  // Recent orders (last 10)
  const recentOrders = await Order.find()
    .populate("userId", "name")
    .populate("restaurantId", "name")
    .sort({ createdAt: -1 })
    .limit(10);

  // Calculate average order value
  const deliveredOrders = await Order.countDocuments({ status: ORDER_STATUS.DELIVERED });
  const avgOrderValue = deliveredOrders > 0 ? totalRevenue / deliveredOrders : 0;

  return {
    totalUsers,
    totalRestaurants,
    totalOrders,
    totalRevenue,
    platformRevenue,
    restaurantRevenue,
    monthlyRevenue,
    monthlyPlatformRevenue,
    avgOrderValue,
    ordersByStatus,
    topRestaurants,
    recentOrders
  };
};

// Get daily revenue report
export const getDailyRevenue = async () => {
  const dailyRevenue = await Order.aggregate([
    {
      $match: { status: ORDER_STATUS.DELIVERED }
    },
    {
      $group: {
        _id: {
          year: { $year: "$createdAt" },
          month: { $month: "$createdAt" },
          day: { $dayOfMonth: "$createdAt" }
        },
        totalRevenue: { $sum: "$totalAmount" },
        orderCount: { $sum: 1 }
      }
    },
    {
      $sort: { "_id.year": -1, "_id.month": -1, "_id.day": -1 }
    },
    {
      $limit: 30  // Last 30 days
    },
    {
      $project: {
        _id: 1,
        totalRevenue: 1,
        orderCount: 1,
        platformRevenue: { $multiply: ["$totalRevenue", 0.20] },
        restaurantRevenue: { $multiply: ["$totalRevenue", 0.80] }
      }
    }
  ]);

  return dailyRevenue;
};
