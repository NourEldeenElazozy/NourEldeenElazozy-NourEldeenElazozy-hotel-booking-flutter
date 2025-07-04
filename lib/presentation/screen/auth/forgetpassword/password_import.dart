import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:hotel_booking/core/constants/my_colors.dart';
import 'package:hotel_booking/core/constants/my_images.dart';
import 'package:hotel_booking/core/constants/my_strings.dart';
import 'package:hotel_booking/core/themes/themes_controller.dart';
import 'package:hotel_booking/presentation/common_widgets/appbar.dart';
import 'package:hotel_booking/presentation/common_widgets/custom_button.dart';
import 'package:hotel_booking/presentation/common_widgets/dialogbox.dart';
import 'package:hotel_booking/presentation/common_widgets/snackbar.dart';
import 'package:hotel_booking/presentation/common_widgets/textformfield.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
// تأكد من استيراد dart:convert لمعالجة JSON
import 'dart:convert';
import 'dart:async'; // لاستخدام Timer
import '../../../../utils/validations.dart';

part 'select_sms_email_screen.dart';
part 'choice_password_screen.dart';
part 'password_controller.dart';
part 'otp_send_screen.dart';
part 'create_new_password_screen.dart';