// Order Routes - endpoints for order management

import express from "express";
import * as orderController from "../controllers/orders.controller.js";
import { verifyToken } from "../middlewares/auth.middleware.js";
import { allowRoles } from "../middlewares/role.middleware.js";
import ROLES from "../config/roles.js";

const router = express.Router();

// GET /orders/my-orders - Get my orders (USER only)
router.get(
  "/my-orders",
  verifyToken,
  allowRoles(ROLES.USER),
  orderController.getMyOrders
);

// GET /orders/user-stats - Get user statistics (USER only)
router.get(
  "/user-stats",
  verifyToken,
  allowRoles(ROLES.USER),
  orderController.getUserStats
);

// GET /orders/restaurant-orders - Get restaurant orders (RESTAURANT only)
router.get(
  "/restaurant-orders",
  verifyToken,
  allowRoles(ROLES.RESTAURANT),
  orderController.getRestaurantOrders
);

// GET /orders/restaurant-stats - Get restaurant statistics (RESTAURANT only)
router.get(
  "/restaurant-stats",
  verifyToken,
  allowRoles(ROLES.RESTAURANT),
  orderController.getRestaurantStats
);

// POST /orders - Place a new order (USER only)
router.post(
  "/",
  verifyToken,
  allowRoles(ROLES.USER),
  orderController.placeOrder
);

// PATCH /orders/:orderId/cancel - Cancel an order (USER only)
router.patch(
  "/:orderId/cancel",
  verifyToken,
  allowRoles(ROLES.USER),
  orderController.cancelOrder
);

// PATCH /orders/:orderId/status - Update order status (RESTAURANT only)
router.patch(
  "/:orderId/status",
  verifyToken,
  allowRoles(ROLES.RESTAURANT),
  orderController.updateOrderStatus
);

export default router;
