import 'package:flutter/material.dart';
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
                top: 50,
              ),
              child: SvgPicture.asset("assets/delivera_logo.svg", height: 100),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0, bottom: 25),
              child: Text("Your fleet, empowered!"),
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

class OrganizationsPage extends StatelessWidget {
  const OrganizationsPage({super.key, required this.onBack});
  final Function onBack;

  @override
  Widget build(Object context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        onBack.call();
      },
      child: Center(child: Text("Organizations Page")),
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
