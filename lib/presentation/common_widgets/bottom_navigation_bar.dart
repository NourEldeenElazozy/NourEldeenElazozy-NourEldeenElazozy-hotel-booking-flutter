import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/core/constants/my_images.dart';
import 'package:hotel_booking/core/constants/my_strings.dart';
import 'package:hotel_booking/presentation/common_widgets/bottom_navigation_bar_controller.dart';
import 'package:hotel_booking/presentation/screen/booking/booking_import.dart';
import 'package:hotel_booking/presentation/screen/home/home_import.dart';
import 'package:hotel_booking/presentation/screen/notification/notification_controller.dart';
import 'package:hotel_booking/presentation/screen/profile/profile_import.dart';
import 'package:hotel_booking/presentation/screen/search/search_import.dart';

class BottomBar extends StatefulWidget {
  final int initialIndex;
  const BottomBar({super.key, this.initialIndex = 0});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final notificationController = Get.put(NotificationController());
  late BottomBarController controller;

  @override
  void initState() {
    controller = Get.put(BottomBarController());
    controller.selectedBottomTab.value = widget.initialIndex; // هنا التهيئة
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        bottomNavigationBar: Obx(() => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items:
            [
              _bottomNavigationBarItem(MyImages.selectedHome, MyImages.unSelectedHome, MyString.home, controller.themeController.isDarkMode.value),
              //_bottomNavigationBarItem(MyImages.selectedSearch, MyImages.unSelectedSearch, MyString.search, controller.themeController.isDarkMode.value),
              _bottomNavigationBarItem(MyImages.selectedBooking, MyImages.unSelectedBooking, MyString.booking, controller.themeController.isDarkMode.value),
              _bottomNavigationBarItem(MyImages.selectedProfile, MyImages.unSelectedProfile, MyString.profile, controller.themeController.isDarkMode.value),
            ],
          currentIndex: controller.selectedBottomTab.value,
          onTap: (value) {
            controller.selectedBottomTab.value = value;
          },
        ),),
        body: Obx(() {
          switch (controller.selectedBottomTab.value) {
            case 0: return const Home();
            case 1: return const Booking();
            case 2: return const Profile();
            default: return const Profile();
          }
        }),
      ),
    );
  }

  _bottomNavigationBarItem(String activeIcon, String unActiveIcon, String labelName, bool isDarkMode) {
    return BottomNavigationBarItem(
      activeIcon: SvgPicture.asset(activeIcon, colorFilter: ColorFilter.mode(controller.themeController.isDarkMode.value ? Colors.white : Colors.black, BlendMode.srcIn),),
      icon: SvgPicture.asset(unActiveIcon),
      label: labelName,
    );
  }
}




