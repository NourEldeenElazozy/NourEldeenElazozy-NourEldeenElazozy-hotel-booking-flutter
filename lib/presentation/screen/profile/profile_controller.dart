part of 'profile_import.dart';

class ProfileController extends GetxController {
  ThemeController themeController = Get.put(ThemeController());

  RxBool isDarkMode = false.obs;

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
}