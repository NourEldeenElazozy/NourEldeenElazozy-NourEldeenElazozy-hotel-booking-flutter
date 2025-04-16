import 'dart:convert';

import 'package:dio/dio.dart' as Dio;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/Model/RestAreas.dart';
import 'package:image_picker/image_picker.dart';

class RestAreaController extends GetxController {
  // Method to post RestAreas data
  Future<Dio.Response> saveRestArea(RestAreas restArea, XFile? mainImage, List<XFile> detailsImages) async {
    try {
      // إنشاء FormData لإرسال الملفات والبيانات معاً
      final formData = Dio.FormData.fromMap({
        ...restArea.toJson(),
        'main_image': mainImage != null
            ? await Dio.MultipartFile.fromFile(mainImage.path.toString(), filename: 'main_${DateTime.now().millisecondsSinceEpoch}.jpg'.toString())
            : null,
        'details_images[]': detailsImages.isNotEmpty
            ? detailsImages.map((image) =>
            Dio.MultipartFile.fromFileSync(image.path, filename: 'detail_${DateTime.now().millisecondsSinceEpoch}_${detailsImages.indexOf(image)}.jpg'))
            .toList()
            : null,
      });
      final jsonData = restArea.toJson();
      debugPrint(jsonEncode(jsonData), wrapWidth: 1024);
      debugPrint('بيانات النموذج الجاهزة للإرسال');
      debugPrint(formData.fields.toString(),wrapWidth: 5000);
      debugPrint('بيانات النموذج الجاهزة mainImage');
      debugPrint(mainImage?.path.toString(),wrapWidth: 5000);

      debugPrint('بيانات النموذج الجاهزة للإرسال');
      final response = await Dio.Dio().post(
        'http://10.0.2.2:8000/api/store',
        data: formData,
        options: Dio.Options(
          headers: {
            'Content-Type': 'multipart/form-data', // مهم جداً لتحديد نوع المحتوى
            'Accept': 'application/json',
          },
        ),
      );

      return response;

    } on Dio.DioException catch (e) {

      debugPrint('خطأ في الإرسال: ${e}');
      if (e.response != null) {
        debugPrint('رد الخادم: ${e.response?.data}');
      }
      throw _handleError(e);
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