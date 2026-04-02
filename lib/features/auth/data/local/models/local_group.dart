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

  /// Sistem tarafından oluşturulan ve silinmemesi gereken gruplar için.
  bool isBuiltIn = false;

  DateTime createdAt = DateTime.now();

  DateTime updatedAt = DateTime.now();
}