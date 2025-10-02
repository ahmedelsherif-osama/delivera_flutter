import 'dart:convert';

import 'package:delivera_flutter/features/authentication/logic/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  Future<void> saveUser(User user) async {
    print("storage saving user $user");
    await _storage.write(key: 'user', value: jsonEncode(user.toJson()));
  }

  Future<User?> getUser() async {
    print("inside get user");
    final raw = await _storage.read(key: 'user');
    print("so storage $raw");
    if (raw == null) return null;
    return User.fromJson(jsonDecode(raw));
  }

  Future<void> clear() async {
    print("storage clearing user");
    await _storage.delete(key: 'user');
  }
}

final userStorageProvider = Provider<UserStorage>((ref) => UserStorage());
