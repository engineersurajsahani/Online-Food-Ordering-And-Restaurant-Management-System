// Menu Service - business logic for menu items

import MenuItem from "../models/MenuItem.js";
import Restaurant from "../models/Restaurant.js";

// Add a new menu item to restaurant
export const addMenuItem = async (ownerId, itemData) => {
  // First, get the restaurant for this owner
  const restaurant = await Restaurant.findOne({ ownerId });
  
  if (!restaurant) {
    throw new Error("You need to create a restaurant first");
  }

  // Create the menu item
  const menuItem = await MenuItem.create({
    restaurantId: restaurant._id,
    name: itemData.name,
    description: itemData.description,
    price: itemData.price,
    isVeg: itemData.isVeg,
    category: itemData.category,
    image: itemData.image,
    isAvailable: itemData.isAvailable !== undefined ? itemData.isAvailable : true
  });

  return menuItem;
};

// Get all menu items for a restaurant
export const getRestaurantMenu = async (restaurantId) => {
  const menuItems = await MenuItem.find({ restaurantId });
  return menuItems;
};

// Get menu items for restaurant owner
export const getMyMenu = async (ownerId) => {
  // Get restaurant first
  const restaurant = await Restaurant.findOne({ ownerId });
  
  if (!restaurant) {
    throw new Error("Restaurant not found");
  }

  const menuItems = await MenuItem.find({ restaurantId: restaurant._id });
  return menuItems;
};

// Update a menu item
export const updateMenuItem = async (ownerId, itemId, updates) => {
  // Get restaurant
  const restaurant = await Restaurant.findOne({ ownerId });
  
  if (!restaurant) {
    throw new Error("Restaurant not found");
  }

  // Find the menu item
  const menuItem = await MenuItem.findOne({
    _id: itemId,
    restaurantId: restaurant._id
  });

  if (!menuItem) {
    throw new Error("Menu item not found");
  }

  // Update fields
  if (updates.name) menuItem.name = updates.name;
  if (updates.description !== undefined) menuItem.description = updates.description;
  if (updates.price) menuItem.price = updates.price;
  if (updates.isVeg !== undefined) menuItem.isVeg = updates.isVeg;
  if (updates.category) menuItem.category = updates.category;
  if (updates.image) menuItem.image = updates.image;
  if (updates.isAvailable !== undefined) menuItem.isAvailable = updates.isAvailable;

  await menuItem.save();
  return menuItem;
};

// Toggle item availability
export const toggleItemAvailability = async (ownerId, itemId, isAvailable) => {
  // Get restaurant
  const restaurant = await Restaurant.findOne({ ownerId });
  
  if (!restaurant) {
    throw new Error("Restaurant not found");
  }

  // Find and update menu item
  const menuItem = await MenuItem.findOne({
    _id: itemId,
    restaurantId: restaurant._id
  });

  if (!menuItem) {
    throw new Error("Menu item not found");
  }

  menuItem.isAvailable = isAvailable;
  await menuItem.save();

  return menuItem;
};

// Delete a menu item
export const deleteMenuItem = async (ownerId, itemId) => {
  // Get restaurant
  const restaurant = await Restaurant.findOne({ ownerId });
  
  if (!restaurant) {
    throw new Error("Restaurant not found");
  }

  // Find and delete menu item
  const menuItem = await MenuItem.findOneAndDelete({
    _id: itemId,
    restaurantId: restaurant._id
  });

  if (!menuItem) {
    throw new Error("Menu item not found");
  }

  return menuItem;
};
