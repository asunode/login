import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/repositories/mock_connection_profile_repository.dart';
import '../../domain/contracts/connection_profile_repository.dart';
import '../../domain/models/connection_profile.dart';
import '../widgets/connection_profile_form.dart';
import '../widgets/connection_profile_list.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final ConnectionProfileRepository _repository =
      MockConnectionProfileRepository();
  List<ConnectionProfile> _profiles = const [];
  ConnectionProfile? _selectedProfile;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    final profiles = await _repository.getProfiles();
    if (!mounted) {
      return;
    }

    setState(() {
      _profiles = profiles;
      _selectedProfile = profiles.isEmpty ? null : profiles.first;
    });
  }

  Future<void> _setActive(String profileId) async {
    final profiles = await _repository.setActiveProfile(profileId);
    if (!mounted) {
      return;
    }

    setState(() {
      _profiles = profiles;
      _selectedProfile =
          profiles.firstWhere((profile) => profile.id == profileId);
    });
  }

  Future<void> _testConnection(String profileId) async {
    final profiles = await _repository.testConnection(profileId);
    if (!mounted) {
      return;
    }

    setState(() {
      _profiles = profiles;
      _selectedProfile =
          profiles.firstWhere((profile) => profile.id == profileId);
    });
  }

  Future<void> _saveProfile(ConnectionProfile draft) async {
    final exists = _profiles.any((profile) => profile.id == draft.id);
    if (exists) {
      await _repository.updateProfile(draft);
    } else {
      await _repository.saveProfile(draft);
    }

    final profiles = await _repository.getProfiles();
    if (!mounted) {
      return;
    }

    setState(() {
      _profiles = profiles;
      _selectedProfile = draft;
    });
  }

  void _prepareNewProfile() {
    setState(() {
      _selectedProfile = null;
    });
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 48, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bağlantı Ayarları',
                  style: AppTextStyles.h1.copyWith(
                    fontSize: 32,
                    color: primaryText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Profil seçin, düzenleyin, yeni kayıt ekleyin ve test bağlantısını simüle edin.',
                  style: AppTextStyles.bodyMedium.copyWith(color: secondaryText),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ConnectionProfileList(
                    profiles: _profiles,
                    selectedProfileId: _selectedProfile?.id,
                    onSelect: (profile) {
                      setState(() => _selectedProfile = profile);
                    },
                    onSetActive: _setActive,
                    onTest: _testConnection,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 3,
                  child: ConnectionProfileForm(
                    selectedProfile: _selectedProfile,
                    onSave: _saveProfile,
                    onCreateNew: _prepareNewProfile,
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

