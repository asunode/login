import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/neumorphic_container.dart';
import '../../../app_settings/data/repositories/in_memory_app_settings_repository.dart';
import '../../../app_settings/domain/contracts/app_settings_repository.dart';
import '../../../auth/data/repositories/mock_auth_repository.dart';
import '../../../auth/data/repositories/mock_authorized_menu_repository.dart';
import '../../../auth/domain/contracts/auth_repository.dart';
import '../../../auth/domain/contracts/authorized_menu_repository.dart';
import '../../../auth/domain/models/app_user.dart';
import '../../../auth/domain/models/authorized_menu_item.dart';
import '../../../auth/presentation/views/authorized_menu_view.dart';
import '../../../auth/presentation/views/login_view.dart';
import '../../../home/presentation/views/info_view.dart';
import '../../../session/data/repositories/in_memory_session_repository.dart';
import '../../../session/domain/contracts/session_repository.dart';
import '../../../session/domain/models/app_session.dart';
import '../../../settings/presentation/views/settings_view.dart';
import '../models/shell_section.dart';
import '../widgets/shell_bottom_bar.dart';
import '../widgets/shell_top_bar.dart';

class ShellPage extends StatefulWidget {
  const ShellPage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  final AuthRepository _authRepository = const MockAuthRepository();
  final AuthorizedMenuRepository _authorizedMenuRepository =
      const MockAuthorizedMenuRepository();
  final SessionRepository _sessionRepository = InMemorySessionRepository();
  final AppSettingsRepository _appSettingsRepository =
      InMemoryAppSettingsRepository();

  ShellSection _section = ShellSection.info;
  AppUser? _currentUser;
  AppSession? _currentSession;
  List<AuthorizedMenuItem> _authorizedMenus = const [];
  String? _loginError;

  String get _subtitle {
    switch (_section) {
      case ShellSection.info:
        return 'Bilgi Alanı';
      case ShellSection.login:
        return 'Kullanıcı Girişi';
      case ShellSection.authorizedMenu:
        return 'Yetkili Menü';
      case ShellSection.settings:
        return 'Bağlantı Ayarları';
    }
  }

  String get _statusText {
    switch (_section) {
      case ShellSection.info:
        return 'Bilgilendirme görünümü aktif';
      case ShellSection.login:
        return 'Kullanıcı doğrulama ekranı açık';
      case ShellSection.authorizedMenu:
        final sessionName =
            _currentSession?.displayName.trim().isNotEmpty == true
                ? _currentSession!.displayName
                : _currentUser?.displayName;

        return sessionName == null
            ? 'Yetkili görünüm bekleniyor'
            : '$sessionName oturumu açık';
      case ShellSection.settings:
        return 'Bağlantı profilleri yönetiliyor';
    }
  }

  bool get _isAuthenticated => _currentSession?.isAuthenticated ?? false;

  String? get _sessionDisplayName {
    final displayName = _currentSession?.displayName.trim();
    if (displayName != null && displayName.isNotEmpty) {
      return displayName;
    }

    final username = _currentSession?.username.trim();
    if (username != null && username.isNotEmpty) {
      return username;
    }

    return null;
  }

  String get _rootTitle {
    if (_isAuthenticated) {
      final sessionName = _sessionDisplayName;
      if (sessionName != null && sessionName.isNotEmpty) {
        return sessionName;
      }
      return 'Menülerim';
    }

    return 'Login';
  }

  Future<void> _rememberSection(ShellSection section) async {
    final settings = await _appSettingsRepository.loadSettings();
    await _appSettingsRepository.saveSettings(
      settings.copyWith(
        lastVisitedSection: section.name,
        rememberLastUserId: _currentUser?.id,
      ),
    );
  }

  Future<bool> _handleLogin(String username, String password) async {
    final user = await _authRepository.authenticate(
      username: username,
      password: password,
    );
    if (user == null) {
      setState(() {
        _loginError = 'Kullanıcı adı veya parola hatalı.';
      });
      return false;
    }

    final menus = await _authorizedMenuRepository.getMenusForUser(user);

    final session = AppSession(
      sessionId: DateTime.now().microsecondsSinceEpoch.toString(),
      userId: user.id,
      username: user.username,
      displayName: user.displayName,
      isAuthenticated: true,
      startedAt: DateTime.now(),
      lastActivityAt: DateTime.now(),
      activeProfileId: null,
      authorizedMenuIds: menus.map((item) => item.id).toList(),
    );

    await _sessionRepository.startSession(session);

    setState(() {
      _currentUser = user;
      _currentSession = session;
      _authorizedMenus = menus;
      _loginError = null;
      _section = ShellSection.authorizedMenu;
    });
    await _rememberSection(_section);
    return true;
  }

