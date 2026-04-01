import '../models/app_settings.dart';

abstract class AppSettingsRepository {
  Future<AppSettings> loadSettings();

  Future<AppSettings> saveSettings(AppSettings settings);
}

