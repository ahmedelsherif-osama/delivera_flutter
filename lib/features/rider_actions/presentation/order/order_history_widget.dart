import 'package:delivera_flutter/features/rider_actions/data/rider_repository.dart';
import 'package:delivera_flutter/features/rider_actions/logic/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class OrderHistoryWidget extends ConsumerStatefulWidget {
  const OrderHistoryWidget({super.key});

  @override
  ConsumerState<OrderHistoryWidget> createState() => _OrderHistoryWidgetState();
}

class _OrderHistoryWidgetState extends ConsumerState<OrderHistoryWidget> {
  List<Order>? _orders;
  bool _isFetchingOrders = true;
  String _error = "";
  Map<String, List<Order>>? groupedOrders;

  @override
  initState() {
    super.initState();
    _fetchOrders();
  }

  _fetchOrders() async {
    final result = await ref.read(riderRepoProvider).fetchRiderOrders();

    if (result is List<Order>) {
      setState(() {
        _orders = result;
        groupedOrders = _groupOrdersByMonth(_orders!);
      });
    } else {
      setState(() {
        _error = result;
      });
    }
    setState(() {
      _isFetchingOrders = false;
    });
  }

  Map<String, List<Order>> _groupOrdersByMonth(List<Order> orders) {
    final Map<String, List<Order>> grouped = {};
    final dateFormat = DateFormat('MMM yyyy');

    for (var order in orders) {
      final key = dateFormat.format(order.createdAt);
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(order);
    }

    return grouped;
  }

  Color _statusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.canceled:
        return Colors.red;
      case OrderStatus.assigned:
        return Colors.blueGrey;
      case OrderStatus.created:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 120, vertical: 30),
            child: Text(
              "Order History",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          SizedBox(
            height: 500,
            width: 300,
            child: Column(
              children: [
                if (_isFetchingOrders) ...[
                  Center(child: CircularProgressIndicator()),
                ] else if (_error != "") ...[
                  Center(child: Text(_error)),
                ] else ...[
                  _orders!.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Text(
                            "No past orders found.",
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: groupedOrders!.entries.length,
                            itemBuilder: (context, index) {
                              final entry = groupedOrders!.entries
                                  .toList()[index];
                              return ExpansionTile(
                                title: Text(
                                  entry.key,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                children: entry.value.map((order) {
                                  return ListTile(
                                    title: Text(
                                      "Order #${order.id.substring(0, 6).toUpperCase()}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "Pickup: ${order.pickUpLocation.address}\nDropoff: ${order.dropOffLocation.address}",
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    trailing: Chip(
                                      label: Text(order.status.name),
                                      backgroundColor: _statusColor(
                                        order.status,
                                      ),
                                      labelStyle: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
