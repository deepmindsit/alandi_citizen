import 'dart:io';

import 'package:alandi/config/exported_path.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class ApiClient {
  ApiClient();

  Future<Map<String, dynamic>> post(
      String urlPath, Map<String, dynamic> body) async {
    // final ioc = HttpClient()
    //   ..badCertificateCallback =
    //       (X509Certificate cert, String host, int port) => true;
    // final httpClient = IOClient(ioc);

    final prefs = await SharedPreferences.getInstance();
    final token = urlPath == Urls.sendOtp ||
            urlPath == Urls.verifyOtp ||
            urlPath == Urls.register ||
            urlPath == Urls.legalPage
        ? 'demo'
        : prefs.getString('auth_key') ?? 'demo';
    final url = Uri.parse(urlPath);
    print(url);
    final response = await http.post(
      // final response = await httpClient.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
    // if (urlPath != Urls.sendOtp &&
    //     urlPath != Urls.verifyOtp &&
    //     urlPath != Urls.register &&
    //     urlPath != Urls.legalPage) {
    //   checkLogin(body['user_login']);
    // }

    return jsonDecode(response.body);
  }
}

final apiClient = ApiClient();
