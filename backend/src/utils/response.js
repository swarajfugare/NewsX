class ApiResponse {
  static success(res, message = 'Success', data = null, statusCode = 200) {
    return res.status(statusCode).json({
      status: 'success',
      success: true,
      message,
      data,
    });
  }

  static error(res, message = 'An error occurred', statusCode = 500, errors = null) {
    return res.status(statusCode).json({
      status: 'error',
      success: false,
      message,
      errors,
    });
  }
}

module.exports = ApiResponse;
