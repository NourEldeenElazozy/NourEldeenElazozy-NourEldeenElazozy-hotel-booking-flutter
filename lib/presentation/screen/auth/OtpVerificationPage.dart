import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/Model/User.dart';
import 'package:hotel_booking/core/constants/my_colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpVerificationPage extends StatefulWidget {
  final String otp;
  final String rawPhone;
  final String useType;
  final String name;
  final String dateOfBirth;
  final int city;
  final String gender;
  final String password;

  const OtpVerificationPage({
    Key? key,
    required this.otp,
    required this.rawPhone,
    required this.useType,
    required this.name,
    required this.dateOfBirth,
    required this.city,
    required this.gender,
    required this.password,
  }) : super(key: key);

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}
var token = ''.obs;
var user = User(id: 0, name: '', phone: '',userType: "",gender: "").obs;
class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;

  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }



  Future<void> _completeRegistration() async {


    final response = await Dio().post(
      'https://esteraha.ly/api/register',
      data: {
        'name': widget.name,
        'phone': widget.rawPhone,
        'date_of_birth': widget.dateOfBirth,
        'city': widget.city,
        'gender': widget.gender,
        'user_type': widget.useType,
        'password': widget.password,

      },
    );

    if (response.statusCode != 200) {
      throw Exception('فشل في التسجيل: ${response.statusCode}');
    }else{
      final loginResponse = LoginResponse.fromJson(response.data);
      token.value = loginResponse.token;
      user.value = loginResponse.user;
      await _storeData(loginResponse.token, loginResponse.user);



    }
  }
  Future<void> _storeData(String token, User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      await prefs.setString('token', token);
      await prefs.setInt('userId', user.id);
      await prefs.setString('userName', user.name);
      await prefs.setString('userPhone', user.phone);
      await prefs.setString('user_type', user.userType);
      await prefs.setString('gender', user.gender);

      // ✅ بعد النجاح نطبع البيانات
      print("✅ تم تخزين بيانات المستخدم:");
      print("token: $token");
      print("userId: ${user.id}");
      print("userName: ${user.name}");
      print("userPhone: ${user.phone}");
      print("user_type: ${user.userType}");
      print("gender: ${user.gender}");

    } catch (e) {
      // ❌ لو صار خطأ نرمي Exception علشان ما يكمل
      throw Exception("فشل تخزين البيانات: $e");
    }
  }
  Future<void> _confirmOtp() async {
    if (otpController.text != widget.otp) {
      _showSnackbar('رمز التحقق غير صحيح', isError: true);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await _completeRegistration();
      _showSnackbar('تم التسجيل بنجاح!');

      Navigator.of(context).pushReplacementNamed('/bottomBar');
    } catch (e) {
      _showSnackbar('حدث خطأ أثناء التسجيل: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }


  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("تأكيد الرمز"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
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
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _confirmOtp,
                  child: const Text(
                    "تأكيد",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
