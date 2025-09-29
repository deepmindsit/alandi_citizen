import 'package:alandi/config/exported_path.dart';

@pragma('vm:entry-point')
Future<void> backgroundHandler(RemoteMessage message) async {
  Map<String, dynamic> data = message.data;
  NotificationService().handleNotificationNavigation(data, '');
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await Firebase.initializeApp();
  NotificationService().init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final langController = getIt<LanguageController>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        final textScaler = TextScaler.linear(
          mediaQueryData.textScaler.scale(1.0).clamp(0.8, 1.0),
        );
        final newMediaQueryData = mediaQueryData.copyWith(
          boldText: false,
          textScaler: textScaler,
        );
        return MediaQuery(
          data: newMediaQueryData,
          child: child!,
        );
      },
      title: 'My alandi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      translations: Languages(),
      locale: langController.isEnglish.value
          ? const Locale('en', 'US')
          : const Locale('mr', 'MR'),
      fallbackLocale: const Locale('mr', 'MR'),
      // home: AttendanceWidget(),
      home: SplashScreen(),
    );
  }
}
