import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/neumorphic_container.dart';
import '../../domain/models/app_user.dart';
import '../../domain/models/authorized_menu_item.dart';

class AuthorizedMenuView extends StatelessWidget {
  const AuthorizedMenuView({
    super.key,
    required this.user,
    required this.menus,
  });

  final AppUser user;
  final List<AuthorizedMenuItem> menus;

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
      padding: const EdgeInsets.fromLTRB(24, 32, 48, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 24),
            child: Text(
              'Hoş geldiniz, ${user.displayName}',
              style: AppTextStyles.h1.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: primaryText,
              ),
            ),
          ),
          Text(
            'Rolünüz: ${user.role}. Aşağıdaki menüler mock yetkilendirme kaynağından yüklenmiştir.',
            style: AppTextStyles.bodyMedium.copyWith(color: secondaryText),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
                childAspectRatio: 1.8,
              ),
              itemCount: menus.length,
              itemBuilder: (context, index) {
                final menu = menus[index];
                return NeumorphicContainer(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NeumorphicContainer(
                        style: NeumorphicStyle.concave,
                        borderRadius: BorderRadius.circular(10),
                        padding: const EdgeInsets.all(8),
                        width: 42,
                        height: 42,
                        child: Icon(
                          menu.icon,
                          size: 20,
                          color: AppColors.accentPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        menu.title,
                        style: AppTextStyles.h3.copyWith(color: primaryText),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        menu.description,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: secondaryText,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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


