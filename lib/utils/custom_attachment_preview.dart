import 'package:alandi/config/exported_path.dart';

class AttachmentPreviewList extends StatelessWidget {
  final List attachments;
  final Function(String path) onDownload;

  const AttachmentPreviewList({
    super.key,
    required this.attachments,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.17,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: attachments.length,
        itemBuilder: (context, index) {
          final file = attachments[index];
          final isPdf = file['type'] == 'pdf';
          final name = file['name'] ?? 'Attachment';
          final path = file['overlay'];
          final extension = name.split('.').last.toLowerCase();
          final isImage = [
            'jpg',
            'jpeg',
            'png',
            'gif',
            'webp',
          ].contains(extension);
          return Padding(
            padding: EdgeInsets.only(right: 12),
            child: Container(
              width: Get.width * 0.45,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isImage)
                    WidgetZoom(
                      heroAnimationTag: 'tag $path',
                      zoomWidget: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: FadeInImage(
                          placeholder:
                              AssetImage('assets/images/alandi_fevicon.png'),
                          image: NetworkImage(path),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/alandi_fevicon.png',
                              height: 80,
                              width: double.infinity,
                              fit: BoxFit.contain,
                            );
                          },
                          height: 80,
                          width: double.infinity,
                          fit: BoxFit.contain,
                          fadeInDuration: const Duration(milliseconds: 300),
                        ),
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: () {
                        if (isPdf) {
                          createFileOfPdfUrl(url2: file['path']).then((file) {
                            Get.dialog(AlertDialog(
                              backgroundColor: Colors.white,
                              surfaceTintColor: Colors.white,
                              contentPadding: const EdgeInsets.all(5),
                              content: SizedBox(
                                width: Get.width * 0.8,
                                height: Get.height * 0.5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: PDFView(
                                    filePath: file.path,
                                    enableSwipe: true,
                                    swipeHorizontal: true,
                                    fitPolicy: FitPolicy.BOTH,
                                  ),
                                ),
                              ),
                            ));
                          });
                        }
                      },
                      child: Container(
                        height: 80,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: getFileTypeColor(extension),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          getIconForFile(name),
                          size: 36,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  SizedBox(height: 8),
                  CustomText(
                    title:
                        name.length > 20 ? '${name.substring(0, 20)}...' : name,
                    fontSize: 13,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
