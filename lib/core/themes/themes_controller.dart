import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  RxBool darkMode = false.obs;

  RxBool get isDarkMode => darkMode.value.obs;

  @override
  void onInit() {
    loadTheme();
    super.onInit();
  }

  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    darkMode.value = prefs.getBool("darkMode") ?? false;
  }

  Future<void> toggleTheme() async {
    darkMode.value = !darkMode.value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("darkMode", darkMode.value);
  }
}