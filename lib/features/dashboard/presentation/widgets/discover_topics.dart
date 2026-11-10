import 'package:flutter/material.dart';

import '../theme/sirius_palette.dart';

/// Suggests example topics a new user might explore first. These are examples,
/// not the user's content, and do not mutate any state on their own.
class DiscoverTopics extends StatelessWidget {
  const DiscoverTopics({
    super.key,
    required this.onExploreTopic,
    this.topics = const [
      'Artificial Intelligence',
      'Technology',
      'Science',
      'Business',
      'Personal Development',
    ],
  });

  final ValueChanged<String>? onExploreTopic;
  final List<String> topics;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Discover Sirius',
          style: TextStyle(
            color: SiriusPalette.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Try one of these starting points to see how Sirius connects ideas.',
          style: TextStyle(color: SiriusPalette.textSecondary, fontSize: 13),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final topic in topics)
              _TopicChip(
                label: topic,
                onTap: () => onExploreTopic?.call(topic),
              ),
          ],
        ),
      ],
    );
  }
}

class _TopicChip extends StatelessWidget {
  const _TopicChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: SiriusPalette.card,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: SiriusPalette.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.auto_awesome_rounded,
              size: 14,
              color: SiriusPalette.cyan,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: SiriusPalette.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
