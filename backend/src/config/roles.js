// This file defines the three user roles in our system
// Think of roles like different types of accounts people can have

// The three roles in our food ordering app
const ROLES = {
  USER: "USER",              // Normal customer who orders food
  RESTAURANT: "RESTAURANT",  // Restaurant owner who manages menu and orders
  ADMIN: "ADMIN"             // System admin who can see everything
};

// Export so other files can use these roles
export default ROLES;
