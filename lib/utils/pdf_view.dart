import 'package:alandi/config/exported_path.dart';

class PdfView extends StatefulWidget {
  final String pdf;

  const PdfView({super.key, required this.pdf});

  @override
  State<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  final department = getIt<HomeController>();
  String pdf = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInternetAndShowPopup();
    });
    getPdf();
    super.initState();
  }

  getPdf() async {
    await createFileOfPdfUrl(
      url2: department.pdf.value,
    ).then((f) {
      setState(() {
        pdf = f.path;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        title: Text('User Manual'.tr),
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey.withValues(alpha: 0.1),
        surfaceTintColor: Colors.grey.withValues(alpha: 0.1),
      ),
      body: Obx(
        () => department.pdf.isNotEmpty && pdf.isNotEmpty
            ? PDFView(
                filePath: pdf,
                enableSwipe: true,
                fitEachPage: true,
                autoSpacing: false,
                pageFling: false,
              )
            : LoadingWidget(color: primaryBlack),
      ),
    );
  }
}
