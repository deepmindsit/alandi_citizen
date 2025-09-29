import 'package:alandi/config/exported_path.dart';

class AboutUs extends StatefulWidget {
  final bool isDrawer;

  const AboutUs({super.key, required this.isDrawer});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  final about = getIt<GetAbout>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInternetAndShowPopup();
    });
    about.getAbout();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(
          () => about.isLoading.isTrue
              ? LoadingWidget(color: primaryBlack)
              : about.aboutList.isNotEmpty
                  ? aboutUsContent()
                  : Center(
                      child:
                          CustomText(title: 'No Data Found'.tr, fontSize: 14),
                    ),
        ),
      ),
    );
  }

  Widget aboutUsContent() {
    final aboutData = about.aboutList[0];
    return AnimationLimiter(
        child: ListView(
            children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 375),
                childAnimationBuilder: (widget) => SlideAnimation(
                      verticalOffset: 50,
                      // horizontalOffset: 50.0,
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                children: [
          Column(children: [
            Column(
                spacing: Get.height * 0.015,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    aboutData['title'] ?? '',
                    style: TextStyle(
                        fontSize: Get.width * 0.05,
                        fontWeight: FontWeight.bold),
                  ),
                  FadeInImage(
                      placeholder:
                          AssetImage('assets/images/alandi_banner.jpg'),
                      imageErrorBuilder: (context, error, _) =>
                          Image.asset('assets/images/alandi_banner.jpg'),
                      image: NetworkImage(aboutData['image'])),
                  const Divider(),
                  Text(
                    aboutData['description'] ?? '',
                    style: TextStyle(
                        fontSize: Get.width * 0.04, color: Colors.grey),
                  ),
                ]),
          ]),
        ])));
  }

  AppBar appBar() {
    return AppBar(
      foregroundColor: Colors.black,
      backgroundColor: Colors.grey.withValues(alpha: 0.1),
      surfaceTintColor: Colors.grey.withValues(alpha: 0.1),
      leading: widget.isDrawer
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Get.off(() => MainScreen()),
            )
          : null,
      title: Text(
        'About Us'.tr,
        style: TextStyle(
            color: Colors.black,
            fontSize: Get.width * 0.07,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
