import 'dart:convert';

import 'package:dio/dio.dart' as Dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/Model/RestAreas.dart';
import 'package:hotel_booking/core/constants/my_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestAreaController extends GetxController {
  RxBool isLoading = false.obs;
  // Method to post RestAreas data
  // دالة لحفظ أو تحديث بيانات الاستراحة
  Future<Dio.Response> saveRestArea(RestAreas restArea, XFile? mainImage, List<XFile> detailsImages) async {
    try {
      isLoading.value = true; // 🔴 إيقاف مؤشر التحميل دائماً (سواء نجح أو فشل)

      // استرجاع التوكن من SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      // ====== التحقق من صحة البيانات قبل الإرسال ======
      if (mainImage == null) {
        throw Exception('الصورة الرئيسية مطلوبة.');
      }
      if (detailsImages.isEmpty) {
        throw Exception('يجب إضافة صور تفصيلية واحدة على الأقل.');
      }

      // ====== تحضير بيانات النموذج (FormData) ======
      final formData = Dio.FormData.fromMap({
        ...restArea.toJson(), // تحويل كائن RestAreas إلى Map
        'main_image': await Dio.MultipartFile.fromFile(
          mainImage.path,
          filename: 'main_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
        // إضافة جميع صور التفاصيل كمصفوفة
        'details_images[]': await Future.wait(detailsImages.map((image) async {
          return await Dio.MultipartFile.fromFile(
            image.path,
            filename: 'detail_${DateTime.now().millisecondsSinceEpoch}_${detailsImages.indexOf(image)}.jpg',
          );
        }).toList()),
      });

      // لغرض التصحيح: طباعة بيانات النموذج
      final jsonData = restArea.toJson();
      debugPrint(jsonEncode(jsonData), wrapWidth: 1024);
      debugPrint('بيانات النموذج الجاهزة للإرسال');
      debugPrint(formData.fields.toString(), wrapWidth: 5000);
      debugPrint('مسار الصورة الرئيسية:');
      debugPrint(mainImage.path.toString(), wrapWidth: 5000);

      // ====== إرسال الطلب ======
      final response = await Dio.Dio().post(
        'https://esteraha.ly/api/store', // تأكد من نقطة نهاية الـ API الصحيحة
        data: formData,
        options: Dio.Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token', // تضمين التوكن هنا
          },
        ),
      );

      // 🔴 عرض رسالة النجاح
      Get.snackbar(
        "نجاح",
        "تم حفظ الاستراحة بنجاح.",
        backgroundColor: MyColors.successColor, // افترض وجود MyColors.successColor
        colorText: Colors.white,
      );

      return response;

    } on Dio.DioException catch (e) {
      // 🔴 معالجة أخطاء Dio وعرضها
      debugPrint('خطأ في الإرسال (DioException): $e');
      if (e.response != null) {
        debugPrint('رد الخادم: ${e.response?.data}');
      }
      _handleError(e); // استدعاء دالة معالجة الخطأ
      rethrow; // إعادة رمي الخطأ للسماح بمعالجته في مكان آخر إذا لزم الأمر
    } catch (e) {
      // 🔴 معالجة أي أخطاء أخرى غير متوقعة وعرضها
      debugPrint('خطأ آخر غير متوقع: $e');
      Get.snackbar(
        "خطأ",
        "حدث خطأ غير متوقع: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } finally {
      isLoading.value = false; // 🔴 إيقاف مؤشر التحميل دائماً (سواء نجح أو فشل)
    }
  }
