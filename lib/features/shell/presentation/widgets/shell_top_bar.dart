import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import 'shell_icon_button.dart';
import 'shell_title_capsule.dart';

class ShellTopBar extends StatelessWidget {
  const ShellTopBar({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isDarkMode,
    required this.onHomeTap,
    required this.onThemeToggle,
    required this.onUserTap,
    required this.onSettingsTap,
    required this.onExitTap,
    this.onTitleTap,
    this.showLogout = false,
    this.onLogoutTap,
  });

  final String title;
  final String subtitle;
  final bool isDarkMode;
  final VoidCallback onHomeTap;
  final VoidCallback onThemeToggle;
  final VoidCallback onUserTap;
  final VoidCallback onSettingsTap;
  final VoidCallback onExitTap;
  final VoidCallback? onTitleTap;
  final bool showLogout;
  final VoidCallback? onLogoutTap;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final background = brightness == Brightness.dark
        ? AppColors.backgroundDark
        : AppColors.background;

    final titleCapsule = ShellTitleCapsule(
      title: title,
      subtitle: subtitle,
    );

    final bool useLogoutSlot = showLogout && onLogoutTap != null;

    return Container(
      height: AppConstants.topBarHeight,
      color: background,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  'img/slogo.png',
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.accentPrimary,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          MouseRegion(
            cursor: onTitleTap != null
                ? SystemMouseCursors.click
                : SystemMouseCursors.basic,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTitleTap,
              child: titleCapsule,
            ),
          ),
          const Spacer(),
          ShellIconButton(
            icon: Icons.home_rounded,
            onTap: onHomeTap,
            tooltip: 'Ana Bilgi',
          ),
          const SizedBox(width: 12),
          ShellIconButton(
            icon: isDarkMode
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined,
            onTap: onThemeToggle,
            tooltip: 'Tema',
          ),
          const SizedBox(width: 12),
          ShellIconButton(
            icon: useLogoutSlot
                ? Icons.logout_rounded
                : Icons.person_outline_rounded,
            onTap: useLogoutSlot ? onLogoutTap! : onUserTap,
            tooltip: useLogoutSlot ? 'Oturumu Kapat' : 'Kullanıcı',
          ),
          const SizedBox(width: 12),
          ShellIconButton(
            icon: Icons.settings_outlined,
            onTap: onSettingsTap,
            tooltip: 'Ayarlar',
          ),
          const SizedBox(width: 12),
          ShellIconButton(
            icon: Icons.power_settings_new_rounded,
            onTap: onExitTap,
            tooltip: 'Güvenli Çıkış',
          ),
        ],
      ),
    );
  }
}