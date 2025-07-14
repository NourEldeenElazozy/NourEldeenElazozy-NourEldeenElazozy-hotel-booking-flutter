// controllers/payment_controller.dart
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart' ;
import 'package:hotel_booking/core/constants/my_strings.dart';
import 'package:hotel_booking/presentation/screen/Payment/PaymentWebView.dart';
import 'package:hotel_booking/presentation/screen/home/MyHostScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentsController extends GetxController {
  List<Map<String, dynamic>> unpaidData = [];
  final RxString paymentUrl = ''.obs;
  final RxBool isLoading = false.obs;
  String? token;

  @override
  void onInit() {

    unpaidData.clear();
    super.onInit();
  }
  Future<void> initiateCashPayment({
    required double amount,
    required int packageId,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    isLoading.value = true;

    try {
      final response = await dio.Dio().post(
        'https://esteraha.ly/api/test-cash-payment',
        data: {
          'amount': amount,
          'package_id': packageId,
          'rest_area_id': unpaidData.map<int>((item) => item['id'] as int).toList(),
        },
        options: dio.Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final data = response.data;
      MyString.custom_ref = data['custom_ref'].toString();
      Get.to(() => MySotingScreen());

    } on dio.DioError catch (e) {
      if (e.response != null) {
        final statusCode = e.response?.statusCode ?? 0;
        final errorData = e.response?.data;

        if (statusCode == 422 && errorData['errors'] != null) {
          // عرض كل أخطاء الفالديشن في سناك بار منفصل لكل خطأ
          final Map<String, dynamic> errors = errorData['errors'];
          errors.forEach((field, messages) {
            for (var msg in messages) {
              Get.snackbar(
                "خطأ في الحقل: $field",
                msg,
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.red,
                colorText: Colors.white,
                duration: const Duration(seconds: 3),
              );
            }
          });
        } else {
          // عرض رسالة عامة أخرى
          Get.snackbar(
            "خطأ",
            errorData['message'] ?? 'حدث خطأ أثناء المعالجة.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        // لا يوجد استجابة من السيرفر
        Get.snackbar(
          "خطأ",
          "تعذر الاتصال بالخادم.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "خطأ",
        "حدث خطأ غير متوقع.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> initiatePayment({
    required double amount,
    required String phone,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    isLoading.value = true;
    try {
      final response = await dio.Dio().post(
          'https://esteraha.ly/api/test-payment', // 🔁 غيّر الرابط حسب بيئتك
        data: {
          'amount': amount,
          'phone': phone,
          'email': "user@test.com",
        },
          options:dio.Options(
            headers: {

              'Accept': 'application/json',
              'Authorization': 'Bearer $token', // تضمين التوكن هنا
            },
          )
      );

      final data = response.data;


      MyString.custom_ref=data['custom_ref'].toString();
      print(MyString.custom_ref);
      if (data['result'] == 'success' && data['url'] != null) {
        paymentUrl.value = data['url'];
        Get.to(() => PaymentWebViewScreen(url: data['url'],price:amount, unpaidData: unpaidData,));
      } else {

        Get.snackbar("Failed", data['message'] ?? 'Payment failed');
      }
    } catch (e) {
      print( e.toString());
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
  Future<dio.Response> transaction() async {
    try {
      print("transaction");
      print(MyString.custom_ref);

      final response = await dio.Dio().post(
        'https://esteraha.ly/api/transaction',
        data: {
          "custom_ref": MyString.custom_ref,
        },
        options: dio.Options(headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        }),
      );

      print("transaction");
      print(MyString.custom_ref);
      print(response.data);

      return response;

    } on dio.DioError catch (e) {
      if (e.response != null && e.response?.statusCode == 400) {
        // إذا كان هناك رسالة خطأ مخصصة من السيرفر
        final errorMessage = e.response?.data['message'] ?? 'حدث خطأ غير معروف.';
        Get.back();
        Get.snackbar(
          "خطأ في العملية",
          errorMessage,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );

      } else {
        Get.snackbar(
          "خطأ",
          "تعذر الاتصال بالخادم",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        Get.back();
      }

      // ارجع نفس الخطأ ليتمكن المستدعي من التعامل معه أيضًا إن أراد
      rethrow;
    } catch (e) {
      // أي أخطاء أخرى غير DioError
      Get.snackbar(
        "خطأ",
        "حدث خطأ غير متوقع",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      Get.back();
      rethrow;
    }
  }

  Future<dio.Response> storeUserPackage({
    required int packageId,
    required List<int> restAreaIds,
    required String startDate,
    required String endDate,
    required double commissionRate,
  }) async {
    try {
      final response = await dio.Dio().post(
        'https://esteraha.ly/api/user-packages',
        data: {
          'package_id': packageId,
          'rest_area_ids': restAreaIds,
          'start_date': startDate,
          'end_date': endDate,
          'commission_rate': commissionRate,
        },
        options: dio.Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }),
      );

      if (response.statusCode == 201) {
        Get.snackbar("نجاح", "تم حفظ الباقة والفواتير بنجاح");
      } else {
        Get.snackbar("فشل", "حدث خطأ أثناء الحفظ");
      }

      return response;

    } on dio.DioException catch (e) {
      print("restAreaIds $restAreaIds");
      print(e.error);
      Get.snackbar("خطأ", e.response?.data["message"] ?? "فشل الاتصال بالخادم");
      rethrow;
    }
  }

}


