import 'package:delivera_flutter/features/authentication/logic/auth_provider.dart';
import 'package:delivera_flutter/features/authentication/logic/user_provider.dart';
import 'package:delivera_flutter/features/support_actions/logic/order_model.dart';
import 'package:delivera_flutter/features/support_actions/logic/rider_session_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SupportRepository {
  const SupportRepository(this._dio, this._ref);
  final Dio _dio;
  final Ref _ref;

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

  createOrder(Order order) async {
    try {
      final user = _ref.read(userProvider);
      print(user);
      final orderToSend = order.copyWith(organizationId: user!.organizationId);
      print(orderToSend.toJson());

      final res = await _dio.post(
        '/orders/createorder/',
        data: orderToSend.toJson(),
      );
      return res.statusCode == 201;
    } on DioException catch (e) {
      print(e.toString());
      return e.toString();
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future<dynamic> autoAssignOrder(String orderId) async {
    try {
      final res = await _dio.patch(
        '/ridersessions/assignrider/?orderId=${orderId.toUpperCase()}',
      );
      return res.statusCode == 200;
    } on DioException catch (e) {
      return e.response!.data["message"];
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> assignRiderManually(String riderId, String orderId) async {
    try {
      print("rider $riderId order $orderId");
      final res = await _dio.patch(
        '/ridersessions/admin/assignRider/?orderId=${orderId.toUpperCase()}',
        data: {"riderId": riderId.toUpperCase()},
      );
      return res.statusCode == 200;
    } on DioException catch (e) {
      return e.response!.data["message"];
    } catch (e) {
      return e.toString();
    }
  }

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

  Future<dynamic> cancelOrder(String orderId) async {
    try {
      final res = await _dio.patch(
        '/orders/updateorderstatus/',
        data: {"status": "Canceled", "orderId": orderId},
      );
      return res.statusCode == 200;
    } on DioException catch (e) {
      return e.response!.data["message"];
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> fetchActiveRiderSessions() async {
    try {
      final res = await _dio.get('/ridersessions/all');
      return (res.data as List)
          .map((jsonSession) => RiderSession.fromJson(jsonSession))
          .toList();
    } on DioException catch (e) {
      return e.toString();
    } catch (e) {
      return e.toString();
    }
  }
}

final supportRepoProvider = Provider((ref) {
  final dio = ref.read(dioProvider);
  return SupportRepository(dio, ref);
});
