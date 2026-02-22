// Menu Controller - handles menu HTTP requests

import * as menuService from "../services/menus.service.js";
import { sendSuccess, sendError } from "../utils/response.js";

// Add a new menu item
export const addItem = async (req, res, next) => {
  try {
    const ownerId = req.user.userId;
    const { name, description, price, isVeg, category } = req.body;

    // Validation
    if (!name || !price) {
      return sendError(res, "Name and price are required", 400);
    }

    if (price < 0) {
      return sendError(res, "Price cannot be negative", 400);
    }

    // Add menu item
    const menuItem = await menuService.addMenuItem(ownerId, req.body);

    sendSuccess(res, menuItem, "Menu item added successfully");
  } catch (error) {
    next(error);
  }
};

// Get menu for my restaurant
export const getMyMenu = async (req, res, next) => {
  try {
    const ownerId = req.user.userId;

    const menuItems = await menuService.getMyMenu(ownerId);

    sendSuccess(res, menuItems, "Menu fetched successfully");
  } catch (error) {
    next(error);
  }
};

// Get menu for a specific restaurant (for customers)
export const getRestaurantMenu = async (req, res, next) => {
  try {
    const { restaurantId } = req.params;

    const menuItems = await menuService.getRestaurantMenu(restaurantId);

    sendSuccess(res, menuItems, "Menu fetched successfully");
  } catch (error) {
    next(error);
  }
};

// Update a menu item
export const updateItem = async (req, res, next) => {
  try {
    const ownerId = req.user.userId;
    const { itemId } = req.params;

    const menuItem = await menuService.updateMenuItem(ownerId, itemId, req.body);

    sendSuccess(res, menuItem, "Menu item updated successfully");
  } catch (error) {
    next(error);
  }
};

// Toggle item availability
export const toggleAvailability = async (req, res, next) => {
  try {
    const ownerId = req.user.userId;
    const { itemId } = req.params;
    // Get isAvailable from body, or just toggle if not provided
    const { isAvailable } = req.body || {};

    const menuItem = await menuService.toggleItemAvailability(ownerId, itemId, isAvailable);

    sendSuccess(res, menuItem, "Availability updated successfully");
  } catch (error) {
    next(error);
  }
};

// Delete a menu item
export const deleteItem = async (req, res, next) => {
  try {
    const ownerId = req.user.userId;
    const { itemId } = req.params;

    await menuService.deleteMenuItem(ownerId, itemId);

    sendSuccess(res, null, "Menu item deleted successfully");
  } catch (error) {
    next(error);
  }
};
