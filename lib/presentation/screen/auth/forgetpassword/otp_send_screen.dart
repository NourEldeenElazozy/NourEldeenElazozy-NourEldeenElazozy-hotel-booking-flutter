part of 'password_import.dart';

class OtpSendScreen extends StatefulWidget {
  const OtpSendScreen({super.key});

  @override
  State<OtpSendScreen> createState() => _OtpSendScreenState();
}

class _OtpSendScreenState extends State<OtpSendScreen> {
  // استخدام Get.find للحصول على نسخة المتحكم الموجودة
  late PasswordController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<PasswordController>();
    // ✅ إزالة استدعاء controller.startTimer() هنا
    // لأنه يتم استدعاؤه بالفعل في selectSmsEmailSubmit بعد استلام الـ OTP
    // وهذا يضمن أن الـ _timer سيكون قد تم تهيئته.
  }

  @override
  void dispose() {
    // ✅ التأكد من إلغاء المؤقت عند التخلص من الشاشة
    // يتم التعامل مع هذا الآن في onClose الخاص بالـ Controller بشكل أفضل
    // ولكن إبقاؤه هنا لضمان قوي لا يضر.
    // يفضل الاعتماد على onClose في Controller بشكل أساسي.
    // إذا كنت متأكدًا أن `onClose` للمتحكم ستنفذ دائمًا، يمكنك إزالته من هنا.
    // ولكن للتأكد، لا بأس بتركه.
    // لا نحتاج للتحقق من isActive هنا لأن الـ `_timer` أصبح nullable
    // و `.cancel()` على null آمن.
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
                // استدعاء دالة التحقق من الـ OTP في المتحكم
                controller.otpSend(context);
              },
              text: MyString.verify,
              textSize: 16,
              fontBold: FontWeight.w700,
              textColor: MyColors.white,
            ),
          ),
          body: SingleChildScrollView( // ✅ SingleChildScrollView هنا
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 16.0,
              // ✅ إضافة الحشوة السفلية بناءً على ارتفاع لوحة المفاتيح
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
                      // ✅ عرض الرقم الذي تم إرسال الـ OTP إليه
                      Text(controller.smsController.text,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  PinCodeTextField(
                    obscureText: false,
                    autoDisposeControllers: false,
                    appContext: context,
                    // ✅ طول الـ OTP ديناميكيًا بناءً على ما تم استقباله
                    length: controller.receivedOtp.value.toString().length,
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
                        selectedColor: controller.themeController.isDarkMode.value
                            ? Colors.white
                            : Colors.black,
                        inactiveColor: Colors.grey,
                        inactiveFillColor: Colors.blue.shade100, // لون تعبئة حقول غير نشطة
                        activeFillColor: Colors.green.shade100, // لون تعبئة حقول نشطة
                        activeColor: Colors.grey,
                        selectedFillColor: Colors.yellow.shade100 // لون تعبئة الحقل المختار
                    ),
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
                              controller._remainingSeconds.value = 10; // إعادة تعيين العداد
                              controller.startTimer();
                              // ✅ إعادة إرسال OTP - استدعاء نفس منطق الإرسال
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