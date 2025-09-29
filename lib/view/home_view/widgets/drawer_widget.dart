import 'package:alandi/config/exported_path.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({
    super.key,
  });

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final controller = getIt<HomeController>();

  BottomNavigationPageController bottomNavigationPageController = Get.find();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    controller.data.value = json.decode(prefs.getString('userDetails') ?? '{}');
    controller.name.value = prefs.getString('user_name') ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: [
              header(),
              _divider(),
              _buildListTile(HugeIcons.strokeRoundedUser, 'My Profile',
                  () => bottomNavigationPageController.changePage(4)),
              _divider(),
              _buildListTile(HugeIcons.strokeRoundedOffice, 'Departments',
                  () => bottomNavigationPageController.changePage(0)),
              _divider(),
              _buildListTile(HugeIcons.strokeRoundedUserWarning01, 'Complaints',
                  () => bottomNavigationPageController.changePage(2)),
              _divider(),
              _buildListTile(HugeIcons.strokeRoundedLink02, 'Important Links',
                  () => bottomNavigationPageController.changePage(3)),
              _divider(),
              _buildListTile(HugeIcons.strokeRoundedProfile, 'User Manual',
                  () => Get.to(() => PdfView(pdf: controller.pdf.value))),
              _divider(),
              _buildListTile(
                  HugeIcons.strokeRoundedInformationCircle,
                  'About Us',
                  () => bottomNavigationPageController.changePage(1)),
              _divider(),
              _buildListTile(HugeIcons.strokeRoundedDelete02, 'Delete Account',
                  () => Get.to(() => const DeleteAccount())),
              _divider(),
              _buildListTile(HugeIcons.strokeRoundedLogout01, 'Log Out',
                  () => logoutDialog()),
            ],
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget header() {
    return Obx(
      () => Container(
        height: Get.height * 0.17,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: CircleAvatar(
                backgroundColor: Colors.grey.shade500,
                radius: 40,
                child: Text(
                  controller.name.isNotEmpty
                      ? controller.name.value[0].toUpperCase()
                      : '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Get.height * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.name.value,
                  style: const TextStyle(color: Colors.black),
                ),
                Text(
                  controller.data['mobile_no'] ?? '',
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Text('Crafted with by ❤', style: TextStyle(color: Colors.grey)),
          InkWell(
            onTap: () =>
                launchInBrowser(Uri.parse('https://deepmindsinfotech.com')),
            child: const Text(
              'Deepminds Infotech Pvt. Ltd.',
              style: TextStyle(
                  decoration: TextDecoration.underline, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black, size: Get.width * 0.06),
      title: Text(title.tr),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  // Widget _buildImageTile(String assetPath, String title, VoidCallback onTap) {
  //   return ListTile(
  //     leading: Image.asset(assetPath, width: Get.width * 0.07),
  //     title: Text(title.tr),
  //     onTap: () {
  //       Navigator.pop(context);
  //       onTap();
  //     },
  //   );
  // }

  Widget _divider() => const Divider(height: 0);
}
