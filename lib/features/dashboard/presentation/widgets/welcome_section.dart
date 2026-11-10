import 'package:flutter/material.dart';

import '../theme/sirius_palette.dart';

/// Hero section: heading, supporting copy, primary CTA, and helper text.
class WelcomeSection extends StatelessWidget {
  const WelcomeSection({super.key, required this.onCreateMap});

  final VoidCallback? onCreateMap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [SiriusPalette.card, SiriusPalette.navyLight],
        ),
        border: Border.all(
          color: SiriusPalette.electricBlue.withValues(alpha: 0.18),
        ),
        boxShadow: [
          BoxShadow(
            color: SiriusPalette.primaryBlue.withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome to Sirius',
            style: TextStyle(
              color: SiriusPalette.textPrimary,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Your ideas deserve more than notes. '
            'Turn them into connected knowledge.',
            style: TextStyle(
              color: SiriusPalette.textSecondary,
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          _PrimaryCta(
            label: 'Create Your First Knowledge Map',
            onTap: onCreateMap,
          ),
          const SizedBox(height: 18),
          const Text(
            'Start with any idea, question, or topic. '
            'Sirius AI will help you organize it into an interactive '
            'knowledge map.',
            style: TextStyle(
              color: SiriusPalette.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryCta extends StatelessWidget {
  const _PrimaryCta({required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [SiriusPalette.primaryBlue, SiriusPalette.electricBlue],
          ),
          boxShadow: [
            BoxShadow(
              color: SiriusPalette.primaryBlue.withValues(alpha: 0.45),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FilledButton.icon(
          onPressed: onTap,
          icon: const Icon(Icons.add_rounded, size: 20),
          label: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }
}
