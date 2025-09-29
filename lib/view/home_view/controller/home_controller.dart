// import 'dart:developer' as developer;
import 'package:alandi/config/exported_path.dart';

@lazySingleton
class HomeController extends GetxController {
  // final language = Get.put(LanguageController());
  final language = getIt<LanguageController>();
  final isLoading = true.obs;
  final name = ''.obs;
  final data = {}.obs;
  final departmentList = [].obs;
  final sliderList = [].obs;
  final complaintList = [].obs;
  final wardList = [].obs;
  final videoUrl = ''.obs;
  final pdf = ''.obs;
  final versionData = {}.obs;
  final currentVersion = ''.obs;
  final latestVersion = ''.obs;
  RxList filteredDataList = [].obs;
  final isSearch = false.obs;
  final searchController = TextEditingController();

  void filterData(String query) {
    if (query.trim().isEmpty) {
      filteredDataList.assignAll(departmentList);
      return;
    }

    final lowerCaseQuery = query.toLowerCase().trim();

    filteredDataList.assignAll(
      departmentList.where((item) {
        final title = (item['name'] ?? '').toString().toLowerCase();
        return title.contains(lowerCaseQuery);
      }).toList(),
    );
  }

  Future getDepartment() async {
    final prefs = await SharedPreferences.getInstance();
    var user = prefs.getString('user_id');
    final res = await apiClient.post(
      Urls.getDepartment,
      {
        'user_id': user,
        'lang': language.isEnglish.value ? 'en' : 'mr',
      },
    );

    checkLogin(res['user_login']);
    prefs.setString('manual', res['common']['user_manual']);
    res['common']['status'] == true
        ? departmentList.value = res['data']
        : departmentList.value = [];
    res['common']['status'] == true
        ? videoUrl.value = res['common']['video_url']
        : videoUrl.value = '';
    res['common']['status'] == true
        ? pdf.value = res['common']['user_manual']
        : pdf.value = '';
    res['common']['status'] == true
        ? versionData.value = res['android']
        : versionData.value = {};
  }

  Future getSlider() async {
    final prefs = await SharedPreferences.getInstance();
    var user = prefs.getString('user_id');
    final res = await apiClient.post(
      Urls.getSlider,
      {
        'user_id': user,
      },
    );
    res['common']['status'] == true
        ? sliderList.value = res['data']
        : sliderList.value = [];
    checkLogin(res['user_login']);
  }

  Future getComplaints() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var user = prefs.getString('user_id');
      final res = await apiClient.post(
        Urls.getComplaint,
        {
          'user_id': user,
          'lang': language.isEnglish.value ? 'en' : 'mr',
        },
      );

      res['common']['status'] == true
          ? complaintList.value = res['data']
          : complaintList.value = [];

      checkLogin(res['user_login']);
    } finally {}
  }

  Future getWard() async {
    final prefs = await SharedPreferences.getInstance();
    var user = prefs.getString('user_id');
    final res = await apiClient.post(
      Urls.getWard,
      {
        'user_id': user,
        'lang': language.isEnglish.value ? 'en' : 'mr',
      },
    );
    res['common']['status'] == true
        ? wardList.value = res['data']
        : wardList.value = [];
    checkLogin(res['user_login']);
  }
}
