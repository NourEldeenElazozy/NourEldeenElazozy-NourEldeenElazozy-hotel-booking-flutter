part of 'password_import.dart';

class PasswordController extends GetxController {
  ThemeController themeController = Get.put(ThemeController());

  final GlobalKey<FormState> smsEmailKey = GlobalKey<FormState>();

  final TextEditingController smsController = TextEditingController();

  // هذا المتغير سيخزن الـ OTP الذي تم استقباله من الـ API
  // يجب أن يكون من نوع RxInt لكي يتم تحديث الواجهة إذا استخدمته في Obx
  RxString receivedOtp = "".obs; // القيمة الافتراضية 0 أو أي قيمة مناسبة
  @override
  void onInit() {
    super.onInit();
    startTimer();
    // يمكنك تهيئة المؤقت هنا بقيمة أولية إذا كنت ترغب في ذلك
    // لكن الأفضل هو تهيئته عند الحاجة في startTimer
  }
  @override
  void dispose() {
    // هذا السطر مهم لضمان إلغاء المؤقت عند إغلاق الشاشة
    // لكي لا يظل يعمل في الخلفية ويستهلك موارد
  _timer?.cancel();
    super.dispose();
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
      // ✅ التغيير هنا: استخدام Get.off()
      // هذا يزيل الشاشة الحالية (SelectSmsEmailScreen) من المكدس
      // قبل دفع OtpSendScreen، مما يضمن وجود نسخة واحدة فقط من OtpSendScreen
      // في شجرة الـ widgets في أي وقت.
      Get.off(() => const OtpSendScreen());
      // ✅ 2. إذا كان المستخدم موجودًا، أرسل OTP
      final otpResponse = await Dio().post(
        'http://10.0.2.2:8000/api/send-otp',
        data: {"target_number": phone},
      );

      Get.back(); // أغلق الـ loading بعد إرسال OTP

      if (otpResponse.data['success'] == true) {
        print("receivedOtp.values ${otpResponse.data['otp']}");
        receivedOtp.value=otpResponse.data['otp'].toString();

        // ✅ التغيير هنا: استخدام Get.off()
        // هذا يزيل الشاشة الحالية (SelectSmsEmailScreen) من المكدس
        // قبل دفع OtpSendScreen، مما يضمن وجود نسخة واحدة فقط من OtpSendScreen
        // في شجرة الـ widgets في أي وقت.
        Get.off(() => const OtpSendScreen());
      } else {
        Get.snackbar(
          'خطأ',
          otpResponse.data['message'] ?? 'فشل إرسال رمز التحقق',
          backgroundColor: Colors.red,
        );
      }
    } on DioException catch (e) {
      Get.back();
      print("errs ${ e.response?.data}");
      print("phone ${ phone}");

      Get.snackbar(
        'خطأ',
        e.response?.data['message'] ?? 'حدث خطأ في الاتصال بالخادم',
        backgroundColor: Colors.red,
        colorText: Colors.white,

      );
    } catch (e) {
      Get.back();
      print( 'حدث خطأ غير متوقع: $e');
      Get.snackbar('خطأ', 'حدث خطأ غير متوقع: $e');
    }
  }

