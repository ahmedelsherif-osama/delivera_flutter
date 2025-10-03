import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(left: 0, right: 50, top: 50, bottom: 50),
      child: Column(
        children: [
          SizedBox(height: 120),
          Center(child: SvgPicture.asset('assets/delivera_logo.svg')),
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Text(
              "Your fleet, empowered!",
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ],
      ),
    );
  }
}
