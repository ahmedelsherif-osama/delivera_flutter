import 'package:delivera_flutter/features/orgadmin_actions/data/orgadmin_repository.dart';
import 'package:delivera_flutter/features/orgadmin_actions/logic/order_model.dart';
import 'package:delivera_flutter/features/superadmin_actions/data/admin_actions_repository.dart';
import 'package:delivera_flutter/features/superadmin_actions/logic/organization_model.dart';
import 'package:delivera_flutter/features/utils/string_casing_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrdersPage extends ConsumerStatefulWidget {
  const OrdersPage({super.key, required this.onBack});
  final Function onBack;

  @override
  ConsumerState<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends ConsumerState<OrdersPage> {
  List<Order> _orders = [];
  bool _fetchingOrders = true;
  String _error = "";

  _fetchOrders() async {
    final result = await ref.read(orgAdminRepoProvider).fetchOrders();

    if (result is List<Order>) {
      setState(() {
        _orders = result;
      });
    } else {
      setState(() {
        _error = result;
      });
    }
    setState(() {
      _fetchingOrders = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        widget.onBack.call();
      },
      child: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Text(
                    "Orders",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                SizedBox(height: 10),
                if (_fetchingOrders) ...[
                  Center(child: CircularProgressIndicator()),
                ] else if (_error != "") ...[
                  Center(child: Text(_error)),
                ] else ...[
                  SizedBox(
                    height: 400,
                    child: SingleChildScrollView(
                      child: DataTable(
                        columnSpacing: 60,
                        columns: const [
                          DataColumn(label: Text("Order#")),
                          DataColumn(label: Text("Details")),
                        ],
                        rows: _orders
                            .map(
                              (order) => DataRow(
                                cells: [
                                  DataCell(Text(order.id.substring(0, 8))),
                                  DataCell(Text(order.orderDetails)),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: 10),

          ElevatedButton(
            onPressed: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => CreateZonePage(
              //       onSuccess: (zone) {
              //         setState(() {
              //           // _zones.add(zone);
              //           _fetchZones();
              //         });
              //       },
              //     ),
              //   ),
              // );
            },
            child: Text("Create Order"),
          ),
        ],
      ),
    );
  }
}
