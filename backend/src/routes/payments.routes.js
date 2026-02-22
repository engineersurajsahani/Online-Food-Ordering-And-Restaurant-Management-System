// Payment Routes - endpoints for payment operations
// These are stubs for now

import express from "express";
import * as paymentController from "../controllers/payments.controller.js";
import { verifyToken } from "../middlewares/auth.middleware.js";

const router = express.Router();

// POST /payments/:orderId/mark-paid - Mark order as paid (stub)
router.post(
  "/:orderId/mark-paid",
  verifyToken,
  paymentController.markAsPaid
);

// GET /payments/:orderId/status - Get payment status
router.get(
  "/:orderId/status",
  verifyToken,
  paymentController.getPaymentStatus
);

export default router;
