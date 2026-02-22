// Admin Routes - endpoints for admin operations
// Only users with ADMIN role can access these

import express from "express";
import * as adminController from "../controllers/admin.controller.js";
import { verifyToken } from "../middlewares/auth.middleware.js";
import { allowRoles } from "../middlewares/role.middleware.js";
import ROLES from "../config/roles.js";

const router = express.Router();

// All routes require ADMIN role

// GET /admin/users - Get all users
router.get(
  "/users",
  verifyToken,
  allowRoles(ROLES.ADMIN),
  adminController.getAllUsers
);

// GET /admin/restaurants - Get all restaurants
router.get(
  "/restaurants",
  verifyToken,
  allowRoles(ROLES.ADMIN),
  adminController.getAllRestaurants
);

// GET /admin/orders - Get all orders
router.get(
  "/orders",
  verifyToken,
  allowRoles(ROLES.ADMIN),
  adminController.getAllOrders
);

// GET /admin/reports - Get system reports
router.get(
  "/reports",
  verifyToken,
  allowRoles(ROLES.ADMIN),
  adminController.getReports
);

// GET /admin/revenue/daily - Get daily revenue
router.get(
  "/revenue/daily",
  verifyToken,
  allowRoles(ROLES.ADMIN),
  adminController.getDailyRevenue
);

export default router;
