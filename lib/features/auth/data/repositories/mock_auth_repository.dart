import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:isar/isar.dart';

import '../../domain/contracts/auth_repository.dart';
import '../../domain/models/app_user.dart';
import '../local/models/local_user.dart';

class MockAuthRepository implements AuthRepository {
  const MockAuthRepository();

  static const String _isarName = 'login_shell';

  @override
  Future<AppUser?> authenticate({
    required String username,
    required String password,
  }) async {
    final normalizedUsername = _normalizeUsername(username);
    if (normalizedUsername.isEmpty) {
      return null;
    }

    final localUser = await _findLocalUser(normalizedUsername);
    if (localUser == null || !localUser.isActive) {
      return null;
    }

    final passwordHash = _hashPassword(password);
    if (localUser.passwordHash != passwordHash) {
      return null;
    }

    await _touchLastLogin(localUser);
    return _toAppUser(localUser);
  }

  @override
  Future<AppUser?> getUserByUsername(String username) async {
    final normalizedUsername = _normalizeUsername(username);
    if (normalizedUsername.isEmpty) {
      return null;
    }

    final localUser = await _findLocalUser(normalizedUsername);
    if (localUser == null) {
      return null;
    }

    return _toAppUser(localUser);
  }

  Future<LocalUser?> _findLocalUser(String username) async {
    final isar = Isar.getInstance(_isarName);
    if (isar == null) {
      return null;
    }

    return isar.localUsers
        .filter()
        .usernameEqualTo(username, caseSensitive: false)
        .findFirst();
  }

  Future<void> _touchLastLogin(LocalUser localUser) async {
    final isar = Isar.getInstance(_isarName);
    if (isar == null) {
      return;
    }

    localUser.lastLoginAt = DateTime.now();
    localUser.updatedAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.localUsers.put(localUser);
    });
  }

  AppUser _toAppUser(LocalUser localUser) {
    return AppUser(
      id: localUser.id.toString(),
      username: localUser.username,
      password: '',
      displayName: localUser.displayName,
      role: _resolveRole(localUser),
    );
  }

  String _resolveRole(LocalUser localUser) {
    final normalizedUsername = localUser.username.trim().toLowerCase();
    if (normalizedUsername == 'admin') {
      return 'admin';
    }

    if (_isAdminGroup(localUser.groupName)) {
      return 'admin';
    }

    return 'operator';
  }

  bool _isAdminGroup(String groupName) {
    final normalizedGroup = groupName.trim().toLowerCase();
    return normalizedGroup == 'admin' ||
        normalizedGroup == 'yönetici' ||
        normalizedGroup == 'yonetici';
  }

  String _normalizeUsername(String username) {
    return username.trim();
  }

  String _hashPassword(String rawPassword) {
    final bytes = utf8.encode(rawPassword);
    return sha256.convert(bytes).toString();
  }
}