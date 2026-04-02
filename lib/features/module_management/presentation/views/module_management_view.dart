import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/neumorphic_container.dart';
import '../../../auth/data/local/models/local_module.dart';

class ModuleManagementView extends StatefulWidget {
  const ModuleManagementView({
    super.key,
    this.onBack,
  });

  final VoidCallback? onBack;

  @override
  State<ModuleManagementView> createState() => _ModuleManagementViewState();
}

class _ModuleManagementViewState extends State<ModuleManagementView> {
  static const String _isarName = 'login_shell';

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  List<_ModuleDraft> _modules = <_ModuleDraft>[];

  String? _selectedModuleId;
  bool _isActive = true;

  bool _isLoading = true;
  bool _isSaving = false;
  String? _loadError;

  _ModuleDraft? get _selectedModule {
    if (_selectedModuleId == null) {
      return null;
    }

    for (final module in _modules) {
      if (module.id == _selectedModuleId) {
        return module;
      }
    }
    return null;
  }

  bool get _isEditingExistingModule => _selectedModule != null;

  bool get _isBuiltInSelection => _selectedModule?.isBuiltIn ?? false;

  String get _draftName => _nameController.text.trim();

  String get _displayCode {
    final selected = _selectedModule;
    if (selected != null) {
      return selected.code;
    }
    return _buildCodeFromName(_draftName);
  }

  String get _displayIconKey {
    final selected = _selectedModule;
    if (selected != null) {
      return selected.iconKey;
    }
    return _pickIconKeyForName(_draftName);
  }

