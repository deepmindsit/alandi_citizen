import 'exported_path.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  LanguageController get languageController => LanguageController();
}
