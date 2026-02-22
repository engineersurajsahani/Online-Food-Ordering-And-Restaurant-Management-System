// Restaurant Routes - endpoints for restaurant owners

import express from "express";
import * as restaurantController from "../controllers/restaurants.controller.js";
import { verifyToken } from "../middlewares/auth.middleware.js";
import { allowRoles } from "../middlewares/role.middleware.js";
import ROLES from "../config/roles.js";

const router = express.Router();

// Public routes (no auth needed)

// GET /restaurants - Get all restaurants (for customers to browse)
router.get(
  "/",
  verifyToken,
  restaurantController.getAllRestaurants
);

// Restaurant owner routes (need RESTAURANT role)

// POST /restaurants - Create a restaurant
router.post(
  "/",
  verifyToken,
  allowRoles(ROLES.RESTAURANT),
  restaurantController.createRestaurant
);

// GET /restaurants/my-restaurant - Get my restaurant
router.get(
  "/my-restaurant",
  verifyToken,
  allowRoles(ROLES.RESTAURANT),
  restaurantController.getMyRestaurant
);

// GET /restaurants/orders - Get orders for my restaurant
router.get(
  "/orders",
  verifyToken,
  allowRoles(ROLES.RESTAURANT),
  restaurantController.getOrders
);

// PATCH /restaurants/my-restaurant - Update my restaurant
router.patch(
  "/my-restaurant",
  verifyToken,
  allowRoles(ROLES.RESTAURANT),
  restaurantController.updateRestaurant
);

// PATCH /restaurants/toggle-status - Toggle open/close status
router.patch(
  "/toggle-status",
  verifyToken,
  allowRoles(ROLES.RESTAURANT),
  restaurantController.toggleStatus
);

// GET /restaurants/dashboard - Get dashboard stats
router.get(
  "/dashboard",
  verifyToken,
  allowRoles(ROLES.RESTAURANT),
  restaurantController.getDashboard
);

// Admin routes for restaurant management

// GET /restaurants/admin/all - Get all restaurants (including pending)
router.get(
  "/admin/all",
  verifyToken,
  allowRoles(ROLES.ADMIN),
  restaurantController.getAllRestaurantsAdmin
);

// PATCH /restaurants/admin/:restaurantId/approve - Approve restaurant
router.patch(
  "/admin/:restaurantId/approve",
  verifyToken,
  allowRoles(ROLES.ADMIN),
  restaurantController.approveRestaurant
);

// PATCH /restaurants/admin/:restaurantId/reject - Reject restaurant
router.patch(
  "/admin/:restaurantId/reject",
  verifyToken,
  allowRoles(ROLES.ADMIN),
  restaurantController.rejectRestaurant
);

// PATCH /restaurants/admin/:restaurantId/deactivate - Deactivate restaurant
router.patch(
  "/admin/:restaurantId/deactivate",
  verifyToken,
  allowRoles(ROLES.ADMIN),
  restaurantController.deactivateRestaurant
);

// PATCH /restaurants/admin/:restaurantId/reactivate - Reactivate restaurant
router.patch(
  "/admin/:restaurantId/reactivate",
  verifyToken,
  allowRoles(ROLES.ADMIN),
  restaurantController.reactivateRestaurant
);

export default router;
