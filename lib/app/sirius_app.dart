import 'package:flutter/material.dart';

import '../features/auth/presentation/auth_gate.dart';

class SiriusApp extends StatelessWidget {
  const SiriusApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF38BDF8);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    );

    return MaterialApp(
      title: 'Sirius',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFF071426),
      ),
      home: const AuthGate(),
    );
  }
}
