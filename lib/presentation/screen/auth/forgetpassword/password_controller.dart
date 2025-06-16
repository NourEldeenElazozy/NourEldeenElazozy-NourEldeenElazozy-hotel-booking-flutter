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
    // يجب أن تبدأ المؤقت هنا فقط إذا كنت تريد أن يبدأ بمجرد تهيئة المتحكم
    // وإلا، ابدأه في الدالة التي تستدعي إرسال الـ OTP
    // startTimer();
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
      // 🔹 تحقق من وجود المستخدم
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
        return;
      }

      // ✅ 2. إرسال OTP إذا كان المستخدم موجودًا
      final otpResponse = await Dio().post(
        'http://10.0.2.2:8000/api/send-otp',
        data: {"target_number": phone},
      );

      Get.back(); // أغلق الـ loading بعد إرسال OTP

      // 🔴🔴🔴 التعديل هنا: معالجة البيانات المستلمة 🔴🔴🔴
      Map<String, dynamic> parsedData;
      if (otpResponse.data is String) {
        // إذا كانت البيانات نصية، حاول تحليلها كـ JSON
        try {
          parsedData = jsonDecode(otpResponse.data);
        } catch (e) {
          // إذا فشل التحليل، اعتبرها استجابة غير صالحة
          Get.snackbar(
            'خطأ',
            'استجابة غير صالحة من الخادم (تنسيق JSON خاطئ)',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          print('JSON Decoding Error: $e');
          return;
        }
      } else if (otpResponse.data is Map<String, dynamic>) {
        // إذا كانت البيانات بالفعل Map، استخدمها مباشرة
        parsedData = otpResponse.data;
      } else {
        // أي نوع آخر غير متوقع
        Get.snackbar(
          'خطأ',
          'استجابة غير متوقعة من الخادم (نوع بيانات غير مدعوم)',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print('Unexpected otpResponse.data type: ${otpResponse.data.runtimeType}');
        return;
      }

      // 🔴🔴🔴 استخدام parsedData بدلاً من otpResponse.data مباشرة 🔴🔴🔴
      print('--- OTP Response Debug ---');
      print('parsedData runtimeType: ${parsedData.runtimeType}');
      print('parsedData full content: $parsedData');
      print('parsedData[\'status\']: ${parsedData['status']}');
      print('--- End OTP Response Debug ---');


      if (parsedData['status'] == 'success') {
        final content = parsedData['content'];
        // regex لاستخراج 6 أرقام متتالية
        final otpMatch = RegExp(r'\d{6}').firstMatch(content);

        if (otpMatch != null) {
          receivedOtp.value = otpMatch.group(0)!;
          // ابدأ المؤقت هنا بعد نجاح إرسال الـ OTP
          startTimer();
          Get.off(() => const OtpSendScreen());
        } else {
          Get.snackbar(
            'خطأ',
            'تعذر استخراج رمز التحقق من الرسالة',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        // إذا كان الـ 'status' ليس 'success'
        Get.snackbar(
          'خطأ',
          parsedData['message'] ?? 'فشل إرسال رمز التحقق (حالة غير ناجحة)', // تم تعديل الرسالة
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } on DioException catch (e) {
      Get.back(); // إغلاق التحميل عند حدوث خطأ
      print("Dio Error: ${e.response?.data}");
      print("Phone: $phone");

      String errorMessage = 'حدث خطأ في الاتصال بالخادم';
      final dynamic errorData = e.response?.data;

      if (errorData != null) {
        if (errorData is Map<String, dynamic> && errorData.containsKey('message') && errorData['message'] is String) {
          errorMessage = errorData['message'];
        } else if (errorData is String) {
          errorMessage = errorData;
        } else if (errorData is List && errorData.isNotEmpty) {
          final first = errorData[0];
          if (first is String) {
            errorMessage = first;
          } else if (first is Map<String, dynamic> && first.containsKey('message') && first['message'] is String) {
            errorMessage = first['message'];
          } else {
            errorMessage = 'خطأ من الخادم: تنسيق رسالة غير معروف في القائمة.';
          }
        } else {
          errorMessage = 'استجابة خطأ غير متوقعة من الخادم: ${errorData.toString()}';
        }
      }

      Get.snackbar(
        'خطأ',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.back(); // إغلاق التحميل عند أي خطأ غير متوقع
      print('حدث خطأ غير متوقع: $e');
      Get.snackbar('خطأ', 'حدث خطأ غير متوقع: ${e.toString()}',
          backgroundColor: Colors.red, colorText: Colors.white);
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
