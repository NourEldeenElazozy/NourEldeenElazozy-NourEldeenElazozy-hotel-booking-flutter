import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/BootLogoScreen.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 80, color: Colors.red),
            const SizedBox(height: 20),
            const Text(
              "لا يوجد اتصال بالإنترنت",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "يرجى التحقق من اتصالك بالإنترنت وإعادة المحاولة",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // إعادة التحقق من الاتصال
                Get.offAll(() => const BootLogoScreen());
              },
              child: const Text("إعادة المحاولة",style: TextStyle(fontFamily: 'Tajawal'),),
            ),
          ],
        ),
      ),
    );
  }
}
