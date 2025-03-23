import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/Model/User.dart';
import 'package:hotel_booking/core/constants/my_colors.dart';
import 'package:hotel_booking/core/constants/my_images.dart';
import 'package:hotel_booking/core/constants/my_strings.dart';
import 'package:hotel_booking/presentation/common_widgets/custom_button.dart';
import 'package:hotel_booking/presentation/common_widgets/custom_divider.dart';
import 'package:hotel_booking/presentation/common_widgets/textformfield.dart';
import 'package:hotel_booking/utils/validations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/themes/themes_controller.dart';

part 'login.dart';
part 'login_controller.dart';
part 'login_option.dart';