  Isar? get _isar => Isar.getInstance(_isarName);

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_handleDraftChanged);
    _loadData();
  }

  @override
  void dispose() {
    _nameController.removeListener(_handleDraftChanged);
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleDraftChanged() {
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _loadData({String? preferredModuleId}) async {
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
      final localModules = await isar.localModules.where().findAll();

      final modules = localModules
          .map(_ModuleDraft.fromLocalModule)
          .toList()
        ..sort((a, b) {
          if (a.isBuiltIn != b.isBuiltIn) {
            return a.isBuiltIn ? -1 : 1;
          }
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });

      final selectedId = _resolveSelectedModuleId(
        modules: modules,
        preferredModuleId: preferredModuleId,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _modules = modules;
        _selectedModuleId = selectedId;
        _isLoading = false;
        _loadError = null;
      });

      if (selectedId != null) {
        final selectedModule =
            modules.firstWhere((module) => module.id == selectedId);
        _fillFromModule(selectedModule);
      } else {
        _prepareNewModule();
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _loadError = 'Modül verileri yüklenemedi: $error';
      });
    }
  }

  String? _resolveSelectedModuleId({
    required List<_ModuleDraft> modules,
    String? preferredModuleId,
  }) {
    if (modules.isEmpty) {
      return null;
    }

    if (preferredModuleId != null &&
        modules.any((module) => module.id == preferredModuleId)) {
      return preferredModuleId;
    }

    if (_selectedModuleId != null &&
        modules.any((module) => module.id == _selectedModuleId)) {
      return _selectedModuleId;
    }

    return modules.first.id;
  }

  void _fillFromModule(_ModuleDraft module) {
    _nameController.text = module.name;
    _descriptionController.text = module.description;

    setState(() {
      _selectedModuleId = module.id;
      _isActive = module.isActive;
    });
  }

  void _prepareNewModule() {
    _nameController.clear();
    _descriptionController.clear();

    setState(() {
      _selectedModuleId = null;
      _isActive = true;
    });
  }

  void _selectModule(String moduleId) {
    final selectedModule =
        _modules.firstWhere((module) => module.id == moduleId);
    _fillFromModule(selectedModule);
  }

  void _startNewModule() {
    _prepareNewModule();
  }

  Future<void> _saveModule() async {
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

    setState(() {
      _isSaving = true;
    });

    try {
      if (_selectedModuleId == null) {
        final generatedCode = _buildCodeFromName(name);
        if (generatedCode.isEmpty) {
          _showMessage('Geçerli bir modül kodu üretilemedi.');
          return;
        }

        final duplicateName = _modules.any(
          (module) => module.name.toLowerCase() == name.toLowerCase(),
        );
        if (duplicateName) {
          _showMessage('Bu modül adı zaten kayıtlı.');
          return;
        }

        final duplicateCode = _modules.any(
          (module) => module.code.toLowerCase() == generatedCode.toLowerCase(),
        );
        if (duplicateCode) {
          _showMessage(
            'Bu modül adı mevcut bir teknik anahtarla çakışıyor. Farklı bir modül adı girin.',
          );
          return;
        }

        final now = DateTime.now();

        final newModule = LocalModule()
          ..code = generatedCode
          ..name = name
          ..description = description
          ..iconKey = _pickIconKeyForName(name)
          ..isActive = _isActive
          ..isBuiltIn = false
          ..createdAt = now
          ..updatedAt = now;

        late final int createdId;

        await isar.writeTxn(() async {
          createdId = await isar.localModules.put(newModule);
        });

        await _loadData(preferredModuleId: createdId.toString());
        _showMessage('Yeni modül kaydedildi.');
      } else {
        final selected = _selectedModule;
        if (selected == null) {
          _showMessage('Düzenlenecek modül bulunamadı.');
          return;
        }

        final duplicateName = _modules.any(
          (module) =>
              module.name.toLowerCase() == name.toLowerCase() &&
              module.id != _selectedModuleId,
        );
        if (duplicateName) {
          _showMessage('Bu modül adı zaten kayıtlı.');
          return;
        }

        final localModule = await isar.localModules.get(int.parse(selected.id));
        if (localModule == null) {
          _showMessage('Kayıt bulunamadı.');
          await _loadData();
          return;
        }

        localModule.name = name;
        localModule.description = description;
        localModule.updatedAt = DateTime.now();

        if (!localModule.isBuiltIn) {
          localModule.isActive = _isActive;
        }

        await isar.writeTxn(() async {
          await isar.localModules.put(localModule);
        });

        await _loadData(preferredModuleId: localModule.id.toString());
        _showMessage('Modül kaydı güncellendi.');
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

  Future<void> _deleteSelectedModule() async {
    if (_isSaving) {
      return;
    }

    final module = _selectedModule;
    if (module == null) {
      _showMessage('Silinecek bir modül seçilmedi.');
      return;
    }

    if (module.isBuiltIn) {
      _showMessage('Built-in modül silinemez.');
      return;
    }

    final shouldDelete = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => _DeleteModuleDialog(moduleName: module.name),
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
      final id = int.parse(module.id);

      await isar.writeTxn(() async {
        await isar.localModules.delete(id);
      });

      await _loadData();
      _showMessage('Modül kaydı silindi.');
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

  String _buildCodeFromName(String value) {
    final lower = value.trim().toLowerCase();

    if (lower.isEmpty) {
      return '';
    }

    final replacedTurkish = lower
        .replaceAll('ç', 'c')
        .replaceAll('ğ', 'g')
        .replaceAll('ı', 'i')
        .replaceAll('i̇', 'i')
        .replaceAll('ö', 'o')
        .replaceAll('ş', 's')
        .replaceAll('ü', 'u');

    final buffer = StringBuffer();
    var previousDash = false;

    for (final rune in replacedTurkish.runes) {
      final char = String.fromCharCode(rune);
      final isAlphaNumeric = RegExp(r'[a-z0-9]').hasMatch(char);

      if (isAlphaNumeric) {
        buffer.write(char);
        previousDash = false;
      } else {
        if (!previousDash) {
          buffer.write('-');
          previousDash = true;
        }
      }
    }

    final result = buffer
        .toString()
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-+'), '')
        .replaceAll(RegExp(r'-+$'), '');

    return result;
  }

  String _pickIconKeyForName(String value) {
    final normalized = value.trim().toLowerCase();

    if (normalized.isEmpty) {
      return 'module-default';
    }

    if (normalized.contains('profil')) {
      return 'profile';
    }
    if (normalized.contains('hizli') || normalized.contains('hızlı')) {
      return 'bolt';
    }
    if (normalized.contains('aktif')) {
      return 'dashboard';
    }
    if (normalized.contains('rapor')) {
      return 'report';
    }
    if (normalized.contains('ayar')) {
      return 'settings';
    }
    if (normalized.contains('kullanici') || normalized.contains('kullanıcı')) {
      return 'user';
    }
    if (normalized.contains('grup')) {
      return 'group';
    }
    if (normalized.contains('modul') || normalized.contains('modül')) {
      return 'module';
    }
    if (normalized.contains('sifre') || normalized.contains('şifre')) {
      return 'password';
    }

    return 'module-default';
  }

  IconData _iconDataForKey(String iconKey) {
    switch (iconKey) {
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
              'Modül verileri yükleniyor...',
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
                  'Modül verileri açılamadı',
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
            'Modül Tanımı',
            style: AppTextStyles.h1.copyWith(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Modül adı ve açıklaması bu ekranda yönetilir. İkon ilk oluşturma anında başlığa göre seçilir ve sabit kalır.',
            style: AppTextStyles.bodyMedium.copyWith(color: secondaryText),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: _ModuleListPanel(
                    modules: _modules,
                    selectedModuleId: _selectedModuleId,
                    onSelectModule: _selectModule,
                    onCreateNew: _startNewModule,
                    iconDataForKey: _iconDataForKey,
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
                            _isEditingExistingModule
                                ? 'Modül Düzenle'
                                : 'Yeni Modül',
                            style: AppTextStyles.h2.copyWith(color: primaryText),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Gerçek detay ve genişleme, ileride PostgreSQL bağlantısı geldiğinde geliştirilecektir.',
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
                                    icon: Icons.view_module_outlined,
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller: _nameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Modül Adı',
                                      hintText: 'Örn. Aktif Profil',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return 'Modül adı gereklidir';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  InputDecorator(
                                    decoration: const InputDecoration(
                                      labelText: 'Teknik Anahtar',
                                    ),
                                    child: Text(
                                      _displayCode.isEmpty ? '-' : _displayCode,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: primaryText,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _descriptionController,
                                    decoration: const InputDecoration(
                                      labelText: 'Açıklama',
                                      hintText: 'Modülün kullanım amacı',
                                    ),
                                    minLines: 3,
                                    maxLines: 5,
                                  ),
                                  const SizedBox(height: 24),
                                  _SectionHeader(
                                    title: 'İkon',
                                    icon: Icons.image_outlined,
                                  ),
                                  const SizedBox(height: 12),
                                  NeumorphicContainer(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 56,
                                          height: 56,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(16),
                                            color: AppColors.accentPrimary.withOpacity(0.10),
                                          ),
                                          child: Icon(
                                            _iconDataForKey(_displayIconKey),
                                            color: AppColors.accentPrimary,
                                            size: 28,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _displayIconKey,
                                                style: AppTextStyles.h3.copyWith(
                                                  color: primaryText,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                _isEditingExistingModule
                                                    ? 'Bu ikon ilk kayitta secildigi icin sabit tutulur.'
                                                    : 'Kayit aninda modül basligina gore secilir ve ilk kayittan sonra sabit kalir.',
                                                style: AppTextStyles.bodySmall.copyWith(
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
                                  const SizedBox(height: 24),
                                  _SectionHeader(
                                    title: 'Durum',
                                    icon: Icons.verified_outlined,
                                  ),
                                  const SizedBox(height: 12),
                                  SwitchListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: const Text('Modül aktif'),
                                    subtitle: Text(
                                      _isBuiltInSelection
                                          ? 'Built-in modül pasife alınamaz.'
                                          : 'Pasif modül yeni atamalarda kullanılmamalıdır.',
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
                                          'Built-in modül koruması',
                                          style: AppTextStyles.h3.copyWith(
                                            color: primaryText,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Built-in modüller silinemez. İkon ilk oluşturma anında seçilir ve sonrasında sabit tutulur. Gerçek metadata ve detay genişlemesi ileride PostgreSQL bağlantısı geldiğinde geliştirilecektir.',
                                          style: AppTextStyles.bodySmall.copyWith(
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
                                onPressed: _isEditingExistingModule &&
                                        !_isBuiltInSelection &&
                                        !_isSaving
                                    ? _deleteSelectedModule
                                    : null,
                                icon: const Icon(Icons.delete_outline),
                                label: const Text('Sil'),
                              ),
                              ElevatedButton.icon(
                                onPressed: _isSaving ? null : _saveModule,
                                icon: const Icon(Icons.save_outlined),
                                label: Text(
                                  _isSaving
                                      ? 'Kaydediliyor...'
                                      : _isEditingExistingModule
                                          ? 'Kaydet'
                                          : 'Modül Ekle',
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

class _ModuleListPanel extends StatelessWidget {
  const _ModuleListPanel({
    required this.modules,
    required this.selectedModuleId,
    required this.onSelectModule,
    required this.onCreateNew,
    required this.iconDataForKey,
  });

  final List<_ModuleDraft> modules;
  final String? selectedModuleId;
  final ValueChanged<String> onSelectModule;
  final VoidCallback onCreateNew;
  final IconData Function(String iconKey) iconDataForKey;

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
                  'Modüller',
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
            'Sol listeden modül seçin veya yeni modül oluşturun.',
            style: AppTextStyles.bodySmall.copyWith(
              color: secondaryText,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: modules.isEmpty
                ? Center(
                    child: Text(
                      'Henüz modül kaydı bulunmuyor.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: secondaryText,
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: modules.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final module = modules[index];
                      final isSelected = module.id == selectedModuleId;

                      return MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => onSelectModule(module.id),
                          child: NeumorphicContainer(
                            padding: const EdgeInsets.all(16),
                            style: isSelected
                                ? NeumorphicStyle.concave
                                : NeumorphicStyle.convex,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 42,
                                      height: 42,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: AppColors.accentPrimary.withOpacity(0.10),
                                      ),
                                      child: Icon(
                                        iconDataForKey(module.iconKey),
                                        color: AppColors.accentPrimary,
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  module.name,
                                                  style: AppTextStyles.h3.copyWith(
                                                    color: primaryText,
                                                  ),
                                                ),
                                              ),
                                              if (module.isBuiltIn)
                                                _MiniTag(
                                                  label: 'Built-in',
                                                  icon: Icons.shield_outlined,
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            module.code,
                                            style: AppTextStyles.bodySmall.copyWith(
                                              color: secondaryText,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (module.description.trim().isNotEmpty) ...[
                                  const SizedBox(height: 10),
                                  Text(
                                    module.description,
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
                                      label: module.isActive ? 'Aktif' : 'Pasif',
                                      icon: module.isActive
                                          ? Icons.check_circle_outline
                                          : Icons.pause_circle_outline,
                                    ),
                                    _MiniTag(
                                      label: module.iconKey,
                                      icon: Icons.image_outlined,
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

class _DeleteModuleDialog extends StatelessWidget {
  const _DeleteModuleDialog({
    required this.moduleName,
  });

  final String moduleName;

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
              'Modülü Sil',
              style: AppTextStyles.h2.copyWith(color: primaryText),
            ),
            const SizedBox(height: 16),
            Text(
              '"$moduleName" modülünü silmek istediğinize emin misiniz?',
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

class _ModuleDraft {
  const _ModuleDraft({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.iconKey,
    required this.isActive,
    required this.isBuiltIn,
  });

  factory _ModuleDraft.fromLocalModule(LocalModule module) {
    return _ModuleDraft(
      id: module.id.toString(),
      code: module.code,
      name: module.name,
      description: module.description,
      iconKey: module.iconKey,
      isActive: module.isActive,
      isBuiltIn: module.isBuiltIn,
    );
  }

  final String id;
  final String code;
  final String name;
  final String description;
  final String iconKey;
  final bool isActive;
  final bool isBuiltIn;
}
