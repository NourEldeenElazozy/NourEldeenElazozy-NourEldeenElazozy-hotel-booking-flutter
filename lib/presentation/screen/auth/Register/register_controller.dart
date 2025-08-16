part of 'register_import.dart';

class RegisterController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());
  RxString gender ="".obs ;
  RxString birthDate="".obs ;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxBool showPassword = true.obs;

  Rx<FocusNode> emailFocusNode = FocusNode().obs;
  Rx<FocusNode> passwordFocusNode = FocusNode().obs;

  TextEditingController nameController =TextEditingController();
  TextEditingController phoneController =TextEditingController();
  TextEditingController passwordController =TextEditingController();
  TextEditingController testController =TextEditingController();
  TextEditingController cityController=TextEditingController();

  var token = ''.obs;
  var user = User(id: 0, name: '', phone: '',userType: "",gender: "").obs;
  /*
  void submit() {
    final isValid = formKey.currentState!.validate();
    Get.focusScope!.unfocus();
    if (!isValid) {
      return;
    } else {
      Get.toNamed("/fillProfileScreen");
    }
    formKey.currentState!.save();
  }
*/
//------------------------ fill profile -----------------------------

  final GlobalKey<FormState> fillFormKey = GlobalKey<FormState>();

  final TextEditingController nickNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  final otp = ''.obs;
  final generatedOtp = ''.obs;
  String? selectedGender;
  String countryCode = "+93";
  RxList<Map<String, dynamic>> countryCodes = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    _loadCountryCodes();
    super.onInit();
  }


  Future<void> _showOtpDialog(String otp, String rawPhone, String useType, BuildContext context) async {
    final otpController = TextEditingController();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        bool isLoading = false; // حالة تحميل داخل الدايالوج

        return StatefulBuilder(
          builder: (context, setState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                title: const Text(
                  "تأكيد الرمز",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "أدخل رمز التحقق المكون من 6 أرقام المرسل إلى رقمك",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: PinCodeTextField(
                        appContext: context,
                        length: 6,
                        controller: otpController,
                        keyboardType: TextInputType.number,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(8),
                          fieldHeight: 50,
                          fieldWidth: 40,
                          activeFillColor: Colors.white,
                          inactiveFillColor: Colors.white,
                          selectedFillColor: Colors.white,
                        ),
                        animationType: AnimationType.fade,
                        onChanged: (value) {},
                      ),
                    ),
                    if (isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      otpController.dispose();
                      if (Navigator.of(dialogContext).canPop()) {
                        Navigator.of(dialogContext).pop();
                      }
                    },
                    child: const Text("إلغاء"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: isLoading
                        ? null
                        : () async {
                      if (otpController.text == otp) {
                        setState(() => isLoading = true);

                        try {
                          await _completeRegistration(rawPhone, useType);
                          print("11111111111111");
                          otpController.dispose();
                          if (Navigator.of(dialogContext).canPop()) {
                            Navigator.of(dialogContext).pop();
                          }
                          print("222222222222222222222");
                        } catch (e) {
                          _showSafeSnackbar(
                            title: 'خطأ',
                            message: 'حدث خطأ أثناء التسجيل: ${e.toString()}',
                            isError: true,
                          );
                          setState(() => isLoading = false);
                        }
                      } else {
                        _showSafeSnackbar(
                          title: 'خطأ',
                          message: 'رمز التحقق غير صحيح',
                          isError: true,
                        );
                      }
                    },

                    child: const Text("تأكيد", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }




  Future<void> _completeRegistration(String rawPhone, String useType) async {
    try {
      print("333333333333333333");
      final response = await Dio().post(
        'https://esteraha.ly/api/register',
        data: {
          'name': nameController.text,
          'phone': rawPhone,
          'date_of_birth': birthDate.value,
          'city': int.parse(cityController.text),
          'gender': gender.value,
          'user_type': useType,
          'password': passwordController.text,
        },
      );
      print("444444444444444444444");
      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.data);
        token.value = loginResponse.token;
        user.value = loginResponse.user;
        await _storeData(loginResponse.token, loginResponse.user);
        print("555555555555555555");
        Get.offAllNamed("/bottomBar");
        print("66666666666666666");
        _showSafeSnackbar(
          title: 'نجاح',
          message: 'تم التسجيل بنجاح!',
          isError: false,
        );
      } else {
        throw Exception('فشل في التسجيل: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('حدث خطأ أثناء التسجيل: ${e.toString()}');
    }
  }


  Future<void> _showLoadingDialog() async {
    if (!(Get.isDialogOpen ?? false)) {
      await Get.dialog(
        const PopScope(
          canPop: false,
          child: Center(child: CircularProgressIndicator()),
        ),
        barrierDismissible: false,
      );
    }
  }

  void _hideLoadingDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();  // فك التعليق هنا لإغلاق اللودنج
    }
  }
  void _showSafeSnackbar({
    required String title,
    required String message,
    bool isError = false,
  }) {
    if (Get.isSnackbarOpen) {
      //Get.back(); // إغلاق أي snackbar مفتوح حالياً
    }

    Get.snackbar(
      title,
      message,
      backgroundColor: isError ? Colors.red : Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  Future<void> submit(String useType, BuildContext context) async {
    try {
      print(nameController.text);
      print(phoneController.text);
      print(birthDate.value);
      print(gender.value);
      print(useType);

      String rawPhone = phoneController.text;
      String phone;
      if (rawPhone.startsWith('09')) {
        phone = '218${rawPhone.substring(1)}';
      } else if (rawPhone.startsWith('9')) {
        phone = '218$rawPhone';
      } else {
        Get.snackbar('خطأ', 'تنسيق رقم الهاتف غير صحيح. يجب أن يبدأ بـ 09 أو 9.', backgroundColor: Colors.red);
        return;
      }
      // 1. تحقق أولاً من وجود الرقم مسبقاً
      final checkResponse = await Dio().post(
        'https://esteraha.ly/api/check-user-exists',
        data: {'phone': rawPhone},
      );

      if (checkResponse.statusCode == 200 && checkResponse.data['exists'] == true) {
        Get.snackbar('خطأ', 'رقم الهاتف مسجل مسبقاً، يرجى تسجيل الدخول أو استخدام رقم آخر.', backgroundColor: Colors.red
        ,
        );
        return; // توقف هنا لأن الرقم مسجل
      }

      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

      final otpResponse = await Dio().post(
        'https://esteraha.ly/api/send-otp',
        data: {"target_number": phone},
      );

      Get.back();

      Map<String, dynamic> parsedData;
      if (otpResponse.data is String) {
        try {
          parsedData = jsonDecode(otpResponse.data);
        } catch (e) {
          Get.snackbar('خطأ', 'استجابة غير صالحة من الخادم (تنسيق JSON خاطئ)', backgroundColor: Colors.red);
          print('JSON Decode Error: $e');
          return;
        }
      } else if (otpResponse.data is Map<String, dynamic>) {
        parsedData = otpResponse.data;
      } else {
        Get.snackbar('خطأ', 'نوع استجابة غير متوقع من الخادم', backgroundColor: Colors.red);
        return;
      }

      if (parsedData['status'] == 'success') {
        final content = parsedData['content'];
        final otpMatch = RegExp(r'\d{6}').firstMatch(content ?? '');

        if (otpMatch == null) {
          Get.snackbar('خطأ', 'تعذر استخراج رمز التحقق', backgroundColor: Colors.red);
          return;
        }

        final otp = otpMatch.group(0)!;

        // تمرير كل بيانات التسجيل إلى صفحة OTP
        Get.to(() => OtpVerificationPage(
          otp: otp,
          rawPhone: rawPhone,
          useType: useType,
          name: nameController.text,
          dateOfBirth: birthDate.value,
          city: int.parse(cityController.text),
          gender: gender.value,
          password: passwordController.text,
        ));
      } else {
        Get.snackbar('خطأ', parsedData['message'] ?? 'فشل إرسال رمز التحقق', backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.back();
      Get.snackbar('خطأ', 'حدث خطأ غير متوقع: ${e.toString()}', backgroundColor: Colors.red);
    }
  }



  Future<void> sendOtp(String phoneNumber) async {
    try {
      String phone = phoneNumber.startsWith('09')
          ? '218${phoneNumber.substring(1)}'
          : phoneNumber.startsWith('9')
          ? '218$phoneNumber'
          : phoneNumber;

      final response = await Dio().post(
        'https://esteraha.ly/api/send-otp',
        data: {"target_number": phone},
      );

      Map<String, dynamic> parsedData;
      if (response.data is String) {
        try {
          parsedData = jsonDecode(response.data);
        } catch (e) {
          Get.snackbar('خطأ', 'استجابة غير صالحة من الخادم (تنسيق JSON خاطئ)', backgroundColor: Colors.red);
          return;
        }
      } else if (response.data is Map<String, dynamic>) {
        parsedData = response.data;
      } else {
        Get.snackbar('خطأ', 'نوع استجابة غير متوقع من الخادم', backgroundColor: Colors.red);
        return;
      }

      if (parsedData['status'] == 'success') {
        final content = parsedData['content'];
        final otpMatch = RegExp(r'\d{6}').firstMatch(content ?? '');
        if (otpMatch != null) {
          generatedOtp.value = otpMatch.group(0)!;
          // يمكنك الآن استخدام generatedOtp في أي مكان آخر
        } else {
          Get.snackbar('خطأ', 'تعذر استخراج رمز التحقق من الرسالة', backgroundColor: Colors.red);
        }
      } else {
        Get.snackbar('خطأ', parsedData['message'] ?? 'فشل إرسال رمز التحقق', backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء إرسال رمز التحقق: ${e.toString()}', backgroundColor: Colors.red);
    }
  }




  void createAccount() {

    Get.snackbar("نجاح", "تم إنشاء الحساب بنجاح");
  }



  void completeRegistration() {
    Get.snackbar('نجاح', 'تم تأكيد الرقم بنجاح وإنشاء الحساب');

  }


  Future<void> _loadCountryCodes() async {
    String data = await rootBundle.loadString('assets/data/countryPicker.json');
    countryCodes.value = List<Map<String, dynamic>>.from(json.decode(data));
    countryCodes.value = countryCodes.toSet().toList();
  }

  DateTime selectedDate = DateTime.now();
  Dio dio = Dio(BaseOptions(
    baseUrl: 'https://esteraha.ly/api/',
    headers: {
      'Accept': 'application/json',
    },
  ));
  RxBool isLoading = false.obs;
  Future<void> fillProfileSubmit({required String status}) async {
    final isValid = fillFormKey.currentState?.validate() ?? false;
    Get.focusScope?.unfocus();

    if (!isValid) {
      return; // لا تتابع إذا كانت البيانات غير صالحة
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      isLoading.value = true;
      if (token.isEmpty) {
        Get.snackbar('خطأ', 'التوكن غير موجود، يرجى تسجيل الدخول');
        return;
      }
      print("Select Gender ${selectedGender.toString()}");
      final Map<String, dynamic> data = {
        'name': nameController.text,
        'phone': phoneController.text,
        'mobile': mobileNumberController.text,
        'gender': selectedGender.toString(),
      };
      if (passwordController.text.isNotEmpty) {
        data['password'] = passwordController.text;
        data['password_confirmation'] = passwordController.text;
      }

      // إرسال البيانات إلى API تحديث الملف الشخصي
      final response = await dio.post(
        '/update-user',
        data: data,

        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),

      );

      isLoading.value = false; // انتهاء التحميل

      if (response.statusCode == 200) {
        // حفظ البيانات في SharedPreferences فقط بعد نجاح التحديث
        await prefs.setString('userName', nameController.text);
        await prefs.setString('userName', nameController.text);
        await prefs.setString('userPhone', phoneController.text);
        await prefs.setString('userMobile', mobileNumberController.text);
        await prefs.setString('gender',    gender.value.toString());

        print(" response.statusCode ${response.data}");


        if (status == 'update') {
          Get.back();
          Get.snackbar('نجاح', 'تم تحديث الملف الشخصي بنجاح');
        } else {
          Get.offNamedUntil("/bottomBar", (route) => false);
        }
      } else {
        Get.snackbar('خطأ', 'فشل تحديث الملف الشخصي: ${response.statusMessage}');
      }
    } catch (e) {
      isLoading.value = false;
      print("${e.toString()}");
      Get.snackbar('خطأ', 'حدث خطأ أثناء تحديث الملف الشخصي: ',backgroundColor: Colors.red);
    }
  }
}


Future<void> _storeData(String token, User user) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
  await prefs.setInt('userId', user.id);
  await prefs.setString('userName', user.name);
  await prefs.setString('userPhone', user.phone);
  await prefs.setString('user_type', user.userType);
  await prefs.setString('gender', user.gender);
  await prefs.setInt('user_id', user.id);
}
