import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/core/constants/my_colors.dart';
import 'package:hotel_booking/core/constants/my_images.dart';
import 'package:hotel_booking/core/themes/themes_controller.dart';
import 'dart:math' as math;

import 'package:hotel_booking/presentation/screen/notification/notification_controller.dart';
class CustomFullAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? action;

  const CustomFullAppBar({super.key, required this.title, this.action});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {

    ThemeController themeController = Get.put(ThemeController());

    return SafeArea(
      child: AppBar(
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
                width: 20,
                MyImages.backArrow,
                colorFilter: ColorFilter.mode(
                  themeController.isDarkMode.value
                      ? MyColors.white
                      : MyColors.black,
                  BlendMode.srcIn,
                ),
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
      ),
    );
  }
}

PreferredSizeWidget homeAppBar(BuildContext context,String title, bool status, bool isDarkMode, { bool showBackButton = false,
  bool backToHome = false, // اختياري: العودة للصفحة الرئيسية
  bool backToBottomBar = false, // اختياري: العودة لشريط التبويب
  VoidCallback? customBackAction, // اختياري: سلوك مخصص // إضافة هذا المعامل
}

    ) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  final notificationController = Get.find<NotificationController>();
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

  onPressed: customBackAction ?? () {
    if (backToHome) {
      Get.offAllNamed('/bottomBar');
    } else if (backToBottomBar) {
      Navigator.of(context).pop();
    } else {
      // السلوك العادي (العودة للخلف)
      Navigator.of(context).pop();
    }
  }
                )
              else
                Container( // Original app icon container if no back button
                  width: screenWidth * 0.12, // مثال: 12% من عرض الشاشة
                  //margin: const EdgeInsets.only(left: 15),

                  height: screenHeight * 0.05, // مثال: 5% من ارتفاع الشاشة
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
                        Get.toNamed("/notification")?.then((_) {
                          // بعد الرجوع من صفحة الإشعارات نخفي الدائرة
                          notificationController.markNotificationsAsRead();
                        });
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            child: SvgPicture.asset(
                              MyImages.notification,
                              colorFilter: ColorFilter.mode(
                                isDarkMode ? MyColors.white : MyColors.black,
                                BlendMode.srcIn,
                              ),
                              width: 25,
                            ),
                          ),

                          // 🔴 نظهر الدائرة إذا فيه إشعارات جديدة
                          Obx(() => notificationController.hasNewNotification.value
                              ? Positioned(
                            right: 2,
                            top: 2,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                              : const SizedBox.shrink()),
                        ],
                      ),
                    ),


                    const SizedBox(width: 5),

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

                  ],
                ),
              const SizedBox(width: 15), // Padding on the right
            ],
          ),
          //const SizedBox(height: 8), // Space below the row
        ],
      ),
    ),
  );
}
