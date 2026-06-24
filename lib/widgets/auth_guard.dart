import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/providers.dart';
import '../routes.dart';

/// Simple route guard for authentication and (optional) role-based access.
///
/// Usage:
/// AuthGuard(role: 'admin', child: AdminDashboard())
/// AuthGuard(child: MainDashboard())
class AuthGuard extends StatelessWidget {
  final Widget child;
  final String? role;

  const AuthGuard({super.key, required this.child, this.role});

  bool _isAllowed(AuthProvider auth) {
    if (role == null || role!.isEmpty) return true;
    final userRole = auth.user?.role;
    return userRole != null && userRole == role;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (auth.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!auth.isAuthenticated) {
          // Not authenticated -> login.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (ModalRoute.of(context)?.isCurrent == true) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            }
          });
          return const SizedBox.shrink();
        }

        if (!_isAllowed(auth)) {
          // Authenticated but role mismatch.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (ModalRoute.of(context)?.isCurrent == true) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.mainDashboard,
                (route) => false,
              );
            }
          });
          return const SizedBox.shrink();
        }

        return child;
      },
    );
  }
}
