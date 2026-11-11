class AppConstants {
  AppConstants._();

  static const String appName = 'Eureka';
  static const String baseHost = 'https://eureka.growfet.com';
  static const String baseUrl = 'https://eureka.growfet.com/api/v1';
  static const String socketUrl = 'https://eureka.growfet.com';
  static const String socketPath = '/socket.io';
  static const String userTokenKey = 'USER_TOKEN';
  static const String userRefreshTokenKey = 'USER_REFRESH_TOKEN';
  static const String userIdKey = 'USER_ID';
  static const String userRoleKey = 'USER_ROLE';
  static const String userEmailKey = 'USER_EMAIL';
  static const String userFullNameKey = 'USER_FULL_NAME';
  static const String userAvatarUrlKey = 'USER_AVATAR_URL';
  static const String isDarkModeKey = 'IS_DARK_MODE';
  static const String isOnboardingCompletedKey = 'IS_ONBOARDING_COMPLETED';

  static String? formatImageUrl(String? url) {
    if (url == null || url.trim().isEmpty) return null;
    final trimmed = url.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    final cleanPath = trimmed.startsWith('/') ? trimmed : '/$trimmed';
    return '$baseHost$cleanPath';
  }
}
