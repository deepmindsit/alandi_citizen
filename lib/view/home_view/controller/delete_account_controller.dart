import 'package:alandi/config/exported_path.dart';

@lazySingleton
class DeleteAccountController {
  DeleteAccountController._privateConstructor();

  static final DeleteAccountController _instance =
      DeleteAccountController._privateConstructor();

  factory DeleteAccountController() {
    return _instance;
  }

  Future<Map<String, dynamic>> deleteAccountData() async {
    final prefs = await SharedPreferences.getInstance();
    var user = prefs.getString('user_id');
    final res = await apiClient.post(
      Urls.deleteAccount,
      {
        'user_id': user,
      },
    );

    return res;
  }
}
