import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hotel_booking/NoInternetScreen.dart';
import 'package:hotel_booking/core/constants/my_colors.dart';
import 'package:hotel_booking/core/constants/my_images.dart';

class BootLogoScreen extends StatefulWidget {
  const BootLogoScreen({super.key});

  @override
  State<BootLogoScreen> createState() => _BootLogoScreenState();
}

class _BootLogoScreenState extends State<BootLogoScreen> {
  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    final elapsed = (context.findAncestorWidgetOfExactType<MyApp>()?.appStopwatch.elapsedMilliseconds) ?? 0;

    try {

      /*
      final bool hasConnection =
      //await InternetConnectionChecker.instance.hasConnection;


      if (!hasConnection) {
        Get.offAll(() => const NoInternetScreen());
        return;
      }
   */
      final prefs = await SharedPreferences.getInstance();
      final hasSeenOnboarding = prefs.getBool('onboarding');
      debugPrint("⏱️ وقت فتح التطبيق حتى BootLogo: $elapsed ms");
      //await Future.delayed(const Duration(seconds: 2));

      if (hasSeenOnboarding == true) {
        Get.offAllNamed("/bottomBar");
      } else {
        Get.offAllNamed("/onboarding");
      }
    } catch (e) {
      debugPrint("Error in BootLogoScreen: $e");
      Get.offAllNamed("/bottomBar");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      body: Center(
        child: Image.asset(
          MyImages.logo2,
          width: 250,
          height: 250,
        ),
      ),
    );
  }
}
