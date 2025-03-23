part of 'privacy_policy_import.dart';

class PrivacyPolicyController extends GetxController {
  ThemeController themeController = Get.put(ThemeController());
  late WebViewController webViewController;

  @override
  void onInit() {
    initWebView();
    super.onInit();
  }

  Future<void> initWebView() async {
    String fileText = await rootBundle.loadString("assets/data/privacy_policy.html");
    webViewController = WebViewController();
    WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Get.isDarkMode ? MyColors.scaffoldDarkColor : Colors.white);

    webViewController.loadRequest(Uri.dataFromString(fileText,
        mimeType: 'text/html', encoding: Encoding.getByName('utf-8')));
  }

}