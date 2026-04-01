import '../../domain/contracts/session_repository.dart';
import '../../domain/models/app_session.dart';

class InMemorySessionRepository implements SessionRepository {
  AppSession? _session;

  @override
  Future<void> clearSession() async {
    _session = null;
  }

  @override
  Future<AppSession?> getCurrentSession() async {
    return _session;
  }

  @override
  Future<AppSession> startSession(AppSession session) async {
    _session = session;
    return session;
  }

  @override
  Future<AppSession?> updateLastActivity() async {
    if (_session == null) {
      return null;
    }

    _session = _session!.copyWith(
      lastActivityAt: DateTime.now(),
    );
    return _session;
  }
}

