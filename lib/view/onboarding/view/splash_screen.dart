import 'package:alandi/config/exported_path.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = 'splash-screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  String? token;
  var expanded = false;
  bool? isOnboarded;
  final transitionDuration = const Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadPreferences();
    Future.delayed(const Duration(seconds: 1))
        .then((value) => setState(() => expanded = true));
    bool isConnected = await InternetConnectionChecker.instance.hasConnection;

    if (isConnected) {
      token != null
          ? Get.offAll(() => MainScreen())
          : Get.offAll(() => const PageViewWidget());
    } else {
      _showNoInternetDialog();
    }
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('auth_key');
    isOnboarded = prefs.getBool('isOnboarded');
  }

  void _showNoInternetDialog() {
    Get.dialog(
      AlertDialog(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: const Text(
          'No Internet Connection',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/no_wifi.png', width: Get.height * 0.3),
            const Text('Check your Internet Connection'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.offAll(() => const SplashScreen()),
            style: TextButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // @override
  // void initState() {
  //   main();
  //   Future.delayed(const Duration(seconds: 1))
  //       .then((value) => setState(() => expanded = true))
  //       .then((value) =>
  //           Future.delayed(const Duration(seconds: 1)).then((value) async {
  //             bool result =
  //                 await InternetConnectionChecker.instance.hasConnection;
  //             if (result == true) {
  //               token != null
  //                   ? Get.offAll(() => MainScreen())
  //                   : Get.offAll(() => const PageViewWidget());
  //             } else {
  //               Get.dialog(AlertDialog(
  //                 surfaceTintColor: Colors.transparent,
  //                 backgroundColor: Colors.white,
  //                 title: const Text(
  //                   'No Internet Connection',
  //                   style: TextStyle(
  //                     // letterSpacing: 1,
  //                     color: Colors.red,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 content: Container(
  //                   height: Get.height * 0.35,
  //                   color: Colors.white,
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Image.asset(
  //                         'assets/images/no_wifi.png',
  //                         width: Get.height * 0.3,
  //                       ),
  //                       const Text('Check your Internet Connection'),
  //                     ],
  //                   ),
  //                 ),
  //                 actions: [
  //                   GestureDetector(
  //                     onTap: () {
  //                       Get.offAll(() => const SplashScreen());
  //                     },
  //                     child: Container(
  //                       width: Get.width * 0.15,
  //                       decoration: const BoxDecoration(
  //                         borderRadius: BorderRadius.all(
  //                           Radius.circular(8),
  //                         ),
  //                         color: Colors.red,
  //                       ),
  //                       child: const Center(
  //                         child: Padding(
  //                           padding: EdgeInsets.all(8.0),
  //                           child: Text(
  //                             'Retry',
  //                             style: TextStyle(
  //                                 letterSpacing: 1, color: Colors.white),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ));
  //             }
  //           }));
  //   super.initState();
  // }
  //
  // Future<void> main() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   token = prefs.getString('auth_key');
  //   isOnboarded = prefs.getBool('isOnboarded');
  // }

  @override
  Widget build(BuildContext context) {
    return Material(
      surfaceTintColor: Colors.white,
      color: Colors.white,
      child: Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedCrossFade(
              firstCurve: Curves.fastOutSlowIn,
              crossFadeState: !expanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: transitionDuration,
              firstChild: Container(),
              secondChild: _logoRemainder(),
              alignment: Alignment.centerLeft,
              sizeCurve: Curves.easeInOut,
            ),
          ],
        ),
      ),
    );
  }

  Widget _logoRemainder() {
    return Image.asset(
      'assets/images/alandi_fevicon.png',
      height: Get.width * 0.5,
    );
  }
}
