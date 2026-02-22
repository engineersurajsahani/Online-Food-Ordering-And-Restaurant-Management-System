// Menu Routes - endpoints for menu management

import express from "express";
import * as menuController from "../controllers/menus.controller.js";
import { verifyToken } from "../middlewares/auth.middleware.js";
import { allowRoles } from "../middlewares/role.middleware.js";
import ROLES from "../config/roles.js";

const router = express.Router();

// POST /menus - Add new menu item (RESTAURANT only)
router.post(
  "/",
  verifyToken,
  allowRoles(ROLES.RESTAURANT),
  menuController.addItem
);

// GET /menus/my - Get my restaurant's menu (RESTAURANT only)
router.get(
  "/my",
  verifyToken,
  allowRoles(ROLES.RESTAURANT),
  menuController.getMyMenu
);

// GET /menus/restaurant/:restaurantId - Get menu for a restaurant (anyone can see)
router.get(
  "/restaurant/:restaurantId",
  menuController.getRestaurantMenu
);

// PATCH /menus/:itemId - Update menu item (RESTAURANT only)
router.patch(
  "/:itemId",
  verifyToken,
  allowRoles(ROLES.RESTAURANT),
  menuController.updateItem
);

// PATCH /menus/:itemId/toggle - Toggle availability (RESTAURANT only)
router.patch(
  "/:itemId/toggle",
  verifyToken,
  allowRoles(ROLES.RESTAURANT),
  menuController.toggleAvailability
);

// DELETE /menus/:itemId - Delete menu item (RESTAURANT only)
router.delete(
  "/:itemId",
  verifyToken,
  allowRoles(ROLES.RESTAURANT),
  menuController.deleteItem
);

export default router;
