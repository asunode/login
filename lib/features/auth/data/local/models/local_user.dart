import 'package:isar/isar.dart';

part 'local_user.g.dart';

@collection
class LocalUser {
  LocalUser();

  Id id = Isar.autoIncrement;

  @Index(unique: true, caseSensitive: false)
  late String username;

  late String displayName;

  String email = '';

  /// Şifre düz metin tutulmaz.
  /// Burada yalnızca hash değer saklanır.
  late String passwordHash;

  /// İlk fazda basit ve güvenli ilerlemek için grup bilgisi string tutuluyor.
  /// Daha sonra gerekirse LocalGroup ilişkisine taşınabilir.
  String groupName = 'Kullanıcı';

  /// Modül tarafı şimdilik geçici staging mantığıyla tutulur.
  /// Burada gerçek final modül ID'leri değil, teknik code/key değerleri saklanır.
  /// İleride modül ID yapısı netleştiğinde dönüştürülebilir.
  List<String> stagedModuleCodes = <String>[];

  bool isActive = true;

  /// admin gibi sistem kullanıcıları için kullanılır.
  bool isBuiltIn = false;

  /// İlk şifre sonrası kullanıcıyı parola değiştirmeye zorlamak için.
  bool mustChangePassword = false;

  DateTime createdAt = DateTime.now();

  DateTime updatedAt = DateTime.now();

  DateTime? lastLoginAt;
}