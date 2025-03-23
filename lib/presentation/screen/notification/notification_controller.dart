import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/core/themes/themes_controller.dart';
import 'notification_model.dart';

class NotificationController extends GetxController {
  ThemeController themeController = Get.put(ThemeController());

  RxList<NotificationElement> allNotification = <NotificationElement>[].obs;

  @override
  void onInit() {
    getNotification();
    super.onInit();
  }

  Future<List<NotificationElement>> getNotification() async {
    String jsonData = await rootBundle.loadString("assets/data/notification.json");
    dynamic data = json.decode(jsonData);
    List<dynamic> jsonArray = data["notification"];
    for (int i = 0 ; i < jsonArray.length ; i++)
    {
      allNotification.add(NotificationElement.fromJson(jsonArray[i]));
    }
    return allNotification;
  }
}