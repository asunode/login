import '../../domain/contracts/app_settings_repository.dart';
import '../../domain/models/app_settings.dart';

class InMemoryAppSettingsRepository implements AppSettingsRepository {
  AppSettings _settings = const AppSettings(
    isDarkMode: false,
    lastVisitedSection: 'info',
    localeCode: 'tr',
  );

  @override
  Future<AppSettings> loadSettings() async {
    return _settings;
  }

  @override
  Future<AppSettings> saveSettings(AppSettings settings) async {
    _settings = settings;
    return _settings;
  }
}

