part of 'search_import.dart';

class SearchControllers extends GetxController {
  ThemeController themeController = Get.put(ThemeController());

  Rx<TextEditingController> searchController = TextEditingController().obs;
  Rx<FocusNode> searchFocus = FocusNode().obs;
  RxBool selectItem = false.obs;
  RxInt selectedButton = 0.obs;
  static RxList searchText = [].obs;

  void addSearchData(String value) {
    if(searchText.contains(value) == false) {
      searchText.add(value);
    }
  }

  void removeSearchData(int index) {
    searchText.removeAt(index);
  }
}