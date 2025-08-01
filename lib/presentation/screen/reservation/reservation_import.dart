import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/core/constants/my_colors.dart';
import 'package:hotel_booking/core/constants/my_images.dart';
import 'package:hotel_booking/core/constants/my_strings.dart';
import 'package:hotel_booking/core/themes/themes_controller.dart';
import 'package:hotel_booking/presentation/common_widgets/appbar.dart';
import 'package:hotel_booking/presentation/common_widgets/custom_button.dart';
import 'package:hotel_booking/presentation/common_widgets/dropdown_button_form_field.dart';
import 'package:hotel_booking/presentation/common_widgets/textformfield.dart';
import 'package:hotel_booking/presentation/screen/booking/booking_import.dart';
import 'package:hotel_booking/presentation/screen/home/home_import.dart';
import 'package:hotel_booking/utils/validations.dart';
import 'package:intl/intl.dart' as intl;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


part 'reservation.dart';
part 'reservation_controller.dart';