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
    print("inside init user provider");
    final user = await _storage.getUser();
    print("user provider init user $user");
    state = user;
  }

  Future<void> setUser(User user) async {
    print("user provider setting user $user");
    await _storage.saveUser(user);
    state = user;
  }

  Future<void> clearUser() async {
    print("user provider clearing user");
    await _storage.clear();
    state = null;
  }
}

final userProvider = NotifierProvider<UserNotifier, User?>(UserNotifier.new);
