import 'package:alandi/config/exported_path.dart';

class ComplaintSummary extends StatefulWidget {
  final String complaintId;
  final bool isList;

  const ComplaintSummary(
      {super.key, required this.complaintId, required this.isList});

  @override
  State<ComplaintSummary> createState() => _ComplaintSummaryState();
}

class _ComplaintSummaryState extends State<ComplaintSummary> {
  final summaryData = getIt<GetSummary>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInternetAndShowPopup();
    });
    summaryData.getSummary(complaintId: widget.complaintId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        if (context.mounted) Get.offAll(() => MainScreen());
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FA),
        appBar: AppBar(
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              widget.isList ? Get.back() : Get.offAll(() => MainScreen());
            },
          ),
          foregroundColor: Colors.black,
          backgroundColor: const Color(0xFFF4F6FA),
          surfaceTintColor: const Color(0xFFF4F6FA),
          title: Text(
            'Complaint Summary'.tr,
            style: TextStyle(
                color: Colors.black,
                fontSize: Get.width * 0.07,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(
            () => summaryData.isLoading.isTrue
                ? LoadingWidget(color: primaryBlack)
                : summaryData.summaryList.isNotEmpty
                    ? SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (!widget.isList) _buildHeaderSection(),
                            _buildTitle('SUMMARY'.tr),
                            _buildTitleCard(),
                            SizedBox(height: 12),
                            _buildDescriptionCard(),
                            SizedBox(height: 12),
                            if (summaryData.summaryList['attachments'] != null)
                              _buildAttachmentsSection(),
                          ],
                        ),
                      )
                    : Center(
                        child: CustomText(
                          title: 'No Data Found'.tr,
                          fontSize: 14,
                        ),
                      ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleCard() {
    return GlassCard(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            sectionTitleWithIcon(
              '📄 ${summaryData.summaryList['code'] ?? ''}',
            ),
            StatusBadge(
              status: summaryData.summaryList['status'] ?? '',
              color:
                  int.tryParse(summaryData.summaryList['status_color'] ?? '') ??
                      0xFF025599,
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            IconBox(
              icon: HugeIcons.strokeRoundedUser,
              size: 20,
              color: Colors.blue.shade700,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Created By',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    summaryData.userData['name'] ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),
            IconBox(
              icon: HugeIcons.strokeRoundedDateTime,
              size: 20,
              color: Colors.blue.shade700,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date & Time :'.tr,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    summaryData.summaryList['created_on_date'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: buildDetailRow(
                icon: HugeIcons.strokeRoundedOffice,
                title: 'Department :'.tr,
                value: summaryData.summaryList['department'] ?? '-',
              ),
            ),
            Expanded(
              child: buildDetailRow(
                icon: HugeIcons.strokeRoundedArrange,
                title: 'Ward :'.tr,
                value: summaryData.summaryList['ward'] ?? '-',
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: buildDetailRow(
                icon: HugeIcons.strokeRoundedLocation09,
                title: 'Landmark :'.tr,
                value: summaryData.summaryList['landmark'] ?? '-',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescriptionCard() {
    return GlassCard(
      children: [
        Row(
          children: [
            IconBox(
                icon: HugeIcons.strokeRoundedDocumentValidation,
                size: 20,
                color: Colors.blue.shade700),
            // Icon(
            //   HugeIcons.strokeRoundedDocumentValidation,
            //   size: 20,
            //   color: primaryOrange,
            // ),
            SizedBox(width: 8),
            CustomText(
              title: 'Description :'.tr,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        SizedBox(height: 12),
        CustomText(
          title: summaryData.summaryList['description']?.toString() ?? '-',
          fontSize: 14,
          textAlign: TextAlign.start,
          maxLines: 12,
        ),
      ],
    );
  }

  Widget _buildAttachmentsSection() {
    return GlassCard(
      children: [
        sectionTitleWithIcon(
          '📎${'Attachments :'.tr}',
        ),
        AttachmentPreviewList(
          attachments: summaryData.summaryList['attachments'],
          onDownload: (path) => (),
        ),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      children: [
        Center(
          child: Image.asset(
            'assets/images/tick_mark.gif',
            height: Get.height * 0.15,
          ),
        ),
        Text(
          'apology'.tr,
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        const Divider(color: Colors.blue),
      ],
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const Divider(color: Colors.blue),
        ],
      ),
    );
  }

// Summary Details Section
//   Widget _buildSummaryDetails() {
//     return Column(
//       children: [
//         _buildRichText('CODE : '.tr, summaryData.summaryList['code']),
//         data(
//             title: 'Name :'.tr,
//             isColor: true,
//             text: summaryData.userData['name'] ?? ''),
//         data(
//             title: 'Mobile No :'.tr,
//             isColor: false,
//             text: summaryData.userData['mobile_no'] ?? ''),
//         data(
//           title: 'Date & Time :'.tr,
//           isColor: true,
//           text:
//               '${summaryData.summaryList['created_on_date']} ${summaryData.summaryList['created_on_time']}',
//         ),
//         data(
//             title: 'Department :'.tr,
//             isColor: false,
//             text: summaryData.summaryList['department'] ?? ''),
//         data(
//             title: 'Ward :'.tr,
//             isColor: true,
//             text: summaryData.summaryList['ward'] ?? ''),
//         data(
//             title: 'Status :'.tr,
//             isColor: false,
//             text: summaryData.summaryList['status'] ?? ''),
//       ],
//     );
//   }

  // Widget _buildRichText(String title, String value) {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Center(
  //       child: RichText(
  //         softWrap: true,
  //         text: TextSpan(
  //           text: title,
  //           style: const TextStyle(
  //               fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //           children: <TextSpan>[
  //             TextSpan(
  //               text: value,
  //               style: const TextStyle(
  //                   fontWeight: FontWeight.bold, color: Colors.blue),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget attachments() {
  //   return Container(
  //     color: Colors.grey[200],
  //     padding: const EdgeInsets.all(8.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(
  //           'Attachments :'.tr,
  //           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //         ),
  //         const SizedBox(height: 8.0),
  //         SizedBox(
  //           width: Get.width * 0.35,
  //           child: ListView.builder(
  //             shrinkWrap: true,
  //             itemCount: summaryData.summaryList['attachments'].length,
  //             itemBuilder: (context, index) {
  //               final attachment =
  //                   summaryData.summaryList['attachments'][index];
  //               final isImage = attachment['type'].contains('image');
  //               final isPdf = attachment['type'] == 'application/pdf';
  //
  //               if (isPdf) {
  //                 createFileOfPdfUrl(url2: attachment['path']).then((file) {
  //                   summaryData.path.value = file.path;
  //                 });
  //               }
  //
  //               return GestureDetector(
  //                 onTap: () =>
  //                     _showAttachmentDialog(isImage, attachment['path']),
  //                 child: Chip(
  //                   shape: const RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.all(Radius.circular(12)),
  //                   ),
  //                   elevation: 0,
  //                   padding: const EdgeInsets.all(3),
  //                   backgroundColor: Colors.blue.shade50,
  //                   avatar: Icon(
  //                     isImage ? Icons.image : Icons.picture_as_pdf,
  //                     color: Colors.blue,
  //                   ),
  //                   label: Text(
  //                     isImage ? 'Image $index.jpg' : 'Pdf $index.pdf',
  //                     style: const TextStyle(fontSize: 16, color: Colors.blue),
  //                   ),
  //                 ),
  //               );
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // void _showAttachmentDialog(bool isImage, String path) {
  //   Get.dialog(
  //     AlertDialog(
  //       backgroundColor: Colors.white,
  //       surfaceTintColor: Colors.white,
  //       contentPadding: const EdgeInsets.all(5),
  //       content: Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: SizedBox(
  //           width: Get.width * 0.8,
  //           height: Get.height * 0.5,
  //           child: isImage
  //               ? ClipRRect(
  //                   borderRadius: BorderRadius.circular(12),
  //                   child: Image.network(
  //                     path,
  //                     fit: BoxFit.cover,
  //                     width: Get.width * 0.7,
  //                     height: Get.height * 0.45,
  //                   ),
  //                 )
  //               : PDFView(
  //                   filePath: summaryData.path.value,
  //                   enableSwipe: true,
  //                   swipeHorizontal: true,
  //                   fitPolicy: FitPolicy.BOTH,
  //                 ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

// Widget landmark() {
//   return _buildInfoSection(
//       'Landmark :'.tr, summaryData.summaryList['landmark'], Colors.white);
// }

// Widget description() {
//   return _buildInfoSection('Description :'.tr,
//       summaryData.summaryList['description'], Colors.grey[200]);
// }

// Widget _buildInfoSection(String title, String text, var color) {
//   return Container(
//     color: color,
//     padding: const EdgeInsets.all(8.0),
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           flex: 2,
//           child: Text(
//             title,
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//         ),
//         Expanded(
//           flex: 3,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 text,
//                 maxLines: 3,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(fontSize: 16, height: 1.2),
//               ),
//               if (text.length >= 50)
//                 GestureDetector(
//                   onTap: () => showMoreData(text),
//                   child: const Padding(
//                     padding: EdgeInsets.only(top: 3.0),
//                     child: Text(
//                       'Read More',
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold, color: Colors.blue),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget attachments() {
//   return Container(
//     color: Colors.grey[200],
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text('Attachments :'.tr,
//               style:
//                   const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         ),
//         SizedBox(
//           width: Get.width * 0.35,
//           child: ListView.builder(
//             shrinkWrap: true,
//             itemCount: summaryData.summaryList['attachments'].length,
//             itemBuilder: (context, index) {
//               final attachment =
//                   summaryData.summaryList['attachments'][index];
//               final isImage = attachment['type'] == 'image/jpeg' ||
//                   attachment['type'] == 'image/jpg';
//               final isPdf = attachment['type'] == 'application/pdf';
//               if (isPdf) {
//                 createFileOfPdfUrl(url2: attachment['path']).then((file) {
//                   // setState(() {
//                   summaryData.path.value = file.path;
//                   // });
//                 });
//               }
//
//               return GestureDetector(
//                 onTap: () {
//                   Get.dialog(AlertDialog(
//                     backgroundColor: Colors.white,
//                     surfaceTintColor: Colors.white,
//                     contentPadding: const EdgeInsets.all(5),
//                     content: SizedBox(
//                       width: Get.width * 0.8,
//                       height: Get.height * 0.5,
//                       child: isImage
//                           ? Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(12),
//                                 child: Image.network(
//                                   attachment['path'],
//                                   fit: BoxFit.cover,
//                                   width: Get.width * 0.7,
//                                   height: Get.height * 0.45,
//                                 ),
//                               ),
//                             )
//                           : Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: PDFView(
//                                 filePath: summaryData.path.value,
//                                 enableSwipe: true,
//                                 swipeHorizontal: true,
//                                 fitPolicy: FitPolicy.BOTH,
//                               ),
//                             ),
//                     ),
//                   ));
//                 },
//                 child: Chip(
//                   shape: const RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(12))),
//                   elevation: 0,
//                   padding: const EdgeInsets.all(3),
//                   backgroundColor: Colors.blue.shade50,
//                   avatar: Icon(
//                     isImage ? Icons.image : Icons.picture_as_pdf,
//                     color: Colors.blue,
//                   ),
//                   //CircleAvatar
//                   label: isImage
//                       ? Text(
//                           'Image $index.jpg',
//                           style: const TextStyle(
//                               fontSize: 16, color: Colors.blue),
//                         )
//                       : Text(
//                           'Pdf $index.pdf',
//                           style: const TextStyle(
//                               fontSize: 16, color: Colors.blue),
//                         ), //Text
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     ),
//   );
// }
//
// Widget landmark() {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Text('Landmark :'.tr,
//             style:
//                 const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//       ),
//       SizedBox(
//         width: Get.width * 0.5,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(summaryData.summaryList['landmark'],
//                 maxLines: 3,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(
//                   height: 1,
//                   fontSize: 16,
//                 )),
//             if (summaryData.summaryList['landmark'].length >= 50)
//               GestureDetector(
//                   onTap: () {
//                     showMoreData(summaryData.summaryList['landmark']);
//                   },
//                   child: const Padding(
//                     padding: EdgeInsets.all(3.0),
//                     child: Text(
//                       'Read More',
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold, color: Colors.blue),
//                     ),
//                   ))
//           ],
//         ),
//       ),
//     ],
//   );
// }
//
// Widget description() {
//   return Container(
//     color: Colors.grey[200],
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text('Description :'.tr,
//               style:
//                   const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         ),
//         SizedBox(
//           width: Get.width * 0.5,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(summaryData.summaryList['description'],
//                   maxLines: 3,
//                   style: const TextStyle(
//                     height: 1,
//                     fontSize: 16,
//                   )),
//               if (summaryData.summaryList['description'].length >= 50)
//                 GestureDetector(
//                     onTap: () {
//                       showMoreData(summaryData.summaryList['description']);
//                     },
//                     child: const Padding(
//                       padding: EdgeInsets.all(3.0),
//                       child: Text(
//                         'Read More',
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, color: Colors.blue),
//                       ),
//                     ))
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }
}
