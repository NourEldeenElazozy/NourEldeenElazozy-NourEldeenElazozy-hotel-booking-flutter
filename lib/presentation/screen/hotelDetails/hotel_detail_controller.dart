part of 'hotel_detail_import.dart';

class HomeDetailController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());
  late bool isDarkMode;
  late Detail detail;
  RxInt sliderIndex = 0.obs;
  late String firstHalf;
  late String secondHalf;
  RxBool flag = true.obs;


  @override
  void onInit() {
    isDarkMode = themeController.isDarkMode.value;
    if (Get.arguments['data'] is Map<String, dynamic>) {
      print("Invalid data passed to HomeDetailController");
      detail = Detail.fromJson(Get.arguments['data']);
      print(detail);
    } else {
      // يمكنك التعامل مع الحالة عندما لا تكون البيانات صحيحة
      print("Invalid data passed to HomeDetailController");
    }
    super.onInit();
  }


}
