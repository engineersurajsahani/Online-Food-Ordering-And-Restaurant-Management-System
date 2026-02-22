// Auth Routes - defines the endpoints for authentication
// Routes connect URLs to controller functions

import express from "express";
import * as authController from "../controllers/auth.controller.js";

const router = express.Router();

// POST /auth/register - Register a new user
router.post("/register", authController.register);

// POST /auth/login - Login a user
router.post("/login", authController.login);

export default router;
