part of 'password_import.dart';

class PasswordController extends GetxController {
  ThemeController themeController = Get.put(ThemeController());

  final GlobalKey<FormState> smsEmailKey = GlobalKey<FormState>();

  final TextEditingController smsController = TextEditingController();

  // هذا المتغير سيخزن الـ OTP الذي تم استقباله من الـ API
  // يجب أن يكون من نوع RxInt لكي يتم تحديث الواجهة إذا استخدمته في Obx
  RxInt receivedOtp = 0.obs; // القيمة الافتراضية 0 أو أي قيمة مناسبة
  @override
  void onInit() {
    super.onInit();
    // يمكنك تهيئة المؤقت هنا بقيمة أولية إذا كنت ترغب في ذلك
    // لكن الأفضل هو تهيئته عند الحاجة في startTimer
  }

  @override
  void onClose() {
    // ✅ التأكد من إلغاء المؤقت عند إغلاق المتحكم
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
    super.onClose();
  }
  String? mobileNumberValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "رقم الهاتف مطلوب";
    } else if (value.length != 10) {
      return "يجب ان يحتوي رقم الهاتف على 10 أرقام";
    } else if (!value.startsWith('09')) {
      return "يجب أن يبدأ رقم الهاتف ب 09";
    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return "يجب أن يحتوي رقم الهاتف على أرقام فقط";
    }
    return null;
  }

  String? emailValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required.";
    } else if (!Validations().emailRegex.hasMatch(value)) {
      return "Enter a valid Email!";
    } else {
      return null;
    }
  }

  // **** التعديل الرئيسي هنا: دالة selectSmsEmailSubmit ****
  Future<void> selectSmsEmailSubmit(BuildContext context) async {
    final isValid = smsEmailKey.currentState!.validate();
    Get.focusScope!.unfocus();
    if (!isValid) return;

    // تحويل الرقم إلى الصيغة الدولية (2189xxxxxxx)
    String rawPhone = smsController.text;
    String phone;

    if (rawPhone.startsWith('09')) {
      phone = '218${rawPhone.substring(1)}';
    } else if (rawPhone.startsWith('9')) {
      phone = '218$rawPhone';
    } else {
      Get.snackbar('خطأ', 'يجب أن يبدأ رقم الهاتف بـ 09 أو 9');
      return;
    }

    // ✅ 1. تحقق من وجود المستخدم أولاً
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      // 🔹 أرسل طلبًا إلى API للتحقق من وجود المستخدم
      final checkUserResponse = await Dio().post(
        'http://10.0.2.2:8000/api/check-user-exists',
        data: {"phone": phone},
      );

      final bool userExists = checkUserResponse.data['user_exists'];

      if (!userExists) {
        Get.back(); // أغلق الـ loading
        Get.snackbar(
          'خطأ',
          'هذا الرقم غير مسجل. يرجى التسجيل أولاً.',
          backgroundColor: Colors.red,
        );
        return; // توقف إذا لم يكن المستخدم موجودًا
      }

      // ✅ 2. إذا كان المستخدم موجودًا، أرسل OTP
      final otpResponse = await Dio().post(
        'http://10.0.2.2:8000/api/send-otps',
        data: {"target_number": phone},
      );

      Get.back(); // أغلق الـ loading بعد إرسال OTP

      if (otpResponse.data['success'] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OtpSendScreen()),
        );
      } else {
        Get.snackbar(
          'خطأ',
          otpResponse.data['message'] ?? 'فشل إرسال رمز التحقق',
          backgroundColor: Colors.red,
        );
      }
    } on DioException catch (e) {
      Get.back();
      Get.snackbar(
        'خطأ',
        e.response?.data['message'] ?? 'حدث خطأ في الاتصال بالخادم',
        backgroundColor: Colors.red,
      );
    } catch (e) {
      Get.back();
      Get.snackbar('خطأ', 'حدث خطأ غير متوقع: $e');
    }
  }

