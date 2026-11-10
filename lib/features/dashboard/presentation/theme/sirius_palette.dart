import 'package:flutter/material.dart';

/// Sirius dashboard color palette — the blue identity for the dashboard
/// surface. Kept local to the dashboard feature so the app-level [SiriusApp]
/// theme remains untouched while the dashboard adopts its own visual language.
class SiriusPalette {
  SiriusPalette._();

  static const Color navy = Color(0xFF071426);
  static const Color navyLight = Color(0xFF0B1F38);
  static const Color card = Color(0xFF102A46);
  static const Color cardElevated = Color(0xFF153152);
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color electricBlue = Color(0xFF38BDF8);
  static const Color cyan = Color(0xFF22D3EE);
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color border = Color(0xFF1E3A5F);
}
