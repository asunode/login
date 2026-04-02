import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/neumorphic_container.dart';
import '../../../auth/data/local/models/local_group.dart';

class GroupManagementView extends StatefulWidget {
  const GroupManagementView({
    super.key,
    this.onBack,
  });

  final VoidCallback? onBack;

  @override
  State<GroupManagementView> createState() => _GroupManagementViewState();
}

class _GroupManagementViewState extends State<GroupManagementView> {
  static const String _isarName = 'login_shell';

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  List<_GroupDraft> _groups = <_GroupDraft>[];

  String? _selectedGroupId;
  bool _isActive = true;

  bool _isLoading = true;
  bool _isSaving = false;
  String? _loadError;

  _GroupDraft? get _selectedGroup {
    if (_selectedGroupId == null) {
      return null;
    }

    for (final group in _groups) {
      if (group.id == _selectedGroupId) {
        return group;
      }
    }
    return null;
  }

  bool get _isEditingExistingGroup => _selectedGroup != null;

  bool get _isBuiltInSelection => _selectedGroup?.isBuiltIn ?? false;

  Isar? get _isar => Isar.getInstance(_isarName);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadData({String? preferredGroupId}) async {
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
      final localGroups = await isar.localGroups.where().findAll();

      final groups = localGroups
          .map(_GroupDraft.fromLocalGroup)
          .toList()
        ..sort((a, b) {
          if (a.isBuiltIn != b.isBuiltIn) {
            return a.isBuiltIn ? -1 : 1;
          }
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });

      final selectedId = _resolveSelectedGroupId(
        groups: groups,
        preferredGroupId: preferredGroupId,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _groups = groups;
        _selectedGroupId = selectedId;
        _isLoading = false;
        _loadError = null;
      });

