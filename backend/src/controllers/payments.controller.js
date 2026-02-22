// Payment Controller - handles payment requests

import * as paymentService from "../services/payments.service.js";
import { sendSuccess } from "../utils/response.js";

// Mark order as paid (stub)
export const markAsPaid = async (req, res, next) => {
  try {
    const { orderId } = req.params;

    const order = await paymentService.markOrderAsPaid(orderId);

    sendSuccess(res, order, "Payment marked as successful");
  } catch (error) {
    next(error);
  }
};

// Get payment status
export const getPaymentStatus = async (req, res, next) => {
  try {
    const { orderId } = req.params;

    const paymentInfo = await paymentService.getPaymentStatus(orderId);

    sendSuccess(res, paymentInfo, "Payment status fetched");
  } catch (error) {
    next(error);
  }
};
