import 'dart:convert';

import 'package:delivera_flutter/features/authentication/logic/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  Future<void> saveUser(User user) async {
    await _storage.write(key: 'user', value: user.toJson().toString());
  }

  Future<User?> getUser() async {
    final raw = await _storage.read(key: 'user');
    if (raw == null) return null;
    return User.fromJson(Map<String, dynamic>.from(jsonDecode(raw)));
  }

  Future<void> clear() async {
    await _storage.delete(key: 'user');
  }
}

final userStorageProvider = Provider<UserStorage>((ref) => UserStorage());
