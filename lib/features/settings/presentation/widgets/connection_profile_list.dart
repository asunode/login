import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/neumorphic_container.dart';
import '../../domain/models/connection_profile.dart';

class ConnectionProfileList extends StatelessWidget {
  const ConnectionProfileList({
    super.key,
    required this.profiles,
    required this.selectedProfileId,
    required this.onSelect,
    required this.onSetActive,
    required this.onTest,
  });

  final List<ConnectionProfile> profiles;
  final String? selectedProfileId;
  final ValueChanged<ConnectionProfile> onSelect;
  final ValueChanged<String> onSetActive;
  final ValueChanged<String> onTest;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final primaryText = brightness == Brightness.dark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimary;
    final secondaryText = brightness == Brightness.dark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondary;

    return NeumorphicContainer(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bağlantı Profilleri',
            style: AppTextStyles.h2.copyWith(color: primaryText),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: profiles.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final profile = profiles[index];
                final isSelected = selectedProfileId == profile.id;

                return GestureDetector(
                  onTap: () => onSelect(profile),
                  child: NeumorphicContainer(
                    style: isSelected
                        ? NeumorphicStyle.concave
                        : NeumorphicStyle.convex,
                    borderRadius: BorderRadius.circular(20),
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                profile.name,
                                style: AppTextStyles.h3.copyWith(
                                  color: primaryText,
                                ),
                              ),
                            ),
                            if (profile.isActive)
                              Text(
                                'Aktif',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.accentPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${profile.host} • ${profile.database}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: secondaryText,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () => onSetActive(profile.id),
                              child: const Text('Aktif Yap'),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () => onTest(profile.id),
                              child: const Text('Test Et'),
                            ),
                            const Spacer(),
                            Text(
                              _statusText(profile.testStatus),
                              style: AppTextStyles.bodySmall.copyWith(
                                color: _statusColor(profile.testStatus),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _statusText(ConnectionTestStatus status) {
    switch (status) {
      case ConnectionTestStatus.idle:
        return 'Test edilmedi';
      case ConnectionTestStatus.success:
        return 'Bağlantı başarılı';
      case ConnectionTestStatus.failed:
        return 'Bağlantı başarısız';
    }
  }

  Color _statusColor(ConnectionTestStatus status) {
    switch (status) {
      case ConnectionTestStatus.idle:
        return AppColors.textSecondary;
      case ConnectionTestStatus.success:
        return const Color(0xFF10B981);
      case ConnectionTestStatus.failed:
        return const Color(0xFFEF4444);
    }
  }
}


