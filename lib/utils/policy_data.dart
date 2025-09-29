import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../config/exported_path.dart';

class PolicyData extends StatefulWidget {
  final String slug;

  const PolicyData({super.key, required this.slug});

  @override
  State<PolicyData> createState() => _PolicyDataState();
}

class _PolicyDataState extends State<PolicyData> {
  final controller = getIt<ProfileController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInternetAndShowPopup();
      controller.getPolicy(slug: widget.slug);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.isTrue
          ? Container(
              color: Colors.white, child: LoadingWidget(color: primaryColor))
          : Scaffold(
              appBar: AppBar(
                surfaceTintColor: Colors.white,
                backgroundColor: Colors.white,
                titleSpacing: 0,
                title: Text(
                  controller.privacyData['page_name'] ?? '',
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              body: InAppWebView(
                initialUrlRequest: URLRequest(
                    url: WebUri('${controller.privacyData['url']}?key=demo')),
                initialSettings: InAppWebViewSettings(
                  pageZoom: 8,
                  supportZoom: true,
                  minimumFontSize: 8,
                  javaScriptEnabled: true,
                ),
                onPermissionRequest: (controller, request) async {
                  return PermissionResponse(
                      resources: request.resources,
                      action: PermissionResponseAction.GRANT);
                },
              ),
            ),
    );
  }
}
