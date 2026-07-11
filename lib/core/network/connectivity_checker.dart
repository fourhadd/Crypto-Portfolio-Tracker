// core/network/connectivity_checker.dart
import 'dart:io';

class ConnectivityChecker {
  const ConnectivityChecker();

  Future<bool> hasConnection() async {
    try {
      final result = await InternetAddress.lookup(
        'one.one.one.one',
      ).timeout(const Duration(seconds: 4));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    } catch (_) {
      return false;
    }
  }
}
