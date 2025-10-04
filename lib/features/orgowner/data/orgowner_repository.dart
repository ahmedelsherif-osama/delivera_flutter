import 'package:delivera_flutter/features/authentication/logic/auth_provider.dart';
import 'package:delivera_flutter/features/authentication/logic/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrgOwnerRepository {
  const OrgOwnerRepository(this._dio);
  final Dio _dio;

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

  Future<dynamic> approveUserByOrgOwner(String userId) async {
    print("approve " + userId);
    try {
      final res = await _dio.patch(
        '/adminactions/orgowner/approveuser/$userId',
      );
      return res.statusCode == 200;
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response?.data);
      }
      return e.response?.data;
    } catch (er) {
      print(er);
      return er;
    }
  }

  Future<dynamic> revokeUserByOrgOwner(String userId) async {
    print("revoke " + userId);
    try {
      final res = await _dio.patch('/adminactions/orgowner/revokeuser/$userId');
      return res.statusCode == 200;
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response?.data);
      }
      return e.response?.data;
    } catch (er) {
      print(er);
      return er;
    }
  }
}

final orgOwnerRepoProvider = Provider((ref) {
  final dio = ref.read(dioProvider);
  return OrgOwnerRepository(dio);
});
