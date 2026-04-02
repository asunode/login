import 'package:isar/isar.dart';

part 'local_module.g.dart';

@collection
class LocalModule {
  LocalModule();

  Id id = Isar.autoIncrement;

  /// Teknik anahtar.
  /// İleride uygulama içi menü/route eşleşmelerinde kullanılacak.
  @Index(unique: true, caseSensitive: false)
  late String code;

  /// Ekranda görünen modül adı.
  late String name;

  String description = '';

  /// İlk oluşturma anında başlığa göre seçilen,
  /// sonrasında sabit kalacak ikon anahtarı.
  ///
  /// Not:
  /// Gerçek ikon/metadata genişlemesi ileride PostgreSQL bağlantısı geldiğinde
  /// daha detaylı modele taşınabilir.
  String iconKey = 'module-default';

  bool isActive = true;

  /// Sistem tarafından oluşturulan temel modüller için.
  bool isBuiltIn = false;

  DateTime createdAt = DateTime.now();

  DateTime updatedAt = DateTime.now();
}