  Future<void> _goToLoginRoot() async {
    setState(() {
      _section = ShellSection.login;
      _loginError = null;
    });
    await _rememberSection(ShellSection.login);
  }

  Future<void> _goToAuthorizedRoot() async {
    if (!_isAuthenticated || _currentUser == null) {
      await _goToLoginRoot();
      return;
    }

    setState(() {
      _section = ShellSection.authorizedMenu;
      _loginError = null;
    });
    await _rememberSection(ShellSection.authorizedMenu);
  }

  Future<void> _handleTitleTap() async {
    if (_isAuthenticated) {
      await _goToAuthorizedRoot();
      return;
    }

    await _goToLoginRoot();
  }

  Future<void> _handleUserTap() async {
    if (_isAuthenticated) {
      await _goToAuthorizedRoot();
      return;
    }

    await _goToLoginRoot();
  }

  Future<void> _handleLogout() async {
    if (!_isAuthenticated) {
      await _goToLoginRoot();
      return;
    }

    final shouldLogout = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => const _LogoutConfirmationDialog(),
        ) ??
        false;

    if (!mounted || !shouldLogout) {
      return;
    }

    await _sessionRepository.clearSession();

    setState(() {
      _currentSession = null;
      _currentUser = null;
      _authorizedMenus = const [];
      _loginError = null;
      _section = ShellSection.login;
    });

    await _rememberSection(ShellSection.login);
  }

  Future<void> _confirmExit() async {
    final shouldExit = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => const _ExitConfirmationDialog(),
        ) ??
        false;

    if (!mounted || !shouldExit) {
      return;
    }

    await _sessionRepository.clearSession();
    _currentSession = null;
    exit(0);
  }

  Widget _buildSectionView() {
    switch (_section) {
      case ShellSection.info:
        return const InfoView();
      case ShellSection.login:
        return LoginView(
          onLogin: _handleLogin,
          errorText: _loginError,
        );
      case ShellSection.authorizedMenu:
        if (_currentUser == null) {
          return LoginView(
            onLogin: _handleLogin,
            errorText: _loginError,
          );
        }
        return AuthorizedMenuView(
          user: _currentUser!,
          menus: _authorizedMenus,
        );
      case ShellSection.settings:
        return const SettingsView();
    }
  }

  @override
  Widget build(BuildContext context) {
    final background = Theme.of(context).brightness == Brightness.dark
        ? AppColors.backgroundDark
        : AppColors.background;

    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.f10) {
          _confirmExit();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Scaffold(
        backgroundColor: background,
        body: Column(
          children: [
            ShellTopBar(
              title: _rootTitle,
              subtitle: _subtitle,
              isDarkMode: widget.isDarkMode,
              onTitleTap: _handleTitleTap,
              onHomeTap: () {
                setState(() {
                  _section = ShellSection.info;
                  _loginError = null;
                });
                _rememberSection(ShellSection.info);
              },
              onThemeToggle: widget.onToggleTheme,
              onUserTap: _handleUserTap,
              onSettingsTap: () {
                setState(() {
                  _section = ShellSection.settings;
                  _loginError = null;
                });
                _rememberSection(ShellSection.settings);
              },
              showLogout: _isAuthenticated,
              onLogoutTap: _handleLogout,
              onExitTap: _confirmExit,
            ),
            Expanded(
              child: _buildSectionView(),
            ),
            ShellBottomBar(
              statusText: _statusText,
              isAuthenticated: _isAuthenticated,
              sessionDisplayName: _sessionDisplayName,
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoutConfirmationDialog extends StatelessWidget {
  const _LogoutConfirmationDialog();

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
        borderRadius: BorderRadius.circular(AppConstants.radiusCard),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Oturumu Kapat',
              style: AppTextStyles.h2.copyWith(color: primaryText),
            ),
            const SizedBox(height: 16),
            Text(
              'Mevcut kullanıcı oturumunu kapatmak istediğinize emin misiniz?',
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
                  child: const Text('Oturumu Kapat'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ExitConfirmationDialog extends StatelessWidget {
  const _ExitConfirmationDialog();

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
        borderRadius: BorderRadius.circular(AppConstants.radiusCard),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Güvenli Çıkış',
              style: AppTextStyles.h2.copyWith(color: primaryText),
            ),
            const SizedBox(height: 16),
            Text(
              'Uygulamadan çıkmak istediğinize emin misiniz?',
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
                  child: const Text('Çıkış'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}