import 'package:alandi/config/attendance_controller.dart';
import 'package:alandi/config/exported_path.dart';

class AttendanceWidget extends StatelessWidget {
  AttendanceWidget({super.key});
  final controller = Get.put(AttendanceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance Capture')),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.images.isEmpty) {
                return const Center(
                  child: Text('Tap a button to capture or pick an image.'),
                );
              }
              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // two images per row
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: controller.images.length,
                itemBuilder: (context, index) {
                  final imgData = controller.images[index];
                  return GestureDetector(
                    onTap: () {
                      Get.dialog(
                        Dialog(
                          surfaceTintColor: Colors.white,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                child: Image.memory(
                                  imgData.imageBytes,
                                  fit: BoxFit.contain,
                                  width: Get.width * 0.6,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (imgData.userLocation.isNotEmpty)
                                      Text('📍 ${imgData.userLocation}',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500)),
                                    if (imgData.latLng.isNotEmpty)
                                      Text('🌐 ${imgData.latLng}',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500)),
                                    if (imgData.dateTime.isNotEmpty)
                                      Text('🕒 ${imgData.dateTime}',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () => Get.back(),
                                child: const Text("Close"),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        imgData.imageBytes,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    onPressed: () =>
                        controller.pickImageAndDetails(fromCamera: true),
                    child: const Text('Capture from Camera'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800]),
                    onPressed: () =>
                        controller.pickImageAndDetails(fromCamera: false),
                    child: const Text('Pick from Gallery'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
