// Order Controller - handles order HTTP requests

import * as orderService from "../services/orders.service.js";
import Restaurant from "../models/Restaurant.js";
import { sendSuccess, sendError } from "../utils/response.js";

// Place a new order (USER only)
export const placeOrder = async (req, res, next) => {
  try {
    const userId = req.user.userId;
    const { restaurantId, items } = req.body;

    // Validation
    if (!restaurantId) {
      return sendError(res, "Restaurant ID is required", 400);
    }

    if (!items || items.length === 0) {
      return sendError(res, "Order must have at least one item", 400);
    }

    // Validate items format
    for (const item of items) {
      if (!item.menuItemId || !item.quantity) {
        return sendError(res, "Each item must have menuItemId and quantity", 400);
      }

      if (item.quantity < 1) {
        return sendError(res, "Quantity must be at least 1", 400);
      }
    }

    // Place order
    const order = await orderService.placeOrder(userId, restaurantId, items);

    sendSuccess(res, order, "Order placed successfully");
  } catch (error) {
    next(error);
  }
};

// Cancel order (USER only)
export const cancelOrder = async (req, res, next) => {
  try {
    const userId = req.user.userId;
    const { orderId } = req.params;

    const order = await orderService.cancelOrder(userId, orderId);

    sendSuccess(res, order, "Order cancelled successfully");
  } catch (error) {
    next(error);
  }
};

// Update order status (RESTAURANT only)
export const updateOrderStatus = async (req, res, next) => {
  try {
    const ownerId = req.user.userId;
    const { orderId } = req.params;
    const { status } = req.body;

    if (!status) {
      return sendError(res, "Status is required", 400);
    }

    // Get restaurant for this owner
    const restaurant = await Restaurant.findOne({ ownerId });
    
    if (!restaurant) {
      return sendError(res, "Restaurant not found", 404);
    }

    // Update order status
    const order = await orderService.updateOrderStatus(restaurant._id, orderId, status);

    sendSuccess(res, order, "Order status updated successfully");
  } catch (error) {
    next(error);
  }
};

// Get my orders (USER only)
export const getMyOrders = async (req, res, next) => {
  try {
    const userId = req.user.userId;
    const orders = await orderService.getUserOrders(userId);
    sendSuccess(res, orders, "Orders fetched successfully");
  } catch (error) {
    next(error);
  }
};

// Get user statistics (USER only)
export const getUserStats = async (req, res, next) => {
  try {
    const userId = req.user.userId;
    const stats = await orderService.getUserStats(userId);
    sendSuccess(res, stats, "Statistics retrieved successfully");
  } catch (error) {
    next(error);
  }
};

// Get restaurant orders (RESTAURANT only)
export const getRestaurantOrders = async (req, res, next) => {
  try {
    const ownerId = req.user.userId;
    
    // Get restaurant for this owner
    const restaurant = await Restaurant.findOne({ ownerId });
    
    if (!restaurant) {
      return sendError(res, "Restaurant not found", 404);
    }

    const orders = await orderService.getRestaurantOrders(restaurant._id);
    sendSuccess(res, orders, "Orders fetched successfully");
  } catch (error) {
    next(error);
  }
};

// Get restaurant statistics (RESTAURANT only)
export const getRestaurantStats = async (req, res, next) => {
  try {
    const ownerId = req.user.userId;

    // Get restaurant for this owner
    const restaurant = await Restaurant.findOne({ ownerId });
    
    if (!restaurant) {
      return sendError(res, "Restaurant not found", 404);
    }

    const stats = await orderService.getRestaurantStats(restaurant._id);

    sendSuccess(res, stats, "Statistics retrieved successfully");
  } catch (error) {
    next(error);
  }
};
