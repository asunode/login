import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/neumorphic_container.dart';
import '../../../auth/data/local/models/local_group.dart';
import '../../../auth/data/local/models/local_user.dart';

class UserManagementView extends StatefulWidget {
  const UserManagementView({
    super.key,
    this.onBack,
  });

  final VoidCallback? onBack;

  @override
  State<UserManagementView> createState() => _UserManagementViewState();
}

class _UserManagementViewState extends State<UserManagementView> {
  static const String _isarName = 'login_shell';

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _displayNameController = TextEditingController();

  final List<_ModuleOption> _moduleOptions = const <_ModuleOption>[
    _ModuleOption(
      id: 'user-management',
      title: 'Kullanıcı Tanımı',
    ),
    _ModuleOption(
      id: 'group-management',
      title: 'Grup Tanımı',
    ),
    _ModuleOption(
      id: 'module-management',
      title: 'Modül Tanımı',
    ),
    _ModuleOption(
      id: 'change-password',
      title: 'Şifre Güncelle',
    ),
  ];

  List<_GroupOption> _groups = <_GroupOption>[];
  List<_UserDraft> _users = <_UserDraft>[];

  String? _selectedUserId;
  String? _selectedGroupName;
  bool _isActive = true;
  bool _mustChangePassword = false;
  Set<String> _stagedModuleIds = <String>{};

  bool _isLoading = true;
  bool _isSaving = false;
  String? _loadError;

  _UserDraft? get _selectedUser {
    if (_selectedUserId == null) {
      return null;
    }

    for (final user in _users) {
      if (user.id == _selectedUserId) {
        return user;
      }
    }
    return null;
  }

  bool get _isEditingExistingUser => _selectedUser != null;

  bool get _isBuiltInSelection => _selectedUser?.isBuiltIn ?? false;

