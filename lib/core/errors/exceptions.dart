// core/errors/exceptions.dart
class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Server xətası baş verdi']);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'İnternet bağlantısı yoxdur']);
}

class TimeoutException implements Exception {
  final String message;
  const TimeoutException([this.message = 'Sorğu vaxtı bitdi']);
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Yaddaşda saxlama xətası']);
}
