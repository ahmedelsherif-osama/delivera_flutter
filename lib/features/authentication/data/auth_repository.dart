import 'package:delivera_flutter/features/authentication/logic/register_request.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  const AuthRepository(this._dio);
  final Dio _dio;

  Future<Map<String, dynamic>> login(String username, String password) async {
    final res = await _dio.post(
      '/Auth/login',
      data: {"username": username, "password": password},
    );
    return res.data;
  }

  Future<Map<String, dynamic>> logout(String refreshToken) async {
    print("repo refresh token $refreshToken");
    final res = await _dio.post(
      '/Auth/logout',
      data: {"refreshToken": refreshToken},
    );
    return res.data;
  }

  Future<Map<String, dynamic>> refresh(String refreshToken) async {
    final res = await _dio.post(
      '/Auth/refresh',
      data: {"refresh": refreshToken},
    );
    return res.data;
  }

  Future<bool> register(RegisterRequest registerRequest) async {
    try {
      final res = await _dio.post(
        '/Auth/register',
        data: registerRequest.toJson(),
      );
      return res.statusCode == 200;
    } catch (e) {
      throw e;
    }
  }
}
