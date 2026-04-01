import 'package:flutter/material.dart';

import '../../domain/models/authorized_menu_item.dart';

const Map<String, List<AuthorizedMenuItem>> mockAuthorizedMenusByRole = {
  'admin': [
    AuthorizedMenuItem(
      id: 'connections',
      title: 'Bağlantı Yönetimi',
      description: 'Profil tanımları ve aktif bağlantı seçimi',
      icon: Icons.hub_outlined,
    ),
    AuthorizedMenuItem(
      id: 'users',
      title: 'Kullanıcı Yetkileri',
      description: 'Yerel kullanıcı ve menü eşleştirmeleri',
      icon: Icons.admin_panel_settings_outlined,
    ),
    AuthorizedMenuItem(
      id: 'logs',
      title: 'Oturum Kayıtları',
      description: 'Yerel oturum ve değişiklik izlemesi',
      icon: Icons.history_outlined,
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


