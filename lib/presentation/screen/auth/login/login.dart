part of 'login_import.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  late LoginController controller;
  bool showPassword = false;

  @override
  void initState() {
    super.initState();
    controller = Get.put(LoginController());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: controller,
      builder: (controller) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                return Get.back();
                              },
                              child: Container(
                                padding: const EdgeInsets.only(right: 3, top: 3, bottom: 3),
                                child: SvgPicture.asset(MyImages.backArrow),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height* 0.25,
          
                          child: ClipOval(
                            child: Image.asset(
                              MyImages.logo,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
          
                        Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height * 0.10,
                          child: const Text(MyString.loginTitle,  style:  TextStyle(
          
                            fontSize: 20,
          
                          ),),
                        ),
          
                        // Focus(
                        //   child: Builder(
                        //     builder: (BuildContext context) {
                        //       final FocusNode emailFocusNode = Focus.of(context);
                        //       final bool hasFocus = emailFocusNode.hasFocus;
                        //       return
                        //     },
                        //   ),
                        // ),
                        CustomTextFormField(
                          controller: controller.phoneController,
                          obscureText: false,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            return Validations().mobileNumberValidation(value);
                          },
                          hintText: MyString.phoneNumber,
                          fillColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.disabledTextFieldColor,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SvgPicture.asset(MyImages.mobile),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Focus(
                        //   child: Builder(
                        //     builder: (BuildContext context) {
                        //       final FocusNode passwordFocusNode = Focus.of(context);
                        //       final bool hasFocus = passwordFocusNode.hasFocus;
                        //       return
                        //     },
                        //   ),
                        // ),
                        CustomTextFormField(
                          controller: controller.passwordController,
                          obscureText: controller.password.value,
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            return Validations().passwordValidation(value);
                          },
                          hintText: MyString.passwordHintText,
                          fillColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor :MyColors.disabledTextFieldColor,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SvgPicture.asset(MyImages.passwordLock),
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  controller.password.value = !controller.password.value;
                                });
                              },
                              child: SvgPicture.asset(controller.password.value ? MyImages.hidePassword : MyImages.showPassword, colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Obx(() => SizedBox(
                          height: 55,
                          width: MediaQuery.of(context).size.width,
                          child: controller.isLoading.value
                              ? const Center(child: CircularProgressIndicator(color: Colors.orange,)) // ← أثناء التحميل
                              : Button(
                            onpressed: () {
                              controller.submit();
                            },
                            text: MyString.signIn,
                            shadowColor: controller.themeController.isDarkMode.value
                                ? Colors.transparent
                                : MyColors.buttonShadowColor,
                          ),
                        )),
                        const SizedBox(height: 30),
                        InkWell(
                            onTap: () {
                              Get.toNamed("/choicePassword");
                            },
                            child: Text(MyString.forgotPassword, style: TextStyle(fontSize: 16, color: controller.themeController.isDarkMode.value ? MyColors.textYellowColor : MyColors.successColor, fontWeight: FontWeight.w600),)
                        ),
                        const SizedBox(height: 40),
          
                        const SizedBox(height: 30),
          
                        const SizedBox(height: 40),
          
                      ],
                    ),
                  )
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

customLoginOptionButton(String image, bool isDarkMode) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color:isDarkMode ? MyColors.white : MyColors.dividerLightTheme),
    ),
    child: SvgPicture.asset(image, width: 30,),
  );
}
