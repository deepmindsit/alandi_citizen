import '../../../config/exported_path.dart';

@lazySingleton
class ProfileController extends GetxController {
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  dynamic data;
  final name = ''.obs;
  final isUpdate = false.obs;
  final isLoading = false.obs;
  final isLoading2 = false.obs;
  final privacyData = {}.obs;
  FocusNode nameFocusNode = FocusNode();

  void getData() async {
    isLoading2(true);
    final prefs = await SharedPreferences.getInstance();
    data = json.decode(prefs.getString('userDetails') ?? '{}');
    name.value = prefs.getString('user_name').toString();

    _updateTextFields(data);
  }

  _updateTextFields(var data2) async {
    nameController.text = name.value;
    numberController.text = data2['mobile_no'].toString();
    isLoading2(false);
  }

  Future<void> saveUserName(String newName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', newName);
  }

  Future<Map<String, dynamic>> updateProfile({required String name}) async {
    try {
      isLoading(true);

      final prefs = await SharedPreferences.getInstance();
      var userId = prefs.getString('user_id');
      final res = await apiClient.post(
        Urls.updateProfile,
        {
          'user_id': userId,
          'name': name,
        },
      );
      if (res['common']['status'] == true) {
        checkLogin(res['user_login']);
      }

      return res;
    } catch (e) {
      // print("Error updating profile: $e");
      return {'error': e.toString()};
    } finally {
      isLoading(false);
    }
  }

  Future getPolicy({required String slug}) async {
    isLoading.value = true;
    try {
      final res = await apiClient.post(
        Urls.legalPage,
        {
          'slug': slug,
        },
      );
      res['common']['status'] == true
          ? privacyData.value = res['data']
          : privacyData.value = {};
    } finally {
      isLoading.value = false;
    }
  }
}
