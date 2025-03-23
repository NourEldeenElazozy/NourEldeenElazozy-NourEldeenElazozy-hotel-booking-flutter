import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/core/constants/my_colors.dart';
import 'package:hotel_booking/core/themes/themes_controller.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final Function(String)? onChange;
  final Function(String)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool? obscureText;
  final Color? fillColor;
  final Widget? prefixIcon;
  final String? hintText;
  final Widget? suffixIcon;
  final InputBorder? border;
  final int? maxLength;
  const CustomTextFormField({super.key,
    required this.controller,
    this.focusNode,
    this.onTap,
    this.onChange,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.obscureText,
    this.fillColor,
    this.prefixIcon,
    this.hintText,
    this.suffixIcon,
    this.border,
    this.maxLength,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {

  ThemeController controller = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: widget.onTap,
      onChanged: widget.onChange,
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: widget.obscureText!,
      maxLength: widget.maxLength,
      keyboardType: widget.keyboardType,
      cursorColor: controller.isDarkMode.value ? Colors.white : Colors.black,
      cursorErrorColor: controller.isDarkMode.value ? Colors.white : Colors.black,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textInputAction: widget.textInputAction,
      validator: widget.validator != null ? (value) => widget.validator!(value!) : null,
      decoration: InputDecoration(
        filled: true,
        fillColor: controller.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.disabledTextFieldColor,
        focusColor: MyColors.textFieldFocusColor,
        counterText: "",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: controller.isDarkMode.value ? Colors.transparent : Colors.grey.shade300),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: controller.isDarkMode.value ? Colors.white : Colors.black),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: controller.isDarkMode.value ? Colors.white : Colors.black),
          borderRadius: BorderRadius.circular(15),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: controller.isDarkMode.value ? Colors.transparent : MyColors.dividerLightTheme),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: controller.isDarkMode.value ? Colors.transparent : MyColors.dividerLightTheme),
        ),
        prefixIcon: widget.prefixIcon,
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Colors.grey,fontWeight: FontWeight.w400, fontSize: 14),
        suffixIcon: widget.suffixIcon,
      ),
    );
  }
}
