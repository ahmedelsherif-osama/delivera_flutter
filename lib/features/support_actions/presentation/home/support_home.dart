import 'package:delivera_flutter/core/shared_widgets/exit_dialog.dart';
import 'package:delivera_flutter/features/support_actions/presentation/order/orders_page.dart';

import 'package:delivera_flutter/features/authentication/logic/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class SupportHome extends StatefulWidget {
  const SupportHome({super.key});

  @override
  State<SupportHome> createState() => _SupportHomeState();
}

class _SupportHomeState extends State<SupportHome> {
  Widget? _currentPage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
              child: SvgPicture.asset("assets/delivera_logo.svg", height: 100),
            ),

            PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                if (_currentPage == null) {
                  showDialog(
                    context: context,
                    builder: (context) => ExitDialog(),
                  );
                }
              },
              child: Column(
                children: [
                  _currentPage ??
                      SupportOptionsPage(
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
    );
  }
}

class SupportOptionsPage extends ConsumerStatefulWidget {
  const SupportOptionsPage({
    super.key,
    required this.onSelectOption,
    required this.onBack,
  });
  final Function(Widget page) onSelectOption;
  final Function onBack;

  @override
  ConsumerState<SupportOptionsPage> createState() => _SupportOptionsPageState();
}

class _SupportOptionsPageState extends ConsumerState<SupportOptionsPage> {
  bool _loggingout = false;

  _logout() async {
    print("inside logout");
    await ref.read(authProvider.notifier).logout();
    print("logged out success");
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
        SizedBox(height: 90),
        SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  widget.onSelectOption.call(OrdersPage(onBack: widget.onBack));
                },
                child: Container(
                  child: Text(
                    "Orders",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
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
