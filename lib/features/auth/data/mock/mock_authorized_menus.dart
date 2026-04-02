import 'package:flutter/material.dart';

import '../../domain/models/authorized_menu_item.dart';

const Map<String, List<AuthorizedMenuItem>> mockAuthorizedMenusByRole = {
  'admin': [
    AuthorizedMenuItem(
      id: 'user-management',
      title: 'Kullanıcı Tanımı',
      description: 'Yerel kullanıcı kayıtları, durum yönetimi ve şifre sıfırlama',
      icon: Icons.person_outline,
    ),
    AuthorizedMenuItem(
      id: 'group-management',
      title: 'Grup Tanımı',
      description: 'Gruplar, açıklamalar ve modül atama hazırlığı',
      icon: Icons.group_outlined,
    ),
    AuthorizedMenuItem(
      id: 'module-management',
      title: 'Modül Tanımı',
      description: 'Teknik anahtar, görünen ad ve aktif modül yönetimi',
      icon: Icons.view_module_outlined,
    ),
    AuthorizedMenuItem(
      id: 'change-password',
      title: 'Şifre Güncelle',
      description: 'Mevcut parola doğrulama ve güvenli parola güncelleme',
      icon: Icons.lock_reset_outlined,
    ),
  ],
  'operator': [
    AuthorizedMenuItem(
      id: 'profile',
      title: 'Aktif Profil',
      description: 'Çalışma profili ve bağlantı özeti',
      icon: Icons.badge_outlined,
    ),
    AuthorizedMenuItem(
      id: 'quick-actions',
      title: 'Hızlı İşlemler',
      description: 'Giriş sonrası yetkili aksiyonlar',
      icon: Icons.flash_on_outlined,
    ),
  ],
};

List<AuthorizedMenuItem> menusForRole(String role) {
  return mockAuthorizedMenusByRole[role] ?? const <AuthorizedMenuItem>[];
}