import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/core/constants/my_colors.dart';
import 'package:hotel_booking/core/constants/my_images.dart';
import 'package:hotel_booking/core/themes/themes_controller.dart';

class CustomFullAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? action;

  const CustomFullAppBar({super.key, required this.title, this.action});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    ThemeController themeController = Get.put(ThemeController());

    return AppBar(
      // backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      leadingWidth: 43,
      leading: Row(
        children: [
          const SizedBox(width: 15),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: SvgPicture.asset(
              MyImages.backArrow,
              colorFilter: ColorFilter.mode(
                  themeController.isDarkMode.value
                      ? MyColors.white
                      : MyColors.black,
                  BlendMode.srcIn),
            ),
          ),
        ],
      ),
      title: Text(
        title,
        style: const TextStyle(   fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Tajawal',),
      ),
      actions: action,
    );
  }
}

PreferredSizeWidget homeAppBar(BuildContext context,String title, bool status, bool isDarkMode, {bool showBackButton = false}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(kToolbarHeight),
    child: SizedBox(
      height: 100, // You might need to adjust this height based on content
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end, // Align content to the bottom
        children: [
          Row(
            children: [
              // Back Button (Conditional)
              if (showBackButton)
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: isDarkMode ? MyColors.white : MyColors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              else
                Container( // Original app icon container if no back button
                  width: 50,
                  //margin: const EdgeInsets.only(left: 15),

                  height: 50,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(
                    MyImages.appIcon,

                  ),
                ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
              ),
              const Spacer(),
              if (status == true) // Checks if status is true to show these icons
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.toNamed("/notification");
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        child: SvgPicture.asset(MyImages.notification,
                            colorFilter: ColorFilter.mode(
                                isDarkMode ? MyColors.white : MyColors.black,
                                BlendMode.srcIn),
                            width: 25),
                      ),
                    ),
                    const SizedBox(width: 5),
               /*
                    InkWell(
                      onTap: () {
                        Get.toNamed("/bookMark");
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        child: SvgPicture.asset(MyImages.bookMarkBlack,
                            colorFilter: ColorFilter.mode(
                                isDarkMode ? MyColors.white : MyColors.black,
                                BlendMode.srcIn),
                            width: 25),
                      ),
                    ),
                */
                  ],
                ),
              const SizedBox(width: 15), // Padding on the right
            ],
          ),
          const SizedBox(height: 10), // Space below the row
        ],
      ),
    ),
  );
}
