class AppSettings {
  const AppSettings({
    required this.isDarkMode,
    required this.lastVisitedSection,
    required this.localeCode,
    this.lastActiveProfileId,
    this.rememberLastUserId,
  });

  final bool isDarkMode;
  final String? lastActiveProfileId;
  final String lastVisitedSection;
  final String? rememberLastUserId;
  final String localeCode;

  AppSettings copyWith({
    bool? isDarkMode,
    String? lastActiveProfileId,
    String? lastVisitedSection,
    String? rememberLastUserId,
    String? localeCode,
  }) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      lastActiveProfileId: lastActiveProfileId ?? this.lastActiveProfileId,
      lastVisitedSection: lastVisitedSection ?? this.lastVisitedSection,
      rememberLastUserId: rememberLastUserId ?? this.rememberLastUserId,
      localeCode: localeCode ?? this.localeCode,
    );
  }
}

