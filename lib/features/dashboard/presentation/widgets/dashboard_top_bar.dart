import 'package:flutter/material.dart';

import '../theme/sirius_palette.dart';

/// Top navigation bar for the dashboard. Contains the greeting, quick
/// notifications, and a compact user avatar on the right.
class DashboardTopBar extends StatelessWidget {
  const DashboardTopBar({
    super.key,
    this.title = 'Dashboard',
    this.userInitial = 'S',
    this.onAvatarTap,
  });

  final String title;
  final String userInitial;
  final VoidCallback? onAvatarTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: const BoxDecoration(
        color: SiriusPalette.navy,
        border: Border(bottom: BorderSide(color: SiriusPalette.border)),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: SiriusPalette.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
          const Spacer(),
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: SiriusPalette.textSecondary,
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: onAvatarTap,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    SiriusPalette.primaryBlue,
                    SiriusPalette.electricBlue,
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: SiriusPalette.primaryBlue.withValues(alpha: 0.35),
                    blurRadius: 12,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                userInitial,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
