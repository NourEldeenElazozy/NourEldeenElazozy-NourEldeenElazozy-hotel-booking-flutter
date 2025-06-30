part of 'login_import.dart';

class LoginController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxBool password = true.obs;

  TextEditingController phoneController =TextEditingController();
  TextEditingController passwordController =TextEditingController();
  var isLoading = false.obs;
  var token = ''.obs;
  var user = User(id: 0, name: '', phone: '',userType: "").obs;

  Future<String?> getDeviceToken() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      print('Failed to get device token: $e');
      return null;
    }
  }
  Future<void> login(String phone, String password) async {
    isLoading.value = true;
    try {
      final response = await Dio().post(
        'http://10.0.2.2:8000/api/login',
        data: {
          'phone': phone,
          'password': password,
        },
      );

      if (response.statusCode == 200) {

        LoginResponse loginResponse = LoginResponse.fromJson(response.data);
        String ttoken = response.data['token'];

// طباعة طول التوكن
        print("طول التوكن: ${ttoken.length}");

// تقسيم وطباعة التوكن إلى أجزاء
        for (int i = 0; i < ttoken.length; i += 1000) {
          print(ttoken.substring(i, i + 1000 > ttoken.length ? ttoken.length : i + 1000));
        };
        debugPrint("ttoken: ${response.data['token']}");
        token.value = loginResponse.token;
        user.value = loginResponse.user;
        await _storeData(loginResponse.token, loginResponse.user);
        // جلب device token
        String? deviceToken = await getDeviceToken();
        if (deviceToken != null) {
          print("deviceToken: ${deviceToken.toString()}");


        await Dio().post(
          'http://10.0.2.2:8000/api/update-device-token',
          data: {
            'device_token': deviceToken,
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer ${loginResponse.token}',
            },
          ),
        );
        } else {
          print('Error: ${response.statusCode}');
        }
        // يمكنك تخزين التوكن أو أي معلومات أخرى هنا
      } else {
        // التعامل مع الأخطاء
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
  void submit() {
    final isValid = formKey.currentState!.validate();
    Get.focusScope!.unfocus();

    if (!isValid) {
      return;
    } else {
      // استدعاء دالة تسجيل الدخول
      login(phoneController.text, passwordController.text).then((response) {
        // تحقق من نجاح تسجيل الدخول
        if (token.isNotEmpty) {
          // إذا كانت البيانات صحيحة، انتقل إلى الصفحة التالية
          Get.offNamedUntil("/bottomBar", (route) => false);
        } else {
          // إذا كانت البيانات غير صحيحة، يمكنك عرض رسالة خطأ
          Get.snackbar('خطأ', 'فشل في تسجيل الدخول. تحقق من بياناتك.',backgroundColor: Colors.red);
        }
      }).catchError((error) {
        // التعامل مع الأخطاء أثناء الاتصال بالخادم
        Get.snackbar('خطأ', 'حدث خطأ أثناء محاولة تسجيل الدخول.');
      });
    }

    formKey.currentState!.save();
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
}