import 'package:delivera_flutter/features/authentication/logic/auth_provider.dart';
import 'package:delivera_flutter/features/authentication/logic/user_model.dart';
import 'package:delivera_flutter/features/orgadmin_actions/logic/zone_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrgadminRepository {
  const OrgadminRepository(this._dio);
  final Dio _dio;

  createZone() async {}
  fetchZone(String zoneId) async {}
  Future<dynamic> fetchZones() async {
    try {
      final res = await _dio.get("/zones/");
      print(res);
      final zones = (res.data as List)
          .map((zoneJson) => Zone.fromJson(zoneJson))
          .toList();
      print("zones $zones");
      return zones;
    } on DioException catch (e) {
      return e.error ?? e.message;
    } catch (e) {
      return e;
    }
  }
}

final orgAdminRepoProvider = Provider((ref) {
  final dio = ref.read(dioProvider);
  return OrgadminRepository(dio);
});
