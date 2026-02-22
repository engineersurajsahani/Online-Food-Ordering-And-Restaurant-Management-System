// User model - represents users in our database
// Users can be customers, restaurant owners, or admins

import mongoose from "mongoose";
import ROLES from "../config/roles.js";

// Define how a User looks in the database
const userSchema = new mongoose.Schema(
  {
    // User's full name
    name: {
      type: String,
      required: true,
      trim: true
    },

    // User's email (must be unique)
    email: {
      type: String,
      required: true,
      unique: true,
      lowercase: true,
      trim: true
    },

    // User's phone number (optional)
    phone: {
      type: String,
      required: false,
      trim: true
    },

    // Hashed password (never store plain password!)
    passwordHash: {
      type: String,
      required: true
    },

    // What type of user? USER, RESTAURANT, or ADMIN
    role: {
      type: String,
      enum: [ROLES.USER, ROLES.RESTAURANT, ROLES.ADMIN],
      default: ROLES.USER
    },

    // Is this account active?
    isActive: {
      type: Boolean,
      default: true
    }
  },
  {
    // Automatically add createdAt and updatedAt fields
    timestamps: true
  }
);

// Create indexes for faster searches
userSchema.index({ email: 1 });
userSchema.index({ role: 1 });

// Create the User model
const User = mongoose.model("User", userSchema);

export default User;
