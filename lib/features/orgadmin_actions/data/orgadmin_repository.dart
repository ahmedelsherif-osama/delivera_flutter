import 'package:delivera_flutter/features/authentication/logic/auth_provider.dart';
import 'package:delivera_flutter/features/orgadmin_actions/logic/order_model.dart';
import 'package:delivera_flutter/features/orgadmin_actions/logic/zone_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrgadminRepository {
  const OrgadminRepository(this._dio);
  final Dio _dio;

  createZone(Zone zone) async {
    try {
      final res = await _dio.post("/zones/create/", data: zone.toJson());
      return Zone.fromJson(res.data);
    } on DioException catch (e) {
      return e.error ?? e.message;
    } catch (e) {
      return e.toString();
    }
  }

  deleteZone(String zoneId) async {
    try {
      final res = await _dio.delete("/zones/delete/$zoneId");
      if (res.statusCode == 200) return true;
    } on DioException catch (e) {
      return e.error ?? e.message;
    } catch (e) {
      return e.toString();
    }
  }

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
      return e.toString();
    }
  }

  fetchOrders() async {
    try {
      final res = await _dio.get("/orders/orgorders");
      print(res);
      final orders = (res.data as List)
          .map((orderJson) => Order.fromJson(orderJson))
          .toList();
      print("orders $orders");
      return orders;
    } on DioException catch (e) {
      return e.error ?? e.message;
    } catch (e) {
      return e.toString();
    }
  }

  createOrder(Order order) async {}
}

final orgAdminRepoProvider = Provider((ref) {
  final dio = ref.read(dioProvider);
  return OrgadminRepository(dio);
});
