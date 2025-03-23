
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/core/constants/my_colors.dart';
import 'package:hotel_booking/core/constants/my_images.dart';
import 'package:hotel_booking/core/constants/my_strings.dart';
import 'package:hotel_booking/presentation/common_widgets/custom_button.dart';

// congratulationDialog(BuildContext context) {
//   return showDialog(
//     context: context,
//     builder: (context) {
//       return Dialog(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(30.0),
//             child: Column(
//               children: [
//                 SvgPicture.asset(MyImages.congratulation),
//                 const SizedBox(height: 40),
//                 const Text(MyString.congratulation, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24)),
//                 const SizedBox(height: 10),
//                 const Text(MyString.congratsDescription, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18), textAlign: TextAlign.center,),
//                 const SizedBox(height: 20),
//                 SizedBox(
//                   height: 50,
//                   width: MediaQuery.of(context).size.width,
//                   child: Button(
//                     onpressed: () {
//                       Get.offNamedUntil("/bottomBar", (route) => false);
//                     },
//                     text: 'Go to Homepage',
//                     textColor: MyColors.white,
//                     fontBold: FontWeight.w700,
//                     textSize: 16,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }

class CongratulationDialog extends StatelessWidget {
  final bool status;
  final String? title;
  final String? subTitle;
  final String? buttonName;
  final String? buttonName2;
  final double? textSize;
  final FontWeight? fontBold;
  final Color? textColor;
  final Color? buttonColor;
  final Color? shadowColor;
  final VoidCallback onpressed;
  final VoidCallback onpressed2;
  const CongratulationDialog({super.key,
    required this.onpressed,
    required this.onpressed2,
    required this.status,
    this.title,
    this.subTitle,
    this.textSize,
    this.textColor,
    this.buttonColor,
    this.shadowColor,
    this.fontBold,
    this.buttonName,
    this.buttonName2
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(MyImages.congratulation),
              const SizedBox(height: 40),
              Text(title.toString(), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),textAlign: TextAlign.center),
              const SizedBox(height: 15),
              Text(subTitle.toString(), style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15),textAlign: TextAlign.center),
              const SizedBox(height: 25),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Button(
                  onpressed: onpressed,
                  text: buttonName.toString(),
                  shadowColor: shadowColor,
                ),
              ),
              status == true
              ? Column(
                children: [
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: Button(
                      onpressed: onpressed2,
                      text: buttonName2.toString(),
                      textColor: textColor,
                      buttonColor: buttonColor,
                      shadowColor: shadowColor,
                    ),
                  ),
                ],
              )
              : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}



ratingDialog(BuildContext context, bool isDarkMode) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SvgPicture.asset(MyImages.rating),
                const SizedBox(height: 20),
                const Text(MyString.rateTitle, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                const SizedBox(height: 10),
                Text(MyString.rateSubTitle, style: TextStyle(color: isDarkMode ? MyColors.white : MyColors.ratingSubTitleColor, fontWeight: FontWeight.w500, fontSize: 12)),
                const SizedBox(height: 20),
                RatingBar(
                  itemCount: 5,
                  allowHalfRating: true,
                  itemSize: 30,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 5),
                  ratingWidget: RatingWidget(
                    full: const Icon(Icons.star_rounded, color: MyColors.ratingStarColor),
                    // full: SvgPicture.asset(MyImages.selectStar, colorFilter: const ColorFilter.mode(MyColors.ratingStarColor, BlendMode.srcIn),),
                    half: const Icon(Icons.star_half_rounded, color: MyColors.ratingStarColor),
                    // half: SvgPicture.asset(MyImages.selectStar, colorFilter: const ColorFilter.mode(MyColors.ratingStarColor, BlendMode.srcIn),),
                    empty: SvgPicture.asset(MyImages.outlineStar, colorFilter: const ColorFilter.mode(MyColors.ratingStarColor, BlendMode.srcIn),width: 10,height: 10,),
                  ),
                  onRatingUpdate: (value) {},
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                              side: const BorderSide(color: Colors.black)
                            ),
                          child: const Text(MyString.cancel, style: TextStyle(color: Colors.black),)
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        child: Button(
                          onpressed: () {
                            Get.back();
                          },
                          text: MyString.submit,
                          shadowColor: Colors.transparent,
                          // textColor: MyColors.white,
                          // fontBold: FontWeight.w700,
                          // textSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}