      if (selectedId != null) {
        final selectedGroup = groups.firstWhere((group) => group.id == selectedId);
        _fillFromGroup(selectedGroup);
      } else {
        _prepareNewGroup();
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _loadError = 'Grup verileri yüklenemedi: $error';
      });
    }
  }

  String? _resolveSelectedGroupId({
    required List<_GroupDraft> groups,
    String? preferredGroupId,
  }) {
    if (groups.isEmpty) {
      return null;
    }

    if (preferredGroupId != null &&
        groups.any((group) => group.id == preferredGroupId)) {
      return preferredGroupId;
    }

    if (_selectedGroupId != null &&
        groups.any((group) => group.id == _selectedGroupId)) {
      return _selectedGroupId;
    }

    return groups.first.id;
  }

  void _fillFromGroup(_GroupDraft group) {
    _nameController.text = group.name;
    _descriptionController.text = group.description;

    setState(() {
      _selectedGroupId = group.id;
      _isActive = group.isActive;
    });
  }

  void _prepareNewGroup() {
    _nameController.clear();
    _descriptionController.clear();

    setState(() {
      _selectedGroupId = null;
      _isActive = true;
    });
  }

  void _selectGroup(String groupId) {
    final selectedGroup = _groups.firstWhere((group) => group.id == groupId);
    _fillFromGroup(selectedGroup);
  }

  void _startNewGroup() {
    _prepareNewGroup();
  }

  Future<void> _saveGroup() async {
    if (_isSaving || !_formKey.currentState!.validate()) {
      return;
    }

    final isar = _isar;
    if (isar == null) {
      _showMessage('Isar bağlantısı bulunamadı.');
      return;
    }

    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    final duplicateGroup = _groups.any(
      (group) =>
          group.name.toLowerCase() == name.toLowerCase() &&
          group.id != _selectedGroupId,
    );

    if (duplicateGroup) {
      _showMessage('Bu grup adı zaten kayıtlı.');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      if (_selectedGroupId == null) {
        final now = DateTime.now();

        final newGroup = LocalGroup()
          ..name = name
          ..description = description
          ..isActive = _isActive
          ..isBuiltIn = false
          ..createdAt = now
          ..updatedAt = now;

        late final int createdId;

        await isar.writeTxn(() async {
          createdId = await isar.localGroups.put(newGroup);
        });

        await _loadData(preferredGroupId: createdId.toString());
        _showMessage('Yeni grup kaydedildi.');
      } else {
        final selected = _selectedGroup;
        if (selected == null) {
          _showMessage('Düzenlenecek grup bulunamadı.');
          return;
        }

        final localGroup = await isar.localGroups.get(int.parse(selected.id));
        if (localGroup == null) {
          _showMessage('Kayıt bulunamadı.');
          await _loadData();
          return;
        }

        final oldName = localGroup.name.trim().toLowerCase();
        final newName = name.trim().toLowerCase();

        if (localGroup.isBuiltIn && oldName != newName) {
          _showMessage('Built-in grup adı değiştirilemez.');
          return;
        }

        localGroup.name = name;
        localGroup.description = description;
        localGroup.updatedAt = DateTime.now();

        if (!localGroup.isBuiltIn) {
          localGroup.isActive = _isActive;
        }

        await isar.writeTxn(() async {
          await isar.localGroups.put(localGroup);
        });

        await _loadData(preferredGroupId: localGroup.id.toString());
        _showMessage('Grup kaydı güncellendi.');
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

  Future<void> _deleteSelectedGroup() async {
    if (_isSaving) {
      return;
    }

    final group = _selectedGroup;
    if (group == null) {
      _showMessage('Silinecek bir grup seçilmedi.');
      return;
    }

    if (group.isBuiltIn) {
      _showMessage('Built-in yönetici grubu silinemez.');
      return;
    }

    final shouldDelete = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => _DeleteGroupDialog(groupName: group.name),
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
      final id = int.parse(group.id);

      await isar.writeTxn(() async {
        await isar.localGroups.delete(id);
      });

      await _loadData();
      _showMessage('Grup kaydı silindi.');
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
              'Grup verileri yükleniyor...',
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
                  'Grup verileri açılamadı',
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
            'Grup Tanımı',
            style: AppTextStyles.h1.copyWith(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Grup temel kayıtları bu ekranda yönetilir. Modül atama tarafı sonraki aşamada açılacaktır.',
            style: AppTextStyles.bodyMedium.copyWith(color: secondaryText),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: _GroupListPanel(
                    groups: _groups,
                    selectedGroupId: _selectedGroupId,
                    onSelectGroup: _selectGroup,
                    onCreateNew: _startNewGroup,
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
                            _isEditingExistingGroup
                                ? 'Grup Düzenle'
                                : 'Yeni Grup',
                            style: AppTextStyles.h2.copyWith(color: primaryText),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Grup alanı gerçek domain kaydı olarak tutulur. Yetki ve modül detayları sonraki fazlarda genişletilecektir.',
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
                                    icon: Icons.group_outlined,
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller: _nameController,
                                    enabled: !_isBuiltInSelection,
                                    decoration: const InputDecoration(
                                      labelText: 'Grup Adı',
                                      hintText: 'Örn. Operasyon',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return 'Grup adı gereklidir';
                                      }
                                      return null;
                                    },
                                  ),
                                  if (_isBuiltInSelection) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      'Built-in grupta grup adı korunur.',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: secondaryText,
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _descriptionController,
                                    decoration: const InputDecoration(
                                      labelText: 'Açıklama',
                                      hintText: 'Grubun kullanım amacı',
                                    ),
                                    minLines: 3,
                                    maxLines: 5,
                                  ),
                                  const SizedBox(height: 24),
                                  _SectionHeader(
                                    title: 'Durum',
                                    icon: Icons.verified_outlined,
                                  ),
                                  const SizedBox(height: 12),
                                  SwitchListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: const Text('Grup aktif'),
                                    subtitle: Text(
                                      _isBuiltInSelection
                                          ? 'Built-in yönetici grubu pasife alınamaz.'
                                          : 'Pasif grup yeni atamalarda kullanılmamalıdır.',
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
                                          'Built-in yönetici grubu koruması',
                                          style: AppTextStyles.h3.copyWith(
                                            color: primaryText,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Built-in yönetici grubu silinemez, grup adı değiştirilemez ve pasife alınamaz. Böylece temel yönetim omurgası korunur.',
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
                                onPressed: _isEditingExistingGroup &&
                                        !_isBuiltInSelection &&
                                        !_isSaving
                                    ? _deleteSelectedGroup
                                    : null,
                                icon: const Icon(Icons.delete_outline),
                                label: const Text('Sil'),
                              ),
                              ElevatedButton.icon(
                                onPressed: _isSaving ? null : _saveGroup,
                                icon: const Icon(Icons.save_outlined),
                                label: Text(
                                  _isSaving
                                      ? 'Kaydediliyor...'
                                      : _isEditingExistingGroup
                                          ? 'Kaydet'
                                          : 'Grup Ekle',
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

class _GroupListPanel extends StatelessWidget {
  const _GroupListPanel({
    required this.groups,
    required this.selectedGroupId,
    required this.onSelectGroup,
    required this.onCreateNew,
  });

  final List<_GroupDraft> groups;
  final String? selectedGroupId;
  final ValueChanged<String> onSelectGroup;
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
                  'Gruplar',
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
            'Sol listeden grup seçin veya yeni grup oluşturun.',
            style: AppTextStyles.bodySmall.copyWith(
              color: secondaryText,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: groups.isEmpty
                ? Center(
                    child: Text(
                      'Henüz grup kaydı bulunmuyor.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: secondaryText,
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: groups.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final group = groups[index];
                      final isSelected = group.id == selectedGroupId;

                      return MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => onSelectGroup(group.id),
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
                                        group.name,
                                        style: AppTextStyles.h3.copyWith(
                                          color: primaryText,
                                        ),
                                      ),
                                    ),
                                    if (group.isBuiltIn)
                                      _MiniTag(
                                        label: 'Built-in',
                                        icon: Icons.shield_outlined,
                                      ),
                                  ],
                                ),
                                if (group.description.trim().isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    group.description,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: secondaryText,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _MiniTag(
                                      label: group.isActive ? 'Aktif' : 'Pasif',
                                      icon: group.isActive
                                          ? Icons.check_circle_outline
                                          : Icons.pause_circle_outline,
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

class _DeleteGroupDialog extends StatelessWidget {
  const _DeleteGroupDialog({
    required this.groupName,
  });

  final String groupName;

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
              'Grubu Sil',
              style: AppTextStyles.h2.copyWith(color: primaryText),
            ),
            const SizedBox(height: 16),
            Text(
              '"$groupName" grubunu silmek istediğinize emin misiniz?',
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

class _GroupDraft {
  const _GroupDraft({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
    required this.isBuiltIn,
  });

  factory _GroupDraft.fromLocalGroup(LocalGroup group) {
    return _GroupDraft(
      id: group.id.toString(),
      name: group.name,
      description: group.description,
      isActive: group.isActive,
      isBuiltIn: group.isBuiltIn,
    );
  }

  final String id;
  final String name;
  final String description;
  final bool isActive;
  final bool isBuiltIn;
}