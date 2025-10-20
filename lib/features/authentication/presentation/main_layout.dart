import 'package:delivera_flutter/features/authentication/data/token_storage.dart';
import 'package:delivera_flutter/features/authentication/data/user_storage.dart';
import 'package:delivera_flutter/features/authentication/logic/auth_provider.dart';
import 'package:delivera_flutter/features/authentication/logic/user_provider.dart';
import 'package:delivera_flutter/features/authentication/presentation/authentication_layout.dart';
import 'package:delivera_flutter/features/authentication/presentation/home_page.dart';
import 'package:delivera_flutter/features/authentication/presentation/login_page.dart';
import 'package:delivera_flutter/features/authentication/presentation/splash_page.dart';
import 'package:delivera_flutter/features/notifications/services/notifications_service.dart';
import 'package:delivera_flutter/features/notifications/services/system_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class MainLayout extends ConsumerStatefulWidget {
  const MainLayout({super.key});

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  bool showingSplash = true;

  delayForSplash() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      showingSplash = false;
    });
  }

  @override
  void initState() {
    super.initState();
    delayForSplash();
  }

  _startNotificationService() async {
    final token = await TokenStorage().getAccessToken();
    final user = await ref.read(userStorageProvider).getUser();
    print("token $token and user ${user!.id} in main layout");
    final notificationService = ref.read(notificationServiceProvider);
    await notificationService.connect(token!, user.id);
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.watch(authProvider);

    Widget body;

    if (showingSplash) {
      body = const SplashPage();
    } else if (isLoggedIn.isLoading) {
      body = const SplashPage();
    } else if (isLoggedIn.hasError) {
      body = Center(child: Text(isLoggedIn.error.toString()));
    } else if (isLoggedIn.value == true) {
      _startNotificationService();
      body = const HomePage();
    } else {
      body = const AuthenticationLayout(); // 👈 clean, no Expanded/Column
    }

    return Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Do you wish to exit Delivera?",
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).scaffoldBackgroundColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                SystemNavigator.pop();
                              },
                              child: Text(
                                "Yes",
                                style: Theme.of(context).textTheme.bodySmall!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).scaffoldBackgroundColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "No",
                                style: Theme.of(context).textTheme.bodySmall!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: body,
      ),
    );
  }
}
