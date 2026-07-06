// core/local_storage/storage_service.dart
import 'dart:convert';

import 'package:get_storage/get_storage.dart';

/// Bütün feature-lar bu servis üzərindən GetStorage-a JSON oxuyub-yazır.
/// main() içində `await StorageService.init()` çağırılmalıdır (GetIt-dən əvvəl).
class StorageService {
  static const String _boxName = 'crypto_tracker_box';
  final GetStorage _box = GetStorage(_boxName);

  static Future<void> init() async {
    await GetStorage.init(_boxName);
  }

  /// Map/List formatında olan datanı JSON string kimi saxlayır
  Future<void> writeJson(String key, dynamic value) async {
    await _box.write(key, jsonEncode(value));
  }

  /// Saxlanılan JSON string-i decode edib qaytarır (List<dynamic> və ya Map)
  dynamic readJson(String key) {
    final raw = _box.read<String>(key);
    if (raw == null) return null;
    return jsonDecode(raw);
  }

  /// Sadə primitive dəyər (String, bool, int) üçün
  Future<void> writeValue(String key, dynamic value) async {
    await _box.write(key, value);
  }

  T? readValue<T>(String key) => _box.read<T>(key);

  Future<void> remove(String key) async => _box.remove(key);

  Future<void> clearAll() async => _box.erase();
}
