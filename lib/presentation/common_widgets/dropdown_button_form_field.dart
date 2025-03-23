import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/core/themes/themes_controller.dart';
import 'package:hotel_booking/utils/validations.dart';

import '../../core/constants/my_colors.dart';
import '../../core/constants/my_strings.dart';

commonDropdownButton(String? selectedGender, List<String> genderOptions ,bool isDarkMode) {
  return DropdownButtonFormField<String>(
    value: selectedGender,
    validator: Validations().genderValidation,
    onChanged: (newValue) {
      selectedGender = newValue!;
    },
    dropdownColor: isDarkMode ? MyColors.scaffoldDarkColor : MyColors.scaffoldLightColor,
    style: TextStyle( color: isDarkMode ? Colors.white : Colors.black),
    autovalidateMode: AutovalidateMode.onUserInteraction,
    decoration: InputDecoration(
      filled: true,
      fillColor: isDarkMode ? MyColors.darkTextFieldColor : MyColors.disabledTextFieldColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: isDarkMode ? Colors.transparent : MyColors.dividerLightTheme),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: isDarkMode ? Colors.transparent : MyColors.dividerLightTheme),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: isDarkMode ? Colors.white : Colors.black),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: isDarkMode ? Colors.white : MyColors.dividerLightTheme),
        borderRadius: BorderRadius.circular(15),
      ),
      hintText: MyString.gender,
      hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 14),
    ),
    items: genderOptions
        .map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
  );
}

countryPickerDropdown(String countryCode, RxList<Map<String, dynamic>> countryCodes) {
  ThemeController controller = Get.put(ThemeController());
  return DropdownButtonFormField<String>(
    value: countryCode,
    onChanged: (value) {
      countryCode = value!;
    },
    items: countryCodes.map<DropdownMenuItem<String>>((country) {
      return DropdownMenuItem<String>(
        value: country['dial_code'],
        child: Text('${country['dial_code']}'),
      );
    }).toList(),
    alignment: Alignment.center,
    dropdownColor: controller.isDarkMode.value ? MyColors.scaffoldDarkColor : MyColors.scaffoldLightColor,
    style: TextStyle(color: controller.isDarkMode.value ? MyColors.white : MyColors.black,),
    decoration: InputDecoration(
      filled: true,
      fillColor: controller.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.disabledTextFieldColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: controller.isDarkMode.value ? Colors.white : MyColors.dividerLightTheme),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: controller.isDarkMode.value ? Colors.transparent : MyColors.dividerLightTheme),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: controller.isDarkMode.value ? Colors.white : MyColors.dividerLightTheme),
        borderRadius: BorderRadius.circular(15),
      ),
    ),
  );
}
