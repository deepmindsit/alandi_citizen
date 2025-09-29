import 'package:alandi/config/exported_path.dart';

class UpdateController extends GetxController {
  var currentVersion = ''.obs;
  var latestVersion = ''.obs;
  var updateData = {}.obs;

  /// Fetches profile data and initializes package info.
  Future<void> checkForUpdate() async {
    await _getDeptData();
    await _initPackageInfo();
  }

  // final language = Get.put(LanguageController());
  final language = getIt<LanguageController>();
  /// Fetch latest version from API
  Future<void> _getDeptData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var user = prefs.getString('user_id');
      final res = await apiClient.post(
        Urls.getDepartment,
        {
          'user_id': user,
          'lang': language.isEnglish.value ? 'en' : 'mr',
        },
      );
      res['common']['status'] == true
          ? updateData.value = res['android']
          : updateData.value = {};
    } finally {}
  }

  /// Get system app version and compare with latest API version.
  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    currentVersion.value = info.version;
    latestVersion.value = updateData['version'];

    int apiVersion = _versionToInt(latestVersion.value);
    int systemVersion = _versionToInt(currentVersion.value);

    if (apiVersion > systemVersion && updateData['show_popup'] == true) {
      _showUpdateDialog();
    }
  }

  /// Convert version `x.y.z` to integer for comparison.
  int _versionToInt(String version) {
    List<String> parts = version.split('.');
    int major = int.parse(parts[0]);
    int minor = int.parse(parts[1]);
    int patch = int.parse(parts[2]);
    return major * 1000000 + minor * 1000 + patch;
  }

  /// Show Update Dialog
  void _showUpdateDialog() {
    Get.dialog(
      PopScope(
        canPop: false,
        child: Dialog(
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    HugeIcons.strokeRoundedDownload02,
                    size: 36,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  'New Update Available!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  'A new version is available with exciting new features and improvements.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),

                // Buttons
                Row(
                  children: [
                    if (updateData['force_update'] == false)
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey,
                            side: const BorderSide(color: Colors.grey),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => Get.back(),
                          child: const Text('Later'),
                        ),
                      ),
                    if (updateData['force_update'] == false)
                      const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          side: BorderSide(color: Colors.transparent),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () =>
                            launchInBrowser(Uri.parse(updateData['url'])),
                        child: const Text('Update Now'),
                      ),
                    ),
                  ],
                ),

                // Force update notice
                if (updateData['force_update'] == true) ...[
                  const SizedBox(height: 12),
                  Text(
                    'This update is required to continue using the app',
                    style: TextStyle(
                      color: Colors.red[400],
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
