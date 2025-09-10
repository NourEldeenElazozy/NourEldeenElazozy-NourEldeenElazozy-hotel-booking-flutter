import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:hotel_booking/presentation/screen/Package/PackageCard.dart';

class PackageCardController extends GetxController {
  var packages = <Package>[].obs; // قائمة الباقات
  var isLoading = true.obs; // حالة التحميل

  @override
  void onInit() {
    fetchPackages();
    super.onInit();
  }

  void fetchPackages() async {
    isLoading.value = true; // تغيير الحالة إلى التحميل

    try {
      final response = await Dio().get(
        'https://esteraha.ly/api/packages',
        options: Options(
          sendTimeout: const Duration(seconds: 30), // مهلة الإرسال 1 ثانية
          receiveTimeout: const Duration(seconds: 30), // مهلة الاستلام 1 ثانية

        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        packages.value = data.map((pkg) => Package(
          id: pkg['id'],
          name: pkg['name'],
          duration: pkg['duration'],
          //startRange: pkg['start_range'],
          //endRange: pkg['end_range'],
          percentage: pkg['percentage'],
          price: pkg['price'],
        )).toList();
        print(packages.value);
      }

    } on DioException  catch (e) {
      if (e.type == DioExceptionType.unknown) {
        print('sتم انتهاء المهلة، لم يتمكن من الحصول على البيانات.');
        // تأكد من تغيير الحالة عند الانتهاء من الطلب
        isLoading.value = false; // تغيير الحالة عند الانتهاء
      }
      if (e.type == DioExceptionType.sendTimeout) {
        print('تم انتهاء المهلة، لم يتمكن من الحصول على البيانات.a');
        // تأكد من تغيير الحالة عند الانتهاء من الطلب
        isLoading.value = false; // تغيير الحالة عند الانتهاء
      }
      if (e.type == DioExceptionType.badResponse) {
        print('cتم انتهاء المهلة، لم يتمكن من الحصول على البيانات.');
        // تأكد من تغيير الحالة عند الانتهاء من الطلب
        isLoading.value = false; // تغيير الحالة عند الانتهاء
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        print('fتم انتهاء المهلة، لم يتمكن من الحصول على البيانات.');
        // تأكد من تغيير الحالة عند الانتهاء من الطلب
        isLoading.value = false; // تغيير الحالة عند الانتهاء
      }
      if (e.type == DioExceptionType.receiveTimeout) {
        print('تم انتهاء المهلة، لم يتمكن من الحصول على البيانات.r');
        // تأكد من تغيير الحالة عند الانتهاء من الطلب
        isLoading.value = false; // تغيير الحالة عند الانتهاء
      }
      print('Error: $e'); // طباعة الخطأ
      isLoading.value = false; // تغيير الحالة عند الانتهاء
    } finally {

      print('تم انتهاء المهلة، لم يتمكن من الحصول على البياناتس.');
      // تأكد من تغيير الحالة عند الانتهاء من الطلب
      isLoading.value = false; // تغيير الحالة عند الانتهاء

    }
  }
}