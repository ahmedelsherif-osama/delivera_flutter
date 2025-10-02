import 'package:delivera_flutter/features/admin_actions/presentation/superadmin_home.dart';
import 'package:delivera_flutter/features/authentication/logic/auth_provider.dart';
import 'package:delivera_flutter/features/authentication/logic/user_model.dart';
import 'package:delivera_flutter/features/authentication/logic/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _loggingout = false;
  @override
  initState() {
    super.initState();
    // Listen to auth changes
  }

  _logout() async {
    print("inside logout");
    await ref.read(authProvider.notifier).logout();
    print("logged out success");
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    if (user == null) {
      return Center(child: Text("User details are missing!"));
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          UserHome(user: user),
          // ElevatedButton(onPressed: _logout, child: Text("Logout")),
          // _loggingout
          //     ? Center(child: CircularProgressIndicator())
          //     : Container(),
        ],
      ),
    );
  }
}

class UserHome extends StatelessWidget {
  const UserHome({super.key, required this.user});
  final User user;
  @override
  Widget build(BuildContext context) {
    switch (user.globalRole) {
      case "SuperAdmin":
        return SuperadminHome();
      case "OrgUser":
        switch (user.organizationRole) {
          case "Rider":
            return Center(child: Text("Rider home"));
          case "Support":
            return Center(child: Text("Org support home"));
          case "Admin":
            return Center(child: Text("Org admin home"));
          case "Owner":
            return Center(child: Text("Org owner home"));
          default:
            return Center(child: Text("Error"));
        }
      default:
        return Center(child: Text("Error"));
    }
  }
}
