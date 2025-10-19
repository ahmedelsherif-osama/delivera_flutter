import 'dart:convert';

import 'package:delivera_flutter/features/authentication/logic/auth_provider.dart';
import 'package:delivera_flutter/features/authentication/logic/user_provider.dart';
import 'package:delivera_flutter/features/rider_actions/logic/order_model.dart';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RiderRepository {
  const RiderRepository(this._dio, this._ref);
  final Dio _dio;
  final Ref _ref;

  Future<dynamic> completeOrder(String orderId) async {
    try {
      print("inside complete repo");
      final res = await _dio.patch(
        '/orders/updateorderstatus/',
        data: {"status": "Delivered", "orderId": orderId},
      );
      return res.statusCode == 200;
    } on DioException catch (e) {
      return e.toString();
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> pickupOrder(String orderId) async {
    try {
      print("inside complete repo");
      final res = await _dio.patch(
        '/orders/updateorderstatus/',
        data: {"status": "PickedUp", "orderId": orderId},
      );
      return res.statusCode == 200;
    } on DioException catch (e) {
      return e.toString();
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> fetchRiderOrders() async {
    final riderId = _ref.read(userProvider)!.id;
    try {
      final res = await _dio.get('/orders/rider/all/${riderId.toUpperCase()}');
      return (res.data as List)
          .map((jsonOrder) => Order.fromJson(jsonOrder))
          .toList();
    } on DioException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> fetchCurrentOrder() async {
    final riderId = _ref.read(userProvider)!.id;
    try {
      final res = await _dio.get('/orders/rider/currentorder');

      return Order.fromJson(res.data);
    } on DioException catch (e) {
      return e.response!.data["message"];
    } catch (e) {
      return e.toString();
    }
  }
}

final riderRepoProvider = Provider((ref) {
  final dio = ref.read(dioProvider);
  return RiderRepository(dio, ref);
});
