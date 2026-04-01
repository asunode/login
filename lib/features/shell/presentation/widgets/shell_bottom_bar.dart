import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class ShellBottomBar extends StatelessWidget {
  const ShellBottomBar({
    super.key,
    required this.statusText,
    required this.isAuthenticated,
    this.sessionDisplayName,
  });

  final String statusText;
  final bool isAuthenticated;
  final String? sessionDisplayName;

  String get _sessionText {
    if (!isAuthenticated) {
      return 'Oturum yok';
    }

    final trimmedName = sessionDisplayName?.trim();
    if (trimmedName == null || trimmedName.isEmpty) {
      return 'Oturum açık';
    }

    return trimmedName;
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final background = brightness == Brightness.dark
        ? AppColors.backgroundDark
        : AppColors.background;
    final secondaryText = brightness == Brightness.dark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondary;

    return Container(
      height: AppConstants.bottomBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: background,
        boxShadow: [
          BoxShadow(
            color: (brightness == Brightness.dark
                    ? AppColors.shadowDarkMode
                    : AppColors.shadowDark)
                .withValues(alpha: 0.35),
            offset: const Offset(0, -3),
            blurRadius: 8,
          ),
          BoxShadow(
            color: (brightness == Brightness.dark
                    ? AppColors.shadowLightMode
                    : AppColors.shadowLight)
                .withValues(alpha: 0.35),
            offset: const Offset(0, -1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(
                  isAuthenticated
                      ? Icons.lock_open_rounded
                      : Icons.lock_outline_rounded,
                  size: 16,
                  color: AppColors.accentPrimary,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    '$_sessionText • $statusText',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(color: secondaryText),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'ASUNODE LoginShell v0.1.0',
            style: AppTextStyles.caption.copyWith(color: secondaryText),
          ),
        ],
      ),
    );
  }
}