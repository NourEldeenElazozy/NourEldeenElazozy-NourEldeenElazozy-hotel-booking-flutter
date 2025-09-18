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
  // 🔴 متغير لمعرفة إذا فيه إشعارات جديدة أو لا
  var hasNewNotification = false.obs;
  @override
  void onInit() {
    loadUserId();
    getNotification();
    markNotificationsAsRead();
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
      final response = await Dio().get(
        'https://esteraha.ly/api/notifications',
        queryParameters: {'user_id': userId.value},
      );

      if (response.statusCode == 200) {
        print("response.dataa");
        print(response.data);
        print("response.dataa");
        final data = response.data['notifications'] as List<dynamic>; // تأكد من كونها List
        notifications.clear();
        notifications.addAll(data.map((e) => SimpleNotification.fromJson(e)));

        // تحديث حالة الدائرة
        hasNewNotification.value = notifications.any((n) => !n.isRead);
      }
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }

  Future<void> markNotificationsAsRead() async {
    try {
      // إرسال الطلب للسيرفر
      await Dio().post(
        'https://esteraha.ly/api/notifications/mark-as-read',
        data: {'user_id': userId.value},
      );

      // تحديث كل الإشعارات محليًا
      for (var n in notifications) {
        n.isRead = true; // يجب أن يكون isRead متغير وليس final
      }
      notifications.refresh();

      // إخفاء الدائرة
      hasNewNotification.value = false;
    } catch (e) {
      print('Error marking notifications as read: $e');
    }
  }


}