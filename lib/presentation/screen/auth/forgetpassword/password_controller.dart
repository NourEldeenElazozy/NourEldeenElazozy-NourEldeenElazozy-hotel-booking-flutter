part of 'password_import.dart';

class PasswordController extends GetxController {
  ThemeController themeController = Get.put(ThemeController());

  final GlobalKey<FormState> smsEmailKey = GlobalKey<FormState>();

  final TextEditingController smsController = TextEditingController();

  String? mobileNumberValidation(String value) {
    if(value.isEmpty) {
      return "Mobile Number is required.";
    } else if (value.length < 10) {
      return "Enter 10 Digit";
    }
    return null;
  }

  String? emailValidation(String value) {
    if(value.isEmpty)
    {
      return "Email is required.";
    }
    else if(!Validations().emailRegex.hasMatch(value)) {
      return "Enter a valid Email!";
    }
    else {
      return null;
    }
  }

  void selectSmsEmailSubmit(BuildContext context) {
    final isValid = smsEmailKey.currentState!.validate();
    Get.focusScope!.unfocus();
    if (!isValid) {
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const OtpSendScreen()));
      // Get.toNamed("/otpSend");
    }
    smsEmailKey.currentState!.save();
  }

//----------------------------------------- OtpSend_Screen -------------------------------------------

  final TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();

  late Timer _timer;
  final RxInt _remainingSeconds = 10.obs;

  void otpSend(BuildContext context) {
    if(otpController.text.isEmpty) {
      showErrorMsg(context: context, message: "Enter OTP");
    } else if(_remainingSeconds <= 0) {
      showErrorMsg(context: context, message: "OTP Expire, Resend OTP");
    } else {
      Get.toNamed("/createNewPassword");
    }
  }

  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      if (_remainingSeconds.value == 0) {
        timer.cancel();
      } else {
        _remainingSeconds.value--;
      }
    }) ;
  }

//----------------------------------------- CreateNewPassword_Screen -------------------------------------------

  final GlobalKey<FormState> newPasswordKey = GlobalKey<FormState>();

  RxBool newShowPassword = true.obs;
  RxBool confirmShowPassword = true.obs;

  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  String? confirmPasswordValidation(String value) {
    if(value.isEmpty)
    {
      return "ConfirmPassword is required.";
    }
    else if(value != newPassword.text) {
      // return "Enter valid Password!";
      return "Not Match Password";
    }
    else{
      return null;
    }
  }

  void submit(BuildContext context) {
    final isValid = newPasswordKey.currentState!.validate();
    Get.focusScope!.unfocus();
    if (!isValid) {
      return ;
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
              // Get.offNamedUntil('/bottomBar');
              Get.offNamedUntil('/bottomBar', (route) => false);
            },
            onpressed2: () {},
          );
        },
      );
    }
    newPasswordKey.currentState!.save();
  }
}