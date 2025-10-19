import 'package:delivera_flutter/features/authentication/logic/auth_provider.dart';
import 'package:delivera_flutter/features/rider_actions/data/rider_repository.dart';
import 'package:delivera_flutter/features/rider_actions/logic/order_model.dart';
import 'package:delivera_flutter/features/rider_actions/presentation/order/order_history_widget.dart';
import 'package:delivera_flutter/features/rider_actions/presentation/order/view_order_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class RiderHome extends ConsumerStatefulWidget {
  const RiderHome({super.key});

  @override
  ConsumerState<RiderHome> createState() => _RiderHomeState();
}

class _RiderHomeState extends ConsumerState<RiderHome> {
  Widget? _currentPage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 720,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  bottom: 10,
                  right: 50,
                  top: 10,
                ),
                child: SvgPicture.asset(
                  "assets/delivera_logo.svg",
                  height: 100,
                ),
              ),

              SizedBox(
                child: Column(
                  children: [
                    _currentPage ??
                        RiderOptionsPage(
                          onBack: () {
                            setState(() {
                              _currentPage = null;
                            });
                          },
                          onSelectOption: (page) {
                            setState(() {
                              _currentPage = page;
                            });
                          },
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RiderOptionsPage extends ConsumerStatefulWidget {
  const RiderOptionsPage({
    super.key,
    required this.onSelectOption,
    required this.onBack,
  });
  final Function(Widget page) onSelectOption;
  final Function onBack;

  @override
  ConsumerState<RiderOptionsPage> createState() => _RiderOptionsPageState();
}

class _RiderOptionsPageState extends ConsumerState<RiderOptionsPage> {
  bool _loggingout = false;

  _logout() async {
    print("inside logout");
    await ref.read(authProvider.notifier).logout();
    print("logged out success");
  }

  Order? _currentOrder;
  bool _fetchingCurrentOrder = true;
  String _error = "";

  _fetchCurrentOrder() async {
    final result = await ref.read(riderRepoProvider).fetchCurrentOrder();
    if (result is Order) {
      setState(() {
        _currentOrder = result;
      });
    } else {
      setState(() {
        _error = result;
      });
    }
    setState(() {
      _fetchingCurrentOrder = false;
    });
  }

  @override
  initState() {
    super.initState();
    _fetchCurrentOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            "Your fleet, empowered!",
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Current Order:",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              // SizedBox(height: 30),
              if (_fetchingCurrentOrder) ...[
                Center(child: CircularProgressIndicator()),
              ] else if (_error != "") ...[
                Center(
                  child: Text(
                    _error,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ] else ...[
                SizedBox(
                  height: 742,
                  child: Expanded(
                    child: ViewOrderPage(
                      order: _currentOrder!,
                      omitTitle: true,
                    ),
                  ),
                ),
              ],

              SizedBox(height: 0),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => OrderHistoryWidget(),
                    ),
                  );
                },
                child: Text(
                  "Order History",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 60),
        ElevatedButton(onPressed: _logout, child: Text("Logout")),
        _loggingout ? Center(child: CircularProgressIndicator()) : Container(),
      ],
    );
  }
}
