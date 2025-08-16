part of 'search_import.dart';

class SearchControllers extends GetxController {
  ThemeController themeController = Get.put(ThemeController());

  Rx<TextEditingController> searchController = TextEditingController().obs;
  Rx<FocusNode> searchFocus = FocusNode().obs;
  RxBool selectItem = false.obs;
  RxInt selectedButton = 0.obs;
  static RxList searchText = [].obs;
  RxList<dynamic> searchResults = <dynamic>[].obs;
  void addSearchData(String value) {
    if(searchText.contains(value) == false) {
      searchText.add(value);
    }
  }

  void removeSearchData(int index) {
    searchText.removeAt(index);
  }
  void searchLive(String query) async {
    try {
      var response = await Dio().get(
        "https://esteraha.ly/api/rest-areas/filter",
        queryParameters: {"q": query}, // البحث الجزئي حسب الاسم
      );
      searchResults.value = response.data;
      print(searchResults.value);
      print("searchResults.value");
    } catch (e) {
      print("Search error: $e");
    }
  }

}