import 'package:flutter/material.dart';

import '../theme/sirius_palette.dart';

/// Static illustrative preview of the kind of knowledge map Sirius will
/// generate. Uses a deterministic custom painter so no animation, random
/// values, or third-party graph library is required.
class KnowledgeMapPreview extends StatelessWidget {
  const KnowledgeMapPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: SiriusPalette.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: SiriusPalette.electricBlue.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Preview · Knowledge Map',
            style: TextStyle(
              color: SiriusPalette.textSecondary,
              fontSize: 12,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          AspectRatio(
            aspectRatio: 16 / 10,
            child: Container(
              decoration: BoxDecoration(
                color: SiriusPalette.navy,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: SiriusPalette.border),
                gradient: RadialGradient(
                  center: const Alignment(-0.2, -0.3),
                  radius: 1.1,
                  colors: [
                    SiriusPalette.primaryBlue.withValues(alpha: 0.18),
                    SiriusPalette.navy,
                  ],
                ),
              ),
              child: CustomPaint(
                painter: _KnowledgeMapPainter(),
                size: Size.infinite,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'This is how your ideas will appear once Sirius organizes them.',
            style: TextStyle(
              color: SiriusPalette.textSecondary,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _KnowledgeMapPainter extends CustomPainter {
  static const _center = Offset(0.5, 0.5);

  static const _nodes = <_PreviewNode>[
    _PreviewNode(label: 'Machine Learning', pos: Offset(0.16, 0.30)),
    _PreviewNode(label: 'Deep Learning', pos: Offset(0.84, 0.26)),
    _PreviewNode(label: 'Neural Networks', pos: Offset(0.86, 0.74)),
    _PreviewNode(
      label: 'Natural Language\nProcessing',
      pos: Offset(0.14, 0.74),
    ),
    _PreviewNode(label: 'Computer Vision', pos: Offset(0.50, 0.88)),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final centerPx = Offset(_center.dx * size.width, _center.dy * size.height);

    final edgePaint = Paint()
      ..color = SiriusPalette.electricBlue.withValues(alpha: 0.35)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw edges first, then glow, then solid nodes, then labels.
    for (final node in _nodes) {
      final nodePx = Offset(
        node.pos.dx * size.width,
        node.pos.dy * size.height,
      );
      canvas.drawLine(centerPx, nodePx, edgePaint);
    }

    _drawGlow(canvas, centerPx, 26, SiriusPalette.electricBlue);
    for (final node in _nodes) {
      final nodePx = Offset(
        node.pos.dx * size.width,
        node.pos.dy * size.height,
      );
      _drawGlow(canvas, nodePx, 14, SiriusPalette.electricBlue);
    }

    _drawNode(canvas, centerPx, 12, SiriusPalette.electricBlue);
    for (final node in _nodes) {
      final nodePx = Offset(
        node.pos.dx * size.width,
        node.pos.dy * size.height,
      );
      _drawNode(canvas, nodePx, 7, SiriusPalette.cyan);
    }

    _drawLabel(
      canvas,
      centerPx + const Offset(0, 22),
      'Artificial Intelligence',
      color: SiriusPalette.textPrimary,
      fontSize: 12,
      fontWeight: FontWeight.w700,
    );

    for (final node in _nodes) {
      final nodePx = Offset(
        node.pos.dx * size.width,
        node.pos.dy * size.height,
      );
      final labelOffset = node.pos.dy > 0.5
          ? const Offset(0, 14)
          : const Offset(0, -20);
      _drawLabel(
        canvas,
        nodePx + labelOffset,
        node.label,
        color: SiriusPalette.textSecondary,
        fontSize: 9,
      );
    }
  }

  void _drawGlow(Canvas canvas, Offset center, double radius, Color color) {
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = color.withValues(alpha: 0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );
  }

  void _drawNode(Canvas canvas, Offset center, double radius, Color color) {
    canvas.drawCircle(center, radius, Paint()..color = color);
    canvas.drawCircle(
      center,
      radius * 0.35,
      Paint()..color = Colors.white.withValues(alpha: 0.8),
    );
  }

  void _drawLabel(
    Canvas canvas,
    Offset anchor,
    String text, {
    required Color color,
    required double fontSize,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 140);
    painter.paint(
      canvas,
      anchor - Offset(painter.width / 2, painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PreviewNode {
  const _PreviewNode({required this.label, required this.pos});
  final String label;
  final Offset pos;
}
