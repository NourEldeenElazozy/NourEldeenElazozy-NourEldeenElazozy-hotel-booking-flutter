import 'package:flutter/material.dart';
import 'package:hotel_booking/NoInternetScreen.dart';
import 'package:hotel_booking/core/constants/my_colors.dart';
import 'package:hotel_booking/core/constants/my_images.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

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
    try {
      // ✅ إنشاء instance أولاً
     // final bool isConnected = await InternetConnectionChecker.instance.hasConnection;
     // bool hasConnection = isConnected;



      final prefs = await SharedPreferences.getInstance();
      final hasSeenOnboarding = prefs.getBool('onboarding');
      print("hasSeenOnboarding1 $hasSeenOnboarding");

      await Future.delayed(const Duration(seconds: 2));

      if (hasSeenOnboarding == true) {
        Get.offAllNamed("/bottomBar");
      } else {
        Get.offAllNamed("/onboarding");
      }
    } catch (e) {
      print("Error: $e");
      Get.offAllNamed("/bottomBar");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor, // أو اللون الأساسي للتطبيق
      body: Center(
        child: Image.asset(
          MyImages.logo2, // مسار اللوقو
          width: 250,
          height: 250,
        ),
      ),
    );
  }
}
