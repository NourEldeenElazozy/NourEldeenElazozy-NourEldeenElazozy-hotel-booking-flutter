part of 'review_import.dart';

class ReviewController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());

  RxInt selectedRate = 0.obs;

  RxList<AllReviews> allReviews = <AllReviews>[].obs;
  RxBool isLoadingReviews = false.obs;
  // Dio instance
  final Dio _dio = Dio();
  RxDouble overallRating = 0.0.obs;
  RxInt totalReviewsCount = 0.obs;

  RxBool isDarkMode = false.obs; // استبدل هذا بالطريقة الفعلية لجلب وضع الليل/النهار
  @override
  void onInit() {

    //getAllReview();
    super.onInit();
  }

  Future<void> fetchReviews({required int restAreaId}) async {
    isLoadingReviews.value = true; // تفعيل حالة التحميل

    try {
      // تعديل نقطة النهاية لجلب المراجعات الخاصة بـ restAreaId معينة
      // يجب أن تكون نقطة النهاية في Laravel كما يلي:
      // Route::get('/reviews/{rest_area_id}', [ReviewController::class, 'index']);
      final url = 'https://esteraha.ly/api/reviews/$restAreaId'; // <--- المسار لجلب المراجعات

      final response = await _dio.get(url);
      print('response $response');
      if (response.statusCode == 200) {
        // افترض أن الاستجابة هي:
        // {
        //   "data": [...list of reviews...],
        //   "meta": {"overall_rating": 4.8, "total_reviews": 100} // بيانات إضافية
        // }

        final List<dynamic> reviewsData = response.data['data'];
        final List<AllReviews> fetchedReviews = reviewsData
            .map((json) => AllReviews.fromJson(json as Map<String, dynamic>))
            .toList();

        allReviews.assignAll(fetchedReviews); // تحديث قائمة المراجعات

        // تحديث التقييم الإجمالي وعدد المراجعات إذا كانت متاحة في الـ API
        if (response.data['meta'] != null) {
          overallRating.value = (response.data['meta']['overall_rating'] as num?)?.toDouble() ?? 0.0;
          totalReviewsCount.value = response.data['meta']['total_reviews'] as int? ?? 0;
        }

      } else {
        Get.snackbar(
          "خطأ",
          "فشل جلب التقييمات: ${response.statusMessage}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } on DioException catch (e) {
      String errorMessage = "حدث خطأ في الشبكة.";
      if (e.response != null) {
        errorMessage = "خطأ في الخادم: ${e.response?.statusCode} - ${e.response?.data['message'] ?? e.response?.statusMessage}";
      }
      Get.snackbar(
        "خطأ",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      print('err $e');
      Get.snackbar(
        "خطأ",
        "حدث خطأ غير متوقع أثناء جلب التقييمات: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingReviews.value = false; // تعطيل حالة التحميل
    }
  }
}