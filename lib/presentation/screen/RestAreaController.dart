import 'dart:convert';

import 'package:dio/dio.dart' as Dio;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/Model/RestAreas.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestAreaController extends GetxController {
  // Method to post RestAreas data
  Future<Dio.Response> saveRestArea(RestAreas restArea, XFile? mainImage, List<XFile> detailsImages) async {
    try {
      // استرجاع التوكن من SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      // ====== Validation before sending ======
      if (mainImage == null) {
        throw Exception('الصورة الرئيسية مطلوبة.');
      }
      if (detailsImages.isEmpty) {
        throw Exception('يجب إضافة صور تفصيلية واحدة على الأقل.');
      }

      // ====== Prepare FormData ======
      final formData = Dio.FormData.fromMap({
        ...restArea.toJson(),
        'main_image': await Dio.MultipartFile.fromFile(
          mainImage.path,
          filename: 'main_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
        'details_images[]': detailsImages.map((image) {
          return Dio.MultipartFile.fromFileSync(
            image.path,
            filename: 'detail_${DateTime.now().millisecondsSinceEpoch}_${detailsImages.indexOf(image)}.jpg',
          );
        }).toList(),
      });

      final jsonData = restArea.toJson();
      debugPrint(jsonEncode(jsonData), wrapWidth: 1024);
      debugPrint('بيانات النموذج الجاهزة للإرسال');
      debugPrint(formData.fields.toString(), wrapWidth: 5000);
      debugPrint('مسار الصورة الرئيسية:');
      debugPrint(mainImage.path.toString(), wrapWidth: 5000);

      // ====== Send Request ======
      final response = await Dio.Dio().post(
        'http://10.0.2.2:8000/api/store',
        data: formData,
        options: Dio.Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token', // تضمين التوكن هنا
          },
        ),
      );

      return response;

    } on Dio.DioException catch (e) {
      debugPrint('خطأ في الإرسال: $e');
      if (e.response != null) {
        debugPrint('رد الخادم: ${e.response?.data}');
      }
      throw _handleError(e);
    } catch (e) {
      debugPrint('خطأ آخر: $e');
      rethrow;
    }
  }


  // Error handling
  dynamic _handleError(Dio.DioException e) {
    if (e.response != null) {
      print(e.response);
      throw Exception(e.response?.data['message'] ?? 'Failed to save data');
    } else {
      throw Exception('Network error: ${e.message}');
    }
  }

}