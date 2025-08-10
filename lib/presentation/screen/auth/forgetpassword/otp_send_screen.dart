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
    controller.startTimer();
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
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
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
                        Column(
                          children: [
                            Row(
                              children: [
                                const Text(MyString.codeSend,
                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
                                Text(controller.smsController.text,
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                              ],
                            ),

                          ],
                        ),

                      ],

                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("يرجي فحص صندوق الرسائل  الخاص بك",
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    ),
                    const SizedBox(height: 20),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: PinCodeTextField(
                        obscureText: false,
                        autoDisposeControllers: false,
                        appContext: context,
                        length: 6,
                        controller: controller.otpController,
                        animationType: AnimationType.scale,
                        keyboardType: TextInputType.number,
                        pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(10),
                            fieldHeight: 50,
                            fieldWidth: 45,
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
                    ),
                    const SizedBox(height: 16),
                    Obx(
                          () => Column(
                        children: [
                          Text(
                            "إعادة ارسال الرمز خلال ${controller._remainingSeconds.value} ثانية",
                            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                          ),
                          // زر "إعادة ارسال" معطل بصريًا وغير قابل للضغط عندما يكون العداد نشطًا
                          Button(
                            shadowColor: Colors.transparent,
                            // ✅ التحكم في قابلية الضغط:
                            // إذا كان العداد صفر، مرر الدالة التي تنفذ إعادة الإرسال.
                            // وإلا، مرر دالة فارغة لا تفعل شيئًا عند الضغط.
                            onpressed: controller._remainingSeconds.value == 0
                                ? () {
                              controller.otpController.clear();
                              controller._remainingSeconds.value = 120;
                              controller.startTimer();
                              controller.selectSmsEmailSubmit(context);
                            }
                                : () {}, // ✅ دالة فارغة لتعطيل الضغط
                            text: "إعادة ارسال",
                            // ✅ التحكم في لون النص ليعكس حالة التعطيل
                            textColor: controller._remainingSeconds.value == 0
                                ? MyColors.white // لون عادي عند التفعيل
                                : Colors.grey, // لون باهت عند التعطيل
                            // ✅ التحكم في لون الزر ليعكس حالة التعطيل
                            buttonColor: controller._remainingSeconds.value == 0
                                ? Theme.of(context).primaryColor // لون عادي عند التفعيل
                                : Colors.grey.withOpacity(0.5), // لون باهت للزر عند التعطيل
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}