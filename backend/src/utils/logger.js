// Simple logger to print messages to console
// This helps us understand what's happening in our app

// Info message - normal information
export const logInfo = (message) => {
  console.log(`ℹ️  [INFO] ${message}`);
};

// Error message - when something breaks
export const logError = (message) => {
  console.error(`❌ [ERROR] ${message}`);
};

// Success message - when something works well
export const logSuccess = (message) => {
  console.log(`✅ [SUCCESS] ${message}`);
};
