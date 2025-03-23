import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/core/themes/app_themes.dart';
import 'package:hotel_booking/presentation/routes/routes_imports.dart';
import 'package:hotel_booking/utils/flutter_web_frame/flutter_web_frame.dart';

import 'core/themes/themes_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return FlutterWebFrame(
        maximumSize: const Size(475.0, 812.0),
        enabled: kIsWeb, // default is enable, when disable content is full size
        backgroundColor: Colors.grey, // Background color/white space
        builder: (context) {
          return Obx(() => GetMaterialApp(
                debugShowCheckedModeBanner: false,
                theme: themeController.darkMode.value
                    ? Themes.darkTheme
                    : Themes.lightTheme,
                // darkTheme: Themes().darkTheme,
                // themeMode: ThemeMode.system,
                initialRoute: "/welcome",
                getPages: Routes.navigator,
                // home: Practice(),
              ));
        });
  }
}
