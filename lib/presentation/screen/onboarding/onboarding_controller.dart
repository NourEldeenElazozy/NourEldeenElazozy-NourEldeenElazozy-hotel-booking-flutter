part of 'onboarding_import.dart';

class OnboardingController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());

  RxInt changeValue = 0.obs;
  final Rx<PageController> _pageController = PageController(initialPage: 0).obs;

  // Future<void> willpopback () async {
  //   Get.offNamedUntil('/onboarding', (route) => false);
  //   // final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   // prefs.getBool('welcome') == true ?
  // }

  void nextButton () {
    _pageController.value.animateToPage(
      _pageController.value.page!.toInt() + 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  Future<void> storeValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding', true);
    Get.offNamed("/loginOptionScreen");
  }
}