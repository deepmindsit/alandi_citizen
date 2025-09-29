import '../../../config/exported_path.dart';

@lazySingleton
class GetAbout extends GetxController {
  final aboutList = [].obs;
  var isLoading = true.obs;
  // final language = Get.put(LanguageController());
  final language = getIt<LanguageController>();
  void getAbout() async {
    isLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      var userId = prefs.getString('user_id');
      final res = await apiClient.post(
        Urls.aboutUS,
        {
          'user_id': userId,
          'lang': language.isEnglish.value ? 'en' : 'mr',
        },
      );
      checkLogin(res['user_login']);
      aboutList.value = res['common']['status'] == true ? res['data'] : [];
    } finally {
      isLoading(false);
    }
  }
}
