// Payment Service - stub for future payment integration
// Right now we just mark orders as PAID manually

import Order from "../models/Order.js";
import { PAYMENT_STATUS } from "../models/Order.js";

// Mark an order as paid (stub function)
export const markOrderAsPaid = async (orderId) => {
  const order = await Order.findById(orderId);

  if (!order) {
    throw new Error("Order not found");
  }

  if (order.paymentStatus === PAYMENT_STATUS.PAID) {
    throw new Error("Order is already paid");
  }

  // Mark as paid
  order.paymentStatus = PAYMENT_STATUS.PAID;
  await order.save();

  return order;
};

// Get payment status for an order
export const getPaymentStatus = async (orderId) => {
  const order = await Order.findById(orderId).select("paymentStatus totalAmount");

  if (!order) {
    throw new Error("Order not found");
  }

  return {
    orderId: order._id,
    paymentStatus: order.paymentStatus,
    amount: order.totalAmount
  };
};

// Future: This is where you'll integrate Razorpay, Stripe, etc.
// For now, it's just a stub
