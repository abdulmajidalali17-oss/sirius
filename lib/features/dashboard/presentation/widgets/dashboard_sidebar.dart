import 'package:flutter/material.dart';

import '../theme/sirius_palette.dart';

/// Sidebar navigation destinations.
enum DashboardSection {
  dashboard(label: 'Dashboard', icon: Icons.space_dashboard_outlined),
  maps(label: 'My Knowledge Maps', icon: Icons.map_outlined),
  create(label: 'Create New Map', icon: Icons.add_circle_outline),
  explore(label: 'Explore', icon: Icons.explore_outlined),
  activity(label: 'Recent Activity', icon: Icons.history_outlined),
  settings(label: 'Settings', icon: Icons.settings_outlined);

  const DashboardSection({required this.label, required this.icon});
  final String label;
  final IconData icon;
}

/// Fixed left navigation for the desktop dashboard layout.
class DashboardSidebar extends StatelessWidget {
  const DashboardSidebar({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.onLogout,
    this.userName = 'Explorer',
    this.userEmail = 'you@example.com',
  });

  final DashboardSection selected;
  final ValueChanged<DashboardSection> onSelect;
  final VoidCallback? onLogout;
  final String userName;
  final String userEmail;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 264,
      decoration: const BoxDecoration(
        color: SiriusPalette.navy,
        border: Border(right: BorderSide(color: SiriusPalette.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        SiriusPalette.electricBlue,
                        SiriusPalette.primaryBlue,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: SiriusPalette.electricBlue.withValues(
                          alpha: 0.4,
                        ),
                        blurRadius: 16,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Sirius',
                  style: TextStyle(
                    color: SiriusPalette.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                for (final section in DashboardSection.values)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: _SidebarItem(
                      section: section,
                      selected: section == selected,
                      onTap: () => onSelect(section),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(color: SiriusPalette.border, height: 1),
          _userTile(),
          _logoutTile(),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _userTile() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: SiriusPalette.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: SiriusPalette.border),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: SiriusPalette.primaryBlue.withValues(
                alpha: 0.25,
              ),
              child: Text(
                userName.isNotEmpty ? userName[0].toUpperCase() : 'S',
                style: const TextStyle(
                  color: SiriusPalette.electricBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                      color: SiriusPalette.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    userEmail,
                    style: const TextStyle(
                      color: SiriusPalette.textSecondary,
                      fontSize: 11,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _logoutTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: TextButton.icon(
        onPressed: onLogout,
        icon: const Icon(Icons.logout_rounded, size: 18),
        label: const Text('Logout'),
        style: TextButton.styleFrom(
          foregroundColor: SiriusPalette.textSecondary,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.section,
    required this.selected,
    required this.onTap,
  });

  final DashboardSection section;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: selected
                ? LinearGradient(
                    colors: [
                      SiriusPalette.primaryBlue.withValues(alpha: 0.28),
                      SiriusPalette.electricBlue.withValues(alpha: 0.08),
                    ],
                  )
                : null,
            border: selected
                ? Border.all(
                    color: SiriusPalette.electricBlue.withValues(alpha: 0.35),
                  )
                : null,
          ),
          child: Row(
            children: [
              Icon(
                section.icon,
                size: 20,
                color: selected
                    ? SiriusPalette.electricBlue
                    : SiriusPalette.textSecondary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  section.label,
                  style: TextStyle(
                    color: selected
                        ? SiriusPalette.textPrimary
                        : SiriusPalette.textSecondary,
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
