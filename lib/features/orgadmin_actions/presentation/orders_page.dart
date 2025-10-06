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
            Center(
              child: Text(
                "Organizations",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            SizedBox(height: 10),
            if (_fetchingOrganizations) ...[
              Center(child: CircularProgressIndicator()),
            ] else if (_error != "") ...[
              Center(child: Text(_error)),
            ] else ...[
              SizedBox(
                height: 518,
                child: SingleChildScrollView(
                  child: DataTable(
                    columnSpacing: 10,
                    columns: const [
                      DataColumn(label: Text("Registration#")),
                      DataColumn(label: Text("Name")),
                      DataColumn(label: Text("Approved")),
                    ],
                    rows: _organizations
                        .map(
                          (org) => DataRow(
                            cells: [
                              DataCell(Text(org.registrationNumber)),
                              DataCell(Text(org.name)),
                              DataCell(
                                CustomSwitch(
                                  isApproved: org.isApproved,
                                  organizationId: org.id,
                                ),
                              ),
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
    );
  }
}

class CustomSwitch extends ConsumerStatefulWidget {
  const CustomSwitch({
    super.key,
    required this.isApproved,
    required this.organizationId,
  });
  final bool isApproved;
  final String organizationId;

  @override
  ConsumerState<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends ConsumerState<CustomSwitch> {
  bool? _isApproved;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _isApproved = widget.isApproved;
    _isLoading = false;
  }

  _updateApproval(String organizationId) async {
    print("inside update approval");

    final result = _isApproved!
        ? await ref
              .read(adminActionsRepoProvider)
              .approveOrg(organizationId.toUpperCase())
        : await ref
              .read(adminActionsRepoProvider)
              .revokeOrg(organizationId.toUpperCase());
    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Organization ${_isApproved! ? "approved" : "revoked"}!",
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $result")));
      setState(() {
        _isApproved = widget.isApproved;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    print("Primary: ${scheme.primary}");
    print("OnSurface: ${scheme.onSurface}");
    if (_isLoading) {
      return Container();
    }
    return Switch.adaptive(
      value: _isApproved!,
      onChanged: (value) {
        setState(() {
          _isApproved = value;
        });
        _updateApproval(widget.organizationId);
      },
    );
  }
}
