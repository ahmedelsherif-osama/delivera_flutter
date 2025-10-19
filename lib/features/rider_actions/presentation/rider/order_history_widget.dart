import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:delivera_flutter/features/orgadmin_actions/logic/order_model.dart';

class OrderHistoryWidget extends StatelessWidget {
  final List<Order> orders;

  const OrderHistoryWidget({super.key, required this.orders});

  /// Group orders by month/year (e.g. "Oct 2025")
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

  /// Color for order status chip
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
    final groupedOrders = _groupOrdersByMonth(orders);

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            "Order History",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),

        SizedBox(
          height: 500,
          width: 300,
          child: orders.isEmpty
              ? const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text(
                    "No past orders found.",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: groupedOrders.entries.length,
                  itemBuilder: (context, index) {
                    final entry = groupedOrders.entries.toList()[index];
                    return ExpansionTile(
                      title: Text(
                        entry.key,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      children: entry.value.map((order) {
                        return ListTile(
                          title: Text(
                            "Order #${order.id.substring(0, 6).toUpperCase()}",
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            "Pickup: ${order.pickUpLocation.address}\nDropoff: ${order.dropOffLocation.address}",
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: Chip(
                            label: Text(order.status.name),
                            backgroundColor: _statusColor(order.status),
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
        ),

        // //         if (orders.isEmpty) ...[
        // //           const Padding(
        // //             padding: EdgeInsets.only(top: 16.0),
        // //             child: Text(
        // //               "No past orders found.",
        // //               style: TextStyle(color: Colors.grey),
        // //             ),
        // //           ),
        // //         ] else ...[
        // // Column(
        // //       crossAxisAlignment: CrossAxisAlignment.start,
        // //       children: [

        // //         SizedBox(
        // //           height: 400,
        // //           child: ListView.builder(
        // //             itemCount: groupedOrders.entries.length,
        // //             itemBuilder: (context, index) {
        // //               final entry = groupedOrders.entries.toList()[index];
        // //               return ExpansionTile(
        // //                 title: Text(
        // //                   entry.key,
        // //                   style: const TextStyle(fontWeight: FontWeight.bold),
        // //                 ),
        // //                 children: entry.value.map((order) {
        // //                   return ListTile(
        // //                     title: Text(
        // //                       "Order #${order.id.substring(0, 6).toUpperCase()}",
        // //                       style: const TextStyle(fontWeight: FontWeight.w500),
        // //                     ),
        // //                     subtitle: Text(
        // //                       "Pickup: ${order.pickUpLocation.address}\nDropoff: ${order.dropOffLocation.address}",
        // //                       style: const TextStyle(fontSize: 12),
        // //                     ),
        // //                     trailing: Chip(
        // //                       label: Text(order.status.name),
        // //                       backgroundColor: _statusColor(order.status),
        // //                       labelStyle: const TextStyle(color: Colors.white),
        // //                     ),
        // //                   );
        // //                 }).toList(),
        // //               );
        // //             },
        // //           ),
        // //         ),
        // //       ],
        // //     ),
        //         ]
      ],
    );

    // return
  }
}
