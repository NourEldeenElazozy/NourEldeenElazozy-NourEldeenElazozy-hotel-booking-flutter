import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/core/themes/themes_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_model.dart';

class NotificationController extends GetxController {
  ThemeController themeController = Get.put(ThemeController());

  RxList<SimpleNotification> notifications = <SimpleNotification>[].obs;

  @override
  void onInit() {
    loadUserId();
    getNotification();
    super.onInit();
  }
  RxInt userId = 0.obs;
  Future<void> loadUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId.value = prefs.getInt('user_id') ?? 0;
    print ('user_id ${userId.value}');
  }
  Future<void> getNotification() async {
    try {
      await loadUserId();
      print ('user_id2 ${userId.value}');
      final response = await Dio().get('https://esteraha.ly/api/notifications',
          queryParameters: {
            'user_id': userId.value
          }
      );
      if (response.statusCode == 200) {
        print ('response ${response.data}');
        List<dynamic> data = response.data['notifications'];
        notifications.clear();
        notifications.addAll(data.map((e) => SimpleNotification.fromJson(e)));
      } else {
        print('فشل جلب الإشعارات: ${response.statusCode}');
      }
    } catch (e) {
      print('خطأ أثناء جلب الإشعارات: $e');
    }
  }
}