import '../../../config/exported_path.dart';

@lazySingleton
class GetNotification extends GetxController {
  var isLoading = true.obs;
  final page = 0.obs;
  final hasNextPage = true.obs;
  final isFirstLoadRunning = false.obs;
  // final language = Get.put(LanguageController());
  final language = getIt<LanguageController>();
  final isLoadMoreRunning = false.obs;
  RxList notificationList = [].obs;
  ScrollController controller = ScrollController();

  @override
  void onInit() {
    firstLoad();
    super.onInit();
  }

  void firstLoad() async {
    isFirstLoadRunning.value = true;
    hasNextPage.value = true;
    try {
      page.value = 0;
      final prefs = await SharedPreferences.getInstance();
      var user = prefs.getString('user_id');
      final res = await apiClient.post(
        Urls.getNotification,
        {
          'user_id': user,
          'lang': language.isEnglish.value ? 'en' : 'mr',
          'page_no': page.toString()
        },
      );
      res['common']['status'] == true
          ? notificationList.value = res['data']
          : notificationList.value = [];
      checkLogin(res['user_login']);
    } catch (err) {
      if (kDebugMode) {}
    }
    isFirstLoadRunning.value = false;
  }

  void loadMore() async {
    if (hasNextPage.value == true &&
        isFirstLoadRunning.value == false &&
        isLoadMoreRunning.value == false &&
        controller.position.extentAfter < 300) {
      isLoadMoreRunning.value = true;
      page.value += 1; // Increase _page by 1
      try {
        final prefs = await SharedPreferences.getInstance();
        var user = prefs.getString('user_id');
        final res = await apiClient.post(
          Urls.getNotification,
          {
            'user_id': user,
            'lang': language.isEnglish.value ? 'en' : 'mr',
            'page_no': page.toString()
          },
        );

        final List fetchedPosts = res['data'];
        if (fetchedPosts.isNotEmpty) {
          notificationList.addAll(fetchedPosts);
        } else {
          hasNextPage.value = false;
        }
      } catch (err) {
        if (kDebugMode) {}
      }
      isLoadMoreRunning.value = false;
    }
  }

  Future<void> readNotification({required var notificationId}) async {
    isLoading(true);

    try {
      final prefs = await SharedPreferences.getInstance();
      var user = prefs.getString('user_id');

      final res = await apiClient.post(
        Urls.readNotification,
        {
          'user_id': user,
          'notification_id': notificationId,
        },
      );

      isLoading(false);
      checkLogin(res['user_login']);
    } catch (e) {}
  }
}
