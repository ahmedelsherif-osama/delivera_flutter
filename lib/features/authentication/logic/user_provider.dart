import 'package:delivera_flutter/features/authentication/data/user_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_model.dart';

class UserNotifier extends Notifier<User?> {
  late final UserStorage _storage;

  @override
  User? build() {
    _storage = ref.read(userStorageProvider);
    // On app start, try to restore user from storage
    _init();
    return null;
  }

  Future<void> _init() async {
    final user = await _storage.getUser();
    state = user;
  }

  Future<void> setUser(User user) async {
    await _storage.saveUser(user);
    state = user;
  }

  Future<void> clearUser() async {
    await _storage.clear();
    state = null;
  }
}

final userProvider = NotifierProvider<UserNotifier, User?>(UserNotifier.new);
