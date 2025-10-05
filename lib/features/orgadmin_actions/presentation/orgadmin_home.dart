import 'package:delivera_flutter/features/superadmin_actions/presentation/organizations_page.dart';
import 'package:delivera_flutter/features/superadmin_actions/presentation/users_page.dart';
import 'package:delivera_flutter/features/authentication/logic/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class OrgadminHome extends StatefulWidget {
  const OrgadminHome({super.key});

  @override
  State<OrgadminHome> createState() => _OrgadminHomeState();
}

class _OrgadminHomeState extends State<OrgadminHome> {
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

            Column(
              children: [
                _currentPage ??
                    AdminOptionsPage(
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
          ],
        ),
      ),
    );
  }
}

class AdminOptionsPage extends ConsumerStatefulWidget {
  const AdminOptionsPage({
    super.key,
    required this.onSelectOption,
    required this.onBack,
  });
  final Function(Widget page) onSelectOption;
  final Function onBack;

  @override
  ConsumerState<AdminOptionsPage> createState() => _AdminOptionsPageState();
}

class _AdminOptionsPageState extends ConsumerState<AdminOptionsPage> {
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
                  widget.onSelectOption.call(
                    OrganizationsPage(onBack: widget.onBack),
                  );
                },
                child: Container(
                  child: Text(
                    "Zones",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ),
              SizedBox(height: 60),

              GestureDetector(
                onTap: () {
                  widget.onSelectOption.call(UsersPage(onBack: widget.onBack));
                },
                child: Container(
                  child: Text(
                    "Users",
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
