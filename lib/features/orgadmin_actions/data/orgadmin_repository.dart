import 'package:delivera_flutter/features/authentication/logic/auth_provider.dart';
import 'package:delivera_flutter/features/authentication/logic/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrgadminRepository {
  const OrgadminRepository(this._dio);
  final Dio _dio;

  createZone() async {}
  getZone(String zoneId) async {}
  getAllZones() async {}
}

final orgAdminRepoProvider = Provider((ref) {
  final dio = ref.read(dioProvider);
  return OrgadminRepository(dio);
});
