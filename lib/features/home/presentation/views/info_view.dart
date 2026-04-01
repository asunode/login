import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/neumorphic_container.dart';

class InfoView extends StatelessWidget {
  const InfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final secondaryText = brightness == Brightness.dark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondary;

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bağlantılarınızı güvenli ve kontrollü yönetin.',
                  style: AppTextStyles.h1.copyWith(
                    fontSize: 42,
                    height: 1.2,
                    fontWeight: FontWeight.w800,
                    color: brightness == Brightness.dark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Bu ilk faz yapıda üst kabuk korunur, orta alan ise bilgi, giriş ve ayar deneyimleri arasında geçiş yapar.\n\nKullanıcı, profil ve tema gibi yerel kontrol verileri ileride Isar tabanlı yapıya taşınabilecek şekilde düşünülmüştür.',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontSize: 18,
                    height: 1.6,
                    color: secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 48, 32),
            child: NeumorphicContainer(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Başlangıç Durumu',
                    style: AppTextStyles.h2.copyWith(
                      color: brightness == Brightness.dark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Home ile bu ekrana dönersiniz.\nKullanıcı ile giriş sürecini açarsınız.\nAyarlar ile bağlantı profillerini yönetirsiniz.\nGüvenli çıkış ile oturum kapatma akışını başlatırsınız.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: secondaryText,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: const [
                      _InfoChip(label: 'Soft UI Shell'),
                      _InfoChip(label: 'Mock Auth Flow'),
                      _InfoChip(label: 'Profile Management'),
                      _InfoChip(label: 'Theme Toggle'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final textColor = brightness == Brightness.dark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimary;

    return NeumorphicContainer(
      borderRadius: BorderRadius.circular(14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}


