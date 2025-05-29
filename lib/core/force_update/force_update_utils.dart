// force_update_utils.dart (Add the static method here)
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:get/get.dart'; // Import GetX if you want to use Get.context directly

class ForceUpdateUtils {
  static int compareVersions(String v1, String v2) {
    final v1Parts = v1.split('.').map(int.parse).toList();
    final v2Parts = v2.split('.').map(int.parse).toList();

    for (var i = 0; i < v1Parts.length; i++) {
      if (i >= v2Parts.length) return 1; // v1 has more parts, thus newer
      if (v1Parts[i] > v2Parts[i]) return 1;
      if (v1Parts[i] < v2Parts[i]) return -1;
    }
    if (v2Parts.length > v1Parts.length) return -1; // v2 has more parts, thus newer
    return 0;
  }

  static Future<void> launchStore(String appId) async {
    final url = Platform.isAndroid
        ? 'https://play.google.com/store/apps/details?id=$appId'
        : 'https://apps.apple.com/app/id$appId';

    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        debugPrint('Could not launch $url');
      }
    } on PlatformException catch (e) {
      debugPrint('Error launching store: ${e.message}');
    } on Exception catch (e) {
      debugPrint('General error launching store: $e');
    }
  }

  // Modified to use Get.context or a provided context if GetX isn't used
  static void showUpdateDialog(String appId) {
    // Ensure Get.context is not null before showing the dialog
    if (Get.context != null) {
      showDialog(
        context: Get.context!, // Use Get.context for a context under MaterialApp
        barrierDismissible: false,
        builder: (context) => PopScope(
          canPop: false, // Prevents back button dismissal
          child: AlertDialog(
            title: const Text('تحديث مطلوب'),
            content: const Text('يجب تحديث التطبيق لمواصلة الاستخدام.'),
            actions: [
              TextButton(
                onPressed: () => launchStore(appId),
                child: const Text('تحديث الآن'),
              ),
            ],
          ),
        ),
      );
    } else {
      debugPrint('Error: Get.context is null. Cannot show update dialog.');
    }
  }
}