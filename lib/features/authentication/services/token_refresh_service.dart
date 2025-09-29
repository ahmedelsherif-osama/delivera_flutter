import 'dart:async';

import 'package:delivera_flutter/features/authentication/logic/auth_provider.dart';
import 'package:delivera_flutter/features/authentication/data/auth_repository.dart';
import 'package:delivera_flutter/features/authentication/data/token_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TokenRefreshService {
  TokenRefreshService(this._authRepository, this._tokenStorage, this._ref);
  Timer? _timer;
  final AuthRepository _authRepository;
  final TokenStorage _tokenStorage;
  final Ref _ref;

  start() {
    print("inside start");
    _scheduleNextRefresh();
  }

  stop() {
    print("inside stop ${_timer!.isActive}");
    _timer?.cancel();
  }

  _refreshToken() async {
    try {
      print("inside regresh token");
      final oldRefreshToken = await _tokenStorage.getRefreshToken();
      final res = await _authRepository.refresh(oldRefreshToken!);
      await _tokenStorage!.saveTokens(
        res['AccessToken'] ?? res['accessToken'] ?? '',
        res['RefreshToken'] ?? res['refreshToken'] ?? '',
        (res['ExpiresIn'] ?? res['expiresIn'] ?? 0) as int,
      );
      print("refresh success");
    } catch (e) {
      print("refresh failed $e");
      await _ref.read(authProvider.notifier).logout();
    }
  }

  _scheduleNextRefresh() async {
    print("inside schedule nextrefresh");
    final expiry = await _tokenStorage.getExpiry();
    final now = DateTime.now();
    final refreshIn = expiry!.difference(now).inMinutes - 10;
    _timer?.cancel();
    _timer = Timer(Duration(minutes: refreshIn), _refreshToken);
    print("scheduling succeeded");
  }
}

final tokenRefreshServiceProvider = Provider<TokenRefreshService>((ref) {
  final repo = ref.read(authRepositoryProvider);
  final storage = ref.read(tokenStorageProvider);
  final service = TokenRefreshService(repo, storage, ref);
  service.start();

  // Stop timer when provider is disposed
  ref.onDispose(() => service.stop());
  return service;
});
