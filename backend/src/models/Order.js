// Order model - represents customer orders
// This is the most important model in our system!

import mongoose from "mongoose";

// Possible order statuses
const ORDER_STATUS = {
  PLACED: "PLACED",       // Customer just placed order
  CONFIRMED: "CONFIRMED", // Restaurant confirmed it
  PREPARING: "PREPARING", // Restaurant is cooking
  READY: "READY",         // Food is ready for pickup
  DELIVERED: "DELIVERED", // Order completed
  CANCELLED: "CANCELLED"  // User or restaurant cancelled
};

// Payment statuses
const PAYMENT_STATUS = {
  PENDING: "PENDING",  // Not paid yet
  PAID: "PAID"         // Payment completed
};

// Define how an Order looks in the database
const orderSchema = new mongoose.Schema(
  {
    // Which customer placed this order
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true
    },

    // Which restaurant is this order for
    restaurantId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Restaurant",
      required: true
    },

    // List of items in this order
    // We save name and price as "snapshot" because menu can change later
    items: [
      {
        menuItemId: {
          type: mongoose.Schema.Types.ObjectId,
          ref: "MenuItem"
        },
        nameSnapshot: String,   // Save item name at time of order
        priceSnapshot: Number,  // Save item price at time of order
        quantity: {
          type: Number,
          required: true,
          min: 1
        }
      }
    ],

    // Total amount for this order
    totalAmount: {
      type: Number,
      required: true,
      min: 0
    },

    // Current status of the order
    status: {
      type: String,
      enum: Object.values(ORDER_STATUS),
      default: ORDER_STATUS.PLACED
    },

    // Payment status
    paymentStatus: {
      type: String,
      enum: Object.values(PAYMENT_STATUS),
      default: PAYMENT_STATUS.PENDING
    }
  },
  {
    // Automatically add createdAt and updatedAt
    timestamps: true
  }
);

// Create indexes for faster searches
orderSchema.index({ userId: 1 });
orderSchema.index({ restaurantId: 1 });
orderSchema.index({ createdAt: -1 });

// Create the Order model
const Order = mongoose.model("Order", orderSchema);

// Export both the model and status enums
export default Order;
export { ORDER_STATUS, PAYMENT_STATUS };
