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
    RxBool generalNotification = true.obs;
    RxBool sound = true.obs;
    RxBool vibrate = true.obs;
    RxBool appUpdates = true.obs;
    RxBool serviceAvailable = true.obs;
    RxBool tipsAvailable = true.obs;

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

  Future<void> deleteAccount() async {
    try {
      isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token'); // تخزين التوكن عند تسجيل الدخول

      if (token == null) {
        Get.snackbar("خطأ", "لم يتم العثور على التوكن");
        return;
      }

      final dio = Dio();
      final response = await dio.post(
        "https://esteraha.ly/api/delete-account",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        // حذف التوكن من التخزين المحلي
        await prefs.remove('token');
        await prefs.remove('user_type');
        await prefs.remove('userId');
        await prefs.remove('userName');
        await prefs.remove('userPhone');
        await prefs.remove('gender');

        Get.snackbar(
          "تم الحذف",
          response.data['message'] ?? "تم حذف الحساب بنجاح",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );

        // رجوع لصفحة تسجيل الدخول
        Get.offAllNamed('/loginOptionScreen');
      } else {
        Get.snackbar("خطأ", response.data['message'] ?? "فشل حذف الحساب");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء حذف الحساب");
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}