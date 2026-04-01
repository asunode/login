import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/neumorphic_container.dart';
import '../../domain/models/connection_profile.dart';

class ConnectionProfileForm extends StatefulWidget {
  const ConnectionProfileForm({
    super.key,
    required this.selectedProfile,
    required this.onSave,
    required this.onCreateNew,
  });

  final ConnectionProfile? selectedProfile;
  final void Function(ConnectionProfile draft) onSave;
  final VoidCallback onCreateNew;

  @override
  State<ConnectionProfileForm> createState() => _ConnectionProfileFormState();
}

class _ConnectionProfileFormState extends State<ConnectionProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _hostController;
  late final TextEditingController _databaseController;
  late final TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _hostController = TextEditingController();
    _databaseController = TextEditingController();
    _usernameController = TextEditingController();
    _fillFromProfile(widget.selectedProfile);
  }

  @override
  void didUpdateWidget(covariant ConnectionProfileForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedProfile?.id != widget.selectedProfile?.id) {
      _fillFromProfile(widget.selectedProfile);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hostController.dispose();
    _databaseController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _fillFromProfile(ConnectionProfile? profile) {
    _nameController.text = profile?.name ?? '';
    _hostController.text = profile?.host ?? '';
    _databaseController.text = profile?.database ?? '';
    _usernameController.text = profile?.username ?? '';
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final base = widget.selectedProfile;
    widget.onSave(
      ConnectionProfile(
        id: base?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        host: _hostController.text.trim(),
        database: _databaseController.text.trim(),
        username: _usernameController.text.trim(),
        isActive: base?.isActive ?? false,
        testStatus: base?.testStatus ?? ConnectionTestStatus.idle,
      ),
    );
  }

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
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.selectedProfile == null
                        ? 'Yeni Profil'
                        : 'Profil Düzenle',
                    style: AppTextStyles.h2.copyWith(color: primaryText),
                  ),
                ),
                TextButton(
                  onPressed: widget.onCreateNew,
                  child: const Text('Yeni Kayıt'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Bu yapı ileride Isar tabanlı yerel profil yönetimine geçirilebilir.',
              style: AppTextStyles.bodySmall.copyWith(color: secondaryText),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Profil Adı'),
              validator: _requiredField,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _hostController,
              decoration: const InputDecoration(labelText: 'Host'),
              validator: _requiredField,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _databaseController,
              decoration: const InputDecoration(labelText: 'Veritabanı'),
              validator: _requiredField,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Kullanıcı'),
              validator: _requiredField,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: Text(
                  widget.selectedProfile == null ? 'Profil Ekle' : 'Kaydet',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _requiredField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bu alan gereklidir';
    }
    return null;
  }
}


