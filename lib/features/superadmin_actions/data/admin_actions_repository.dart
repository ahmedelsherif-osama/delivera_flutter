import 'package:delivera_flutter/features/superadmin_actions/logic/organization_model.dart';
import 'package:delivera_flutter/features/authentication/logic/auth_provider.dart';
import 'package:delivera_flutter/features/authentication/logic/register_request.dart';
import 'package:delivera_flutter/features/authentication/logic/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminActionsRepository {
  const AdminActionsRepository(this._dio);
  final Dio _dio;

  Future<dynamic> fetchOrganizations() async {
    final res = await _dio.get('/adminactions/organizations/');

    try {
      final organizations = (res.data as List)
          .map((jsonOrg) => Organization.fromJson(jsonOrg))
          .toList();
      return organizations;
    } on DioException catch (e) {
      print(e.response!.data);
      return e.response!.data;
    }
  }

  Future<dynamic> fetchUsers() async {
    final res = await _dio.get('/adminactions/orgowner/users/');

    try {
      final users = (res.data as List)
          .map((jsonOrg) => User.fromJson(jsonOrg))
          .toList();
      return users;
    } on DioException catch (e) {
      print(e.response!.data);
      return e.response!.data;
    }
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

  Future<dynamic> approveOrg(String organizationId) async {
    print("approve " + organizationId);
    try {
      final res = await _dio.patch(
        '/adminactions/superadmin/approveOrg/$organizationId',
      );
      return res.statusCode == 200;
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response?.data); // will show ValidationProblemDetails JSON
      }
      return e.response?.data;
    } catch (er) {
      print(er);
      return er;
    }
  }

  Future<dynamic> approveUserBySuperAdmin(String userId) async {
    print("approve " + userId);
    try {
      final res = await _dio.patch(
        '/adminactions/superadmin/approveUser/$userId',
      );
      return res.statusCode == 200;
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response?.data); // will show ValidationProblemDetails JSON
      }
      return e.response?.data;
    } catch (er) {
      print(er);
      return er;
    }
  }

  Future<dynamic> revokeUserBySuperAdmin(String userId) async {
    print("revoke " + userId);
    try {
      final res = await _dio.patch(
        '/adminactions/superadmin/revokeuser/$userId',
      );
      return res.statusCode == 200;
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response?.data); // will show ValidationProblemDetails JSON
      }
      return e.response?.data;
    } catch (er) {
      print(er);
      return er;
    }
  }

  Future<dynamic> revokeOrg(String organizationId) async {
    print("revoke " + organizationId);
    try {
      final res = await _dio.patch(
        '/adminactions/superadmin/revokeOrg/$organizationId',
      );
      return res.statusCode == 200;
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response?.data); // will show ValidationProblemDetails JSON
      }
      return e.response?.data;
    } catch (er) {
      print(er);
      return er;
    }
  }
}

final adminActionsRepoProvider = Provider((ref) {
  final dio = ref.read(dioProvider);
  return AdminActionsRepository(dio);
});
