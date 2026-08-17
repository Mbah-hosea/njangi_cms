/// All fixed values used across the app
/// Change a value here = changes everywhere
class AppConstants {
  // Private constructor — this class is never instantiated
  AppConstants._();

  // ── App Info ──────────────────────────────────────────────
  static const String appName    = 'Njangi CMS';
  static const String appVersion = '1.0.0';

  // ── API URLs ──────────────────────────────────────────────
  // We use dev URL now — swap to prod before releasing
  static const String baseUrlDev  = 'http://localhost:3000/api/v1';
  static const String baseUrlProd = 'https://api.njangicms.com/api/v1';

  // ── Pricing (CFA) ─────────────────────────────────────────
  static const int registrationFee     = 5000;
  static const int pricePerMember      = 100;
  static const int minimumMonthlyFee   = 2000;
  static const int annualMonthsCharged = 10;
  static const double loyaltyDiscount  = 0.10;

  // ── Grace Period (days) ───────────────────────────────────
  static const int graceReminderDay  = 7;
  static const int graceWarningDay   = 14;
  static const int graceReadOnlyDay  = 30;
  static const int graceSuspendDay   = 60;

  // ── Pagination ────────────────────────────────────────────
  static const int pageSize = 20;

  // ── Local Storage Keys ────────────────────────────────────
  // These are the key names used to save data on the device
  static const String keyAuthToken  = 'auth_token';
  static const String keyUserId     = 'user_id';
  static const String keyGroupId    = 'active_group_id';
  static const String keyUserRole   = 'user_role';
  static const String keyOnboarded  = 'has_onboarded';
  static const String keyThemeMode  = 'theme_mode';
  static const String keyLanguage   = 'language';
}