//----------------------------------------- OtpSend_Screen -------------------------------------------

  final TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();

  Timer? _timer;
  final RxInt _remainingSeconds = 10.obs;

  // **** التعديل هنا: دالة otpSend ****
  void otpSend(BuildContext context) {
    if (otpController.text.isEmpty) {
      showErrorMsg(context: context, message: "Enter OTP");
    } else if (_remainingSeconds.value <= 0) {
      showErrorMsg(context: context, message: "OTP Expired, Please Resend OTP");
    } else {
      // مقارنة الـ OTP المدخل بالـ OTP الذي تم استقباله من الـ API
      if (otpController.text == receivedOtp.value.toString()) {
        Get.toNamed("/createNewPassword"); // أو يمكنك استخدام Navigator.push هنا
      } else {
        showErrorMsg(context: context, message: "Incorrect OTP");
      }
    }
  }

  void startTimer() {
    // ✅ إلغاء المؤقت السابق إذا كان نشطًا
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      if (_remainingSeconds.value == 0) {
        timer.cancel();
      } else {
        _remainingSeconds.value--;
      }
    });
  }

  //----------------------------------------- CreateNewPassword_Screen -------------------------------------------

  final GlobalKey<FormState> newPasswordKey = GlobalKey<FormState>();

  RxBool newShowPassword = true.obs;
  RxBool confirmShowPassword = true.obs;

  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  String? confirmPasswordValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "ConfirmPassword is required.";
    } else if (value != newPassword.text) {
      return "Not Match Password";
    } else {
      return null;
    }
  }

  // هذه الدالة تبدو وكأنها خاصة بإنشاء كلمة مرور جديدة بعد التحقق من الـ OTP
  // لم يتم تعديلها لأن التركيز كان على ربط الـ OTP.
  void submit(BuildContext context) {
    final isValid = newPasswordKey.currentState!.validate();
    Get.focusScope!.unfocus();
    if (!isValid) {
      return;
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return CongratulationDialog(
            title: MyString.congratulation,
            subTitle: MyString.congratsDescription,
            buttonName: MyString.homepage,
            shadowColor: Colors.transparent,
            status: false,
            onpressed: () {
              Get.offNamedUntil('/bottomBar', (route) => false);
            },
            onpressed2: () {}, // ربما هذه غير مستخدمة؟
          );
        },
      );
    }
    newPasswordKey.currentState!.save();
  }
}

// نموذج استجابة تسجيل الدخول (LoginResponse) - تحتاج إلى التأكد من أنه موجود في مشروعك
// إذا كان لا يوجد، يمكنك تعريف كلاس بسيط هنا
class LoginResponse {
  final String token;
  final User user; // افترض أن لديك كلاس User
  // أضف أي حقول أخرى تأتي في استجابة تسجيل الدخول

  LoginResponse({required this.token, required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      user: User.fromJson(json['user']), // افترض أن لديك User.fromJson
    );
  }
}

// كلاس User (نموذج مبسط) - تحتاج إلى التأكد من أنه موجود في مشروعك
class User {
  final String id;
  final String name;
  // أضف أي حقول مستخدم أخرى

  User({required this.id, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(), // غالبًا ما يأتي الـ ID كرقم ويجب تحويله لسلسلة
      name: json['name'],
    );
  }
}

// دالة تخزين البيانات (افترض أنها _storeData)
// قد تحتاج إلى إضافة هذه الدالة في متحكمك أو في مكان مناسب
// هذه مجرد نسخة مبسطة، ستحتاج إلى تطبيق منطق تخزين البيانات الفعلي (مثل Shared Preferences)
Future<void> _storeData(String token, User user) async {
  // هنا ستضيف منطق تخزين التوكن وبيانات المستخدم (مثلاً باستخدام shared_preferences)
  print('Storing token: $token');
  print('Storing user: ${user.name}');
  // مثال:
  // final prefs = await SharedPreferences.getInstance();
  // await prefs.setString('token', token);
  // await prefs.setString('user_name', user.name);
}

// المتغيرات العالمية token و user (إذا كانت موجودة خارج المتحكم)
// عادةً، يتم إدارة هذه المتغيرات داخل المتحكم أو خدمة مصادقة
final RxString token = ''.obs;
final Rx<User?> user = Rx<User?>(null);