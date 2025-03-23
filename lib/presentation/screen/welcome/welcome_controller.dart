part of 'welcome_import.dart';

class WelcomeController extends GetxController {

  void init () {
    Future.delayed(const Duration(seconds: 3), () {
      Get.offNamed('/onboarding');
    },);
  }
}