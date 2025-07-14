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
  var user = User(id: 0, name: '', phone: '',userType: "").obs;
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

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) {
            TextEditingController otpController = TextEditingController();
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Text("أدخل رمز التحقق المرسل إلى رقمك", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
                    const SizedBox(height: 10),
                    TextField(
                      controller: otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'رمز التحقق'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (otpController.text == otp) {
                          Navigator.pop(context);
                          Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

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
                            options: Options(validateStatus: (status) => status! < 500),
                          );

                          Get.back();

                          if (response.statusCode == 200) {
                            final loginResponse = LoginResponse.fromJson(response.data);
                            token.value = loginResponse.token;
                            user.value = loginResponse.user;
                            await _storeData(loginResponse.token, loginResponse.user);
                            Get.snackbar('نجاح', 'تم تسجيل المستخدم بنجاح!', backgroundColor: Colors.green);
                            Get.offNamedUntil("/bottomBar", (route) => false);
                          } else {
                            Get.snackbar('خطأ', 'فشل في التسجيل: ${response.statusCode}', backgroundColor: Colors.red);
                          }
                        } else {
                          Get.snackbar('خطأ', 'رمز التحقق غير صحيح', backgroundColor: Colors.red);
                        }
                      },
                      child: const Center(child: Text("تأكيد")),
                    ),
                  ],
                ),
              ),
            );
          },
        );
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

/*
 void showOtpBottomSheet(String phoneNumber) {
    Get.bottomSheet(
      Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "أدخل رمز التحقق المرسل إلى رقمك",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                onChanged: (value) => otp.value = value,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: InputDecoration(
                  labelText: "رمز التحقق",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  counterText: "",
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    if (otp.value == generatedOtp.value) {
                      Get.back(); // إغلاق البوتوم شيت
                      createAccount(); // إنشاء الحساب
                    } else {
                      Get.snackbar("خطأ", "رمز التحقق غير صحيح",backgroundColor: Colors.red);
                    }
                  },
                  child: const Text(
                    "تأكيد",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
 */


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

  void fillProfileSubmit({required status}) {
    final isValid = fillFormKey.currentState!.validate();

    Get.focusScope!.unfocus();
    if (!isValid) {
    } else {
      status == 'update' ? Get.back() : Get.offNamedUntil("/bottomBar", (route) => false);
    }
    fillFormKey.currentState!.save();
  }
}

Future<void> _storeData(String token, User user) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
  await prefs.setInt('userId', user.id);
  await prefs.setString('userName', user.name);
  await prefs.setString('userPhone', user.phone);
  await prefs.setString('user_type', user.userType);
  await prefs.setInt('user_id', user.id);
}