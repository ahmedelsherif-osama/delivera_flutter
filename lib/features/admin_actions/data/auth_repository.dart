import 'package:delivera_flutter/features/admin_actions/logic/organization_model.dart';
import 'package:delivera_flutter/features/authentication/logic/register_request.dart';
import 'package:dio/dio.dart';

class AdminActionsRepository {
  const AdminActionsRepository(this._dio);
  final Dio _dio;

  Future<List<Organization>> fetchOrganizations(
    String username,
    String password,
  ) async {
    final res = await _dio.get('/api/adminactions/organizations/');

    final organizations = (res.data as List)
        .map((jsonOrg) => Organization.fromJson(jsonOrg))
        .toList();
    return organizations;
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
    print(registerRequest.toJson());
    try {
      final res = await _dio.post(
        '/Auth/register',
        data: registerRequest.toJson(),
      );
      return res.statusCode == 20;
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response?.data); // will show ValidationProblemDetails JSON
      }
      throw (DioException);
    } catch (er) {
      print(er);
      throw (er);
    }
  }
}
