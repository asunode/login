import 'package:isar/isar.dart';

part 'local_group.g.dart';

@collection
class LocalGroup {
  LocalGroup();

  Id id = Isar.autoIncrement;

  @Index(unique: true, caseSensitive: false)
  late String name;

  String description = '';

  bool isActive = true;

  /// Grup bazli yetki paketinde yer alan modul kodlari.
  ///
  /// Bu alan, `Modul -> Grup -> Kullanici` yetki modeline gecis icin
  /// eklenmistir. Mevcut kullanici tarafindaki `stagedModuleCodes`
  /// mantigi hemen kaldirilmaz; gecis asamasi boyunca birlikte
  /// var olabilir.
  List<String> moduleCodes = <String>[];

  /// Sistem tarafından oluşturulan ve silinmemesi gereken gruplar için.
  bool isBuiltIn = false;

  DateTime createdAt = DateTime.now();

  DateTime updatedAt = DateTime.now();
}
