import 'dart:io';
import 'package:alandi/config/exported_path.dart';
import 'package:http/http.dart' as http;

@lazySingleton
class AddComplaintsController extends GetxController {
  final latLng = ''.obs;
  final landMarkController = TextEditingController();
  final descriptionController = TextEditingController();
  final imageList = [].obs;
  File? imageFile;
  dynamic data;
  final isLoading = false.obs;
  final ward = RxnString();
  final formKey = GlobalKey<FormState>();

  Future<void> uploadFiles(String deptId) async {
    Get.dialog(FutureBuilder(
      builder: (
        BuildContext context,
        AsyncSnapshot<Map<String, dynamic>> snapshot,
      ) {
        List<Widget> children;
        if (snapshot.hasData) {
          data = snapshot.data;
          if (data!['common']['status'] == true) {
            Future.delayed(const Duration(seconds: 2), () async {
              Get.offAll(() => ComplaintSummary(
                    isList: false,
                    complaintId: data['data']['complaint_id'].toString(),
                  ));
            });

            children = <Widget>[
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 60,
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  data['common']['message'],
                  style: TextStyle(color: Colors.black),
                ),
              )
            ];
          } else {
            Future.delayed(const Duration(seconds: 10), () {
              Get.back();
            });
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  data['common']['message'],
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ];
          }
        } else {
          Future.delayed(const Duration(seconds: 5), () {});
          children = <Widget>[
            SizedBox(
              width: 60,
              height: 60,
              child: LoadingWidget(color: primaryBlack),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                'Processing',
                style: TextStyle(color: Colors.black),
              ),
            )
          ];
        }
        return AlertDialog(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          content: SizedBox(
            height: 150,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ),
            ),
          ),
        );
      },
      future: uploadFileApiCall(
          departmentId: deptId,
          wardId: ward.value!,
          landMark: landMarkController.text,
          description: descriptionController.text,
          latLong: latLng.value,
          files: imageList),
    ));
  }

  Future<Map<String, dynamic>> uploadFileApiCall({
    required String departmentId,
    required List files,
    required String wardId,
    required String landMark,
    required String description,
    required String latLong,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final authKey = prefs.getString('auth_key') ?? '';
    final userId = prefs.getString('user_id') ?? '';
    final url = Uri.parse(Urls.newComplaint);
    try {
      final details = await getDetails();
      final request = http.MultipartRequest('POST', url);

      // Headers
      request.headers['Authorization'] = 'Bearer $authKey';

      // Fields
      request.fields.addAll({
        'user_id': userId,
        'department_id': departmentId,
        'ward_id': wardId,
        'landmark': landMark,
        'description': description,
        // 'lat_long': latLong,
        'lat_long': details['latLng'] ?? '',
        'address': details['userLocation'] ?? '',
        'time': details['dateTime'] ?? '',
      });

      // Files
      for (var file in files) {
        if (file['path'] != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'attachments[]',
            file['path'].path,
          ));
        }
      }

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final responseData = json.decode(response.body);

      if (responseData['common']['status'] == true) {
        resetForm();
        return responseData;
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Something went wrong. Please try again.',
      };
    }
  }

  Future<String> updateUserLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
    try {
      final LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
      Position position = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings);
      latLng.value =
          '${position.latitude.toString()}, ${position.longitude.toString()}';
    } finally {}
    return latLng.value;
  }

  void pickImage(String from) async {
    isLoading(true);
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: from == 'camera' ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 50,
    );
    if (image != null) {
      File? img = File(image.path);
      final details = await getDetails();
      Map<String, dynamic> data = {
        'path': img,
        'from': 'camera',
        'latLng': details['latLng'] ?? '',
        'userLocation': details['userLocation'] ?? '',
        'dateTime': details['dateTime'] ?? '',
      };
      imageList.add(data);
      imageFile = img;
    }
    isLoading(false);
  }

  void pickPdf() async {
    isLoading(true);
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
      ],
    );
    if (result != null) {
      File file = File(result.files.single.path!);

      // Get file size in bytes
      int sizeInBytes = await file.length();
      double sizeInMb = sizeInBytes / (1024 * 1024);

      if (sizeInMb <= 10) {
        // ✅ File is under 10MB
        Map<String, dynamic> data = {'path': file, 'from': 'pdf'};
        imageList.add(data);
      } else {
        // ❌ File is too large
        Get.snackbar(
          "Error",
          "PDF size must be less than 10 MB",
          snackPosition: SnackPosition.BOTTOM,
        );
      }

      // Map<String, dynamic> data = {'path': file, 'from': 'pdf'};
      // imageList.add(data);
    }
    isLoading(false);
  }

  Future<void> showOptions() async {
    return await Get.dialog(AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: const Text('Choose option'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take a photo'),
            onTap: () async {
              Get.back();
              pickImage('camera');
            },
          ),
          ListTile(
            leading: const Icon(Icons.image_outlined),
            title: const Text('Take From Gallery'),
            onTap: () async {
              Get.back();
              pickImage('gallery');
            },
          ),
          ListTile(
            leading: const Icon(Icons.insert_drive_file),
            title: const Text('Choose file'),
            onTap: () async {
              Get.back();
              pickPdf();
            },
          ),
        ],
      ),
    ));
  }

  resetForm() {
    imageList.clear();
    latLng.value = '';
    ward.value = '';
    landMarkController.clear();
    descriptionController.clear();
  }
}
