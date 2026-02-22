// MenuItem model - represents food items in restaurant menus
// Each item belongs to one restaurant

import mongoose from "mongoose";

// Define how a MenuItem looks in the database
const menuItemSchema = new mongoose.Schema(
  {
    // Which restaurant owns this item
    restaurantId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Restaurant",
      required: true
    },

    // Name of the food item
    name: {
      type: String,
      required: true,
      trim: true
    },

    // Description of the dish
    description: {
      type: String,
      default: ""
    },

    // Price in your currency (e.g., ₹)
    price: {
      type: Number,
      required: true,
      min: 0
    },

    // Is it vegetarian?
    isVeg: {
      type: Boolean,
      default: true
    },

    // Category (e.g., "Starters", "Main Course", "Desserts")
    category: {
      type: String,
      enum: [
        "Appetizers",
        "Main Course", 
        "Desserts",
        "Beverages",
        "Breads",
        "Rice & Biryani",
        "Chinese",
        "South Indian",
        "Fast Food",
        "Salads",
        "Other"
      ],
      default: "Other"
    },

    // Image URL for the food item
    image: {
      type: String,
      default: "https://via.placeholder.com/300x200?text=Food+Item"
    },

    // Is this item available for ordering right now?
    isAvailable: {
      type: Boolean,
      default: true
    }
  },
  {
    // Automatically add createdAt and updatedAt
    timestamps: true
  }
);

// Create index for finding items by restaurant
menuItemSchema.index({ restaurantId: 1 });

// Create the MenuItem model
const MenuItem = mongoose.model("MenuItem", menuItemSchema);

export default MenuItem;
