import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  Future<void> saveTokens(String access, String refresh, int expiresIn) async {
    final expiry = DateTime.now().add(Duration(seconds: expiresIn));
    await _storage.write(key: "accessToken", value: access);
    await _storage.write(key: "refreshToken", value: refresh);
    await _storage.write(key: "expiry", value: expiry.toIso8601String());
  }

  Future<String?> getAccessToken() => _storage.read(key: "accessToken");
  Future<String?> getRefreshToken() => _storage.read(key: "refreshToken");
  Future<DateTime?> getExpiry() async {
    final value = await _storage.read(key: "expiry");
    return value != null ? DateTime.parse(value) : null;
  }

  Future<void> clear() async => await _storage.deleteAll();
}
