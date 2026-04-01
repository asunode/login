import '../models/app_user.dart';

abstract class AuthRepository {
  Future<AppUser?> authenticate({
    required String username,
    required String password,
  });

  Future<AppUser?> getUserByUsername(String username);
}

