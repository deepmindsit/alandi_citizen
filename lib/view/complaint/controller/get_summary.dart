import 'package:alandi/config/exported_path.dart';

@lazySingleton
class GetSummary extends GetxController {
  final summaryList = {}.obs;
  final userData = {}.obs;
  // final language = Get.put(LanguageController());
  final language = getIt<LanguageController>();
  final path = ''.obs;
  final isLoading = false.obs;

  Future<void> getSummary({required var complaintId}) async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      var user = prefs.getString('user_id');
      final res = await apiClient.post(
        Urls.getComplaintDetails,
        {
          'user_id': user,
          'complaint_id': complaintId,
          'lang': language.isEnglish.value ? 'en' : 'mr',
        },
      );
      checkLogin(res['user_login']);
      res['common']['status'] == true
          ? summaryList.value = res['data']
          : summaryList.value = {};
      res['common']['status'] == true
          ? userData.value = res['user']
          : userData.value = {};

    } finally {
      isLoading.value = false;
    }

    //
    //   final prefs = await SharedPreferences.getInstance();
    // var authKey = prefs.getString('auth_key');
    // var user = prefs.getString('user_id');
    // try {
    //   http.Response response = (await http.post(
    //     Uri.parse(Urls.getComplaintDetails),
    //     headers: {
    //       'Authorization': 'Bearer $authKey',
    //     },
    //     body: {
    //       'user_id': user,
    //       'complaint_id': complaintId,
    //       'lang': language.isEnglish.value ? 'en' : 'mr',
    //     },
    //   ));
    //   Map<String, dynamic> res =
    //       json.decode(response.body) as Map<String, dynamic>;
    //   developer.log(res.toString());
    //   res['common']['status'] == true
    //       ? summaryList.value = res['data']
    //       : summaryList.value = {};
    //   res['common']['status'] == true
    //       ? userData.value = res['user']
    //       : userData.value = {};
    //   checkLogin(res['common']['user_login']);
    // } catch (e) {
    //   debugPrint("Error: $e");
    // } finally {
    //   isLoading.value = false;
    // }
  }
  //
  // void getSummary({required var complaintId}) async {
  //   http.Response response = (await http.post(
  //     Uri.parse(Urls.getComplaintDetails),
  //     headers: {
  //       'Authorization': 'Bearer $authKey',
  //     },
  //     body: {
  //       'user_id': user,
  //       'complaint_id': complaintId,
  //       'lang': language.isEnglish.value ? 'en' : 'mr',
  //     },
  //   ));
  //   Map<String, dynamic> res =
  //       json.decode(response.body) as Map<String, dynamic>;
  //   developer.log(res.toString());
  //   res['common']['status'] == true
  //       ? summaryList.value = res['data']
  //       : summaryList.value = {};
  //   res['common']['status'] == true
  //       ? userData.value = res['user']
  //       : userData.value = {};
  //
  //   checkLogin(res['common']['user_login']);
  // }
}
