import 'package:alandi/config/exported_path.dart';

class Links extends StatefulWidget {
  final bool isDrawer;

  const Links({super.key, required this.isDrawer});

  @override
  State<Links> createState() => _LinksState();
}

class _LinksState extends State<Links> {
  final linksData = getIt<GetLinks>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInternetAndShowPopup();
    });
    linksData.getLinks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.grey.withValues(alpha: 0.1),
          surfaceTintColor: Colors.grey.withValues(alpha: 0.1),
          leading: widget.isDrawer
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Get.off(() => MainScreen());
                  },
                )
              : null,
          title: Text(
            'Important Links'.tr,
            style: TextStyle(
                color: Colors.black,
                fontSize: Get.width * 0.07,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Obx(() {
          if (linksData.isLoading.value) {
            return LoadingWidget(color: primaryBlack);
          }

          if (linksData.linkList.isEmpty) {
            return const Center(child: Text('Data is empty'));
          }

          return linkData();
        }));
  }

  Widget linkData() {
    return AnimationLimiter(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 5.0,
          mainAxisExtent: Get.height * 0.15,
          crossAxisSpacing: 5.0, // spacing between columns
        ),
        itemCount: linksData.linkList.length,
        itemBuilder: (_, int index) {
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 375),
            columnCount: linksData.linkList.length,
            child: ScaleAnimation(
              child: FadeInAnimation(child: buildLinkCard(index)),
            ),
          );
        },
      ),
    );
  }

  Widget buildLinkCard(int index) {
    final link = linksData.linkList[index];
    return GestureDetector(
      onTap: () =>
          link['url'] != null ? launchInBrowser(Uri.parse(link['url'])) : null,
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black, width: 0.5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: linkContent(link),
      ),
    );
  }

  Widget linkContent(var link) {
    return Container(
        width: Get.width * 0.3,
        height: Get.width * 0.2,
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: const Offset(2, 2),
                color: Colors.grey.shade300,
                blurRadius: 5.0,
              ),
            ],
            color: Colors.white,
            border: Border.all(width: 0.5, color: Colors.black54),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              link['image'],
              height: Get.height * 0.07,
              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
            ),
            Text(
              link['name'],
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(height: 1),
            ),
          ],
        ));
  }
}
