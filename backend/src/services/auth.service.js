// Auth Service - handles business logic for authentication
// This is where the actual work happens (register, login)

import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import User from "../models/User.js";
import ROLES from "../config/roles.js";

// Service to register a new user
export const registerUser = async (name, email, phone, password, role = ROLES.USER) => {
  // Check if user with this email already exists
  const existingUser = await User.findOne({ email });
  if (existingUser) {
    throw new Error("User with this email already exists");
  }

  // Hash the password for security
  // Never save plain passwords in database!
  const passwordHash = await bcrypt.hash(password, 10);

  // Create new user in database
  const newUser = await User.create({
    name,
    email,
    phone,
    passwordHash,
    role
  });

  // Return user info (without password)
  return {
    userId: newUser._id,
    name: newUser.name,
    email: newUser.email,
    role: newUser.role
  };
};

// Service to login a user
export const loginUser = async (email, password) => {
  // Find user by email
  const user = await User.findOne({ email });
  if (!user) {
    throw new Error("Invalid email or password");
  }

  // Check if account is active
  if (!user.isActive) {
    throw new Error("Your account is deactivated. Contact admin");
  }

  // Compare password with hashed password in database
  const isPasswordValid = await bcrypt.compare(password, user.passwordHash);
  if (!isPasswordValid) {
    throw new Error("Invalid email or password");
  }

  // Create JWT token
  // Token contains user ID and role
  const token = jwt.sign(
    { 
      userId: user._id, 
      role: user.role 
    },
    process.env.JWT_SECRET,
    { expiresIn: "7d" }  // Token expires in 7 days
  );

  // Return token and user info
  return {
    token,
    user: {
      userId: user._id,
      name: user.name,
      email: user.email,
      role: user.role
    }
  };
};
