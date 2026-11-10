import 'package:flutter/material.dart';

import '../theme/sirius_palette.dart';
import 'dashboard_sidebar.dart';

/// Bottom navigation used on mobile layouts.
class MobileBottomNav extends StatelessWidget {
  const MobileBottomNav({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  final DashboardSection selected;
  final ValueChanged<DashboardSection> onSelect;

  static const _visibleSections = <DashboardSection>[
    DashboardSection.dashboard,
    DashboardSection.maps,
    DashboardSection.create,
    DashboardSection.explore,
    DashboardSection.settings,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: SiriusPalette.navy,
        border: Border(top: BorderSide(color: SiriusPalette.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (final section in _visibleSections)
                _NavButton(
                  section: section,
                  selected: section == selected,
                  onTap: () => onSelect(section),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.section,
    required this.selected,
    required this.onTap,
  });

  final DashboardSection section;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? SiriusPalette.electricBlue
        : SiriusPalette.textSecondary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(section.icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(
              section == DashboardSection.maps
                  ? 'Maps'
                  : section == DashboardSection.create
                  ? 'Create'
                  : section.label.split(' ').first,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
