import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PointsController extends GetxController {
  RxInt totalPoints = 0.obs;
  RxBool isLoading = false.obs;

  Future<void> fetchPoints() async {

    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      debugPrint(token);

      final response = await Dio().get(
        'http://10.0.2.2:8000/api/getUserPoints',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      print(response.data);
      if (response.data['success'] == true) {
        totalPoints.value = int.tryParse(response.data['points'].toString()) ?? 0;
      } else {
        totalPoints.value = 0;
      }
    } catch (e) {
      totalPoints.value = 0;
      print('خطأ في جلب النقاط: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchPoints();
  }
}
