// core/shared/cubit/connectivity_cubit.dart
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../network/connectivity_checker.dart';

enum ConnectivityStatus { online, offline }

/// App-wide connection status. A single instance lives for the lifetime
/// of the app (registered as a lazy singleton) and is watched by
/// [ConnectivityBanner] so that a "no internet" banner can show up on
/// top of *any* screen, not just the one that happened to make a failing
/// request.
///
/// Two ways the status gets updated:
/// 1. Periodic background poll (every 5s) via [ConnectivityChecker].
/// 2. Instantly via [reportFailure], which any repository/DioClient can
///    call the moment a request fails with a connectivity-related error,
///    so the banner appears immediately instead of waiting for the next
///    poll tick.
class ConnectivityCubit extends Cubit<ConnectivityStatus> {
  final ConnectivityChecker _checker;
  Timer? _pollTimer;

  ConnectivityCubit({ConnectivityChecker checker = const ConnectivityChecker()})
    : _checker = checker,
      super(ConnectivityStatus.online) {
    _startPolling();
    checkNow();
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => checkNow(),
    );
  }

  /// Actively re-checks connectivity. Used both by the background poll
  /// and by the banner's "Retry" button.
  Future<void> checkNow() async {
    final connected = await _checker.hasConnection();
    if (isClosed) return;
    emit(connected ? ConnectivityStatus.online : ConnectivityStatus.offline);
  }

  /// Called by DioClient (or any datasource) the instant a request fails
  /// with a network/timeout error, so the user doesn't have to wait for
  /// the next poll tick to see the banner.
  void reportFailure() {
    if (isClosed) return;
    if (state != ConnectivityStatus.offline) {
      emit(ConnectivityStatus.offline);
    }
    // Confirm shortly after in case it was a one-off blip (e.g. a single
    // dropped request rather than a real outage).
    Future.delayed(const Duration(seconds: 2), checkNow);
  }

  @override
  Future<void> close() {
    _pollTimer?.cancel();
    return super.close();
  }
}
