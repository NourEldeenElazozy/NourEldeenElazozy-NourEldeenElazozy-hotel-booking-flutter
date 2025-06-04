part of 'hotel_detail_import.dart';

class HomeDetailController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());
  late bool isDarkMode;
  late Detail detail;
  RxInt sliderIndex = 0.obs;
  late String firstHalf;
  late String secondHalf;
  RxBool flag = true.obs;
  RxDouble userRating = 0.0.obs;
  TextEditingController commentController = TextEditingController();
  RxBool isLoading = false.obs; // <--- متغير جديد لحالة التحميل
  final Dio _dio = Dio();

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
  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }

  void setUserRating(double rating) {
    userRating.value = rating;
  }


  void setUserComment(String comment) {
    // يمكنك حفظ التعليق هنا إذا أردت تتبعه بشكل مباشر
    // على سبيل المثال: RxString userCommentText = ''.obs;
    // userCommentText.value = comment;
  }

  // <--- دالة إرسال التقييم باستخدام Dio مع حالة التحميل
  Future<void> submitReview({required int restAreaId}) async {
    // 1. تحقق من صحة التقييم قبل البدء
    if (userRating.value == 0.0) {
      Get.snackbar(
        "خطأ",
        "الرجاء اختيار تقييم بالنجوم.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // 2. تفعيل حالة التحميل
    isLoading.value = true;
    print("Loading state activated: ${isLoading.value}");

    try {
      final url = 'http://10.0.2.2:8000/api/reviews'; // تأكد من هذا العنوان
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      // إذا كنت تستخدم التوثيق بـ Sanctum (Bearer Token)
      // تأكد من أن لديك الـ token الخاص بالمستخدم
      final String? authToken = 'YOUR_AUTH_TOKEN_HERE'; // <--- استبدل بالتوكن الفعلي
      if (authToken == null || authToken.isEmpty) {
        // إذا كان مطلوباً تسجيل الدخول للتقييم
        Get.snackbar(
          "خطأ",
          "يجب أن تكون مسجل دخول لإرسال التقييم.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        isLoading.value = false;
        return;
      }


      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token', // إضافة الـ Token
          },
        ),
        data: {
          'rest_area_id': restAreaId, // تمرير معرف المكان من الواجهة
          'rating': userRating.value,
          'comment': commentController.text,
        },
      );

      // 3. معالجة الاستجابة
      if (response.statusCode == 201) {
        Get.snackbar(
          "نجاح",
          "تم إرسال تقييمك بنجاح!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // إعادة تعيين الحالة بعد الإرسال الناجح
        userRating.value = 0.0;
        commentController.clear();
      } else {
        Get.snackbar(
          "خطأ",
          "فشل إرسال التقييم: ${response.statusMessage}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print("API Error: ${response.data}");
      }
    } on DioException catch (e) { // استخدام DioException لمعالجة أخطاء Dio
      String errorMessage = "حدث خطأ غير معروف.";
      if (e.response != null) {
        errorMessage = "خطأ من الخادم: ${e.response?.statusCode} - ${e.response?.data['message'] ?? e.response?.statusMessage}";
        print("Dio Error Response: ${e.response?.data}");
      } else {
        errorMessage = "خطأ في الشبكة: ${e.message}";
      }
      Get.snackbar(
        "خطأ",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print("Dio Exception: $e");
    } catch (e) {
      Get.snackbar(
        "خطأ",
        "حدث خطأ غير متوقع: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print("General Error: $e");
    } finally {
      // 4. تعطيل حالة التحميل دائماً سواء نجح الطلب أو فشل
      isLoading.value = false;
      print("Loading state deactivated: ${isLoading.value}");
    }
  }

}
