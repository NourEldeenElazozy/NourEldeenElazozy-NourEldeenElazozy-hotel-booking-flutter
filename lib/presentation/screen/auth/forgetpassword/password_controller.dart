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
      return "Mobile Number is required.";
    } else if (value.length < 9) { // الأرقام الليبية عادة 9 بعد 09
      return "Enter 9 Digit";
    }
    // يمكنك إضافة المزيد من التحقق مثل التأكد من أنها أرقام فقط
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
    Get.focusScope!.unfocus(); // إخفاء لوحة المفاتيح
    if (!isValid) {
      return; // توقف إذا لم تكن المدخلات صحيحة
    }

    // تحويل الرقم: إزالة الصفر الأول وإضافة 218
    String rawPhone = smsController.text;
    String phone;
    // للتأكد من أن الرقم يبدأ بـ '09' ثم تحويله لـ '2189'
    // أو إذا كان يبدأ بـ '9' فقط، أضف '218'
    if (rawPhone.startsWith('09')) {
      phone = '218${rawPhone.substring(1)}'; // إزالة الصفر الأول وإضافة 218
    } else if (rawPhone.startsWith('9')) {
      phone = '218$rawPhone'; // إضافة 218 مباشرة إذا كان يبدأ بـ 9
    } else {
      Get.snackbar('خطأ', 'تنسيق رقم الهاتف غير صحيح. يجب أن يبدأ بـ 09 أو 9.',
          backgroundColor: Colors.red);
      return; // توقف التنفيذ
    }

    // ✅ إظهار لودينق قبل إرسال OTP
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      // 1. إرسال OTP إلى الخادم الخاص بك (الذي يتصل بـ Textly.ly)
      final otpResponse = await Dio().post(
        'http://10.0.2.2:8000/api/send-otps', // تأكد من صحة هذا الرابط
        data: {"target_number": phone},
      );
      String? otpContent = "661266";
      // ✅ إغلاق اللودينق بعد إرسال OTP
      Get.back();

      if (otpContent== "661266") {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const OtpSendScreen()));
        // *********** استخراج الـ OTP من استجابة الخادم ***********
        //String? otpContent = otpResponse.data['response_data']['content'];
        int? extractedOtp;



        if (extractedOtp == null) {
          Get.snackbar('خطأ', 'لم يتم استخراج رمز التحقق من الاستجابة.',
              backgroundColor: Colors.red);
          return;
        }

        // تخزين الـ OTP المستخرج في المتغير RxInt
        receivedOtp.value = extractedOtp;
        print("Received OTP from API: ${receivedOtp.value}"); // للتحقق في Debug Console

        // الانتقال إلى شاشة إدخال OTP
        // لا تستخدم Get.toNamed هنا إذا كنت تستخدم Navigator.push في selectSmsEmailSubmit
        // لأن Navigator.push هو الأنسب عند تمرير 'context'
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const OtpSendScreen()));
      } else {
        // معالجة الأخطاء من استجابة الخادم (إذا كان 'success' false أو حالة HTTP غير 200)
        Get.snackbar(
          'خطأ',
          otpResponse.data['message'] ?? 'فشل إرسال رمز التحقق، تأكد من صحة الرقم',
          backgroundColor: Colors.red,
        );
      }
    } on DioException catch (e) {
      Get.back(); // إغلاق اللودينق في حالة حدوث خطأ من Dio
      print("Dio Error: ${e.response?.data}");
      print("Dio Error message: ${e.message}");
      final errorData = e.response?.data;

      if (errorData != null) {
        if (errorData is Map && errorData['message'] != null) {
          Get.snackbar('خطأ', errorData['message'].toString(),
              backgroundColor: Colors.red);
        } else if (errorData is List) {
          for (var error in errorData) {
            Get.snackbar('خطأ', error.toString(), backgroundColor: Colors.red);
          }
        } else if (errorData is Map && errorData['errors'] != null) {
          (errorData['errors'] as Map).forEach((key, value) {
            if (value is List) {
              for (var msg in value) {
                Get.snackbar('خطأ', msg.toString(), backgroundColor: Colors.red);
              }
            }
          });
        } else {
          Get.snackbar('خطأ', 'حدث خطأ غير معروف من الخادم: $errorData',
              backgroundColor: Colors.red);
        }
      } else {
        Get.snackbar('خطأ', 'حدث خطأ أثناء الاتصال بالخادم، لا توجد بيانات استجابة.',
            backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.back(); // إغلاق اللودينق لأي أخطاء أخرى
      Get.snackbar('خطأ', 'حدث خطأ غير متوقع: ${e.toString()}',
          backgroundColor: Colors.red);
      print("Unexpected Error: $e");
    }
    smsEmailKey.currentState!.save();
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