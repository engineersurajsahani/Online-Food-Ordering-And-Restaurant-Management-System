// Auth Controller - handles HTTP requests for authentication
// Controllers are like receptionists - they receive requests and respond

import * as authService from "../services/auth.service.js";
import { sendSuccess, sendError } from "../utils/response.js";

// Controller to handle user registration
export const register = async (req, res, next) => {
  try {
    // Get data from request body
    const { name, email, phone, password, role } = req.body;

    // Basic validation - phone is optional
    if (!name || !email || !password) {
      return sendError(res, "Name, email and password are required", 400);
    }

    // Call service to register user
    const user = await authService.registerUser(name, email, phone, password, role);

    // Send success response
    sendSuccess(res, user, "User registered successfully");
  } catch (error) {
    // If something goes wrong, pass to error handler
    next(error);
  }
};

// Controller to handle user login
export const login = async (req, res, next) => {
  try {
    // Get email and password from request
    const { email, password } = req.body;

    // Basic validation
    if (!email || !password) {
      return sendError(res, "Email and password are required", 400);
    }

    // Call service to login user
    const result = await authService.loginUser(email, password);

    // Send success response with token
    sendSuccess(res, result, "Login successful");
  } catch (error) {
    // If something goes wrong, pass to error handler
    next(error);
  }
};
