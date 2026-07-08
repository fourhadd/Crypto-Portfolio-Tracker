// core/utils/page_transitions.dart
import 'package:flutter/cupertino.dart';

import 'package:go_router/go_router.dart';

class AppTransitions {
  AppTransitions._();
  static Page<T> push<T>({
    required GoRouterState state,
    required Widget child,
    String? title,
  }) {
    return CupertinoPage<T>(key: state.pageKey, title: title, child: child);
  }

  static Page<T> modal<T>({
    required GoRouterState state,
    required Widget child,
    String? title,
  }) {
    return CupertinoPage<T>(
      key: state.pageKey,
      title: title,
      fullscreenDialog: true,
      child: child,
    );
  }
}
