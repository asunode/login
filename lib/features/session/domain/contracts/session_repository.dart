import '../models/app_session.dart';

abstract class SessionRepository {
  Future<AppSession?> getCurrentSession();

  Future<AppSession> startSession(AppSession session);

  Future<void> clearSession();

  Future<AppSession?> updateLastActivity();
}

