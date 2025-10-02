import 'package:delivera_flutter/features/admin_actions/data/admin_actions_repository.dart';
import 'package:delivera_flutter/features/admin_actions/logic/organization_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class SuperadminHome extends StatefulWidget {
  const SuperadminHome({super.key});

  @override
  State<SuperadminHome> createState() => _SuperadminHomeState();
}

class _SuperadminHomeState extends State<SuperadminHome> {
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

class AdminOptionsPage extends StatelessWidget {
  const AdminOptionsPage({
    super.key,
    required this.onSelectOption,
    required this.onBack,
  });
  final Function(Widget page) onSelectOption;
  final Function onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            onSelectOption.call(OrganizationsPage(onBack: onBack));
          },
          child: Container(child: Text("Organizations")),
        ),
        GestureDetector(
          onTap: () {
            onSelectOption.call(UsersPage(onBack: onBack));
          },
          child: Container(child: Text("Users")),
        ),
      ],
    );
  }
}

class OrganizationsPage extends ConsumerStatefulWidget {
  const OrganizationsPage({super.key, required this.onBack});
  final Function onBack;

  @override
  ConsumerState<OrganizationsPage> createState() => _OrganizationsPageState();
}

class _OrganizationsPageState extends ConsumerState<OrganizationsPage> {
  List<Organization> _organizations = [];
  bool _fetchingOrganizations = true;
  String _error = "";

  _fetchOrganizations() async {
    final result = await ref
        .read(adminActionsRepoProvider)
        .fetchOrganizations();

    if (result is List<Organization>) {
      setState(() {
        _organizations = result;
      });
    } else {
      setState(() {
        _error = result;
      });
    }
    setState(() {
      _fetchingOrganizations = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchOrganizations();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        widget.onBack.call();
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(child: Text("Organizations")),
            SizedBox(height: 30),
            if (_fetchingOrganizations) ...[
              Center(child: CircularProgressIndicator()),
            ] else if (_error != "") ...[
              Center(child: Text(_error)),
            ] else ...[
              SizedBox(
                height: 298,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Name")),
                    DataColumn(label: Text("Approved")),
                  ],
                  rows: _organizations
                      .map(
                        (org) => DataRow(
                          cells: [
                            DataCell(Text(org.name)),
                            DataCell(
                              Switch.adaptive(
                                value: org.isApproved,
                                onChanged: (value) {},
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class UsersPage extends StatelessWidget {
  const UsersPage({super.key, required this.onBack});
  final Function onBack;

  @override
  Widget build(Object context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        onBack.call();
      },
      child: Center(child: Text("Users Page")),
    );
  }
}
