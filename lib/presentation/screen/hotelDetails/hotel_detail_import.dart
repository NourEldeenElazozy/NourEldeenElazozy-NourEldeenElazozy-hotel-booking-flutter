import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:hotel_booking/core/constants/my_colors.dart';
import 'package:hotel_booking/core/constants/my_images.dart';
import 'package:hotel_booking/core/constants/my_strings.dart';
import 'package:hotel_booking/core/themes/themes_controller.dart';
import 'package:hotel_booking/presentation/common_widgets/appbar.dart';
import 'package:hotel_booking/presentation/common_widgets/custom_button.dart';
import 'package:hotel_booking/presentation/screen/home/home_model.dart';
import 'package:hotel_booking/presentation/screen/hotelDetails/Modelclass/review_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart'; // <--- استورد مكتبة Dio
import 'package:intl/intl.dart' as intl  ;
import 'package:url_launcher/url_launcher.dart'; // أضف هذا
import 'dart:math' as math;
part 'google_map_screen.dart';
part 'hotel_detail_controller.dart';
part 'hotel_details.dart';
