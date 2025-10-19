import 'package:delivera_flutter/features/authentication/logic/user_model.dart';
import 'package:delivera_flutter/features/authentication/logic/user_provider.dart';
import 'package:delivera_flutter/features/authentication/services/auth_interceptor.dart';
import 'package:delivera_flutter/features/authentication/data/auth_repository.dart';
import 'package:delivera_flutter/features/authentication/data/token_storage.dart';
import 'package:delivera_flutter/features/authentication/services/token_refresh_service.dart';
import 'package:delivera_flutter/features/notifications/services/notifications_service.dart';
import 'package:delivera_flutter/features/rider_actions/services/location_update_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final d = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:5208/api', // << replace with your base URL
      connectTimeout: Duration(milliseconds: 15000),
      receiveTimeout: Duration(milliseconds: 15000),
    ),
  );

  final storage = TokenStorage();

  d.interceptors.add(AuthInterceptor(storage));

  // Optionally add logging interceptor here (do NOT add refresh interceptor that calls AuthRepository -> Dio,
  // it may cause circular dependency). For refresh logic, call AuthRepository.refresh which uses its own _refreshDio.
  // d.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

  return d;
});

final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.read(dioProvider);
  return AuthRepository(dio);
});

class AuthNotifier extends Notifier<AsyncValue<bool>> {
  late final AuthRepository repo;
  late final TokenStorage storage;
  late final TokenRefreshService refreshService;

  @override
  AsyncValue<bool> build() {
    // use providers instead of constructing inside the class
    repo = ref.read(authRepositoryProvider);
    storage = ref.read(tokenStorageProvider);
    refreshService = ref.read(tokenRefreshServiceProvider);

    // kick off an async auth check (build must be sync); this will update state when done
    checkAuth();

    // initial state (optimistic false until checkAuth completes)
    return const AsyncValue.data(false);
  }

  Future<void> login(String username, String password) async {
    state = const AsyncValue.loading();
    try {
      print("got to provider login");
      final res = await repo.login(username, password);
      // expected keys: accessToken, refreshToken, expiresIn
      print(
        "logging in ${res['AccessToken'] ?? res['accessToken'] ?? '' + res['RefreshToken'] ?? res['refreshToken'] ?? '' + (res['ExpiresIn'] ?? res['expiresIn'] ?? 0)}",
      );
      await storage.saveTokens(
        res['AccessToken'] ?? res['accessToken'] ?? '',
        res['RefreshToken'] ?? res['refreshToken'] ?? '',
        (res['ExpiresIn'] ?? res['expiresIn'] ?? 0) as int,
      );
      print(res);
      final user = User.fromJson(res["user"]);
      print("user fetched on login $user");
      await ref.read(userProvider.notifier).setUser(user);

      print("right before checking role");

      if (user.organizationRole == 'Rider') {
        print("user is a rider");
        final service = ref.read(locationUpdateServiceProvider);
        service.start();
      }

      final notificationService = ref.read(notificationServiceProvider);
      await notificationService.connect(res['accessToken'], user.id);

      state = const AsyncValue.data(true);
      refreshService.start();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    refreshService.stop(); // stop timer first
    final refreshToken = await storage.getRefreshToken();
    final user = ref.read(userProvider);

    print("already saved refresh $refreshToken");
    if (refreshToken != null && refreshToken.isNotEmpty) {
      try {
        await repo.logout(refreshToken);
        final service = ref.read(locationUpdateServiceProvider);
        service.stop();
        await ref.read(notificationServiceProvider).disconnect(user!.id);
      } catch (_) {
        // ignore network errors on logout but still clear local tokens
      }
    }
    await storage.clear();
    await ref.read(userProvider.notifier).clearUser();
    state = const AsyncValue.data(false);
  }

  Future<void> checkAuth() async {
    try {
      final token = await storage.getAccessToken();
      final expiry = await storage.getExpiry();
      if (token != null && expiry != null && expiry.isAfter(DateTime.now())) {
        state = const AsyncValue.data(true);
      } else {
        // try refresh if refresh token exists
        final refreshToken = await storage.getRefreshToken();
        if (refreshToken != null && refreshToken.isNotEmpty) {
          final newTokens = await repo.refresh(refreshToken);
          await storage.saveTokens(
            newTokens['AccessToken'] ?? newTokens['accessToken'] ?? '',
            newTokens['RefreshToken'] ?? newTokens['refreshToken'] ?? '',
            (newTokens['ExpiresIn'] ?? newTokens['expiresIn'] ?? 0) as int,
          );
          state = const AsyncValue.data(true);
        } else {
          state = const AsyncValue.data(false);
        }
      }
    } catch (e, st) {
      // refresh failed or parse error → treat as logged out
      state = AsyncValue.error(e, st);
    }
  }
}

final authProvider = NotifierProvider<AuthNotifier, AsyncValue<bool>>(
  AuthNotifier.new,
);
