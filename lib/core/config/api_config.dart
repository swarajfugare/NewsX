class ApiConfig {
  ApiConfig._();

  // Change this single constant to point to Hostinger production backend server URL
  static const String baseUrl = 'http://localhost:5000/api/v1';
  static const Duration connectionTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
}
