import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/auth_providers.dart';
import 'login_screen.dart';
import '../../dashboard/presentation/dashboard_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const LoginScreen();
        }

        return const DashboardScreen();
      },
      loading: () => const Scaffold(
        backgroundColor: Color(0xFF071426),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF38BDF8)),
        ),
      ),
      error: (error, stackTrace) =>
          Scaffold(body: Center(child: Text('Authentication error: $error'))),
    );
  }
}
