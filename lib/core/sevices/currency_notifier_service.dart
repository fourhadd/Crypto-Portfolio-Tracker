import 'dart:async';

class CurrencyNotifierService {
  CurrencyNotifierService();

  final StreamController<String> _controller =
      StreamController<String>.broadcast();

  Stream<String> get stream => _controller.stream;

  void notify(String currency) {
    _controller.add(currency);
  }

  void dispose() {
    _controller.close();
  }
}
