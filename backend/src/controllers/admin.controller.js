// Admin Controller - handles admin HTTP requests

import * as adminService from "../services/admin.service.js";
import { sendSuccess } from "../utils/response.js";

// Get all users
export const getAllUsers = async (req, res, next) => {
  try {
    const users = await adminService.getAllUsers();
    sendSuccess(res, users, "Users fetched successfully");
  } catch (error) {
    next(error);
  }
};

// Get all restaurants
export const getAllRestaurants = async (req, res, next) => {
  try {
    const restaurants = await adminService.getAllRestaurants();
    sendSuccess(res, restaurants, "Restaurants fetched successfully");
  } catch (error) {
    next(error);
  }
};

// Get all orders
export const getAllOrders = async (req, res, next) => {
  try {
    const orders = await adminService.getAllOrders();
    sendSuccess(res, orders, "Orders fetched successfully");
  } catch (error) {
    next(error);
  }
};

// Get system reports
export const getReports = async (req, res, next) => {
  try {
    const reports = await adminService.getSystemReports();
    sendSuccess(res, reports, "Reports generated successfully");
  } catch (error) {
    next(error);
  }
};

// Get daily revenue
export const getDailyRevenue = async (req, res, next) => {
  try {
    const dailyRevenue = await adminService.getDailyRevenue();
    sendSuccess(res, dailyRevenue, "Daily revenue fetched successfully");
  } catch (error) {
    next(error);
  }
};
