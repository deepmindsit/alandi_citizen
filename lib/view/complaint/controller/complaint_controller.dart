import 'package:alandi/config/exported_path.dart';

@lazySingleton
class ComplaintController extends GetxController {
  final isFirstLoadRunning = false.obs;
  final isLoadMoreRunning = false.obs;
  RxInt page = 0.obs;
  final hasNextPage = false.obs;
  final language = getIt<LanguageController>();
  final complaintList = [].obs;

  Future firstLoad() async {
    final limit = 10;
    isFirstLoadRunning.value = true;
    try {
      page.value = 0;
      hasNextPage.value = true; // reset pagination
      final prefs = await SharedPreferences.getInstance();
      var user = prefs.getString('user_id');
      final res = await apiClient.post(
        Urls.getComplaint,
        {
          'user_id': user,
          'lang': language.isEnglish.value ? 'en' : 'mr',
          'page_no': page.toString()
        },
      );
      checkLogin(res['user_login']);
      complaintList.value = res['data'];
      hasNextPage.value = complaintList.length == limit;
    } finally {}
    isFirstLoadRunning.value = false;
  }

  void loadMore() async {
    if (hasNextPage.value == true &&
        isFirstLoadRunning.value == false &&
        isLoadMoreRunning.value == false) {
      isLoadMoreRunning.value = true;
      page.value += 1;
      try {
        final prefs = await SharedPreferences.getInstance();
        var user = prefs.getString('user_id');
        final res = await apiClient.post(
          Urls.getComplaint,
          {
            'user_id': user,
            'lang': language.isEnglish.value ? 'en' : 'mr',
            'page_no': page.toString()
          },
        );
        final List fetchedPosts = res['data'] ?? [];
        if (fetchedPosts.isNotEmpty) {
          complaintList.addAll(fetchedPosts);
        } else {
          hasNextPage.value = false;
        }
      } catch (err) {
        if (kDebugMode) {}
      }
      isLoadMoreRunning.value = false;
    }
  }
}
