part of 'privacy_policy_import.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {

  late PrivacyPolicyController controller;

  @override
  void initState() {
    controller = Get.put(PrivacyPolicyController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomFullAppBar(title: MyString.privacy),
      body: FutureBuilder(
        future: controller.initWebView(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: controller.themeController.isDarkMode.value ? Colors.white : Colors.black),
            );
          } else if(snapshot.hasError) {
            return Text('Error : ${snapshot.error}');
          } else {
            return WebViewWidget(controller: controller.webViewController);
          }
        },
      ),
    );
  }
}
