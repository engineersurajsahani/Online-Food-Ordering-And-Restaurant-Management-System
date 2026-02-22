// This middleware checks if user has the right role to access a route
// For example, only ADMIN can see all users

import { sendError } from "../utils/response.js";

// Function to check if user has one of the allowed roles
export const allowRoles = (...allowedRoles) => {
  return (req, res, next) => {
    // Get user's role from the request (set by auth middleware)
    const userRole = req.user.role;

    // Check if user's role is in the list of allowed roles
    if (!allowedRoles.includes(userRole)) {
      return sendError(
        res, 
        "You don't have permission to access this", 
        403
      );
    }

    // User has permission, continue
    next();
  };
};
