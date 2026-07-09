// main.dart
import 'package:crypto_portfolio_tracker/app/app.dart';
import 'package:flutter/material.dart';

import 'core/sevices/storage_service.dart';
import 'core/sevices/notification_service.dart';
import 'core/di/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StorageService.init();
  await initDependencies();
  await sl<NotificationService>().init();

  runApp(const CryptoTrackerApp());
}
