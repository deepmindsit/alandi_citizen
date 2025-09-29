import 'package:alandi/config/exported_path.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({
    super.key,
  });

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  final notificationData = getIt<GetNotification>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInternetAndShowPopup();
    });
    notificationData.firstLoad();
    notificationData.controller = ScrollController()
      ..addListener(notificationData.loadMore);
    super.initState();
  }

  @override
  void dispose() {
    notificationData.controller.removeListener(notificationData.loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey.withValues(alpha: 0.1),
        surfaceTintColor: Colors.grey.withValues(alpha: 0.1),
        title: Text(
          'Notifications'.tr,
          style: TextStyle(
              color: Colors.black,
              fontSize: Get.width * 0.07,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(
        () => notificationData.isFirstLoadRunning.isTrue
            ? LoadingWidget(color: primaryBlack)
            : notificationData.notificationList.isEmpty
                ? emptyData()
                : Column(
                    children: [
                      Expanded(
                        child: mainData(),
                      ),
                      if (notificationData.isLoadMoreRunning.isTrue)
                        const Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 20),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      if (notificationData.hasNextPage.isFalse)
                        Container(
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          // color: Colors.amber,
                          child: Center(
                            child: Text(
                              'You have reached at end of this page'.tr,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                          ),
                        ),
                    ],
                  ),
      ),
    );
  }

  Widget mainData() {
    return ListView.builder(
        controller: notificationData.controller,
        itemCount: notificationData.notificationList.length,
        itemBuilder: (_, index) => notificationCard(index));
  }

  Widget notificationCard(int index) {
    final notification = notificationData.notificationList[index];
    return Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black, width: 0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: ListTile(
          shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          isThreeLine: true,
          tileColor: notification['is_read']?.toString() == '0'
              ? primaryGrey
              : Colors.transparent,
          splashColor: Colors.transparent,
          dense: true,
          onTap: () async {
            final notificationId = notification['id']?.toString();
            final action = notification['action'];
            final data = notification['data'];

            if (notificationId != null) {
              await notificationData.readNotification(
                  notificationId: notificationId);
            }

            if (action == 'external_url' && data?['url'] != null) {
              final url = data['url'];
              await launchInBrowser(Uri.parse(url));
            } else if (data?['id'] != null) {
              Get.to(() => ComplaintSummary(
                    isList: true,
                    complaintId: data['id'].toString(),
                  ));
            }

            // Reload notification data after navigation
            notificationData.firstLoad();
          },
          title: Text(
            notification['title'] ?? '',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification['body'] ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                notification['created_on_date'] ?? '',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          trailing: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              notification['image'] ??
                  'https://static-00.iconduck.com/assets.00/person-icon-2048x2048-wiaps1jt.png',
              // width: 60,
              // height: 60,
              // fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 60,
                height: 60,
                color: Colors.grey.shade300,
                alignment: Alignment.center,
                child:
                    const Icon(Icons.broken_image, color: Colors.red, size: 30),
              ),
            ),
          ),
        ));
  }

  Widget emptyData() {
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
