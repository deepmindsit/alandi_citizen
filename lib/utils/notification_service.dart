import 'package:alandi/config/exported_path.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _androidChannelId = 'high_importance_channel';
  static const String _androidChannelName = 'High Importance Notifications';
  static const String _androidChannelDescription =
      'This channel is used for important notifications';

  final AndroidNotificationChannel _androidChannel =
      const AndroidNotificationChannel(
    _androidChannelId,
    _androidChannelName,
    description: _androidChannelDescription,
    importance: Importance.max,
  );

  /// Initialize Firebase Messaging and Local Notifications
  Future<void> init() async {
    await _requestNotificationPermissions();
    await _initPushNotifications();
    await _initLocalNotifications();
  }

  /// Request notification permissions
  Future<void> _requestNotificationPermissions() async {
    await _firebaseMessaging.requestPermission();
   await _firebaseMessaging.getToken();
    // print('FCM Token: $token');
  }

  /// Initialize push notifications
  Future<void> _initPushNotifications() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    _firebaseMessaging.subscribeToTopic("anpPublic");
    // Handle initial message (app launched from terminated state)
    final RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      handleNotificationNavigation(initialMessage.data, 'terminate');
    }

    // Listen for messages when the app is in the foreground
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    // Listen for messages when the app is opened from the background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
  }

  /// Initialize local notifications
  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@drawable/logo');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Create notification channel for Android
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        _localNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(_androidChannel);
  }

  /// Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    if (message.notification != null) {
      _showLocalNotification(
        title: message.notification!.title,
        body: message.notification!.body,
        payload: jsonEncode(message.data),
      );
    }
  }

  /// Handle background messages
  void _handleBackgroundMessage(RemoteMessage message) {
    handleNotificationNavigation(message.data, 'background');
  }

  /// Handle notification taps
  void _onNotificationTap(NotificationResponse response) {
    final Map<String, dynamic> data = jsonDecode(response.payload!);
    handleNotificationNavigation(data, 'local');
  }

  /// Show a local notification
  Future<void> _showLocalNotification({
    required String? title,
    required String? body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      _androidChannelId,
      _androidChannelName,
      channelDescription: _androidChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      // 0,
      title ?? 'Notification',
      body ?? 'New notification',
      platformDetails,
      payload: payload,
    );
  }

  /// Handle navigation based on notification data
  void handleNotificationNavigation(Map<String, dynamic> data, String from) {


    // final String? clickAction = data['click_action'];
  }
}
