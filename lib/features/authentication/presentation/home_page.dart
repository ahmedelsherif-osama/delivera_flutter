import 'package:delivera_flutter/features/orgadmin_actions/presentation/orgadmin_home.dart';
import 'package:delivera_flutter/features/orgowner_actions/presentation/orgowner_home.dart';
import 'package:delivera_flutter/features/superadmin_actions/presentation/superadmin_home.dart';
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
  // bool _loggingout = false;

  // _logout() async {
  //   print("inside logout");
  //   await ref.read(authProvider.notifier).logout();
  //   print("logged out success");
  // }
  @override
  initState() {
    super.initState();
    // Listen to auth changes
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    if (user == null) {
      return Center(child: Text("User details are missing!"));
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(children: [UserHome(user: user)]),
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
            return OrgadminHome();
          case "Owner":
            return OrgownerHome();
          default:
            return Center(child: Text("Error"));
        }
      default:
        return Center(child: Text("Error"));
    }
  }
}
