part of 'bookmark_import.dart';

class BookMarkController extends GetxController {
  ThemeController themeController = Get.put(ThemeController()) ;
  HomeController homeController = HomeController();

  RxInt selectedButton = 0.obs;
}