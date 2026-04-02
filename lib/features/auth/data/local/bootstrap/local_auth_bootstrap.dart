import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:isar/isar.dart';

import '../models/local_group.dart';
import '../models/local_module.dart';
import '../models/local_user.dart';

class LocalAuthBootstrap {
  const LocalAuthBootstrap._();

  static const String adminUsername = 'admin';
  static const String adminInitialPassword = 'admin123';
  static const String adminDisplayName = 'Admin';
  static const String adminGroupName = 'Yönetici';

  static const List<_BuiltInModuleSeed> _builtInModules = [
    _BuiltInModuleSeed(
      code: 'user-management',
      legacyCodes: ['user_management'],
      name: 'Kullanıcı Tanımı',
      description: 'Yerel kullanıcı kayıtları, durum yönetimi ve şifre sıfırlama',
    ),
    _BuiltInModuleSeed(
      code: 'group-management',
      legacyCodes: ['group_management'],
      name: 'Grup Tanımı',
      description: 'Gruplar, açıklamalar ve modül atama hazırlığı',
    ),
    _BuiltInModuleSeed(
      code: 'module-management',
      legacyCodes: ['module_management'],
      name: 'Modül Tanımı',
      description: 'Teknik anahtar, görünen ad ve aktif modül yönetimi',
    ),
    _BuiltInModuleSeed(
      code: 'change-password',
      legacyCodes: ['password_change'],
      name: 'Şifre Güncelle',
      description: 'Mevcut parola doğrulama ve güvenli parola güncelleme',
    ),
  ];

  static Future<void> ensureSeedData(Isar isar) async {
    await isar.writeTxn(() async {
      await _ensureBuiltInGroup(isar);
      await _ensureBuiltInModules(isar);
      await _ensureAdminUser(isar);
    });
  }

  static Future<void> _ensureBuiltInGroup(Isar isar) async {
    final existingGroup = await isar.localGroups
        .filter()
        .nameEqualTo(adminGroupName, caseSensitive: false)
        .findFirst();

    if (existingGroup != null) {
      return;
    }

    final now = DateTime.now();

    final group = LocalGroup()
      ..name = adminGroupName
      ..description = 'Sistem yöneticisi grubu'
      ..isActive = true
      ..isBuiltIn = true
      ..createdAt = now
      ..updatedAt = now;

    await isar.localGroups.put(group);
  }

  static Future<void> _ensureBuiltInModules(Isar isar) async {
    for (final moduleData in _builtInModules) {
      final existingModule = await _findBuiltInModule(isar, moduleData);

      if (existingModule != null) {
        await _normalizeExistingModule(isar, existingModule, moduleData);
        continue;
      }

      final now = DateTime.now();

      final module = LocalModule()
        ..code = moduleData.code
        ..name = moduleData.name
        ..description = moduleData.description
        ..isActive = true
        ..isBuiltIn = true
        ..createdAt = now
        ..updatedAt = now;

      await isar.localModules.put(module);
    }
  }

  static Future<LocalModule?> _findBuiltInModule(
    Isar isar,
    _BuiltInModuleSeed moduleData,
  ) async {
    final canonical = await isar.localModules
        .filter()
        .codeEqualTo(moduleData.code, caseSensitive: false)
        .findFirst();

    if (canonical != null) {
      return canonical;
    }

    for (final legacyCode in moduleData.legacyCodes) {
      final legacy = await isar.localModules
          .filter()
          .codeEqualTo(legacyCode, caseSensitive: false)
          .findFirst();

      if (legacy != null) {
        return legacy;
      }
    }

    return null;
  }

  static Future<void> _normalizeExistingModule(
    Isar isar,
    LocalModule existingModule,
    _BuiltInModuleSeed moduleData,
  ) async {
    var changed = false;

    if (existingModule.code != moduleData.code) {
      existingModule.code = moduleData.code;
      changed = true;
    }

    if (existingModule.name != moduleData.name) {
      existingModule.name = moduleData.name;
      changed = true;
    }

    if (existingModule.description != moduleData.description) {
      existingModule.description = moduleData.description;
      changed = true;
    }

    if (!existingModule.isActive) {
      existingModule.isActive = true;
      changed = true;
    }

    if (!existingModule.isBuiltIn) {
      existingModule.isBuiltIn = true;
      changed = true;
    }

    if (!changed) {
      return;
    }

    existingModule.updatedAt = DateTime.now();
    await isar.localModules.put(existingModule);
  }

  static Future<void> _ensureAdminUser(Isar isar) async {
    final existingAdmin = await isar.localUsers
        .filter()
        .usernameEqualTo(adminUsername, caseSensitive: false)
        .findFirst();

    if (existingAdmin != null) {
      return;
    }

    final now = DateTime.now();

    final adminUser = LocalUser()
      ..username = adminUsername
      ..displayName = adminDisplayName
      ..email = ''
      ..passwordHash = _hashPassword(adminInitialPassword)
      ..groupName = adminGroupName
      ..isActive = true
      ..isBuiltIn = true
      ..mustChangePassword = false
      ..createdAt = now
      ..updatedAt = now;

    await isar.localUsers.put(adminUser);
  }

  static String _hashPassword(String rawPassword) {
    final bytes = utf8.encode(rawPassword);
    return sha256.convert(bytes).toString();
  }
}

class _BuiltInModuleSeed {
  const _BuiltInModuleSeed({
    required this.code,
    required this.legacyCodes,
    required this.name,
    required this.description,
  });

  final String code;
  final List<String> legacyCodes;
  final String name;
  final String description;
}