import 'package:flutter/material.dart';
import 'package:hotel_booking/core/constants/app_error.dart';
import 'package:hotel_booking/utils/snackbar_services.dart';

class Validations {
  //^                                    Start anchor
  //(?=.*[A-Z].*[A-Z])           Ensure string has two uppercase letters.
  //(?=.*[!@#$&*])               Ensure string has one special case letter.
  //(?=.*[0-9].*[0-9])            Ensure string has two digits.
  //(?=.*[a-z].*[a-z].*[a-z])   Ensure string has three lowercase letters.
  //.{8}                                 Ensure string is of length 8.
  //$                                      End anchor.

  //"^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d$@$!%*#?&]{8,30}$"
  //Minimum 8 and Maximum 30 characters at least 1 Alphabet and 1 Number

  //"^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
  //Minimum 8 characters at least 1 Alphabet, 1 Number and 1 Special Character

  //"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
  //Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet and 1 Number

  //"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
  //Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character

  //"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,15}"
  //Minimum 8 and Maximum 15 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character

  RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$'); //Email Regex
  RegExp phoneNumRegex = RegExp(r'^[0-9]{10}$'); //Phone Number Regex
  // RegExp passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\$@!%*#?&]{8,30}$'); //Password Regex
  RegExp passwordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,30}$'); //Password Regex

  void showErrorMsg({required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    SnackBarServices.showError(
      context: context,
      message: message,
    );
  }

  String? nameValidation(String value) {
    if(value.isEmpty) {
      return "Name is required.";
    }
    return null;
  }

  String? phoneValidation(String? value) {
    // التعبير النمطي للتحقق من رقم الهاتف
    final RegExp phoneRegex = RegExp(r'^09\d{8}$');

    if (value == null || value.isEmpty) {
      return "رقم الهاتف مطلوب."; // النص بالعربية
    } else if (!phoneRegex.hasMatch(value)) {
      return "رقم الهاتف يجب أن يبدأ بـ 09 ويتبعه 8 أرقام."; // النص بالعربية
    } else {
      return null;
    }
  }

  String? passwordValidation(String value) {
    if(value.isEmpty) {
      return "الرقم السري مطلوب";
    }
    else if(value.length < 6) {
      return "أدخل الحد الأدنى 8 والحد الأقصى 30 حرفًا";
    }
    return null;
  }

  String? dateValidation(value) {
    if(value.isEmpty || value == null) {
      return "Please select BirthDate";
    }
    return null;
  }

  String? genderValidation(String? value) {
    if(value == null || value.isEmpty) {
      return "Select Gender!";
    }
    return null;
  }

  String? mobileNumberValidation(value) {
    if(value == null || value.isEmpty) {
      return "أدخل رقم الهاتف المحمول!";
    } else if(value.length < 10) {
      return "دخل 10 أرقام على الأقل";
    }
    return null;
  }

  //------------------------------------------------------------------------------------------------------

  bool validateEmail({required BuildContext context, required String value}) {
    if (value.isEmpty) {
      showErrorMsg(context: context, message: AppError.enterEmail);
      return false;
    } else if (emailRegex.hasMatch(value)) {
      showErrorMsg(context: context, message: AppError.enterValidEmail);
      return false;
    }
    return true;
  }

  bool validatePhoneNumber(
      {required BuildContext context, required String value}) {
    if (value.isEmpty) {
      showErrorMsg(context: context, message: AppError.enterPhoneNumber);
      return false;
    } else if (value.length != 10) {
      showErrorMsg(context: context, message: AppError.enterValidPhoneNumber);
      return false;
    }
    return true;
  }

  bool validatePassword(
      {required BuildContext context, required String value}) {
    if (value.isEmpty) {
      showErrorMsg(context: context, message: AppError.enterPassword);
    } else if (passwordRegex.hasMatch(value)) {
      showErrorMsg(context: context, message: AppError.enterValidPassword);
      return false;
    }
    return true;
  }

  bool validateLength(
      {required BuildContext context,
      required String value,
      required int length,
      required String errorMsg}) {
    if (value.length <= length) {
      showErrorMsg(context: context, message: AppError.enterPassword);
      return false;
    }
    return true;
  }
}
