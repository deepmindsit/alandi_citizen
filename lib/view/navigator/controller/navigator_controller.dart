import '../../../config/exported_path.dart';

@lazySingleton
class BottomNavigationPageController extends GetxController {
  static BottomNavigationPageController get to => Get.find();

  final currentIndex = 0.obs;

  List<Widget> pages = [
    const HomeScreen(
      isDrawer: false,
    ),
    const AboutUs(
      isDrawer: false,
    ),
    const ComplaintTest(isDrawer: false),
    const Links(
      isDrawer: false,
    ),
    const Profile(
      isDrawer: false,
    ),
  ];

  Widget get currentPage => pages[currentIndex.value];

  void changePage(int index) {
    currentIndex.value = index;
  }
}
