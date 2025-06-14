import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/Model/AllReview.dart';
import 'package:hotel_booking/core/themes/themes_controller.dart';
import 'package:hotel_booking/presentation/common_widgets/appbar.dart';
import 'package:hotel_booking/presentation/screen/hotelDetails/Modelclass/review_model.dart';
import 'package:hotel_booking/presentation/screen/hotelDetails/hotel_detail_import.dart';

import '../../../core/constants/my_colors.dart';
import '../../../core/constants/my_images.dart';
import '../../../core/constants/my_strings.dart';
import '../../common_widgets/custom_button.dart';

part 'review.dart';
part 'review_controller.dart';