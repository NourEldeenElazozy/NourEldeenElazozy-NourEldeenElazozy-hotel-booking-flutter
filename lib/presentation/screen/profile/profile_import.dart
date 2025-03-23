import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/core/constants/my_colors.dart';
import 'package:hotel_booking/core/constants/my_images.dart';
import 'package:hotel_booking/core/constants/my_strings.dart';
import 'package:hotel_booking/core/themes/themes_controller.dart';
import 'package:hotel_booking/presentation/common_widgets/appbar.dart';
import 'package:hotel_booking/presentation/common_widgets/custom_button.dart';
import 'package:hotel_booking/presentation/common_widgets/custom_switch.dart';
import 'package:hotel_booking/presentation/common_widgets/dialogbox.dart';
import 'package:hotel_booking/presentation/common_widgets/dropdown_button_form_field.dart';
import 'package:hotel_booking/presentation/common_widgets/textformfield.dart';
import 'package:hotel_booking/presentation/screen/auth/Register/register_import.dart';
import 'package:hotel_booking/utils/validations.dart';
import 'package:image_picker/image_picker.dart';

import '../../common_widgets/bottomsheet.dart';

part 'choose_language.dart';
part 'edit_profile.dart';
part 'profile.dart';
part 'profile_controller.dart';
part 'profile_notification.dart';