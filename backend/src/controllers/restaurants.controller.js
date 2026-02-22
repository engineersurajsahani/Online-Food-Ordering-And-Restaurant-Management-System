// Restaurant Controller - handles restaurant HTTP requests

import * as restaurantService from "../services/restaurants.service.js";
import { sendSuccess, sendError } from "../utils/response.js";
// Get all restaurants (for customers)
export const getAllRestaurants = async (req, res, next) => {
  try {
    const restaurants = await restaurantService.getAllRestaurants();
    sendSuccess(res, restaurants, "Restaurants fetched successfully");
  } catch (error) {
    next(error);
  }
};
// Create a restaurant
export const createRestaurant = async (req, res, next) => {
  try {
    const ownerId = req.user.userId;
    const { name, description, address, preparationTime } = req.body;

    // Validation
    if (!name || !address) {
      return sendError(res, "Name and address are required", 400);
    }

    // Create restaurant
    const restaurant = await restaurantService.createRestaurant(
      ownerId, 
      name, 
      description, 
      address, 
      preparationTime
    );

    sendSuccess(res, restaurant, "Restaurant created successfully");
  } catch (error) {
    next(error);
  }
};

// Get my restaurant details
export const getMyRestaurant = async (req, res, next) => {
  try {
    const ownerId = req.user.userId;

    const restaurant = await restaurantService.getMyRestaurant(ownerId);

    // Return null if no restaurant (user hasn't created one yet)
    sendSuccess(res, restaurant, restaurant ? "Restaurant fetched successfully" : "No restaurant found");
  } catch (error) {
    next(error);
  }
};

// Get orders for my restaurant
export const getOrders = async (req, res, next) => {
  try {
    // First get the restaurant
    const ownerId = req.user.userId;
    const restaurant = await restaurantService.getMyRestaurant(ownerId);

    // Then get orders
    const orders = await restaurantService.getRestaurantOrders(restaurant._id);

    sendSuccess(res, orders, "Orders fetched successfully");
  } catch (error) {
    next(error);
  }
};

// Update my restaurant
export const updateRestaurant = async (req, res, next) => {
  try {
    const ownerId = req.user.userId;
    const updates = req.body;

    const restaurant = await restaurantService.updateRestaurant(ownerId, updates);

    sendSuccess(res, restaurant, "Restaurant updated successfully");
  } catch (error) {
    next(error);
  }
};

// Toggle restaurant open/close
export const toggleStatus = async (req, res, next) => {
  try {
    const ownerId = req.user.userId;
    const { isOpen } = req.body;

    if (isOpen === undefined) {
      return sendError(res, "isOpen field is required", 400);
    }

    const restaurant = await restaurantService.toggleRestaurantStatus(ownerId, isOpen);

    sendSuccess(res, restaurant, "Restaurant status updated");
  } catch (error) {
    next(error);
  }
};

// Get restaurant dashboard
export const getDashboard = async (req, res, next) => {
  try {
    const ownerId = req.user.userId;
    const restaurant = await restaurantService.getMyRestaurant(ownerId);

    const dashboard = await restaurantService.getRestaurantDashboard(restaurant._id);

    sendSuccess(res, dashboard, "Dashboard data fetched successfully");
  } catch (error) {
    next(error);
  }
};

// Admin: Get all restaurants including pending
export const getAllRestaurantsAdmin = async (req, res, next) => {
  try {
    const restaurants = await restaurantService.getAllRestaurants(true);
    sendSuccess(res, restaurants, "All restaurants fetched");
  } catch (error) {
    next(error);
  }
};

// Admin: Approve restaurant
export const approveRestaurant = async (req, res, next) => {
  try {
    const { restaurantId } = req.params;
    const { notes } = req.body;
    const adminId = req.user.userId;

    const restaurant = await restaurantService.approveRestaurant(restaurantId, adminId, notes);

    sendSuccess(res, restaurant, "Restaurant approved successfully");
  } catch (error) {
    next(error);
  }
};

// Admin: Reject restaurant
export const rejectRestaurant = async (req, res, next) => {
  try {
    const { restaurantId } = req.params;
    const { reason } = req.body;
    const adminId = req.user.userId;

    if (!reason) {
      return sendError(res, "Rejection reason is required", 400);
    }

    const restaurant = await restaurantService.rejectRestaurant(restaurantId, adminId, reason);

    sendSuccess(res, restaurant, "Restaurant rejected");
  } catch (error) {
    next(error);
  }
};

// Admin: Deactivate restaurant
export const deactivateRestaurant = async (req, res, next) => {
  try {
    const { restaurantId } = req.params;
    const { reason } = req.body;

    const restaurant = await restaurantService.deactivateRestaurant(restaurantId, reason);

    sendSuccess(res, restaurant, "Restaurant deactivated");
  } catch (error) {
    next(error);
  }
};

// Admin: Reactivate restaurant
export const reactivateRestaurant = async (req, res, next) => {
  try {
    const { restaurantId } = req.params;

    const restaurant = await restaurantService.reactivateRestaurant(restaurantId);

    sendSuccess(res, restaurant, "Restaurant reactivated");
  } catch (error) {
    next(error);
  }
};
