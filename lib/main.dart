import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hotel_booking/BootLogoScreen.dart';
import 'package:hotel_booking/NoInternetScreen.dart';
import 'package:hotel_booking/core/themes/app_themes.dart';
import 'package:hotel_booking/core/themes/themes_controller.dart';
import 'package:hotel_booking/presentation/routes/routes_imports.dart';
import 'package:hotel_booking/utils/flutter_web_frame/flutter_web_frame.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:hotel_booking/firebase_options.dart';
import 'package:get/get.dart';


import 'package:internet_connection_checker/internet_connection_checker.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

/*
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background message: ${message.messageId}");
}
 */

Future<void> initializeAppServices() async {
  try {
    // 1. Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // 2. Notifications
    //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        debugPrint("Notification tapped: ${response.payload}");
      },
    );

    // طلب أذونات
    //await FirebaseMessaging.instance.requestPermission();

    // عرض الـ Token
    //String? token = await FirebaseMessaging.instance.getToken();
   // debugPrint("FCM Token: $token");

    // اشتراك في topic
    //await FirebaseMessaging.instance.subscribeToTopic("all");

    // إشعارات foreground
  /*
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        flutterLocalNotificationsPlugin.show(
          message.hashCode,
          message.notification!.title,
          message.notification!.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'إشعارات التطبيق الهامة',
              channelDescription: 'قناة لعرض الإشعارات الهامة من التطبيق.',
              importance: Importance.max,
              priority: Priority.high,
              playSound: true,
              icon: '@mipmap/ic_launcher',
            ),
            iOS: DarwinNotificationDetails(),
          ),
          payload: message.data['click_action'] ?? message.data['payload'],
        );
      }
    });
   */

    // SMS AutoFill
    if (kDebugMode) {
      final hash = await SmsAutoFill().getAppSignature;
      debugPrint("App hash: $hash");
    }

    debugPrint("✅ Services initialized");
  } catch (e) {
    debugPrint("❌ Error initializing services: $e");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ شغل الواجهة مباشرة
  runApp( MyApp(initialRoute: "/bootLogo",appStopwatch: stopwatch));

  // ✅ خلّي التهيئة تشتغل بالخلفية
  initializeAppServices();
}
final stopwatch = Stopwatch()..start();
class MyApp extends StatefulWidget {
  final String initialRoute;
  final Stopwatch appStopwatch;

  const MyApp({
    super.key,
    this.initialRoute = "/bootLogo",
    required this.appStopwatch,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  ThemeController themeController = Get.put(ThemeController());

  @override
  void initState() {
    super.initState();
    // تم إزالة جميع منطق الإشعارات والتحديث الإجباري من هنا
    // حيث تم نقلها إلى دالة main() ليتم تهيئتها قبل تشغيل التطبيق.
  }

  @override
  Widget build(BuildContext context) {
    return FlutterWebFrame(
      maximumSize: const Size(475.0, 812.0),
      enabled: kIsWeb,
      backgroundColor: Colors.grey,
      builder: (webFrameContext) {
        return Obx(() => GetMaterialApp(
          navigatorKey: Get.key, // ضروري لعمل Get.to / Get.back / Get.context

          debugShowCheckedModeBanner: false,
          theme: themeController.darkMode.value
              ? Themes.darkTheme
              : Themes.lightTheme,
          initialRoute: widget.initialRoute, // يبدأ من bootLogo
          getPages: [
            GetPage(name: "/bootLogo", page: () => const BootLogoScreen()),
            GetPage(
                name: "/noInternet", page: () => const NoInternetScreen()),
            ...Routes.navigator, // باقي الصفحات عندك
          ],
        ));
      },
    );
  }
}
