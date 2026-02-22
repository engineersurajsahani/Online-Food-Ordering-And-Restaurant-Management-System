// This file helps us send consistent responses to the frontend
// Every API response will look the same - easier for Flutter to handle!

// Success response - when everything works fine
export const sendSuccess = (res, data = null, message = "Success") => {
  return res.status(200).json({
    success: true,
    message: message,
    data: data
  });
};

// Error response - when something goes wrong
export const sendError = (res, message = "Something went wrong", statusCode = 500) => {
  return res.status(statusCode).json({
    success: false,
    message: message,
    data: null
  });
};
