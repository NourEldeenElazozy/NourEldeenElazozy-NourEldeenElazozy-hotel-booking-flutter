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

  String? selectedGender;
  String countryCode = "+93";
  RxList<Map<String, dynamic>> countryCodes = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    _loadCountryCodes();
    super.onInit();
  }
  Future<void> submit(String useType) async {
    try {
      final response = await Dio().post(
        'http://10.0.2.2:8000/api/register', // تعديل الرابط حسب الحاجة
        data: {
          'name': nameController.text,
          'phone': phoneController.text,
          'date_of_birth': birthDate.value,
          'city': int.parse(cityController.text),
          'gender': gender.value,
          'user_type': useType, // أو 'host' حسب الحاجة
          'password': passwordController.text, // تأكد من استخدام القيمة المناسبة
        },
      );





      if (response.statusCode == 200) {
        LoginResponse loginResponse = LoginResponse.fromJson(response.data);
        token.value = loginResponse.token;
        user.value = loginResponse.user;
        await _storeData(loginResponse.token, loginResponse.user);
        // التعامل مع الاستجابة الناجحة
        Get.snackbar('نجاح', 'تم تسجيل المستخدم بنجاح!',backgroundColor: Colors.green);
        if (token.isNotEmpty) {
          // إذا كانت البيانات صحيحة، انتقل إلى الصفحة التالية
          Get.offNamedUntil("/bottomBar", (route) => false);
        }
      } else {
        // إذا كانت الاستجابة غير ناجحة
        Get.snackbar('خطأ', 'فشل في التسجيل: ${response.statusCode}');
      }
    } catch (e) {
      // تحويل الخريطة إلى JSON
      Map<String, dynamic> userData = {
        'name': nameController.text,
        'phone': phoneController.text,
        'date_of_birth': birthDate.value,
        'city': int.parse(cityController.text),
        'gender': gender.value,
        'user_type': useType, // أو 'host' حسب الحاجة
        'password': passwordController.text, // تأكد من استخدام القيمة المناسبة
      };
      String jsonData = jsonEncode(userData);

      // طباعة البيانات بصيغة JSON
      print(jsonData);
      // التعامل مع الأخطاء
      if (e is DioError) {
        // إذا كان الخطأ مرتبطًا بـ Dio
       print( 'حدث خطأ أثناء التسجيل: ${e.message}');
        print('DioError: ${e.response?.data}');
        Get.snackbar('خطأ', 'حدث خطأ أثناء التسجيل: ${e.message}');
      } else {
        // أخطاء أخرى
        print('Error: $e');
        Get.snackbar('خطأ', 'حدث خطأ غير متوقع.');
      }
    }
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
}