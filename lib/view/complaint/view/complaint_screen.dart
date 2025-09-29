import 'package:alandi/config/exported_path.dart';

class ComplaintTest extends StatefulWidget {
  const ComplaintTest({super.key, required this.isDrawer});

  final bool isDrawer;

  @override
  State<ComplaintTest> createState() => _ComplaintTestState();
}

class _ComplaintTestState extends State<ComplaintTest> {
  final controller = getIt<ComplaintController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInternetAndShowPopup();
    });
    controller.firstLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: widget.isDrawer
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Get.off(() => MainScreen());
                },
              )
            : null,
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey.withValues(alpha: 0.1),
        surfaceTintColor: Colors.grey.withValues(alpha: 0.1),
        title: Text(
          'Complaints'.tr,
          style: TextStyle(
              color: Colors.black,
              fontSize: Get.width * 0.07,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(
        () => NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollEndNotification &&
                scrollNotification.metrics.pixels ==
                    scrollNotification.metrics.maxScrollExtent) {
              controller.loadMore();
            }
            return true;
          },
          child: controller.isFirstLoadRunning.isTrue
              ? LoadingWidget(color: primaryBlack)
              : controller.complaintList.isEmpty
                  ? emptyComplaint()
                  : Column(
                      children: [
                        Expanded(
                          child: complaintList(),
                        ),
                        buildLoader(),
                      ],
                    ),
        ),
      ),
    );
  }

  Widget complaintList() {
    return AnimationLimiter(
      child: ListView.builder(
          itemCount: controller.complaintList.length,
          itemBuilder: (_, index) => AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: complaintCard(index),
                  ),
                ),
              )),
    );
  }

  Widget complaintCard(int index) {
    final complaint = controller.complaintList[index];
    final int statusColor =
        int.tryParse(complaint['status_color'] ?? '0xFF000000') ?? 0xFF000000;
    return GestureDetector(
      onTap: () => Get.to(() => ComplaintSummary(
            isList: true,
            complaintId: complaint['id'].toString(),
          )),
      child: ComplaintCard(
        title: complaint['department'] ?? 'N/A',
        location: complaint['ward']?.toString() ?? 'N/A',
        date: complaint['created_on_date'] ?? 'N/A',
        status: complaint['status'] ?? 'N/A',
        statusColor: statusColor.toString(),
        ticketNo: complaint['code'] ?? '',
        deptImg: complaint['department_image'],
      ),
    );

    //   Card(
    //   surfaceTintColor: Colors.transparent,
    //   elevation: 0,
    //   shape: RoundedRectangleBorder(
    //     side: const BorderSide(color: Colors.black, width: 1),
    //     borderRadius: BorderRadius.circular(10),
    //   ),
    //   margin: const EdgeInsets.all(10),
    //   child: ListTile(
    //     tileColor: Colors.white,
    //     contentPadding: const EdgeInsets.symmetric(horizontal: 5),
    //     onTap: () {
    //       Get.to(() => ComplaintSummary(
    //             isList: true,
    //             complaintId: complaint['id'].toString(),
    //           ));
    //     },
    //     splashColor: Colors.transparent,
    //     dense: true,
    //     leading: Image.network(
    //       complaint['department_image'],
    //     ),
    //     title: Text(
    //       complaint['department'],
    //       style: const TextStyle(
    //           fontWeight: FontWeight.w500, fontSize: 16, height: 1.0),
    //     ),
    //     subtitle: Text(
    //       complaint['description'],
    //       maxLines: 1,
    //       overflow: TextOverflow.ellipsis,
    //     ),
    //     trailing: trailingButton(complaint),
    //   ),
    // );
  }

  Widget trailingButton(complaint) {
    final statusColor = Color(int.parse(complaint['status_color']));
    return Container(
        width: Get.width * 0.22,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: statusColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 1, color: statusColor),
        ),
        child: Text(
          complaint['status'],
          textAlign: TextAlign.center,
          style: TextStyle(height: 1, color: statusColor, fontSize: 14),
        ));
  }

  Widget buildLoader() {
    if (controller.isLoadMoreRunning.value) {
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: LoadingWidget(
          color: primaryBlack,
        ),
      );
    } else if (!controller.hasNextPage.value) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(child: Text('No more data')),
      );
    }
    return const SizedBox.shrink();
  }

  Widget emptyComplaint() {
    return Center(
        child: SizedBox(
            width: Get.width * 0.6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/empty_data.png'),
                Text(
                  'No Data Found'.tr,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              ],
            )));
  }
}
