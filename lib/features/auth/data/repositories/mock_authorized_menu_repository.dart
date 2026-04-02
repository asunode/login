import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../../domain/contracts/authorized_menu_repository.dart';
import '../../domain/models/app_user.dart';
import '../../domain/models/authorized_menu_item.dart';
import '../local/models/local_group.dart';
import '../local/models/local_module.dart';
import '../local/models/local_user.dart';
import '../mock/mock_authorized_menus.dart';

class MockAuthorizedMenuRepository implements AuthorizedMenuRepository {
  const MockAuthorizedMenuRepository();

  static const String _isarName = 'login_shell';

  static const Set<String> _adminOnlyModuleCodes = <String>{
    'user-management',
    'group-management',
    'module-management',
    'change-password',
  };

  @override
  Future<List<AuthorizedMenuItem>> getMenusForUser(AppUser user) async {
    final isar = Isar.getInstance(_isarName);
    if (isar == null) {
      return _fallbackMenus(user);
    }

    final localUser = await _findLocalUser(isar, user);
    if (localUser == null) {
      return _fallbackMenus(user);
    }

    final localModules = await isar.localModules.where().findAll();
    if (localModules.isEmpty) {
      return _fallbackMenus(user);
    }

    final isAdmin = _isAdminUser(user, localUser);
    final localGroup = await _findLocalGroup(isar, localUser.groupName);

    final groupAssignedCodes = (localGroup?.moduleCodes ?? const <String>[])
        .map(_normalizeCode)
        .where((code) => code.isNotEmpty)
        .toSet();

    final stagedAssignedCodes = localUser.stagedModuleCodes
        .map(_normalizeCode)
        .where((code) => code.isNotEmpty)
        .toSet();

    final effectiveAssignedCodes = isAdmin
        ? <String>{...groupAssignedCodes, ...stagedAssignedCodes}
        : groupAssignedCodes.isNotEmpty
            ? groupAssignedCodes
            : stagedAssignedCodes;

    final activeModules = localModules.where((module) => module.isActive).toList()
      ..sort((a, b) {
        if (a.isBuiltIn != b.isBuiltIn) {
          return a.isBuiltIn ? -1 : 1;
        }
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });

    final visibleModules = activeModules.where((module) {
      final moduleCode = _normalizeCode(module.code);
      if (moduleCode.isEmpty) {
        return false;
      }

      if (isAdmin) {
        return module.isBuiltIn || effectiveAssignedCodes.contains(moduleCode);
      }

      if (_adminOnlyModuleCodes.contains(moduleCode)) {
        return false;
      }

      return effectiveAssignedCodes.contains(moduleCode);
    }).toList();

    if (visibleModules.isEmpty) {
      return const <AuthorizedMenuItem>[];
    }

    return List<AuthorizedMenuItem>.unmodifiable(
      visibleModules
          .map(
            (module) => AuthorizedMenuItem(
              id: module.code,
              title: module.name,
              description: module.description.trim().isEmpty
                  ? 'Tanımlı modül'
                  : module.description,
              icon: _iconDataForKey(module.iconKey),
            ),
          )
          .toList(),
    );
  }

  Future<LocalUser?> _findLocalUser(Isar isar, AppUser user) async {
    final normalizedId = user.id.trim();
    final parsedId = int.tryParse(normalizedId);
    if (parsedId != null) {
      final byId = await isar.localUsers.get(parsedId);
      if (byId != null) {
        return byId;
      }
    }

    final normalizedUsername = user.username.trim();
    if (normalizedUsername.isEmpty) {
      return null;
    }

    return isar.localUsers
        .filter()
        .usernameEqualTo(normalizedUsername, caseSensitive: false)
        .findFirst();
  }

  Future<LocalGroup?> _findLocalGroup(Isar isar, String groupName) async {
    final normalizedGroupName = groupName.trim();
    if (normalizedGroupName.isEmpty) {
      return null;
    }

    return isar.localGroups
        .filter()
        .nameEqualTo(normalizedGroupName, caseSensitive: false)
        .findFirst();
  }

  bool _isAdminUser(AppUser user, LocalUser localUser) {
    final role = user.role.trim().toLowerCase();
    if (role == 'admin') {
      return true;
    }

    final username = localUser.username.trim().toLowerCase();
    if (username == 'admin') {
      return true;
    }

    final groupName = localUser.groupName.trim().toLowerCase();
    return groupName == 'admin' ||
        groupName == 'yönetici' ||
        groupName == 'yonetici';
  }

  String _normalizeCode(String value) {
    return value.trim().toLowerCase();
  }

  List<AuthorizedMenuItem> _fallbackMenus(AppUser user) {
    final normalizedRole = user.role.trim().toLowerCase();
    return List<AuthorizedMenuItem>.unmodifiable(
      menusForRole(normalizedRole),
    );
  }

  IconData _iconDataForKey(String iconKey) {
    switch (iconKey.trim().toLowerCase()) {
      case 'profile':
        return Icons.badge_outlined;
      case 'bolt':
        return Icons.bolt_outlined;
      case 'dashboard':
        return Icons.dashboard_customize_outlined;
      case 'report':
        return Icons.assessment_outlined;
      case 'settings':
        return Icons.settings_outlined;
      case 'user':
        return Icons.person_outline;
      case 'group':
        return Icons.group_outlined;
      case 'module':
        return Icons.view_module_outlined;
      case 'password':
        return Icons.lock_outline;
      default:
        return Icons.widgets_outlined;
    }
  }
}
