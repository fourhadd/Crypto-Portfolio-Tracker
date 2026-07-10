// core/errors/exceptions.dart
class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Server error occurred']);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'No internet connection']);
}

class TimeoutException implements Exception {
  final String message;
  const TimeoutException([this.message = 'Request timed out']);
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Storage error occurred']);
}
