import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/neumorphic_container.dart';

class LoginFormPanel extends StatefulWidget {
  const LoginFormPanel({
    super.key,
    required this.onSubmit,
    this.errorText,
  });

  final Future<bool> Function(String username, String password) onSubmit;
  final String? errorText;

  @override
  State<LoginFormPanel> createState() => _LoginFormPanelState();
}

class _LoginFormPanelState extends State<LoginFormPanel> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _submitting = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _submitting = true);
    await widget.onSubmit(
      _usernameController.text,
      _passwordController.text,
    );
    if (mounted) {
      setState(() => _submitting = false);
    }
  }

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
      padding: const EdgeInsets.all(32),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kullanıcı Girişi',
              style: AppTextStyles.h2.copyWith(color: primaryText),
            ),
            const SizedBox(height: 8),
            Text(
              'Mock kullanıcılarla ilk faz akışını başlatın.',
              style: AppTextStyles.bodyMedium.copyWith(color: secondaryText),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Kullanıcı Adı',
                hintText: 'admin veya operator',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Kullanıcı adı gereklidir';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Parola',
                hintText: 'Parolanızı girin',
                suffixIcon: IconButton(
                  onPressed: _togglePasswordVisibility,
                  tooltip: _obscurePassword ? 'Parolayı göster' : 'Parolayı gizle',
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Parola gereklidir';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            if (widget.errorText != null) ...[
              Text(
                widget.errorText!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.red.shade400,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
            ],
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitting ? null : _submit,
                child: Text(_submitting ? 'Doğrulanıyor...' : 'Giriş Yap'),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Örnek kullanıcılar: admin / admin123, operator / operator123',
              style: AppTextStyles.bodySmall.copyWith(color: secondaryText),
            ),
          ],
        ),
      ),
    );
  }
}