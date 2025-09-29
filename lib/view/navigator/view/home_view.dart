import '../../../config/exported_path.dart';

class MainScreen extends StatelessWidget {
  MainScreen({
    super.key,
  });

  final bottomNavigationPageController =
      Get.put(BottomNavigationPageController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: BottomNavigationPageController.to.currentPage,
        bottomNavigationBar: Theme(
          data: ThemeData(
            useMaterial3: false,
            splashColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            unselectedFontSize: 11,
            elevation: 10,
            backgroundColor: Colors.white,
            currentIndex: BottomNavigationPageController.to.currentIndex.value,
            onTap: BottomNavigationPageController.to.changePage,
            unselectedItemColor: Colors.grey,
            selectedItemColor: primaryOrange,
            showUnselectedLabels: true,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const Icon(HugeIcons.strokeRoundedHome01),
                label: 'Home'.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(HugeIcons.strokeRoundedInformationCircle),
                label: 'About Us2'.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(HugeIcons.strokeRoundedUserWarning01),
                label: 'Complaints'.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(HugeIcons.strokeRoundedLink02),
                label: 'Links'.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(HugeIcons.strokeRoundedUser),
                label: 'Profile'.tr,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
