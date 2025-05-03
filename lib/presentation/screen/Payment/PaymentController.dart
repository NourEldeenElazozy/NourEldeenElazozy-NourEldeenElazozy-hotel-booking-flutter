// controllers/payment_controller.dart
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart' ;
import 'package:hotel_booking/core/constants/my_strings.dart';
import 'package:hotel_booking/presentation/screen/Payment/PaymentWebView.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentController extends GetxController {

  final RxString paymentUrl = ''.obs;
  final RxBool isLoading = false.obs;

  Future<void> initiatePayment({
    required double amount,
    required String phone,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    isLoading.value = true;
    try {
      final response = await dio.Dio().post(
          'http://10.0.2.2:8000/api/test-payment', // 🔁 غيّر الرابط حسب بيئتك
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
        Get.to(() => PaymentWebViewScreen(url: data['url']));
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
      print ("transaction");
      print (MyString.custom_ref);




      final response = await dio.Dio().post(
          'https://c7drkx2ege.execute-api.eu-west-2.amazonaws.com/receipt/transaction',

          data: {
            "store_id": "L594BelkgyrDR9X631N7mAP4MEQBqVvdYqZnx5zWk2ow0eKGdLlOajYJbgDQEyKW",

            "custom_ref": MyString.custom_ref
          },
          options: dio.Options(headers: {
            "Content-Type": "application/json",
            "Authorization":
            "Bearer tyFD6SCj7EngBEAGVYLPQawTgdkdK15AG0uCSn67",
          })
      );
      print ("transaction");
      print (MyString.custom_ref);
      print (response.data);
      print (response.data);


      return response;

    } catch (e) {
      print('Error during request $e');
      // يمكنك معالجة الخطأ هنا
      rethrow; // لإعادة رمي الاستثناء إلى المستوى الأعلى
    }
  }
}
