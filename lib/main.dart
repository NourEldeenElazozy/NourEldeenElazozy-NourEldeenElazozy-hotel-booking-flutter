// main.dart (The main application file)
import 'dart:io';

import 'package:firebase_core/firebase_core.dart'; // استيراد مكتبة firebase_core
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/core/force_update/force_update_service.dart';
import 'package:hotel_booking/core/force_update/force_update_utils.dart';
import 'package:hotel_booking/core/themes/app_themes.dart';
import 'package:hotel_booking/presentation/routes/routes_imports.dart';
import 'package:hotel_booking/utils/flutter_web_frame/flutter_web_frame.dart';
import 'core/themes/themes_controller.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('Handling a background message: ${message.messageId}');

  if (message.notification != null) {
    flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification!.title,
      message.notification!.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'background_channel_id',
          'إشعارات الخلفية',
          channelDescription: 'قناة للإشعارات التي تصل والتطبيق في الخلفية.',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/app_icon',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: message.data['payload'],
    );
  }
}
void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
  debugPrint('Notification tapped in foreground, payload: ${notificationResponse.payload}');
}

void onDidReceiveBackgroundNotificationResponse(NotificationResponse notificationResponse) async {
  debugPrint('Notification tapped in background, payload: ${notificationResponse.payload}');
}

Future<void> createNotificationChannels() async {
  const AndroidNotificationChannel highImportanceChannel = AndroidNotificationChannel(
    'high_importance_channel',
    'إشعارات التطبيق الهامة',
    description: 'قناة لعرض الإشعارات الهامة من تطبيق زكاة.',
    importance: Importance.max,
    playSound: true,
    showBadge: true,
  );

  const AndroidNotificationChannel backgroundChannel = AndroidNotificationChannel(
    'background_channel_id',
    'إشعارات الخلفية',
    description: 'قناة للإشعارات التي تصل والتطبيق في الخلفية.',
    importance: Importance.high,
    playSound: true,
    showBadge: true,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(highImportanceChannel);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(backgroundChannel);
}
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Hashs");
    final hash = await SmsAutoFill().getAppSignature;

    print("Hash: ${hash ?? 'NO HASH RECEIVED'}");
    final remoteConfig = FirebaseRemoteConfig.instance;
    final forceUpdateService = ForceUpdateService(remoteConfig);

    await forceUpdateService.initialize();

    final shouldUpdate = await forceUpdateService.isUpdateRequired();

    // Pass the update status to MyApp
    runApp(MyApp(
      forceUpdateRequired: shouldUpdate,
      // IMPORTANT: Replace with your actual app IDs
      appId: Platform.isAndroid ? 'com.example.hotelbooking' : '1234567890', // Example IDs
    ));
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
    // If Firebase initialization fails, continue without force update
    runApp(MyApp(
      forceUpdateRequired: false,
      appId: Platform.isAndroid ? 'com.example.hotelbooking' : '1234567890', // Example IDs
    ));
  }
}

class MyApp extends StatefulWidget {
  final bool forceUpdateRequired;
  final String appId;

  const MyApp({
    super.key,
    required this.forceUpdateRequired,
    required this.appId,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeController themeController = Get.put(ThemeController());

  @override
  void initState() {
    super.initState();
    // Schedule the dialog to be shown after the first frame has rendered
    // and GetMaterialApp's context is available.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.forceUpdateRequired) {
        debugPrint("Force update is required. Attempting to show dialog via ForceUpdateUtils.");
        // Call the static method directly
        ForceUpdateUtils.showUpdateDialog(widget.appId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterWebFrame(
      maximumSize: const Size(475.0, 812.0),
      enabled: kIsWeb,
      backgroundColor: Colors.grey,
      builder: (webFrameContext) {
        return Obx(() => GetMaterialApp(
          // Ensure Get.context is available for showDialog
          navigatorKey: Get.key, // This line ensures Get.context works properly
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          supportedLocales: const [Locale('ar')],
          debugShowCheckedModeBanner: false,
          theme: themeController.darkMode.value ? Themes.darkTheme : Themes.lightTheme,
          initialRoute: "/bottomBar",
          getPages: Routes.navigator,
        ));
      },
    );
  }
}