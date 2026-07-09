import 'dart:async';

/// Broadcasts refresh-interval changes (in seconds) so any cubit that
/// polls prices can restart its Timer.periodic with the new interval
/// the moment the user changes it in Settings.
class RefreshIntervalNotifierService {
  RefreshIntervalNotifierService();

  final StreamController<int> _controller = StreamController<int>.broadcast();

  Stream<int> get stream => _controller.stream;

  void notify(int seconds) {
    _controller.add(seconds);
  }

  void dispose() {
    _controller.close();
  }
}