//Updated
  // 🔴🔴🔴 دالة تحديث استراحة موجودة 🔴🔴🔴
  Future<Dio.Response> updateRestArea(
      RestAreas restArea,
      XFile? newMainImage, // الصورة الرئيسية الجديدة (إذا تم تغييرها)
      List<XFile> newDetailsImages, // صور التفاصيل الجديدة (إذا تم إضافتها)
      String? initialMainImageUrl, // رابط الصورة الرئيسية الأولية (للمقارنة/الحذف في Backend)
      List<String> initialDetailsImageUrls, // روابط صور التفاصيل الأولية (للمقارنة/الحذف في Backend)
      ) async {
    try {
      isLoading.value = true;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      // التحقق من وجود معرف الاستراحة
      if (restArea.id == null || restArea.id == 0) {
        throw Exception('معرف الاستراحة مطلوب للتحديث.');
      }

      final Map<String, dynamic> dataMap = restArea.toJson();

      // إضافة _method: 'PUT' لتقليد طلب PUT إذا كان مسار Laravel هو POST
      dataMap['_method'] = 'PUT';

      // 🔴🔴🔴 التعديل هنا: إزالة 'main_image' من dataMap مبدئياً 🔴🔴🔴
      // إذا كان موجوداً في toJson()، نُزيله أولاً ثم نضيفه كملف أو كقيمة فارغة حسب الحاجة
      dataMap.remove('main_image'); // إزالة مسار الصورة كسلسلة نصية من بيانات الـ JSON

      final formData = Dio.FormData.fromMap(dataMap);

      // 🔴 معالجة الصورة الرئيسية
      if (newMainImage != null) {
        print("newMainImagee ${newMainImage}");
        // إذا تم اختيار صورة رئيسية جديدة، أضفها إلى formData كملف
        formData.files.add(MapEntry(
          'main_image',
          await Dio.MultipartFile.fromFile(
            newMainImage.path,
            filename: 'main_${DateTime.now().millisecondsSinceEpoch}.jpg',
          ),
        ));
      } else if (initialMainImageUrl == null || initialMainImageUrl.isEmpty) {
        print("initialMainImageUrle ${initialMainImageUrl}");
        // إذا لم يتم اختيار صورة جديدة وتم مسح الرابط الأولي (يعني المستخدم حذفها)
        // أرسل قيمة فارغة لـ 'main_image' لتخبر Backend بحذفها
        formData.fields.add(MapEntry('main_image', ''));
      }
      // إذا لم يتم اختيار صورة جديدة ولم يتم مسح الرابط الأولي، لا نضيف 'main_image' إلى formData
      // وسيحتفظ Backend بالصورة الموجودة (لأنها لم تتغير).

      // 🔴 معالجة صور التفاصيل
      // أضف روابط الصور الأولية التي لم يتم حذفها إلى formData
      // هذه القائمة تخبر الـ Backend بالصور التي يجب الاحتفاظ بها من الصور القديمة
      if (initialDetailsImageUrls.isNotEmpty) {
        formData.fields.add(MapEntry('initial_details_image_urls', initialDetailsImageUrls.join(',')));
      } else {
        // إذا كانت القائمة فارغة، أرسل قيمة فارغة لتخبر Backend بحذف جميع صور التفاصيل القديمة
        formData.fields.add(MapEntry('initial_details_image_urls', ''));
      }

      // أضف صور التفاصيل الجديدة التي تم اختيارها
      if (newDetailsImages.isNotEmpty) {
        for (int i = 0; i < newDetailsImages.length; i++) {
          formData.files.add(MapEntry(
            'details_images[$i]', // استخدم فهرسًا لضمان إرسالها كمصفوفة
            await Dio.MultipartFile.fromFile(
              newDetailsImages[i].path,
              filename: 'detail_${DateTime.now().millisecondsSinceEpoch}_$i.jpg',
            ),
          ));
        }
      }

      // لغرض التصحيح: طباعة بيانات النموذج
      debugPrint('بيانات النموذج الجاهزة للإرسال (تحديث):');
      debugPrint(jsonEncode(restArea.toJson()), wrapWidth: 1024);
      debugPrint('Fields in FormData: ${formData.fields.toString()}', wrapWidth: 5000);
      debugPrint('Files in FormData: ${formData.files.map((e) => e.key + ': ' + e.value.filename.toString()).toList()}');

      // ====== إرسال الطلب ======
      final response = await Dio.Dio().post( // استخدام POST مع _method: PUT
        'https://esteraha.ly/api/rest-areas/${restArea.id}', // نقطة نهاية التحديث
        data: formData,
        options: Dio.Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      Get.snackbar(
        "نجاح",
        "تم إرسال طلب تحديث الاستراحة بنجاح.",
        backgroundColor: MyColors.successColor,
        colorText: Colors.white,
      );

      return response;
    } on Dio.DioException catch (e) {
      debugPrint('خطأ في الإرسال (DioException - تحديث): $e');
      if (e.response != null) {
        debugPrint('رد الخادم: ${e.response?.data}');
      }
      _handleError(e);
      rethrow;
    } catch (e) {
      debugPrint('خطأ آخر غير متوقع (تحديث): $e');
      Get.snackbar(
        "خطأ",
        "حدث خطأ غير متوقع: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // 🔴 دالة مساعدة لمعالجة أخطاء Dio وعرض رسائل واضحة للمستخدم
  void _handleError(Dio.DioException e) {
    String errorMessage = "حدث خطأ غير متوقع.";
    if (e.response != null) {
      // التحقق من رموز حالة HTTP الشائعة وتقديم رسائل محددة
      if (e.response!.statusCode == 401) {
        errorMessage = "غير مصرح: يرجى تسجيل الدخول مرة أخرى.";
      } else if (e.response!.statusCode == 403) {
        errorMessage = "ممنوع: ليس لديك الصلاحية للقيام بهذا الإجراء.";
      } else if (e.response!.statusCode == 404) {
        errorMessage = "المورد غير موجود.";
      } else if (e.response!.statusCode == 422) { // أخطاء التحقق من صحة البيانات (Validation errors)
        if (e.response!.data != null && e.response!.data is Map && e.response!.data.containsKey('errors')) {
          Map<String, dynamic> errors = e.response!.data['errors'];
          errorMessage = "خطأ في التحقق من صحة البيانات:";
          errors.forEach((key, value) {
            if (value is List) {
              errorMessage += "\n- ${value.join(', ')}"; // لدمج رسائل الأخطاء المتعددة لنفس الحقل
            } else {
              errorMessage += "\n- $value";
            }
          });
        } else if (e.response!.data != null && e.response!.data.containsKey('message')) {
          errorMessage = e.response!.data['message'];
        } else {
          errorMessage = "خطأ في البيانات المدخلة.";
        }
      } else if (e.response!.data != null && e.response!.data.containsKey('message')) {
        errorMessage = e.response!.data['message'];
      } else {
        errorMessage = "خطأ من الخادم: ${e.response!.statusCode}";
      }
    } else {
      // لا يوجد استجابة، على الأرجح خطأ في الشبكة
      errorMessage = "خطأ في الاتصال: تأكد من اتصالك بالإنترنت.";
    }

    Get.snackbar(
      "خطأ",
      errorMessage,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 5), // زيادة مدة عرض الرسالة
    );
  }

}