// core/local_storage/storage_service.dart
import 'dart:convert';

import 'package:get_storage/get_storage.dart';

class StorageService {
  static const String _boxName = 'crypto_tracker_box';
  final GetStorage _box = GetStorage(_boxName);

  static Future<void> init() async {
    await GetStorage.init(_boxName);
  }

  Future<void> writeJson(String key, dynamic value) async {
    await _box.write(key, jsonEncode(value));
  }

  dynamic readJson(String key) {
    final raw = _box.read<String>(key);
    if (raw == null) return null;
    return jsonDecode(raw);
  }

  Future<void> writeValue(String key, dynamic value) async {
    await _box.write(key, value);
  }

  T? readValue<T>(String key) => _box.read<T>(key);

  Future<void> remove(String key) async => _box.remove(key);

  Future<void> clearAll() async => _box.erase();
}
