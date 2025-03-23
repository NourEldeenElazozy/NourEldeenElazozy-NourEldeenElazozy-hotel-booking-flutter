part of 'password_import.dart';

class SelectSmsEmailScreen extends StatefulWidget {
  final String icon;
  final String sms;
  final String hintText;
  final bool status;
  const SelectSmsEmailScreen({super.key, required this.icon, required this.sms, required this.hintText, required this.status});

  @override
  State<SelectSmsEmailScreen> createState() => _SelectSmsEmailScreenState();
}

class _SelectSmsEmailScreenState extends State<SelectSmsEmailScreen> {

  late PasswordController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(PasswordController());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PasswordController>(
      init: controller,
      builder: (controller) {
        return Scaffold(
          appBar: const CustomFullAppBar(title: MyString.choiceForgotPassword),
          bottomNavigationBar: Container(
            height: 90,
            padding: const EdgeInsets.all(15),
            child: Button(
              onpressed: () {
                return controller.selectSmsEmailSubmit(context);
              },
              text: MyString.continueButton,
              textSize: 16,
              fontBold: FontWeight.w700,
              textColor: MyColors.white,
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
              child: Column(
                children: [
                  Image.asset(MyImages.forgotPasswordLock),
                  const SizedBox(height: 40),
                  const Text(MyString.passwordDescription, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),),
                  const SizedBox(height: 30),
                  Form(
                    key: controller.smsEmailKey,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        // color: MyColors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 38,
                            backgroundColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.skipButtonColor,
                            child: SvgPicture.asset(widget.icon),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.sms, style: TextStyle(color: controller.themeController.isDarkMode.value ? MyColors.switchOffColor : Colors.grey.shade600, fontWeight: FontWeight.w500, fontSize: 13),),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 70,
                                width: 200,
                                child: TextFormField(
                                  controller: controller.smsController,
                                  autofocus: true,
                                  keyboardType: widget.status ? TextInputType.number : TextInputType.emailAddress,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    return widget.status
                                      ? controller.mobileNumberValidation(value!)
                                      : controller.emailValidation(value!);
                                  },
                                  decoration:InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                    hintText: widget.hintText,
                                    hintStyle: const TextStyle(color: Colors.grey,fontWeight: FontWeight.w500, fontSize: 12),
                                    filled: true,
                                    fillColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.disabledTextFieldColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7),
                                      borderSide: BorderSide(color: Colors.grey.shade300),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: controller.themeController.isDarkMode.value ? Colors.white : Colors.black),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: controller.themeController.isDarkMode.value ? Colors.white : Colors.black),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7),
                                      borderSide: BorderSide(color: controller.themeController.isDarkMode.value ? Colors.transparent : Colors.grey.shade300),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7),
                                      borderSide: BorderSide(color: controller.themeController.isDarkMode.value ? Colors.transparent : Colors.grey.shade300),
                                    ),
                                  ),
                                )
                              ),
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
      },
    );
  }
}
