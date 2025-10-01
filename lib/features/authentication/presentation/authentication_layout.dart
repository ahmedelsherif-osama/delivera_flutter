import 'package:delivera_flutter/features/authentication/presentation/login_page.dart';
import 'package:delivera_flutter/features/authentication/presentation/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AuthenticationLayout extends StatefulWidget {
  const AuthenticationLayout({super.key});

  @override
  State<AuthenticationLayout> createState() => _AuthenticationLayoutState();
}

class _AuthenticationLayoutState extends State<AuthenticationLayout> {
  bool _haveAnAccount = true;

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

            _haveAnAccount
                ? LoginPage(
                    changeAccountStatus: () {
                      setState(() => _haveAnAccount = false);
                    },
                  )
                : RegistrationPage(
                    onBack: () {
                      setState(() => _haveAnAccount = true);
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
