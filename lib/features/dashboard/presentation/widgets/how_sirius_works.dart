import 'package:flutter/material.dart';

import '../theme/sirius_palette.dart';

/// Three-step explainer of how Sirius works. On wide layouts the steps are
/// laid out horizontally with connecting lines; on narrow layouts they stack
/// vertically.
class HowSiriusWorks extends StatelessWidget {
  const HowSiriusWorks({super.key});

  static const _steps = <_Step>[
    _Step(
      icon: Icons.lightbulb_outline_rounded,
      title: 'Share Your Idea',
      description: 'Enter a topic, question, or concept.',
    ),
    _Step(
      icon: Icons.hub_outlined,
      title: 'Let AI Connect the Dots',
      description: 'Sirius AI identifies key concepts and relationships.',
    ),
    _Step(
      icon: Icons.explore_outlined,
      title: 'Explore Your Knowledge',
      description: 'Navigate your interactive knowledge map and discover new connections.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 720;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How Sirius Works',
              style: TextStyle(
                color: SiriusPalette.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Three simple steps from raw thought to connected knowledge.',
              style: TextStyle(
                color: SiriusPalette.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 20),
            isWide ? _buildHorizontal() : _buildVertical(),
          ],
        );
      },
    );
  }

  Widget _buildHorizontal() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < _steps.length; i++) ...[
          Expanded(
            child: _StepCard(step: _steps[i], index: i + 1),
          ),
          if (i < _steps.length - 1)
            Container(
              margin: const EdgeInsets.only(top: 40, left: 6, right: 6),
              height: 2,
              width: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    SiriusPalette.electricBlue.withValues(alpha: 0.0),
                    SiriusPalette.electricBlue.withValues(alpha: 0.6),
                    SiriusPalette.electricBlue.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildVertical() {
    return Column(
      children: [
        for (var i = 0; i < _steps.length; i++) ...[
          _StepCard(step: _steps[i], index: i + 1),
          if (i < _steps.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _Step {
  const _Step({
    required this.icon,
    required this.title,
    required this.description,
  });
  final IconData icon;
  final String title;
  final String description;
}

class _StepCard extends StatelessWidget {
  const _StepCard({required this.step, required this.index});

  final _Step step;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: SiriusPalette.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: SiriusPalette.electricBlue.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      SiriusPalette.primaryBlue.withValues(alpha: 0.35),
                      SiriusPalette.electricBlue.withValues(alpha: 0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: SiriusPalette.electricBlue.withValues(alpha: 0.4),
                  ),
                ),
                child: Icon(
                  step.icon,
                  color: SiriusPalette.electricBlue,
                  size: 20,
                ),
              ),
              const Spacer(),
              Text(
                '0$index',
                style: TextStyle(
                  color: SiriusPalette.electricBlue.withValues(alpha: 0.5),
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            step.title,
            style: const TextStyle(
              color: SiriusPalette.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            step.description,
            style: const TextStyle(
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
