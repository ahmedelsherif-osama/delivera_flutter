import 'package:delivera_flutter/features/superadmin_actions/logic/organization_model.dart';
import 'package:delivera_flutter/features/authentication/logic/auth_provider.dart';
import 'package:delivera_flutter/features/authentication/logic/register_request.dart';
import 'package:delivera_flutter/features/authentication/logic/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrgOwnerRepository {
  const OrgOwnerRepository(this._dio);
  final Dio _dio;

  Future<dynamic> fetchUsers() async {
    final res = await _dio.get('/adminactions/users/');

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
  return OrgOwnerRepository(dio);
});
