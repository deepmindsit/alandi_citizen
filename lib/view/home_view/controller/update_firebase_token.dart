import '../../../config/exported_path.dart';

class FirebaseTokenController {
  FirebaseTokenController._privateConstructor();

  static final FirebaseTokenController _instance =
      FirebaseTokenController._privateConstructor();

  factory FirebaseTokenController() {
    return _instance;
  }

  Future<Map<String, dynamic>> updateToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    // print('token');
    // print(token);
    final prefs = await SharedPreferences.getInstance();
    var user = prefs.getString('user_id');
    final res = await apiClient.post(
      Urls.updateFirebaseToken,
      {'user_id': user, 'token': token},
    );

    //
    //
    //
    // var prefs = await SharedPreferences.getInstance();
    // var authKey = prefs.getString('auth_key');
    // var user = prefs.getString('user_id');
    // final url = Uri.parse(Urls.updateFirebaseToken);
    // final response = await http.post(
    //   url,
    //   headers: {
    //     'Authorization': 'Bearer $authKey',
    //   },
    //   body: {'user_id': user, 'token': token},
    // );
    // Map<String, dynamic> res =
    //     json.decode(response.body) as Map<String, dynamic>;

    return res;
  }
}
