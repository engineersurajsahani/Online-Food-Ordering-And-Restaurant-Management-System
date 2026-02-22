// User Controller - handles HTTP requests for user operations

import * as userService from "../services/users.service.js";
import { sendSuccess, sendError } from "../utils/response.js";

// Get logged in user's profile
export const getProfile = async (req, res, next) => {
  try {
    // Get user ID from token (set by auth middleware)
    const userId = req.user.userId;

    // Get user profile from service
    const user = await userService.getUserProfile(userId);

    // Send response
    sendSuccess(res, user, "Profile fetched successfully");
  } catch (error) {
    next(error);
  }
};

// Get logged in user's order history
export const getMyOrders = async (req, res, next) => {
  try {
    // Get user ID from token
    const userId = req.user.userId;

    // Get orders from service
    const orders = await userService.getUserOrders(userId);

    // Send response
    sendSuccess(res, orders, "Orders fetched successfully");
  } catch (error) {
    next(error);
  }
};
