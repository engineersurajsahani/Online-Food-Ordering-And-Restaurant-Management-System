// Restaurant model - represents restaurants in our database
// Each restaurant is owned by one user with RESTAURANT role

import mongoose from "mongoose";

// Define how a Restaurant looks in the database
const restaurantSchema = new mongoose.Schema(
  {
    // Who owns this restaurant (reference to User)
    ownerId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true
    },

    // Restaurant name
    name: {
      type: String,
      required: true,
      trim: true
    },

    // Description of the restaurant
    description: {
      type: String,
      default: ""
    },

    // Restaurant address
    address: {
      type: String,
      required: true
    },

    // Is restaurant accepting orders right now?
    isOpen: {
      type: Boolean,
      default: true
    },

    // How long does it take to prepare food? (in minutes)
    preparationTime: {
      type: Number,
      default: 30
    },

    // Approval status by admin
    approvalStatus: {
      type: String,
      enum: ["PENDING", "APPROVED", "REJECTED"],
      default: "PENDING"
    },

    // Is restaurant active? (Admin can deactivate)
    isActive: {
      type: Boolean,
      default: true
    },

    // Admin notes for rejection or other comments
    adminNotes: {
      type: String,
      default: ""
    },

    // Approved by (admin user ID)
    approvedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User"
    },

    // Approval date
    approvedAt: {
      type: Date
    }
  },
  {
    // Automatically add createdAt and updatedAt
    timestamps: true
  }
);

// Create index for finding restaurants by owner
restaurantSchema.index({ ownerId: 1 });

// Create the Restaurant model
const Restaurant = mongoose.model("Restaurant", restaurantSchema);

export default Restaurant;
