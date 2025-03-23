part of 'password_import.dart';

class OtpSendScreen extends StatefulWidget {

  const OtpSendScreen({super.key});

  @override
  State<OtpSendScreen> createState() => _OtpSendScreenState();
}

class _OtpSendScreenState extends State<OtpSendScreen>  {

  late PasswordController controller;
  @override
  void initState() {
    super.initState();
    controller = Get.put(PasswordController());
    controller.startTimer();
  }

  @override
  void dispose() {
    controller._timer.cancel();
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
                return controller.otpSend(context);
                // Get.toNamed("/createNewPassword");
              },
              text: MyString.verify,
              textSize: 16,
              fontBold: FontWeight.w700,
              textColor: MyColors.white,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: controller.otpFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(MyString.codeSend, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
                      Text(controller.smsController.text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  PinCodeTextField(
                    obscureText: false,
                    autoDisposeControllers: false,
                    appContext: context,
                    length: 4,
                    controller: controller.otpController,
                    animationType: AnimationType.scale,
                    keyboardType: TextInputType.number,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(10),
                      fieldHeight: 50,
                      fieldWidth: 65,
                      inactiveBorderWidth: 0,
                      activeBorderWidth: 0,
                      selectedColor: controller.themeController.isDarkMode.value ? Colors.white : Colors.black,
                      inactiveColor: Colors.grey,
                      inactiveFillColor: Colors.blue,
                      activeFillColor: Colors.green,
                      activeColor: Colors.grey,
                      selectedFillColor: Colors.yellow
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    onChanged: (value) {
                      // Implement any logic when the OTP changes
                    },
                  ),
                  const SizedBox(height: 16),
                  Obx(() => Column(
                    children: [
                      Text(
                        "Resend code in ${controller._remainingSeconds.value} s",
                        style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                      ),
                      controller._remainingSeconds.value == 0
                        ? Button(
                        shadowColor: Colors.transparent,
                          onpressed: () {
                            controller.otpController.clear();
                            controller._remainingSeconds.value = 10;
                            controller.startTimer();
                          },
                          text: "Resend"
                      )
                      : const SizedBox()
                    ],
                  ),)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
