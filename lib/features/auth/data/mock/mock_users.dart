import '../../domain/models/app_user.dart';

const List<AppUser> mockUsers = [
  AppUser(
    id: 'u1',
    username: 'admin',
    password: 'admin123',
    displayName: 'Sistem Yöneticisi',
    role: 'admin',
  ),
  AppUser(
    id: 'u2',
    username: 'operator',
    password: 'operator123',
    displayName: 'Operasyon Kullanıcısı',
    role: 'operator',
  ),
];

AppUser? authenticateUser({
  required String username,
  required String password,
}) {
  for (final user in mockUsers) {
    if (user.username == username.trim() && user.password == password) {
      return user;
    }
  }
  return null;
}


