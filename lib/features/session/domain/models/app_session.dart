class AppSession {
  const AppSession({
    required this.sessionId,
    required this.userId,
    required this.username,
    required this.displayName,
    required this.isAuthenticated,
    required this.startedAt,
    required this.lastActivityAt,
    required this.activeProfileId,
    required this.authorizedMenuIds,
  });

  final String sessionId;
  final String userId;
  final String username;
  final String displayName;
  final bool isAuthenticated;
  final DateTime startedAt;
  final DateTime lastActivityAt;
  final String? activeProfileId;
  final List<String> authorizedMenuIds;

  AppSession copyWith({
    String? sessionId,
    String? userId,
    String? username,
    String? displayName,
    bool? isAuthenticated,
    DateTime? startedAt,
    DateTime? lastActivityAt,
    String? activeProfileId,
    List<String>? authorizedMenuIds,
  }) {
    return AppSession(
      sessionId: sessionId ?? this.sessionId,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      startedAt: startedAt ?? this.startedAt,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      activeProfileId: activeProfileId ?? this.activeProfileId,
      authorizedMenuIds: authorizedMenuIds ?? this.authorizedMenuIds,
    );
  }
}

