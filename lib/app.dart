import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:login/core/theme/app_theme.dart';
import 'package:login/features/app_settings/data/repositories/in_memory_app_settings_repository.dart';
import 'package:login/features/app_settings/domain/contracts/app_settings_repository.dart';
import 'package:login/features/shell/presentation/pages/shell_page.dart';

class ShellFirstApp extends StatefulWidget {
  const ShellFirstApp({super.key});

  @override
  State<ShellFirstApp> createState() => _ShellFirstAppState();
}

class _ShellFirstAppState extends State<ShellFirstApp> {
  final AppSettingsRepository _appSettingsRepository =
      InMemoryAppSettingsRepository();

  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _appSettingsRepository.loadSettings();
    if (!mounted) {
      return;
    }

    setState(() {
      _themeMode = settings.isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  Future<void> _toggleTheme() async {
    final nextMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    setState(() {
      _themeMode = nextMode;
    });

    final settings = await _appSettingsRepository.loadSettings();
    await _appSettingsRepository.saveSettings(
      settings.copyWith(isDarkMode: nextMode == ThemeMode.dark),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SWorld Login',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('tr', 'TR'),
      ],
      locale: const Locale('tr', 'TR'),
      home: ShellPage(
        isDarkMode: _themeMode == ThemeMode.dark,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

