/// All navigation route names in one place
/// Every screen has a unique path — like a website URL
class AppRoutes {
  AppRoutes._();

  // ── Auth Flow ─────────────────────────────────────────────
  static const String splash     = '/';
  static const String onboarding = '/onboarding';
  static const String login      = '/login';
  static const String otp        = '/otp';
  static const String roleSelect = '/role-select';

  // ── Main App ──────────────────────────────────────────────
  static const String dashboard  = '/dashboard';

  // ── Groups ────────────────────────────────────────────────
  static const String groupType   = '/group/type';
  static const String createGroup = '/group/create';

  // ── Members ───────────────────────────────────────────────
  static const String members       = '/members';
  static const String memberProfile = '/members/:id';

  // ── Contributions ─────────────────────────────────────────
  static const String contributions = '/contributions';

  // ── Notifications ─────────────────────────────────────────
  static const String notifications = '/notifications';

static const String profileSetup = '/profile-setup';
static const String shell = '/shell';
static const String groupChoice = '/group-choice';
static const String joinGroup   = '/group/join';
}