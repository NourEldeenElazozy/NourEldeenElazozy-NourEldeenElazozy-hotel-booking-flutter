part of 'help_center_import.dart';

class HelpCenterController extends GetxController {
  ThemeController themeController = Get.put(ThemeController());

  Rx<TextEditingController> searchController = TextEditingController().obs;
  Rx<FocusNode> searchFocus = FocusNode().obs;
  RxList isExpandedList = [].obs;
  // RxBool isExpanded = true.obs ;
  // RxInt? isExpandedIndex;
}