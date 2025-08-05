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
import 'package:flutter_localizations/flutter_localizations.dart'; // <--- تم إعادة إضافة هذا الاستيراد
import 'package:sms_autofill/sms_autofill.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart'; // <--- استيراد جديد لتهيئة اللغة
import 'package:shared_preferences/shared_preferences.dart';
// تأكد من وجود ملف firebase_options.dart الخاص بمشروعك
import 'firebase_options.dart';
// 🔴🔴🔴 تم إزالة استيراد ForceUpdateScreen.dart 🔴🔴🔴
// import 'package:hotel_booking/core/force_update/force_update_screen.dart';


// تهيئة FlutterLocalNotificationsPlugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// دالة لمعالجة رسائل FCM في الخلفية (يجب أن تكون دالة على المستوى الأعلى/العمومي)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // يجب تهيئة Firebase هنا أيضًا لضمان أنها تعمل في سياق الخلفية
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('Handling a background message: ${message.messageId}');

  if (message.notification != null) {
    flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification!.title,
      message.notification!.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'background_channel_id', // يجب أن يتطابق مع معرف القناة التي تم إنشاؤها
          'إشعارات الخلفية',
          channelDescription: 'قناة للإشعارات التي تصل والتطبيق في الخلفية.',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher', // 🔴🔴🔴 تم التعديل إلى ic_launcher 🔴🔴🔴
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: message.data['payload'], // يمكنك إرسال بيانات إضافية في الـ payload
    );
  }
}

// دالة رد الاتصال عند النقر على إشعار (في الواجهة الأمامية أو الخلفية)
void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
  debugPrint('Notification tapped! Payload: ${notificationResponse.payload}');
  // هنا يمكنك إضافة منطق التوجيه إلى صفحة معينة بناءً على الـ payload
  // مثال:
  // if (notificationResponse.payload != null) {
  //   Get.toNamed('/some_route', arguments: notificationResponse.payload);
  // }
}

