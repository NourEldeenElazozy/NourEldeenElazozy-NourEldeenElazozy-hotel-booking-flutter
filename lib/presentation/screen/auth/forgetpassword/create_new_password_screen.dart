part of 'password_import.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  State<CreateNewPasswordScreen> createState() => _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {

  late PasswordController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(PasswordController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomFullAppBar(title: MyString.newPassword),
      bottomNavigationBar: Container(
        height: 90,
        padding: const EdgeInsets.all(15),
        child: Button(
          onpressed: () {
            return controller.submit(context);
          },
          text: MyString.continueButton,
          textSize: 16,
          fontBold: FontWeight.w700,
          textColor: MyColors.white,
          shadowColor: controller.themeController.isDarkMode.value ? Colors.transparent : MyColors.buttonShadowColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: controller.newPasswordKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(MyImages.newPassword),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(MyString.yourNewPassword, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: controller.newPassword,
                  obscureText: controller.newShowPassword.value,
                  hintText: MyString.newPassword,
                  fillColor: MyColors.disabledTextFieldColor,
                  validator: Validations().passwordValidation,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SvgPicture.asset(MyImages.passwordLock),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          controller.newShowPassword.value = !controller.newShowPassword.value;
                        });
                      },
                      child: SvgPicture.asset(controller.newShowPassword.value ? MyImages.hidePassword : MyImages.showPassword, colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: controller.confirmPassword,
                  obscureText: controller.confirmShowPassword.value,
                  hintText: MyString.confirmPassword,
                  fillColor: MyColors.disabledTextFieldColor,
                  validator: (value) {
                    return controller.confirmPasswordValidation(value);
                  },
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SvgPicture.asset(MyImages.passwordLock),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          controller.confirmShowPassword.value = !controller.confirmShowPassword.value;
                        });
                      },
                      child: SvgPicture.asset(controller.confirmShowPassword.value ? MyImages.hidePassword : MyImages.showPassword, colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
