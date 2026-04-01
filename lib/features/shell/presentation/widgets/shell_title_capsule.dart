import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class ShellTitleCapsule extends StatelessWidget {
  const ShellTitleCapsule({
    super.key,
    required this.title,
    this.subtitle,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final background = brightness == Brightness.dark
        ? AppColors.surfaceDark
        : AppColors.background;
    final primaryText = brightness == Brightness.dark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimary;
    final secondaryText = brightness == Brightness.dark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
        boxShadow: [
          BoxShadow(
            color: (brightness == Brightness.dark
                    ? AppColors.shadowDarkMode
                    : AppColors.shadowDark)
                .withValues(alpha: 0.25),
            offset: const Offset(2, 2),
            blurRadius: 4,
          ),
          BoxShadow(
            color: (brightness == Brightness.dark
                    ? AppColors.shadowLightMode
                    : AppColors.shadowLight)
                .withValues(alpha: 0.25),
            offset: const Offset(-2, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(
              color: primaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(width: 6),
            Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: secondaryText,
            ),
            const SizedBox(width: 6),
            Text(
              subtitle!,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.accentPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}


