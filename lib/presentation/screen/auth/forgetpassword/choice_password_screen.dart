part of 'password_import.dart';

class ChoicePasswordScreen extends StatefulWidget {
  const ChoicePasswordScreen({super.key});

  @override
  State<ChoicePasswordScreen> createState() => _ChoicePasswordScreenState();
}

class _ChoicePasswordScreenState extends State<ChoicePasswordScreen> {
  // يفضل الحصول على المتحكم هنا باستخدام Get.put
  // لضمان وجود نسخة واحدة منه لاستخدامها في الشاشات التالية
  late PasswordController controller;

  @override
  void initState() {
    controller = Get.put(PasswordController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const CustomFullAppBar(title: MyString.choiceForgotPassword),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            child: Column(
              children: [
                Image.asset(MyImages.forgotPasswordLock),
                const SizedBox(height: 40),
                const Text(
                  MyString.passwordDescription,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                  textAlign: TextAlign.center, // لتحسين مظهر النص
                ),
                const SizedBox(height: 30),
                InkWell(
                  onTap: () {
                    // عند النقر، سننتقل إلى شاشة SelectSmsEmailScreen
                    // ونمرر لها المعلمات المناسبة لعملية الـ SMS
                    Get.to(SelectSmsEmailScreen(
                      icon: MyImages.viaSms,
                      sms: MyString.viaSms,
                      hintText: MyString.mobileNumber,
                      status: true, // true لـ SMS
                      // هنا يجب أن تتأكد من أنك تمرر المتحكم أو تستخدم Get.find في OtpSendScreen
                      // بما أننا نستخدم Get.put في initState، يمكننا استخدام Get.find
                    ));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color: controller.themeController.isDarkMode.value
                              ? Colors.grey.shade800
                              : Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 38,
                          backgroundColor: controller.themeController.isDarkMode.value
                              ? MyColors.darkTextFieldColor
                              : MyColors.skipButtonColor,
                          child: SvgPicture.asset(MyImages.viaSms),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              MyString.viaSms,
                              style: TextStyle(
                                  color: controller.themeController.isDarkMode.value
                                      ? MyColors.switchOffColor
                                      : Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              MyString.mobileNumber,
                              style: TextStyle(
                                  color: controller.themeController.isDarkMode.value
                                      ? MyColors.white
                                      : MyColors.profileListTileColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

// هذه الشاشة لم تكن ضمن الكود الأصلي، لكنها ضرورية لمنطقك
// لتمكين المستخدم من إدخال رقم الهاتف أو البريد الإلكتروني قبل إرسال الـ OTP
