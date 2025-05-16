import 'package:flutter/widgets.dart';
import 'package:vgv/app.dart';
import 'package:vgv/config/bootstrap.dart';
import 'package:vgv/config/env_loader.dart';
import 'package:vgv/dependency_injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = EnvLoader.getConfig('staging');

  await configureDependencies(config: config);

  await bootstrap(
    () => const App(),
    config: config,
  );
}
