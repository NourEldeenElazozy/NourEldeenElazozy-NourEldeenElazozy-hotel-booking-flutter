part of 'password_import.dart';

class ChoicePasswordScreen extends StatefulWidget {
  const ChoicePasswordScreen({super.key});

  @override
  State<ChoicePasswordScreen> createState() => _ChoicePasswordScreenState();
}

class _ChoicePasswordScreenState extends State<ChoicePasswordScreen> {

  late PasswordController controller;

  @override
  void initState() {
    controller = Get.put(PasswordController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomFullAppBar(title: MyString.choiceForgotPassword),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
          child: Column(
            children: [
              Image.asset(MyImages.forgotPasswordLock),
              const SizedBox(height: 40),
              const Text(MyString.passwordDescription, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),),
              const SizedBox(height: 30),
              InkWell(
                onTap: () {
                  // Get.toNamed("/selectSmsEmail");
                  Get.to(const SelectSmsEmailScreen(icon:MyImages.viaSms,sms:MyString.viaSms, hintText:MyString.mobileNumber, status:true));
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: controller.themeController.isDarkMode.value ? Colors.grey.shade800 : Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 38,
                        backgroundColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.skipButtonColor,
                        child: SvgPicture.asset(MyImages.viaSms),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(MyString.viaSms, style: TextStyle(color: controller.themeController.isDarkMode.value ? MyColors.switchOffColor : Colors.grey.shade600 ,fontWeight: FontWeight.w500, fontSize: 14),),
                          const SizedBox(height: 10),
                          Text(MyString.mobileNumber, style: TextStyle(color: controller.themeController.isDarkMode.value ? MyColors.white : MyColors.profileListTileColor ,fontWeight: FontWeight.w500, fontSize: 14),),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Get.to(const SelectSmsEmailScreen(icon:MyImages.viaEmail ,sms:MyString.viaEmail, hintText:MyString.emailId, status:false));
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: controller.themeController.isDarkMode.value ? Colors.grey.shade800 : Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 38,
                        backgroundColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.skipButtonColor,
                        child: SvgPicture.asset(MyImages.viaEmail),
                      ),

                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(MyString.viaEmail, style: TextStyle(color: controller.themeController.isDarkMode.value ? MyColors.switchOffColor : Colors.grey.shade600, fontWeight: FontWeight.w500, fontSize: 14)),
                          const SizedBox(height: 10),
                          const Text(MyString.emailId, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
