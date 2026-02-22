// User Routes - defines endpoints for user operations

import express from "express";
import * as userController from "../controllers/users.controller.js";
import { verifyToken } from "../middlewares/auth.middleware.js";
import { allowRoles } from "../middlewares/role.middleware.js";
import ROLES from "../config/roles.js";

const router = express.Router();

// All user routes need authentication
// So we apply verifyToken to all routes

// GET /users/profile - Get my profile
router.get(
  "/profile", 
  verifyToken, 
  allowRoles(ROLES.USER), 
  userController.getProfile
);

// GET /users/orders - Get my order history
router.get(
  "/orders", 
  verifyToken, 
  allowRoles(ROLES.USER), 
  userController.getMyOrders
);

export default router;
