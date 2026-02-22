// Global error handler middleware
// Catches all errors and sends a clean response to frontend

import { logError } from "../utils/logger.js";

// Error handling middleware - must have 4 parameters
export const errorHandler = (err, req, res, next) => {
  // Log the error so we can debug
  logError(err.message);

  // Get status code (default 500 if not specified)
  const statusCode = err.statusCode || 500;

  // Get error message (default generic message)
  const message = err.message || "Internal Server Error";

  // Send error response
  res.status(statusCode).json({
    success: false,
    message: message,
    data: null
  });
};
