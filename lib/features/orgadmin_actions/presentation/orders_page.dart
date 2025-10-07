import 'package:delivera_flutter/features/orgadmin_actions/data/orgadmin_repository.dart';
import 'package:delivera_flutter/features/orgadmin_actions/logic/order_model.dart';
import 'package:delivera_flutter/features/orgadmin_actions/presentation/create_order.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrdersPage extends ConsumerStatefulWidget {
  const OrdersPage({super.key, required this.onBack});
  final Function onBack;

  @override
  ConsumerState<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends ConsumerState<OrdersPage> {
  Widget? _selectedChild;

  @override
  void initState() {
    super.initState();
    _selectedChild = _buildViewOrders();
  }

  void _onBack() {
    setState(() {
      _selectedChild = _buildViewOrders();
    });
  }

  void _onCreateOrder() {
    setState(() {
      _selectedChild = CreateOrder(onBack: _onBack);
    });
  }

  Widget _buildViewOrders() {
    return ViewOrders(onBack: widget.onBack, onCreateOrder: _onCreateOrder);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (_selectedChild == ViewOrder()) {
          widget.onBack.call();
        } else {
          _onBack();
        }
      },
      child: _selectedChild == null
          ? Center(child: CircularProgressIndicator())
          : _selectedChild!,
    );
  }
}

class ViewOrders extends ConsumerStatefulWidget {
  const ViewOrders({
    super.key,
    required this.onBack,
    required this.onCreateOrder,
  });
  final Function onBack;
  final Function onCreateOrder;
  @override
  ConsumerState<ViewOrders> createState() => _ViewOrdersState();
}

class _ViewOrdersState extends ConsumerState<ViewOrders> {
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
              widget.onCreateOrder.call();
            },
            child: Text("Create Order"),
          ),
        ],
      ),
    );
  }
}

class ViewOrder extends StatelessWidget {
  const ViewOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Container(child: Text("View Order")));
  }
}
