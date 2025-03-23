part of 'review_import.dart';

class ReviewController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());

  RxInt selectedRate = 0.obs;

  RxList<AllReview> allReview = <AllReview>[].obs;

  @override
  void onInit() {
    getAllReview();
    super.onInit();
  }

  Future<List<AllReview>> getAllReview() async {
    String jsonData = await rootBundle.loadString("assets/data/review.json");
    dynamic data = json.decode(jsonData);
    List<dynamic> jsonArray = data['allReviews'];
    for (int i = 0; i < jsonArray.length; i++) {
      allReview.add(AllReview.fromJson(jsonArray[i]));
    }
    return allReview;
  }
}