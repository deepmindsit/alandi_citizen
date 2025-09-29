import 'package:alandi/config/exported_path.dart';
import 'package:alandi/di/injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();