//----------------------------------------- OtpSend_Screen -------------------------------------------

  final TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();

  Timer? _timer;
  final RxInt _remainingSeconds = 120.obs;

  // **** التعديل هنا: دالة otpSend ****
  void otpSend(BuildContext context) {
    if (otpController.text.isEmpty) {
      showErrorMsg(context: context, message: " ادخل رمز التأكيد ");
    } else if (_remainingSeconds.value <= 0) {
      showErrorMsg(context: context, message: "انتهت مهلة الرمز , قم بإعادة طلب الرمز");
    } else {
      // مقارنة الـ OTP المدخل بالـ OTP الذي تم استقباله من الـ API
      if (otpController.text == receivedOtp.value.toString()) {

        Get.toNamed("/createNewPassword"); // أو يمكنك استخدام Navigator.push هنا
      } else {
        print("otpController.text ${otpController.text}");
        print("receivedOtp.value ${receivedOtp.value}");
        showErrorMsg(context: context, message: "خطاء في رمز التأكيد");
      }
    }
  }

  void startTimer() {
    print("startTimer");
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
      return "تأكيد الرقم السري مطوب";
    } else if (value != newPassword.text) {
      return "كلمة السر غير صحيحة";
    } else {
      return null;
    }
  }

  // هذه الدالة تبدو وكأنها خاصة بإنشاء كلمة مرور جديدة بعد التحقق من الـ OTP
  // لم يتم تعديلها لأن التركيز كان على ربط الـ OTP.
  // دالة submit لتغيير كلمة المرور
  void submit(BuildContext context) async { // ✅ جعل الدالة async
    final isValid = newPasswordKey.currentState!.validate();
    Get.focusScope!.unfocus(); // إخفاء لوحة المفاتيح
    if (!isValid) {
      return; // توقف إذا لم تكن المدخلات صحيحة
    }

    // ✅ عرض مؤشر التحميل
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      // ✅ جلب رقم الهاتف من smsController (يجب أن يكون قد تم إدخاله في الشاشة الأولى)
      String phoneNumber = smsController.text;

      // تحويل رقم الهاتف ليتوافق مع API (إذا لزم الأمر)
      // بناءً على منطقك السابق:
      // if (phoneNumber.startsWith('09')) {
      //   phoneNumber = '218${phoneNumber.substring(1)}';
      // } else if (phoneNumber.startsWith('9')) {
      //   phoneNumber = '218$phoneNumber';
      // }

      // ✅ إرسال طلب تغيير كلمة المرور إلى الخادم
      final response = await Dio().post(
        'http://10.0.2.2:8000/api/change-password', // ✅ نقطة نهاية الـ API لتغيير كلمة المرور
        data: {
          "phone": phoneNumber, // رقم الهاتف
          "new_password": newPassword.text, // كلمة المرور الجديدة
          "new_password_confirmation": confirmPassword.text, // تأكيد كلمة المرور
        },
      );

      Get.back(); // إغلاق مؤشر التحميل

      print(phoneNumber);
      if (response.statusCode == 200) {
        // ✅ نجاح تغيير كلمة المرور
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
                // ✅ الانتقال إلى الشاشة الرئيسية بعد النجاح
                Get.offNamedUntil('/loginScreen', (route) => false);

              },
              onpressed2: () {}, // ربما هذه غير مستخدمة؟
            );
          },
        );
      } else {
        // ✅ التعامل مع حالة النجاح ولكن رسالة خطأ (نادراً ما تحدث مع 200 OK)
        Get.snackbar(
          'خطأ',
          response.data['message'] ?? 'حدث خطأ غير معروف عند تغيير كلمة المرور.',
          backgroundColor: Colors.red,
        );
      }
    } on DioException catch (e) {
      Get.back(); // إغلاق مؤشر التحميل
      print("Dio Error: ${e.response?.data}");
      print("Dio Error message: ${e.message}");

      String errorMessage = 'حدث خطأ أثناء تغيير كلمة المرور.';

      if (e.response != null) {
        if (e.response!.data is Map && e.response!.data.containsKey('message')) {
          errorMessage = e.response!.data['message'];
        } else if (e.response!.data is String) {
          errorMessage = e.response!.data;
        } else if (e.response!.data is Map && e.response!.data.containsKey('errors')) {
          // التعامل مع أخطاء التحقق (validation errors) من Laravel
          Map<String, dynamic> errors = e.response!.data['errors'];
          List<String> errorMessages = [];
          errors.forEach((key, value) {
            if (value is List) {
              errorMessages.addAll(value.map((e) => e.toString()));
            }
          });
          if (errorMessages.isNotEmpty) {
            errorMessage = errorMessages.join('\n');
          }
        }
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'لا يوجد اتصال بالإنترنت. يرجى التحقق من اتصالك.';
      }

      Get.snackbar(
        'خطأ',
        errorMessage,
        backgroundColor: Colors.red,
      );
    } catch (e) {
      Get.back(); // إغلاق مؤشر التحميل
      Get.snackbar('خطأ', 'حدث خطأ غير متوقع: ${e.toString()}',
          backgroundColor: Colors.red);
      print("Unexpected Error: $e");
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