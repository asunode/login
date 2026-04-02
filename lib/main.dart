import 'package:flutter/widgets.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'package:login/app.dart';
import 'package:login/features/auth/data/local/bootstrap/local_auth_bootstrap.dart';
import 'package:login/features/auth/data/local/models/local_group.dart';
import 'package:login/features/auth/data/local/models/local_module.dart';
import 'package:login/features/auth/data/local/models/local_user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDirectory = await getApplicationSupportDirectory();

  final isar = await Isar.open(
    [
      LocalUserSchema,
      LocalGroupSchema,
      LocalModuleSchema,
    ],
    directory: appDirectory.path,
    name: 'login_shell',
  );

  await LocalAuthBootstrap.ensureSeedData(isar);

  runApp(const ShellFirstApp());
}
