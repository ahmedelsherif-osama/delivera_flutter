import 'package:delivera_flutter/core/theme/app_theme.dart';
import 'package:delivera_flutter/features/authentication/presentation/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Delivera',

        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        home: MainLayout(),
      ),
    );
  }
}
