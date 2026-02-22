// This middleware checks if user is logged in
// It verifies the JWT token sent from the frontend

import jwt from "jsonwebtoken";
import { sendError } from "../utils/response.js";

// Middleware to verify if user has a valid token
export const verifyToken = (req, res, next) => {
  // Get the token from the request header
  // Frontend sends it like: Authorization: Bearer <token>
  const authHeader = req.headers.authorization;

  // Check if token exists
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return sendError(res, "No token provided. Please login first", 401);
  }

  // Extract the actual token (remove "Bearer " part)
  const token = authHeader.split(" ")[1];

  try {
    // Verify the token using our secret key
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    // Add user info to request so we can use it later
    req.user = {
      userId: decoded.userId,
      role: decoded.role
    };

    // Token is valid, move to next middleware/controller
    next();
  } catch (error) {
    return sendError(res, "Invalid or expired token. Please login again", 401);
  }
};
