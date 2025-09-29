import 'package:alandi/config/exported_path.dart';
import 'package:alandi/utils/policy_data.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  dynamic data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0.5,
        centerTitle: true,
        surfaceTintColor: Colors.white,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text(
          'Delete Account'.tr,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Icon(
                    Icons.warning_amber_rounded,
                    size: 48,
                    color: Colors.orange[700],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'We are sorry to see you go!'.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'DeleteLine'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Terms Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Before you proceed:'.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildBulletPoint(
                    'All your data will be permanently deleted',
                  ),
                  const SizedBox(height: 8),
                  _buildBulletPoint(
                    'This action cannot be undone',
                  ),
                  const SizedBox(height: 8),
                  _buildBulletPoint(
                    'You will lose access to all account features',
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.grey[700],
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'By proceeding, you acknowledge our '.tr,
                        ),
                        TextSpan(
                          text: 'Privacy Policy'.tr,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(() => const PolicyData(
                                    slug: 'privacy-policy',
                                  ));
                              // launchInBrowser(Uri.parse(Urls.privacyPolicy));
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: showDeleteConfirmationDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Delete My Account'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4, right: 8),
          child: Icon(
            Icons.circle,
            size: 8,
            color: Colors.grey[600],
          ),
        ),
        Expanded(
          child: Text(
            text.tr,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  void showDeleteConfirmationDialog() {
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.warning_rounded,
                    size: 28,
                    color: Colors.orange[700],
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Confirm Deletion'.tr,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Are you absolutely sure you want to delete your account? This action is permanent and cannot be undone.'
                    .tr,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      'Cancel'.tr,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () {
                      Get.back();
                      deleteDialog();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red[50],
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      'Delete Account'.tr,
                      style: TextStyle(
                        color: Colors.red[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void deleteDialog() {
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: FutureBuilder(
            future: DeleteAccountController().deleteAccountData(),
            builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.hasData) {
                data = snapshot.data;
                if (data!['common']['status'] == true) {
                  Future.delayed(const Duration(seconds: 2), () async {
                    var prefs = await SharedPreferences.getInstance();
                    prefs.clear();
                    Get.offAll(() => const PageViewWidget());
                  });

                  return _buildDialogContent(
                    icon: Icons.check_circle_rounded,
                    iconColor: Colors.green,
                    message: data['common']['message'],
                  );
                } else {
                  Future.delayed(const Duration(seconds: 2), () {
                    Get.back();
                  });
                  return _buildDialogContent(
                    icon: Icons.error_rounded,
                    iconColor: Colors.red,
                    message: data['common']['message'],
                  );
                }
              }
              return _buildDialogContent(
                icon: Icons.hourglass_top_rounded,
                iconColor: Colors.blue,
                message: 'Processing your request...'.tr,
                isProcessing: true,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDialogContent({
    required IconData icon,
    required Color iconColor,
    required String message,
    bool isProcessing = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        isProcessing
            ? SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  color: iconColor,
                  strokeWidth: 3,
                ),
              )
            : Icon(
                icon,
                size: 60,
                color: iconColor,
              ),
        const SizedBox(height: 24),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
          ),
        ),
        if (isProcessing) const SizedBox(height: 16),
      ],
    );
  }
}
