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
    try {
      final response = await Dio().get('http://10.0.2.2:8000/api/packages');
      if (response.statusCode == 200) {

        List<dynamic> data = response.data;
        packages.value = data.map((pkg) => Package(
          id: pkg['id'],
          name: pkg['name'],
          duration: pkg['duration'],

          startRange: pkg['start_range'],
          endRange: pkg['end_range'],
          percentage: pkg['percentage'],
        )).toList();
        print(packages.value);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false; // تغيير الحالة عند الانتهاء
    }
  }
}