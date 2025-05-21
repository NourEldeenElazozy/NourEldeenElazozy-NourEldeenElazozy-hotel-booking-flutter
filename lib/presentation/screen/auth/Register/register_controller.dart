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

      // تحويل الرقم: إزالة الصفر الأول وإضافة 218
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

      // ✅ إظهار لودينق قبل إرسال OTP
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // 1. إرسال OTP
      final otpResponse = await Dio().post(
        'http://10.0.2.2:8000/api/send-otp',
        data: {"target_number": phone},
      );

      // ✅ إغلاق اللودينق بعد إرسال OTP
      Get.back();

      if (otpResponse.statusCode == 200 && otpResponse.data['success'] == true) {
        String? otpContent = otpResponse.data['response_data']['content'];
        int? otp;

        if (otpContent != null) {
          RegExp regExp = RegExp(r'\d+$');
          Iterable<RegExpMatch> matches = regExp.allMatches(otpContent);
          if (matches.isNotEmpty) {
            otp = int.tryParse(matches.first.group(0)!);
          }
        }

        if (otp == null) {
          Get.snackbar('خطأ', 'لم يتم استخراج رمز التحقق من الاستجابة.', backgroundColor: Colors.red);
          return;
        }

        print("Received OTP: $otp");

        // *********** التغييرات هنا لحل مشكلة لوحة المفاتيح ***********
        showModalBottomSheet(
          context: context,
          isScrollControlled: true, // مهم: يجعل الـ BottomSheet يأخذ كامل الارتفاع المتاح
          builder: (_) {
            TextEditingController otpController = TextEditingController();

            return Directionality(
              textDirection: TextDirection.rtl,
              // استخدام MediaQuery.of(context).viewInsets.bottom لتعديل الحشوة
              // بحيث ترتفع الـ BottomSheet مع لوحة المفاتيح
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                  // هذه هي الحشوة التي سترفع الـ BottomSheet عند ظهور لوحة المفاتيح
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // يجعل العمود يأخذ أقل مساحة ممكنة
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
                    const SizedBox(height: 10),
                    TextField(
                      controller: otpController,
                      keyboardType: TextInputType.number,
                      maxLength: otp.toString().length,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'رمز التحقق',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (otpController.text == otp.toString()) {
                          Navigator.pop(context);

                          Get.dialog(
                            const Center(child: CircularProgressIndicator()),
                            barrierDismissible: false,
                          );

                          final response = await Dio().post(
                            'http://10.0.2.2:8000/api/register',
                            data: {
                              'name': nameController.text,
                              'phone': rawPhone,
                              'date_of_birth': birthDate.value,
                              'city': int.parse(cityController.text),
                              'gender': gender.value,
                              'user_type': useType,
                              'password': passwordController.text,
                            },
                            options: Options(
                              validateStatus: (status) => status! < 500,
                            ),
                          );

                          Get.back();

                          if (response.statusCode == 200) {
                            LoginResponse loginResponse = LoginResponse.fromJson(response.data);
                            token.value = loginResponse.token;
                            user.value = loginResponse.user;
                            await _storeData(loginResponse.token, loginResponse.user);
                            Get.snackbar('نجاح', 'تم تسجيل المستخدم بنجاح!', backgroundColor: Colors.green);
                            if (token.isNotEmpty) {
                              Get.offNamedUntil("/bottomBar", (route) => false);
                            }
                          } else if (response.statusCode == 422) {
                            final errorData = response.data;
                            if (errorData is List) {
                              for (var msg in errorData) {
                                Get.snackbar('خطأ', msg.toString(), backgroundColor: Colors.red,colorText: Colors.white);
                              }
                            } else if (errorData is Map && errorData['errors'] != null) {
                              (errorData['errors'] as Map).forEach((key, value) {
                                if (value is List) {
                                  for (var msg in value) {
                                    Get.snackbar('خطأ', msg.toString(), backgroundColor: Colors.red,colorText: Colors.white);
                                  }
                                }
                              });
                            } else {
                              Get.snackbar('خطأ', 'فشل في التسجيل: ${response.statusCode}', backgroundColor: Colors.red,colorText: Colors.white);
                            }
                          } else {
                            Get.snackbar('خطأ', 'فشل في التسجيل: ${response.statusCode}', backgroundColor: Colors.red,colorText: Colors.white);
                          }
                        } else {
                          Get.snackbar('خطأ', 'رمز التحقق غير صحيح', backgroundColor: Colors.red,colorText: Colors.white);
                        }
                      },
                      child: Center(child: const Text("تأكيد")),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        Get.snackbar(
          'خطأ',
          otpResponse.data['message'] ?? 'فشل إرسال رمز التحقق، تأكد من صحة الرقم',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      Get.back();

      if (e is DioException) {
        print("Dio Error: ${e.response?.data}");
        print("Dio Error message: ${e.message}");
        final errorData = e.response?.data;

        if (errorData != null) {
          if (errorData is Map && errorData['message'] != null) {
            Get.snackbar('خطأ', errorData['message'].toString(), backgroundColor: Colors.red);
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
            Get.snackbar('خطأ', 'حدث خطأ غير معروف من الخادم: $errorData', backgroundColor: Colors.red);
          }
        } else {
          Get.snackbar('خطأ', 'حدث خطأ أثناء الاتصال بالخادم، لا توجد بيانات استجابة.', backgroundColor: Colors.red);
        }
      } else {
        Get.snackbar('خطأ', 'حدث خطأ غير متوقع: ${e.toString()}', backgroundColor: Colors.red);
      }
    }
  }

  Future<void> sendOtp(String phoneNumber) async {
    try {
      // حذف الصفر الأول وإضافة 218
      String normalizedPhone = phoneNumber.startsWith('0')
          ? '218${phoneNumber.substring(1)}'
          : phoneNumber;
      final response = await Dio().post(
        'http://10.0.2.2:8000//api/send-otp',
        data: {
          "phonenumber": normalizedPhone,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        generatedOtp.value = response.data['otp'].toString(); // خزن OTP للمقارنة لاحقاً
        //showOtpBottomSheet(phoneNumber);
      } else {
        Get.snackbar('خطأ', 'فشل في إرسال رمز التحقق');
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء إرسال رمز التحقق');
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