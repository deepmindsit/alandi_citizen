import 'package:alandi/config/exported_path.dart';

class LanguageController extends GetxController {
  var isEnglish = false.obs;

  void toggleLanguage() {
    isEnglish.value = !isEnglish.value;
    String locale = isEnglish.value ? 'en_US' : 'mr';
    Get.updateLocale(Locale(locale));
  }
}
