import '../../domain/contracts/auth_repository.dart';
import '../../domain/models/app_user.dart';
import '../mock/mock_users.dart';

class MockAuthRepository implements AuthRepository {
  const MockAuthRepository();

  @override
  Future<AppUser?> authenticate({
    required String username,
    required String password,
  }) async {
    return authenticateUser(username: username, password: password);
  }

  @override
  Future<AppUser?> getUserByUsername(String username) async {
    for (final user in mockUsers) {
      if (user.username == username.trim()) {
        return user;
      }
    }
    return null;
  }
}

