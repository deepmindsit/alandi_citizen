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
        padding: EdgeInsets.all(12),
        controller: notificationData.controller,
        itemCount: notificationData.notificationList.length,
        itemBuilder: (_, index) => notificationCard(index));
  }

  Widget notificationCard(int index) {
    final notification = notificationData.notificationList[index];
    final bool isRead = notification['is_read'].toString() == '1';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: isRead ? Colors.white : Colors.blue[50]?.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
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
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isRead ? Colors.grey.shade200 : Colors.blue.shade100,
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Notification Icon/Image with status indicator
                Stack(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: !isRead
                            ? Colors.blue.shade50
                            : Colors.grey.shade100,
                        border: Border.all(
                          color: !isRead
                              ? Colors.blue.shade200
                              : Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        !isRead
                            ? Icons.notifications_active_rounded
                            : Icons.notifications_rounded,
                        color: !isRead
                            ? Colors.blue.shade600
                            : Colors.grey.shade600,
                        size: 24,
                      ),
                    ),
                    if (!isRead)
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(width: 12),

// Notification Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title with read status
                                Text(
                                  notification['title'] ?? 'No Title',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: isRead
                                        ? FontWeight.w500
                                        : FontWeight.w700,
                                    color: isRead
                                        ? Colors.grey.shade800
                                        : Colors.blue.shade900,
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                const SizedBox(height: 4),

                                // Body text
                                Text(
                                  notification['body'] ?? '',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey.shade600,
                                    height: 1.4,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),

                          // Time and quick actions
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _formatTime(
                                  notification['created_on_date'] ?? '',
                                ),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey.shade500,
                                ),
                              ),

                              const SizedBox(height: 8),
// Quick action button for unread notifications
                              if (!isRead)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.blue.shade100,
                                    ),
                                  ),
                                  child: Text(
                                    'New',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Additional info or actions
                      if (notification['type'] != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            notification['type'].toString().toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // return Card(
    //     color: Colors.white,
    //     surfaceTintColor: Colors.white,
    //     elevation: 0,
    //     shape: RoundedRectangleBorder(
    //       side: const BorderSide(color: Colors.black, width: 0.5),
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //     margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    //     child: ListTile(
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(10),
    //       ),
    //       isThreeLine: true,
    //       tileColor: notification['is_read']?.toString() == '0'
    //           ? primaryGrey
    //           : Colors.transparent,
    //       splashColor: Colors.transparent,
    //       dense: true,
    //       onTap: () async {
    //         final notificationId = notification['id']?.toString();
    //         final action = notification['action'];
    //         final data = notification['data'];
    //
    //         if (notificationId != null) {
    //           await notificationData.readNotification(
    //               notificationId: notificationId);
    //         }
    //
    //         if (action == 'external_url' && data?['url'] != null) {
    //           final url = data['url'];
    //           await launchInBrowser(Uri.parse(url));
    //         } else if (data?['id'] != null) {
    //           Get.to(() => ComplaintSummary(
    //                 isList: true,
    //                 complaintId: data['id'].toString(),
    //               ));
    //         }
    //
    //         // Reload notification data after navigation
    //         notificationData.firstLoad();
    //       },
    //       title: Text(
    //         notification['title'] ?? '',
    //         style: const TextStyle(
    //           fontWeight: FontWeight.w500,
    //           fontSize: 16,
    //         ),
    //       ),
    //       subtitle: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text(
    //             notification['body'] ?? '',
    //             maxLines: 2,
    //             overflow: TextOverflow.ellipsis,
    //           ),
    //           const SizedBox(height: 4),
    //           Text(
    //             notification['created_on_date'] ?? '',
    //             style: const TextStyle(fontSize: 12, color: Colors.grey),
    //           ),
    //         ],
    //       ),
    //       trailing: ClipRRect(
    //         borderRadius: BorderRadius.circular(8),
    //         child: Image.network(
    //           notification['image'] ??
    //               'https://static-00.iconduck.com/assets.00/person-icon-2048x2048-wiaps1jt.png',
    //           // width: 60,
    //           // height: 60,
    //           // fit: BoxFit.cover,
    //           errorBuilder: (context, error, stackTrace) => Container(
    //             width: 60,
    //             height: 60,
    //             color: Colors.grey.shade300,
    //             alignment: Alignment.center,
    //             child:
    //                 const Icon(Icons.broken_image, color: Colors.red, size: 30),
    //           ),
    //         ),
    //       ),
    //     ));
  }

  String _formatTime(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inMinutes < 1) return 'Now';
      if (difference.inHours < 1) return '${difference.inMinutes}m';
      if (difference.inDays < 1) return '${difference.inHours}h';
      if (difference.inDays < 7) return '${difference.inDays}d';

      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
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
