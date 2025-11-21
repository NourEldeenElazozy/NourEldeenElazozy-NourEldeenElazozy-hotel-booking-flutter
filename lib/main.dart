import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking/BootLogoScreen.dart';
import 'package:hotel_booking/NoInternetScreen.dart';
import 'package:hotel_booking/core/themes/app_themes.dart';
import 'package:hotel_booking/core/themes/themes_controller.dart';
import 'package:hotel_booking/presentation/routes/routes_imports.dart';
import 'package:hotel_booking/utils/flutter_web_frame/flutter_web_frame.dart';
// تم إزالة (firebase_core, firebase_messaging, flutter_local_notifications, sms_autofill)
import 'package:get/get.dart';


// تم حذف جميع الدوال والمتغيرات الخاصة بـ Firebase والإشعارات

/// دالة تهيئة الخدمات (تم تفريغها من كود Firebase)
Future<void> initializeAppServices() async {
  try {
    // هذه الدالة جاهزة لإضافة أي تهيئة أخرى غير Firebase في المستقبل
    debugPrint("✅ تم تهيئة الخدمات (النسخة الخالية من Firebase)");
  } catch (e) {
    debugPrint("❌ حدث خطأ أثناء تهيئة الخدمات: $e");
  }
}

void main() async {
  // التأكد من تهيئة ربط الـ Widgets
  WidgetsFlutterBinding.ensureInitialized();

  // تشغيل تهيئة الخدمات
  initializeAppServices();

  // تشغيل الواجهة مباشرة
  runApp( MyApp(initialRoute: "/bootLogo",appStopwatch: stopwatch));

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
    // initState أصبح الآن نظيفاً
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
            ...Routes.navigator, // باقي الصفحات لديك
          ],
        ));
      },
    );
  }
}