import 'dart:io';
import 'package:alandi/config/exported_path.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

Future<void> launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch $url');
  }
}

Future<Position> liveLocation() async {
  await Geolocator.requestPermission()
      .then((value) {})
      .onError((error, stackTrace) {});
  return await Geolocator.getCurrentPosition();
}

void checkLogin(bool isLogin) async {
  if (isLogin == false) {
    Get.snackbar(
      'Logged Out',
      "Your account is logged in on another device. You have been logged out.",
      colorText: Colors.black,
      icon: const Icon(Icons.add_alert),
    );
    Get.offAll(() => const PageViewWidget());
    var prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}

void showMoreData(String desc) {
  Get.dialog(
    Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                desc,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: const Text("Close"),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Future<File> createFileOfPdfUrl({
  required var url2,
}) async {
  Completer<File> completer = Completer();
  try {
    final url = url2;
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    var dir = await getApplicationDocumentsDirectory();
    File file = File("${dir.path}/$filename");

    await file.writeAsBytes(bytes, flush: true);
    completer.complete(file);
  } catch (e) {
    throw Exception('Error parsing asset file!');
  }
  return completer.future;
}

Widget data({required var title, required var text, required bool isColor}) {
  return Container(
    height: Get.height * 0.07,
    color: isColor ? Colors.grey[200] : Colors.transparent,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          width: Get.width * 0.5,
          child: Text(text,
              style: const TextStyle(
                fontSize: 16,
              )),
        ),
      ],
    ),
  );
}

Future<void> logoutDialog() async {
  Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to logout?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () async {
              await _logoutUser();
            },
          ),
        ],
      ));
}

Future<void> _logoutUser() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  Get.offAll(() => const PageViewWidget());
}

Widget buildDialogButton(String text, Color color, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: Get.height * 0.04,
      width: Get.width * 0.3,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: Get.height * 0.025),
        ),
      ),
    ),
  );
}

Future<void> checkLocationAccess() async {
  final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  final LocationPermission permission = await Geolocator.checkPermission();

  if (!serviceEnabled ||
      permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    _showLocationDialog();
  } else {
    _requestLiveLocation();
  }
}

void _showLocationDialog() async {
  await Future.delayed(const Duration(milliseconds: 50));
  Get.dialog(PopScope(
    canPop: false,
    child: AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        icon: const Icon(Icons.location_pin, color: Colors.green),
        title: Text('Use your location'.tr),
        content: Text("locationDialog".tr),
        actions: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/map.jpg',
                width: Get.width * 0.6,
                height: Get.height * 0.2,
              ),
            ),
          ),
          SizedBox(
            height: Get.height * 0.04,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildDialogButton('DENY', Colors.red, _handleDenyAction),
              buildDialogButton('ACCEPT', Colors.green, _handleAcceptAction),
            ],
          )
        ]),
  ));
}

void _handleDenyAction() {
  if (Platform.isIOS) {
    exit(0);
  } else {
    showLogoutDialog();
  }
}

void _requestLiveLocation() {
  liveLocation();
}

void _handleAcceptAction() {
  Get.back(); // Close the dialog
  _requestLiveLocation();
}

void showLogoutDialog() {
  Get.dialog(
    AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: const Text('Are you sure?'),
      content: const Text(
        "If you can't accept location permission, you can't use the app. \nAre you sure you want to exit?",
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Get.back(),
        ),
        TextButton(
          child: const Text(
            'Exit',
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () => SystemNavigator.pop(),
        ),
      ],
    ),
  );
}

Widget headerRequired({required String header, required bool isRequired}) {
  return Text.rich(
    TextSpan(
      children: [
        TextSpan(
          text: header.tr,
          style: TextStyle(
            fontSize: Get.width * 0.05,
            color: Colors.black,
          ),
        ),
        if (isRequired)
          TextSpan(
            text: ' *',
            style: TextStyle(
              fontSize: Get.width * 0.05,
              color: Colors.red,
            ),
          ),
      ],
    ),
  );
}

Future<Map<String, String>> getDetails() async {
  String latLng = '';
  String userLocation = '';
  String dateTime = '';

  final position = await _getCurrentPosition();
  if (position != null) {
    latLng = 'Lat: ${position.latitude}, Long: ${position.longitude}';
    final placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    if (placemarks.isNotEmpty) {
      final p = placemarks.first;
      userLocation =
          '${p.name}, ${p.subLocality}, ${p.locality}, ${p.administrativeArea}, ${p.country}';
    }
    dateTime = DateFormat('dd MMM yyyy hh:mm a').format(DateTime.now());
  }

  return {
    'latLng': latLng,
    'userLocation': userLocation,
    'dateTime': dateTime,
  };
}

Future<Position?> _getCurrentPosition() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      Get.snackbar('Permission Denied', 'Location access is required.');
      return null;
    }
  }
  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );
  return await Geolocator.getCurrentPosition(
      locationSettings: locationSettings);
}
