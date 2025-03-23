import 'package:flutter/material.dart';

import '../../core/constants/my_colors.dart';

class Button extends StatelessWidget {
  final double? textSize;
  final String text;
  final FontWeight? fontBold;
  final Color? textColor;
  final Color? buttonColor;
  final Color? shadowColor;
  final VoidCallback onpressed;
  const Button({super.key,
    required this.onpressed,
    required this.text,
    this.textSize,
    this.textColor,
    this.buttonColor,
    this.shadowColor,
    this.fontBold,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onpressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.primaryColor,
        shadowColor: shadowColor,
        elevation: 10,
      ),
      child: Text(text, style: TextStyle(color: textColor, fontWeight: fontBold, fontSize: textSize, fontFamily: 'Tajawal'),),
    );
  }
}

Widget customContainerButton(String text, int index, int selectedItem, bool isDarkMode) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: selectedItem == index
          ? isDarkMode
          ? MyColors.successColor
          : MyColors.primaryColor
          : isDarkMode
          ? MyColors.scaffoldDarkColor
          : MyColors.white,
      borderRadius: BorderRadius.circular(25),
      border: Border.all(
        color: selectedItem == index
            ? isDarkMode
            ? MyColors.successColor
            : MyColors.primaryColor
            : isDarkMode
            ? MyColors.white
            : MyColors.primaryColor,
      ),
    ),
    child: FittedBox(

      child: Center(
        child: Text(
          text,
          style: TextStyle(

            fontFamily: 'Tajawal',
            color: selectedItem == index
                ? MyColors.white
                : isDarkMode
                ? MyColors.white
                : MyColors.primaryColor,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    ),
  );
}

// Widget customContainerButton(String buttonName, int index, int controller, bool isDarkMode) {
//   return Container(
//     padding: const EdgeInsets.symmetric(vertical: 8),
//     alignment: Alignment.center,
//     decoration: BoxDecoration(
//         color: controller == index
//             ? isDarkMode
//               ? MyColors.successColor
//               : MyColors.black
//             : isDarkMode
//               ? MyColors.scaffoldDarkColor
//               : MyColors.white,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//             color: controller == index
//                 ? isDarkMode
//                   ? MyColors.successColor
//                   : Colors.black
//                 : isDarkMode
//                   ? MyColors.white
//                   : MyColors.black
//         )
//     ),
//     // padding: const EdgeInsets.symmetric(horizontal: 18),
//     child: Text(
//       buttonName,
//       style: TextStyle(
//           color: controller == index
//               ? MyColors.white
//               : isDarkMode
//               ? MyColors.white
//               : MyColors.black,
//           fontWeight: FontWeight.w600, fontSize: 16,
//       ),
//     ),
//   );
// }