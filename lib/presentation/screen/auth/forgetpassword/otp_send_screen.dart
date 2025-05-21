part of 'password_import.dart';

class OtpSendScreen extends StatefulWidget {
  const OtpSendScreen({super.key});

  @override
  State<OtpSendScreen> createState() => _OtpSendScreenState();
}

class _OtpSendScreenState extends State<OtpSendScreen> {
  late PasswordController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<PasswordController>();
  }

  @override
  void dispose() {
    controller._timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PasswordController>(
      builder: (controller) {
        return Scaffold(
          appBar: const CustomFullAppBar(title: MyString.choiceForgotPassword),
          bottomNavigationBar: Container(
            height: 90,
            padding: const EdgeInsets.all(15),
            child: Button(
              onpressed: () {
                controller.otpSend(context);
              },
              text: MyString.verify,
              textSize: 16,
              fontBold: FontWeight.w700,
              textColor: MyColors.white,
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 16.0,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
            ),
            child: Form(
              key: controller.otpFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(MyString.codeSend,
                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
                      Text(controller.smsController.text,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  PinCodeTextField(
                    obscureText: false,
                    autoDisposeControllers: false,
                    appContext: context,
                    // ✅ ثبت الطول إلى 6 بدلاً من القيمة الديناميكية
                    length: 6,
                    controller: controller.otpController,
                    animationType: AnimationType.scale,
                    keyboardType: TextInputType.number,
                    pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(10),
                        fieldHeight: 50,
                        // ✅ تأكد أن fieldWidth مناسب لـ 6 حقول
                        fieldWidth: 45, // قيمة مقترحة، قد تحتاج للتجربة (45, 40, 35)
                        inactiveBorderWidth: 0,
                        activeBorderWidth: 0,
                        selectedColor: controller.themeController.isDarkMode.value
                            ? Colors.white
                            : Colors.black,
                        inactiveColor: Colors.grey,
                        inactiveFillColor: Colors.blue.shade100,
                        activeFillColor: Colors.green.shade100,
                        activeColor: Colors.grey,
                        selectedFillColor: Colors.yellow.shade100),
                    animationDuration: const Duration(milliseconds: 300),
                    onChanged: (value) {
                      // يمكنك إضافة منطق هنا عند تغيير قيمة الـ OTP
                    },
                  ),
                  const SizedBox(height: 16),
                  Obx(
                        () => Column(
                      children: [
                        Text(
                          "Resend code in ${controller._remainingSeconds.value} s",
                          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                        ),
                        controller._remainingSeconds.value == 0
                            ? Button(
                            shadowColor: Colors.transparent,
                            onpressed: () async {
                              controller.otpController.clear();
                              controller._remainingSeconds.value = 10;
                              controller.startTimer();
                              await controller.selectSmsEmailSubmit(context);
                            },
                            text: "Resend")
                            : const SizedBox()
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}