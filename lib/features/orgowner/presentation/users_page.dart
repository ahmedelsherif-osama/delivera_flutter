import 'package:delivera_flutter/features/authentication/logic/user_model.dart';
import 'package:delivera_flutter/features/orgowner/data/orgowner_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsersPage extends ConsumerStatefulWidget {
  const UsersPage({super.key, required this.onBack});
  final Function onBack;

  @override
  ConsumerState<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends ConsumerState<UsersPage> {
  List<User> _users = [];
  bool _fetchingUsers = true;
  String _error = "";

  _fetchUsers() async {
    final result = await ref.read(orgOwnerRepoProvider).fetchUsers();

    if (result is List<User>) {
      setState(() {
        _users = result;
      });
    } else {
      setState(() {
        _error = result;
      });
    }
    setState(() {
      _fetchingUsers = false;
    });
    final test = (result as List).map((e) => print((e as User).toJson()));
    print("fetched org users in UI $test");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    print("org users page");
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
                "Users",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            SizedBox(height: 10),
            if (_fetchingUsers) ...[
              Center(child: CircularProgressIndicator()),
            ] else if (_error != "") ...[
              Center(child: Text(_error)),
            ] else ...[
              SizedBox(
                height: 526,
                child: SingleChildScrollView(
                  child: DataTable(
                    columnSpacing: 30,
                    columns: const [
                      DataColumn(label: Text("ID")),
                      DataColumn(label: Text("Name")),
                      DataColumn(label: Text("Approved")),
                    ],
                    rows: _users
                        .map(
                          (user) => DataRow(
                            cells: [
                              DataCell(Text(user.id.substring(0, 8))),
                              DataCell(Text(user.username)),
                              DataCell(
                                CustomSwitch(
                                  isApproved: user.isOrgOwnerApproved!,
                                  userId: user.id,
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
    required this.userId,
  });
  final bool isApproved;
  final String userId;

  @override
  ConsumerState<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends ConsumerState<CustomSwitch> {
  bool? _isApproved;
  bool _isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isApproved = widget.isApproved;
    _isLoading = false;
  }

  _updateApproval(String userId) async {
    print("inside update approval");

    final result = _isApproved!
        ? await ref
              .read(orgOwnerRepoProvider)
              .approveUserByOrgOwner(userId.toUpperCase())
        : await ref
              .read(orgOwnerRepoProvider)
              .revokeUserByOrgOwner(userId.toUpperCase());
    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("User ${_isApproved! ? "approved" : "revoked"}!"),
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
    if (_isLoading) {
      return Container();
    }
    return Switch.adaptive(
      value: _isApproved!,
      onChanged: (value) {
        setState(() {
          _isApproved = value;
        });
        _updateApproval(widget.userId);
      },
    );
  }
}
