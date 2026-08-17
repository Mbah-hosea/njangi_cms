import 'package:flutter/material.dart';

/// Njangi CMS Brand Colour Palette
/// Deep Forest Green + Warm Gold = trust, community, African identity
class AppColors {
  // Private constructor — nobody should create an instance of this class
  // It is just a container of constants
  AppColors._();

  // ── Primary Colours — Deep Forest Green ──────────────────
  static const Color primary        = Color(0xFF1B5E20);
  static const Color primaryLight   = Color(0xFF4C8C4A);
  static const Color primaryDark    = Color(0xFF003300);
  static const Color primarySurface = Color(0xFFE8F5E9);

  // ── Secondary Colours — Warm Gold ────────────────────────
  static const Color secondary        = Color(0xFFF9A825);
  static const Color secondaryLight   = Color(0xFFFFD95A);
  static const Color secondaryDark    = Color(0xFFC17900);
  static const Color secondarySurface = Color(0xFFFFF8E1);

  // ── Semantic Colours (meaning-based) ─────────────────────
  static const Color success        = Color(0xFF2E7D32);
  static const Color successSurface = Color(0xFFE8F5E9);
  static const Color warning        = Color(0xFFF9A825);
  static const Color warningSurface = Color(0xFFFFF8E1);
  static const Color error          = Color(0xFFC62828);
  static const Color errorSurface   = Color(0xFFFFEBEE);
  static const Color info           = Color(0xFF1565C0);
  static const Color infoSurface    = Color(0xFFE3F2FD);

  // ── Activity Feed Event Colours ───────────────────────────
  static const Color eventContribution = Color(0xFF2E7D32); // green
  static const Color eventPayout       = Color(0xFF1565C0); // blue
  static const Color eventFine         = Color(0xFFF9A825); // amber
  static const Color eventLoan         = Color(0xFFC62828); // red
  static const Color eventExpenditure  = Color(0xFFE65100); // orange
  static const Color eventMeeting      = Color(0xFF424242); // grey

  // ── Neutral Scale ─────────────────────────────────────────
  static const Color grey900 = Color(0xFF212121);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey50  = Color(0xFFFAFAFA);

  // ── Base ──────────────────────────────────────────────────
  static const Color white       = Color(0xFFFFFFFF);
  static const Color black       = Color(0xFF000000);
  static const Color transparent = Colors.transparent;

  // ── Dark Mode Surfaces ────────────────────────────────────
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface    = Color(0xFF1E1E1E);
  static const Color darkCard       = Color(0xFF2C2C2C);
}