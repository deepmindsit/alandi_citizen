import 'package:alandi/config/exported_path.dart';

@lazySingleton
class GetLinks extends GetxController {
  final linkList = [].obs;
  var isLoading = true.obs;
  final language = getIt<LanguageController>();

  Future<Map<String, dynamic>> getLinks() async {
    isLoading(true);
    final prefs = await SharedPreferences.getInstance();
    var user = prefs.getString('user_id');
    final res = await apiClient.post(
      Urls.getLinks,
      {
        'user_id': user,
        'lang': language.isEnglish.value ? 'en' : 'mr',
      },
    );
    isLoading(false);
    checkLogin(res['user_login']);
    res['common']['status'] == true
        ? linkList.value = res['data']
        : linkList.value = [];

    return res;
  }
}
