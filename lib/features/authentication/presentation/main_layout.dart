import 'package:delivera_flutter/features/authentication/logic/auth_provider.dart';
import 'package:delivera_flutter/features/authentication/presentation/home_page.dart';
import 'package:delivera_flutter/features/authentication/presentation/login_page.dart';
import 'package:delivera_flutter/features/authentication/presentation/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainLayout extends ConsumerStatefulWidget {
  const MainLayout({super.key});

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  bool showingSplash = true;

  delayForSplash() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      showingSplash = false;
    });
  }

  @override
  void initState() {
    super.initState();
    delayForSplash();
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.watch(authProvider);
    return Scaffold(
      body: Column(
        children: [
          if (showingSplash) ...[
            const SplashPage(),
          ] else ...[
            if (isLoggedIn.isLoading) ...[
              const SplashPage(),
            ] else if (isLoggedIn.value == true) ...[
              HomePage(),
            ] else if (isLoggedIn.value == false) ...[
              LoginPage(),
            ] else if (isLoggedIn.hasError) ...[
              Center(child: Text(isLoggedIn.error.toString())),
            ],
          ],
        ],
      ),
    );
  }
}
