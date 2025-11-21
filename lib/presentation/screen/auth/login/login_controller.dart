part of 'login_import.dart';

class LoginController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxBool password = true.obs;

  TextEditingController phoneController =TextEditingController();
  TextEditingController passwordController =TextEditingController();
  var isLoading = false.obs;
  var token = ''.obs;
  var user = User(id: 0, name: '', phone: '',userType: "",gender: "").obs;


  Future<void> login(String phone, String password) async {
    isLoading.value = true;
    try {
      final response = await Dio().post(
        'https://esteraha.ly/api/login',
        data: {
          'phone': phone,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        print('response.data: ${response.data}');
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
        String? deviceToken = "";
        if (deviceToken != null && deviceToken.isNotEmpty) {
          print("deviceToken: ${deviceToken.toString()}");


        await Dio().put(
          'https://esteraha.ly/api/update-device-token',
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
          print("⚠️ لم يتم جلب deviceToken");
        }
        // يمكنك تخزين التوكن أو أي معلومات أخرى هنا
      } else {
        // التعامل مع الأخطاء

        print('Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final data = e.response?.data;

      if (status == 403) {
        // 🔴 حساب موقوف أو محذوف
        final message = data['message'] ?? "هذا الحساب غير مسموح له بالدخول.";
        Get.snackbar(
          'ممنوع',
          message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else if (status == 401) {
        // 🔑 بيانات غير صحيحة
        Get.snackbar(
          'خطأ',
          'اسم المستخدم أو كلمة المرور غير صحيحة.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        // أي خطأ آخر
        final message = data['message'] ?? "حدث خطأ أثناء محاولة تسجيل الدخول.";
        Get.snackbar(
          'خطأ',
          message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'تعذر الاتصال بالخادم',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }  }

    void submit() {
    final isValid = formKey.currentState!.validate();
    Get.focusScope!.unfocus();

    if (!isValid) {
      isLoading.value = false; // ← إظهار التحميل
    } else {
      // استدعاء دالة تسجيل الدخول
      login(phoneController.text, passwordController.text).then((response) {
        isLoading.value = false; // ← إخفاء التحميل
        // تحقق من نجاح تسجيل الدخول
        if (token.isNotEmpty) {
          // إذا كانت البيانات صحيحة، انتقل إلى الصفحة التالية
          Get.offNamedUntil("/bottomBar", (route) => false);
        } else {
          // إذا كانت البيانات غير صحيحة، يمكنك عرض رسالة خطأ
         // Get.snackbar('خطأ', 'فشل في تسجيل الدخول. تحقق من بياناتك.',backgroundColor: Colors.red);
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
    await prefs.setString('gender', user.gender);
    await prefs.setInt('user_id', user.id);
  }
}