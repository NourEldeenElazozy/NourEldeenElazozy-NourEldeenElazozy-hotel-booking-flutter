part of 'profile_import.dart';

class ProfileController extends GetxController {
  ThemeController themeController = Get.put(ThemeController());

  RxBool isDarkMode = false.obs;
  RxBool isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = themeController.isDarkMode.value;
  }

//---------------------------------------- profileNotification_screen -----------------------------------
    RxBool generalNotification = false.obs;
    RxBool sound = false.obs;
    RxBool vibrate = false.obs;
    RxBool appUpdates = false.obs;
    RxBool serviceAvailable = false.obs;
    RxBool tipsAvailable = false.obs;

//---------------------------------------- Language_screen -----------------------------------
    int selectLanguage = 0;


  Future<void> sendResthouseRequest({
    required String name,
    required String phone,
    String? note,
  }) async {
    try {
      isLoading.value=true;
      final Dio _dio = Dio(BaseOptions(baseUrl: "https://esteraha.ly/api"));
      final response = await _dio.post("/resthouse-request", data: {
        "name": name,
        "phone": phone,
        "note": note ?? '',
      });

      if (response.statusCode == 201) {
        isLoading.value=false;
        Get.snackbar("تم الإرسال", "تم إرسال طلبك بنجاح ✅",
            backgroundColor: const Color(0xFF4CAF50), colorText: Get.theme.canvasColor);
      } else {
        Get.snackbar("خطأ", "فشل في إرسال الطلب", backgroundColor: Get.theme.errorColor);
        isLoading.value=false;
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء الإرسال", backgroundColor: Get.theme.errorColor);
      isLoading.value=false;
      print("Dio error: $e");
    }
  }
}