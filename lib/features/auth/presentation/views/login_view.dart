import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/login_form_panel.dart';

class LoginView extends StatelessWidget {
  const LoginView({
    super.key,
    required this.onLogin,
    this.errorText,
  });

  final Future<bool> Function(String username, String password) onLogin;
  final String? errorText;

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
                  'Kullanıcı doğrulaması ile kontrollü geçiş yapın.',
                  style: AppTextStyles.h1.copyWith(
                    fontSize: 42,
                    height: 1.2,
                    color: brightness == Brightness.dark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Bu ekran ilk fazda mock veri ile çalışır. Başarılı girişten sonra orta alanda yetkili menüler görünür ve ileride Isar tabanlı yerel oturum yapısına bağlanabilecek bir akış sağlanır.',
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
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: LoginFormPanel(
                  onSubmit: onLogin,
                  errorText: errorText,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