// دالة لإنشاء قنوات الإشعارات على أندرويد (مهمة لضمان ظهور الإشعارات)
Future<void> createNotificationChannels() async {
  const AndroidNotificationChannel highImportanceChannel = AndroidNotificationChannel(
    'high_importance_channel',
    'إشعارات التطبيق الهامة',
    description: 'قناة لعرض الإشعارات الهامة من تطبيق حجوزات الفنادق.', // تم تعديل الوصف
    importance: Importance.max, // أعلى أهمية
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
  WidgetsFlutterBinding.ensureInitialized(); // تأكد من تهيئة Widgets قبل أي شيء آخر
  await initializeDateFormatting('ar', null); // تهيئة بيانات اللغة العربية

  // 🔴🔴🔴 لم نعد نحتاج لـ shouldUpdate أو appId هنا إذا كنت لا تعرض ForceUpdateScreen 🔴🔴🔴
  // bool shouldUpdate = false;
  // String currentAppId = Platform.isAndroid ? 'com.example.hotelbooking' : 'your_ios_app_id_number';

  try {
    // 1. تهيئة Firebase Core
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // 🔴🔴🔴 تم إزالة منطق Remote Config و Force Update من هنا 🔴🔴🔴
    // final remoteConfig = FirebaseRemoteConfig.instance;
    // final forceUpdateService = ForceUpdateService(remoteConfig);
    // await forceUpdateService.initialize();
    // shouldUpdate = await forceUpdateService.isUpdateRequired();

    // *** لم يعد هناك تحقق من التحديث الإجباري قبل runApp(MyApp) ***
    // if (shouldUpdate) {
    //   debugPrint("Force update is required. Launching ForceUpdateScreen.");
    //   runApp(ForceUpdateScreen(appId: currentAppId));
    //   return;
    // }

    // 2. تهيئة Firebase Cloud Messaging (FCM)
    // تسجيل دالة معالجة الرسائل في الخلفية
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // تهيئة Flutter Local Notifications Plugin
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher'); // 🔴🔴🔴 تم التعديل إلى ic_launcher 🔴🔴🔴

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
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );

    // إنشاء قنوات الإشعارات (خاص بأندرويد)
    await createNotificationChannels();

    // طلب أذونات الإشعارات من المستخدم (مهم لـ iOS و Android 13+)
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false, // لا تطلب أذونات مؤقتة
    );
    debugPrint('User granted permission: ${settings.authorizationStatus}');

    // الحصول على رمز FCM المميز للجهاز
    String? token = await FirebaseMessaging.instance.getToken();
    debugPrint('FCM Token: $token');

    // الاشتراك في توبيك عام لاستقبال الرسائل (اختياري لكن مفيد للاختبار)
    await FirebaseMessaging.instance.subscribeToTopic('all');
    debugPrint('Subscribed to topic: all');

    // الاستماع للرسائل عندما يكون التطبيق في الواجهة الأمامية
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      if (message.notification != null) {
        debugPrint('Message also contained a notification: ${message.notification!.title}');
        debugPrint('Message body: ${message.notification!.body}');
        // عرض الإشعار باستخدام flutter_local_notifications_plugin لضمان الظهور
        flutterLocalNotificationsPlugin.show(
          message.hashCode,
          message.notification!.title,
          message.notification!.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel', // يجب أن يتطابق مع معرف القناة التي تم إنشاؤها
              'إشعارات التطبيق الهامة',
              channelDescription: 'قناة لعرض الإشعارات الهامة من تطبيق حجوزات الفنادق.', // تم تعديل الوصف
              importance: Importance.max,
              priority: Priority.high,
              playSound: true,
              icon: '@mipmap/ic_launcher', // 🔴🔴🔴 تم التعديل إلى ic_launcher 🔴🔴🔴
            ),
            iOS: DarwinNotificationDetails(),
          ),
          payload: message.data['click_action'] ?? message.data['payload'], // يمكنك استخدام click_action أو payload
        );
      }
    });

    // التعامل مع الإشعارات التي تفتح التطبيق من حالة الإنهاء (terminated state)
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        debugPrint('App opened from terminated state by notification: ${message.data}');
        // هنا يمكنك توجيه المستخدم بناءً على بيانات الإشعار
      }
    });

    // التعامل مع الإشعارات التي تفتح التطبيق من الخلفية
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('App opened from background by notification: ${message.notification?.title ?? "No title"}');
      debugPrint('App opened from background by notification data: ${message.data}');
      // هنا يمكنك توجيه المستخدم بناءً على بيانات الإشعار
    });

    // 3. تهيئة SMS Autofill (إذا كنت تستخدمه)
    if (kDebugMode) { // فقط في وضع Debug
      print("Hashs");
      final hash = await SmsAutoFill().getAppSignature;
      print("Hash: ${hash ?? 'NO HASH RECEIVED'}");
    }
    // تحقق مما إذا كان المستخدم شاهد Onboarding أم لا
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('onboarding') ?? false;

    // احفظ المسار المبدئي
    final initialRoute = hasSeenOnboarding ? "/bottomBar" : "/onboarding";
    print("hasSeenOnboarding $hasSeenOnboarding");
    // 4. تشغيل التطبيق الرئيسي
    runApp(MyApp(initialRoute: initialRoute));

  } catch (e) {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('onboarding') ?? false;
    final initialRoute = hasSeenOnboarding ? "/bottomBar" : "/onboarding";

    debugPrint('Firebase initialization error: $e');
    // في حالة حدوث خطأ في تهيئة Firebase
    runApp(MyApp(initialRoute: initialRoute));
  }
}

class MyApp extends StatefulWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

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
          navigatorKey: Get.key, // ضروري لعمل Get.to/Get.back و Get.context
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('ar', 'SA')], // تحديد اللغة العربية كلغة مدعومة
          debugShowCheckedModeBanner: false,
          theme: themeController.darkMode.value ? Themes.darkTheme : Themes.lightTheme,
          initialRoute: widget.initialRoute, // ✅ هنا التعديل, // تم تعيين initialRoute هنا
          //initialRoute: "/onboarding", // تم تعيين initialRoute هنا
          getPages: Routes.navigator, // تم تعيين getPages هنا
        ));
      },
    );
  }
}