  Isar? get _isar => Isar.getInstance(_isarName);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _loadData({String? preferredUserId}) async {
    final isar = _isar;
    if (isar == null) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _loadError = 'Isar bağlantısı bulunamadı.';
      });
      return;
    }

    if (mounted) {
      setState(() {
        _isLoading = true;
        _loadError = null;
      });
    }

    try {
      final localUsers = await isar.localUsers.where().findAll();
      final localGroups = await isar.localGroups.where().findAll();

      final groups = localGroups
          .where((group) => group.isActive)
          .map(
            (group) => _GroupOption(
              id: group.id.toString(),
              name: group.name,
              description: group.description,
              isBuiltIn: group.isBuiltIn,
            ),
          )
          .toList()
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

      final users = localUsers
          .map(_UserDraft.fromLocalUser)
          .toList()
        ..sort((a, b) {
          if (a.isBuiltIn != b.isBuiltIn) {
            return a.isBuiltIn ? -1 : 1;
          }
          return a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase());
        });

      for (final user in users) {
        _ensureGroupExists(
          groups,
          user.groupName,
          description: 'Mevcut kullanıcı kaydından gelen grup değeri',
        );
      }

      final selectedId = _resolveSelectedUserId(
        users: users,
        preferredUserId: preferredUserId,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _groups = groups;
        _users = users;
        _selectedUserId = selectedId;
        _isLoading = false;
        _loadError = null;
      });

      if (selectedId != null) {
        final selectedUser = users.firstWhere((user) => user.id == selectedId);
        _fillFromUser(selectedUser);
      } else {
        _prepareNewUser();
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _loadError = 'Kullanıcı verileri yüklenemedi: $error';
      });
    }
  }

  String? _resolveSelectedUserId({
    required List<_UserDraft> users,
    String? preferredUserId,
  }) {
    if (users.isEmpty) {
      return null;
    }

    if (preferredUserId != null &&
        users.any((user) => user.id == preferredUserId)) {
      return preferredUserId;
    }

    if (_selectedUserId != null &&
        users.any((user) => user.id == _selectedUserId)) {
      return _selectedUserId;
    }

    return users.first.id;
  }

  void _ensureGroupExists(
    List<_GroupOption> groups,
    String groupName, {
    required String description,
  }) {
    final normalized = groupName.trim().toLowerCase();
    if (normalized.isEmpty) {
      return;
    }

    final exists = groups.any(
      (group) => group.name.trim().toLowerCase() == normalized,
    );
    if (exists) {
      return;
    }

    groups.add(
      _GroupOption(
        id: 'legacy-$normalized',
        name: groupName.trim(),
        description: description,
        isBuiltIn: false,
      ),
    );

    groups.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  void _fillFromUser(_UserDraft user) {
    _ensureGroupExists(
      _groups,
      user.groupName,
      description: 'Mevcut kullanıcı kaydından gelen grup değeri',
    );

    _usernameController.text = user.username;
    _displayNameController.text = user.displayName;

    setState(() {
      _selectedUserId = user.id;
      _selectedGroupName = user.groupName;
      _isActive = user.isActive;
      _mustChangePassword = user.mustChangePassword;
      _stagedModuleIds = Set<String>.from(user.stagedModuleIds);
    });
  }

  void _prepareNewUser() {
    _usernameController.clear();
    _displayNameController.clear();

    setState(() {
      _selectedUserId = null;
      _selectedGroupName = _groups.isNotEmpty ? _groups.first.name : null;
      _isActive = true;
      _mustChangePassword = true;
      _stagedModuleIds = <String>{};
    });
  }

  void _selectUser(String userId) {
    final selectedUser = _users.firstWhere((user) => user.id == userId);
    _fillFromUser(selectedUser);
  }

  void _startNewUser() {
    _prepareNewUser();
  }

  void _toggleModule(String moduleId, bool isSelected) {
    setState(() {
      if (isSelected) {
        _stagedModuleIds.add(moduleId);
      } else {
        _stagedModuleIds.remove(moduleId);
      }
    });
  }

  Future<void> _saveUser() async {
    if (_isSaving || !_formKey.currentState!.validate()) {
      return;
    }

    final isar = _isar;
    if (isar == null) {
      _showMessage('Isar bağlantısı bulunamadı.');
      return;
    }

    final username = _usernameController.text.trim();
    final displayName = _displayNameController.text.trim();
    final groupName = _selectedGroupName?.trim() ?? '';

    if (groupName.isEmpty) {
      _showMessage('Grup seçimi gereklidir.');
      return;
    }

    final duplicateUser = _users.any(
      (user) =>
          user.username.toLowerCase() == username.toLowerCase() &&
          user.id != _selectedUserId,
    );

    if (duplicateUser) {
      _showMessage('Bu kullanıcı adı zaten kayıtlı.');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      if (_selectedUserId == null) {
        final temporaryPassword = _buildTemporaryPasswordFor(username);
        final now = DateTime.now();

        final newUser = LocalUser()
          ..username = username
          ..displayName = displayName
          ..email = ''
          ..passwordHash = _hashPassword(temporaryPassword)
          ..groupName = groupName
          ..stagedModuleCodes = _orderedModuleCodes()
          ..isActive = _isActive
          ..isBuiltIn = false
          ..mustChangePassword = _mustChangePassword
          ..createdAt = now
          ..updatedAt = now;

        late final int createdId;

        await isar.writeTxn(() async {
          createdId = await isar.localUsers.put(newUser);
        });

        await _loadData(preferredUserId: createdId.toString());
        _showMessage(
          'Yeni kullanıcı kaydedildi. Geçici parola: $temporaryPassword',
        );
      } else {
        final selected = _selectedUser;
        if (selected == null) {
          _showMessage('Düzenlenecek kullanıcı bulunamadı.');
          return;
        }

        final localUser = await isar.localUsers.get(int.parse(selected.id));
        if (localUser == null) {
          _showMessage('Kayıt bulunamadı.');
          await _loadData();
          return;
        }

        final oldUsername = localUser.username.trim().toLowerCase();
        final newUsername = username.trim().toLowerCase();

        if (localUser.isBuiltIn && oldUsername != newUsername) {
          _showMessage('Built-in kullanıcı adı değiştirilemez.');
          return;
        }

        localUser.username = username;
        localUser.displayName = displayName;
        localUser.groupName = groupName;
        localUser.stagedModuleCodes = _orderedModuleCodes();
        localUser.updatedAt = DateTime.now();

        if (!localUser.isBuiltIn) {
          localUser.isActive = _isActive;
        }

        localUser.mustChangePassword = _mustChangePassword;

        await isar.writeTxn(() async {
          await isar.localUsers.put(localUser);
        });

        await _loadData(preferredUserId: localUser.id.toString());
        _showMessage('Kullanıcı kaydı güncellendi.');
      }
    } catch (error) {
      _showMessage('Kayıt sırasında hata oluştu: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _deleteSelectedUser() async {
    if (_isSaving) {
      return;
    }

    final user = _selectedUser;
    if (user == null) {
      _showMessage('Silinecek bir kullanıcı seçilmedi.');
      return;
    }

    if (user.isBuiltIn) {
      _showMessage('Built-in admin kullanıcısı silinemez.');
      return;
    }

    final shouldDelete = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => _DeleteUserDialog(username: user.username),
        ) ??
        false;

    if (!mounted || !shouldDelete) {
      return;
    }

    final isar = _isar;
    if (isar == null) {
      _showMessage('Isar bağlantısı bulunamadı.');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final id = int.parse(user.id);

      await isar.writeTxn(() async {
        await isar.localUsers.delete(id);
      });

      await _loadData();
      _showMessage('Kullanıcı kaydı silindi.');
    } catch (error) {
      _showMessage('Silme sırasında hata oluştu: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _resetPassword() async {
    if (_isSaving) {
      return;
    }

    final user = _selectedUser;
    if (user == null) {
      _showMessage('Önce bir kullanıcı seçin.');
      return;
    }

    final isar = _isar;
    if (isar == null) {
      _showMessage('Isar bağlantısı bulunamadı.');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final localUser = await isar.localUsers.get(int.parse(user.id));
      if (localUser == null) {
        _showMessage('Kayıt bulunamadı.');
        await _loadData();
        return;
      }

      final temporaryPassword = _buildTemporaryPasswordFor(localUser.username);

      localUser.passwordHash = _hashPassword(temporaryPassword);
      localUser.mustChangePassword = true;
      localUser.updatedAt = DateTime.now();

      await isar.writeTxn(() async {
        await isar.localUsers.put(localUser);
      });

      await _loadData(preferredUserId: localUser.id.toString());
      _showMessage(
        '${localUser.username} için geçici parola: $temporaryPassword',
      );
    } catch (error) {
      _showMessage('Şifre sıfırlama sırasında hata oluştu: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  List<String> _orderedModuleCodes() {
    final moduleIds = _stagedModuleIds.toList()..sort();
    return moduleIds;
  }

  String _buildTemporaryPasswordFor(String username) {
    return '${username.trim()}123';
  }

  String _hashPassword(String rawPassword) {
    final bytes = utf8.encode(rawPassword);
    return sha256.convert(bytes).toString();
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Color _primaryText(Brightness brightness) {
    return brightness == Brightness.dark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimary;
  }

  Color _secondaryText(Brightness brightness) {
    return brightness == Brightness.dark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondary;
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final primaryText = _primaryText(brightness);
    final secondaryText = _secondaryText(brightness);

    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2.4),
            ),
            const SizedBox(height: 16),
            Text(
              'Kullanıcı verileri yükleniyor...',
              style: AppTextStyles.bodyMedium.copyWith(color: secondaryText),
            ),
          ],
        ),
      );
    }

    if (_loadError != null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 48, 32),
        child: Center(
          child: NeumorphicContainer(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 30,
                  color: AppColors.accentPrimary,
                ),
                const SizedBox(height: 12),
                Text(
                  'Kullanıcı verileri açılamadı',
                  style: AppTextStyles.h2.copyWith(color: primaryText),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _loadError!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: secondaryText,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _loadData,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Yeniden Dene'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 48, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.onBack != null) ...[
            TextButton.icon(
              onPressed: widget.onBack,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Yetkili Menüye Dön'),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            'Kullanıcı Tanımı',
            style: AppTextStyles.h1.copyWith(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Kullanıcı temel kayıtları, grup seçimi ve modül staging alanı bu ekranda yönetilir.',
            style: AppTextStyles.bodyMedium.copyWith(color: secondaryText),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: _UserListPanel(
                    users: _users,
                    selectedUserId: _selectedUserId,
                    onSelectUser: _selectUser,
                    onCreateNew: _startNewUser,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 7,
                  child: NeumorphicContainer(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isEditingExistingUser
                                ? 'Kullanıcı Düzenle'
                                : 'Yeni Kullanıcı',
                            style: AppTextStyles.h2.copyWith(color: primaryText),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Grup bilgisi gerçek kayıt mantığına hazırlanır. Modül seçimi ise şimdilik staging alanı olarak tutulur.',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: secondaryText,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _SectionHeader(
                                    title: 'Temel Bilgiler',
                                    icon: Icons.person_outline,
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _usernameController,
                                          enabled: !_isBuiltInSelection,
                                          decoration: const InputDecoration(
                                            labelText: 'Kullanıcı Adı',
                                            hintText: 'ornek.kullanici',
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return 'Kullanıcı adı gereklidir';
                                            }
                                            if (value.contains(' ')) {
                                              return 'Kullanıcı adında boşluk olmamalı';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: TextFormField(
                                          controller: _displayNameController,
                                          decoration: const InputDecoration(
                                            labelText: 'Görünen Ad',
                                            hintText: 'Ad Soyad',
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return 'Görünen ad gereklidir';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  DropdownButtonFormField<String>(
                                    value: _selectedGroupName,
                                    decoration: const InputDecoration(
                                      labelText: 'Grup',
                                    ),
                                    items: _groups
                                        .map(
                                          (group) => DropdownMenuItem<String>(
                                            value: group.name,
                                            child: Text(group.name),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: _isBuiltInSelection
                                        ? null
                                        : (value) {
                                            setState(() {
                                              _selectedGroupName = value;
                                            });
                                          },
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return 'Grup seçimi gereklidir';
                                      }
                                      return null;
                                    },
                                  ),
                                  if (_isBuiltInSelection) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      'Built-in kullanıcıda kullanıcı adı ve grup alanı korunur.',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: secondaryText,
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 24),
                                  _SectionHeader(
                                    title: 'Durum ve Güvenlik',
                                    icon: Icons.verified_user_outlined,
                                  ),
                                  const SizedBox(height: 12),
                                  SwitchListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: const Text('Kullanıcı aktif'),
                                    subtitle: Text(
                                      _isBuiltInSelection
                                          ? 'Built-in kullanıcı pasife alınamaz.'
                                          : 'Pasif kullanıcı giriş yapamaz.',
                                    ),
                                    value: _isActive,
                                    onChanged: _isBuiltInSelection
                                        ? null
                                        : (value) {
                                            setState(() {
                                              _isActive = value;
                                            });
                                          },
                                  ),
                                  SwitchListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: const Text(
                                      'İlk girişte şifre güncelleme zorunlu',
                                    ),
                                    subtitle: const Text(
                                      'Şifre sıfırlama veya ilk atama sonrası kullanılabilir.',
                                    ),
                                    value: _mustChangePassword,
                                    onChanged: (value) {
                                      setState(() {
                                        _mustChangePassword = value;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 24),
                                  _SectionHeader(
                                    title: 'Modül Staging Alanı',
                                    icon: Icons.view_module_outlined,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Bu seçimler ileride netleşecek gerçek modül ID yapısına kadar geçici kayıt mantığıyla tutulur.',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: secondaryText,
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: _moduleOptions.map((module) {
                                      final isSelected = _stagedModuleIds
                                          .contains(module.id);

                                      return FilterChip(
                                        selected: isSelected,
                                        label: Text(module.title),
                                        onSelected: (value) {
                                          _toggleModule(module.id, value);
                                        },
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 24),
                                  _SectionHeader(
                                    title: 'Koruma Notları',
                                    icon: Icons.admin_panel_settings_outlined,
                                  ),
                                  const SizedBox(height: 12),
                                  NeumorphicContainer(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Built-in admin koruması',
                                          style: AppTextStyles.h3.copyWith(
                                            color: primaryText,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Built-in admin silinemez. Mevcut parola görüntülenmez. Yeni kullanıcı ve şifre sıfırlama akışında geçici parola atanır ve ilk girişte değiştirme zorunluluğu kullanılabilir.',
                                          style:
                                              AppTextStyles.bodySmall.copyWith(
                                            color: secondaryText,
                                            height: 1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            alignment: WrapAlignment.end,
                            children: [
                              OutlinedButton.icon(
                                onPressed: _isEditingExistingUser && !_isSaving
                                    ? _resetPassword
                                    : null,
                                icon: const Icon(Icons.lock_reset_outlined),
                                label: const Text('Şifre Sıfırla'),
                              ),
                              OutlinedButton.icon(
                                onPressed: _isEditingExistingUser &&
                                        !_isBuiltInSelection &&
                                        !_isSaving
                                    ? _deleteSelectedUser
                                    : null,
                                icon: const Icon(Icons.delete_outline),
                                label: const Text('Sil'),
                              ),
                              ElevatedButton.icon(
                                onPressed: _isSaving ? null : _saveUser,
                                icon: const Icon(Icons.save_outlined),
                                label: Text(
                                  _isSaving
                                      ? 'Kaydediliyor...'
                                      : _isEditingExistingUser
                                          ? 'Kaydet'
                                          : 'Kullanıcı Ekle',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UserListPanel extends StatelessWidget {
  const _UserListPanel({
    required this.users,
    required this.selectedUserId,
    required this.onSelectUser,
    required this.onCreateNew,
  });

  final List<_UserDraft> users;
  final String? selectedUserId;
  final ValueChanged<String> onSelectUser;
  final VoidCallback onCreateNew;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final primaryText = brightness == Brightness.dark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimary;
    final secondaryText = brightness == Brightness.dark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondary;

    return NeumorphicContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Kullanıcılar',
                  style: AppTextStyles.h2.copyWith(color: primaryText),
                ),
              ),
              TextButton.icon(
                onPressed: onCreateNew,
                icon: const Icon(Icons.add),
                label: const Text('Yeni Kayıt'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Sol listeden kayıt seçin veya yeni kullanıcı oluşturun.',
            style: AppTextStyles.bodySmall.copyWith(
              color: secondaryText,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: users.isEmpty
                ? Center(
                    child: Text(
                      'Henüz kullanıcı kaydı bulunmuyor.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: secondaryText,
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: users.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final user = users[index];
                      final isSelected = user.id == selectedUserId;

                      return MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => onSelectUser(user.id),
                          child: NeumorphicContainer(
                            padding: const EdgeInsets.all(16),
                            style: isSelected
                                ? NeumorphicStyle.concave
                                : NeumorphicStyle.convex,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        user.displayName,
                                        style: AppTextStyles.h3.copyWith(
                                          color: primaryText,
                                        ),
                                      ),
                                    ),
                                    if (user.isBuiltIn)
                                      _MiniTag(
                                        label: 'Built-in',
                                        icon: Icons.shield_outlined,
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '@${user.username}',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: secondaryText,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _MiniTag(
                                      label: user.groupName,
                                      icon: Icons.group_outlined,
                                    ),
                                    _MiniTag(
                                      label: user.isActive ? 'Aktif' : 'Pasif',
                                      icon: user.isActive
                                          ? Icons.check_circle_outline
                                          : Icons.pause_circle_outline,
                                    ),
                                    _MiniTag(
                                      label:
                                          '${user.stagedModuleIds.length} modül seçili',
                                      icon: Icons.view_module_outlined,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final primaryText = brightness == Brightness.dark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimary;

    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.accentPrimary,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTextStyles.h3.copyWith(color: primaryText),
        ),
      ],
    );
  }
}

class _MiniTag extends StatelessWidget {
  const _MiniTag({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final textColor = brightness == Brightness.dark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondary;

    return NeumorphicContainer(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      borderRadius: BorderRadius.circular(999),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: AppColors.accentPrimary,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}

class _DeleteUserDialog extends StatelessWidget {
  const _DeleteUserDialog({
    required this.username,
  });

  final String username;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final primaryText = brightness == Brightness.dark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimary;
    final secondaryText = brightness == Brightness.dark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondary;

    return Dialog(
      child: NeumorphicContainer(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Kullanıcıyı Sil',
              style: AppTextStyles.h2.copyWith(color: primaryText),
            ),
            const SizedBox(height: 16),
            Text(
              '"$username" kaydını silmek istediğinize emin misiniz?',
              style: AppTextStyles.bodyMedium.copyWith(color: secondaryText),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('İptal'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Sil'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _UserDraft {
  const _UserDraft({
    required this.id,
    required this.username,
    required this.displayName,
    required this.groupName,
    required this.isActive,
    required this.isBuiltIn,
    required this.mustChangePassword,
    required this.stagedModuleIds,
  });

  factory _UserDraft.fromLocalUser(LocalUser user) {
    return _UserDraft(
      id: user.id.toString(),
      username: user.username,
      displayName: user.displayName,
      groupName: user.groupName,
      isActive: user.isActive,
      isBuiltIn: user.isBuiltIn,
      mustChangePassword: user.mustChangePassword,
      stagedModuleIds: Set<String>.from(user.stagedModuleCodes),
    );
  }

  final String id;
  final String username;
  final String displayName;
  final String groupName;
  final bool isActive;
  final bool isBuiltIn;
  final bool mustChangePassword;
  final Set<String> stagedModuleIds;
}

class _GroupOption {
  const _GroupOption({
    required this.id,
    required this.name,
    required this.description,
    required this.isBuiltIn,
  });

  final String id;
  final String name;
  final String description;
  final bool isBuiltIn;
}

class _ModuleOption {
  const _ModuleOption({
    required this.id,
    required this.title,
  });

  final String id;
  final String title;
}
