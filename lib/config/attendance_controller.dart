import 'dart:typed_data';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AttendanceImage {
  final Uint8List imageBytes;
  final String latLng;
  final String userLocation;
  final String dateTime;

  AttendanceImage({
    required this.imageBytes,
    required this.latLng,
    required this.userLocation,
    required this.dateTime,
  });
}

class AttendanceController extends GetxController {
  final images = <AttendanceImage>[].obs;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImageAndDetails({required bool fromCamera}) async {
    try {
      final pickedImage = await _picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      );
      if (pickedImage == null) return;

      final bytes = await pickedImage.readAsBytes();

      final position = await _getCurrentPosition();
      String latLng = '';
      String userLocation = '';
      String dateTime = '';

      if (position != null) {
        latLng = 'Lat: ${position.latitude}, Long: ${position.longitude}';

        final placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          userLocation =
          '${p.name}, ${p.subLocality}, ${p.locality}, ${p.administrativeArea}, ${p.country}';
        }

        dateTime = DateFormat('dd MMM yyyy hh:mm a').format(DateTime.now());
      }

      images.add(
        AttendanceImage(
          imageBytes: bytes,
          latLng: latLng,
          userLocation: userLocation,
          dateTime: dateTime,
        ),
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
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
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
