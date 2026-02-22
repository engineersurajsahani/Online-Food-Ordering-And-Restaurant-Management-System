// This is the main app file where we set up Express
// We connect all our routes and middleware here

import express from "express";
import cors from "cors";

// Import all route files
import authRoutes from "./routes/auth.routes.js";
import userRoutes from "./routes/users.routes.js";
import restaurantRoutes from "./routes/restaurants.routes.js";
import menuRoutes from "./routes/menus.routes.js";
import orderRoutes from "./routes/orders.routes.js";
import adminRoutes from "./routes/admin.routes.js";
import paymentRoutes from "./routes/payments.routes.js";
import proxyRoutes from "./routes/proxy.routes.js";

// Import error handler middleware
import { errorHandler } from "./middlewares/error.middleware.js";

const app = express();

/* ---------- Global Middlewares ---------- */
// CORS - allows frontend to make requests
app.use(cors());

// Parse JSON request bodies
app.use(express.json());

/* ---------- Health Check ---------- */
// Simple endpoint to check if API is running
app.get("/health", (req, res) => {
  res.status(200).json({
    success: true,
    message: "Food Ordering API is running! 🍕"
  });
});

/* ---------- API Routes ---------- */
// Connect all our module routes with /api prefix

// Authentication routes (register, login)
app.use("/api/auth", authRoutes);

// User routes (profile, order history)
app.use("/api/users", userRoutes);

// Restaurant routes (create restaurant, manage orders)
app.use("/api/restaurants", restaurantRoutes);

// Menu routes (add items, update items)
app.use("/api/menus", menuRoutes);

// Order routes (place order, cancel order, update status)
app.use("/api/orders", orderRoutes);

// Admin routes (view all users, restaurants, orders, reports)
app.use("/api/admin", adminRoutes);

// Payment routes (stub for now)
app.use("/api/payments", paymentRoutes);

// Image proxy route (bypass CORS for external images)
app.use("/api/proxy", proxyRoutes);

/* ---------- Global Error Handler ---------- */
// Catches all errors from routes and sends proper response
app.use(errorHandler);

export default app;
