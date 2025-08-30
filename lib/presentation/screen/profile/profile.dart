part of 'profile_import.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late ProfileController controller;
  late bool isDarkMode;
  var userType = ''.obs; // استخدام Rx لتحديث الواجهة عند تغيير القيمة
  var userName = ''.obs; // استخدام Rx لتحديث الواجهة عند تغيير القيمة
  var userPhone = ''.obs; // استخدام Rx لتحديث الواجهة عند تغيير القيمة

  Future<void> _loaduserType() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userType.value = prefs.getString('user_type') ?? '';
    print("user_type ${prefs.getString('user_type')}");

  }
  Future<void> _loadusername() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userName.value = prefs.getString('userName') ?? '';
    print("user name ${prefs.getString('userName')}");


  }
  Future<void> _loadusermobile() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userPhone.value = prefs.getString('userPhone') ?? '';
    print("userPhone ${prefs.getString('userPhone')}");


  }
  @override
  void initState() {
    controller = Get.put(ProfileController());
    isDarkMode = controller.themeController.isDarkMode.value;

    super.initState();
  }

  File? selectedImage;

  Future<void> selectImageFromGallery() async {
    XFile? pickedFile =
        (await ImagePicker().pickImage(source: ImageSource.gallery));
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> selectImageFroCamera() async {
    XFile? pickedFile =
        (await ImagePicker().pickImage(source: ImageSource.camera));

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future showOptions() async {
    // final ThemeData theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Wrap(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        selectImageFromGallery();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        // color: Colors.red,
                        child: const Text("Open Gallery",
                            style: TextStyle(
                              fontSize: 14,
                            )),
                      ),
                    ),
                    Divider(color: Colors.grey.shade300),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        selectImageFroCamera();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        // color: Colors.blue,
                        child: const Text("Open Camera",
                            style: TextStyle(
                              fontSize: 14,
                            )),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            );
          },
        );
      },
      // BottomSheet(
      //   actions: [
      //     CupertinoActionSheetAction(
      //       child: Text(
      //         "Open Gallery",
      //         style: theme.primaryTextTheme.displayLarge?.copyWith(
      //           fontSize: 14,
      //         ),
      //       ),
      //       onPressed: () {
      //         // close the options modal
      //         Navigator.of(context).pop();
      //         // get image from gallery
      //         selectImageFromGallery();
      //       },
      //     ),
      //     CupertinoActionSheetAction(
      //       child: Text(
      //         "Open Camera",
      //         style: theme.primaryTextTheme.displayLarge?.copyWith(
      //           fontSize: 14,
      //         ),
      //       ),
      //       onPressed: () {
      //         // close the options modal
      //         Navigator.of(context).pop();
      //         // get image from camera
      //         selectImageFroCamera();
      //       },
      //     ),
      //   ],
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _loaduserType();
    _loadusername();
    _loadusermobile();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: homeAppBar(
            context,
            MyString.profile, false, controller.themeController.isDarkMode.value),
        body: SafeArea(
          child: SingleChildScrollView(
          child: Obx(() => Column(
              children: [
                InkWell(
                  onTap: () {
                    //showOptions();
                  },
                  child: Stack(
                    children: [

                           CircleAvatar(
                              radius: 50,
                              backgroundColor:
                                  controller.themeController.isDarkMode.value
                                      ? MyColors.profilePersonDark
                                      : MyColors.profilePerson,
                              child: Image.asset(
                                MyImages.logo,
                              ),
                            ),

                    ],
                  ),
                ),
                const SizedBox(height: 10),
                 Text(
                  userName.value,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                ),
                const SizedBox(height: 5),
                 Text(
                  userPhone.value,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 20),
                Divider(
                  color: Colors.grey.shade300,
                ),
                if(userType.value.isNotEmpty)
                InkWell(
                  onTap: () {
                    Get.toNamed("/editProfile");
                  },
                  child: commonListTile(MyImages.editProfileScreen,
                      MyString.editProfile, controller.isDarkMode.value),
                ),
                if(userType.value.isNotEmpty)
                if(userType.value=="host")
                InkWell(
                  onTap: () {
                    Get.toNamed("/myHosting");
                  },

                  child: commonListTile(MyImages.myHost,
                      MyString.myHost, controller.isDarkMode.value),
                ),
                if(userType.value.isNotEmpty)
                if(userType.value=="host")
                  InkWell(
                    onTap: () {
                      Get.toNamed("/Booking");
                    },

                    child: commonListTile(MyImages.selectedBooking,
                        MyString.myBook, controller.isDarkMode.value),
                  ),
                if(userType.value.isEmpty)
                  InkWell(
                    onTap: () {
                      Get.toNamed('/registerScreen');
                    },
                    child: commonListTile(MyImages.unSelectedProfile,
                        MyString.registerTitle, controller.isDarkMode.value),
                  ),
                if(userType.value.isNotEmpty)
                InkWell(
                  onTap: () {
                    Get.toNamed('/profileNotification');
                  },
                  child: commonListTile(MyImages.notificationScreen,
                      MyString.notifications, controller.isDarkMode.value),
                ),
                ListTile(
                  leading: SvgPicture.asset(
                    MyImages.darkThemeScreen,
                    colorFilter: ColorFilter.mode(
                        controller.isDarkMode.value ? Colors.white : MyColors.profileListTileColor, BlendMode.srcIn),
                    height: 20,
                    width: 20,
                  ),
                  title: const Text(MyString.darkTheme),
                  titleTextStyle: TextStyle(
                    color: controller.isDarkMode.value
                        ? Colors.white
                        : MyColors.profileListTileColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  trailing: CustomSwitch(
                    value: controller.isDarkMode.value,
                    onChanged: (value) {
                      controller.isDarkMode.value = value;
                      controller.themeController.toggleTheme();
                    },
                  ),
                ),
                if(userType.value.isNotEmpty)
                InkWell(
                  onTap: () {
                    Get.toNamed('/pointsPage');
                  },
                  child: commonListTile(MyImages.whiteStar, "نقاط الولاء", controller.isDarkMode.value),
                ),
               /*
                  InkWell(
                  onTap: () {
                    Get.toNamed('/chooseLanguage');
                  },
                  child: commonListTile(MyImages.languageScreen, MyString.language, controller.isDarkMode.value),
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed('/helpCenter');
                  },
                  child: commonListTile(MyImages.helpCenterScreen,
                      MyString.helpCentre, controller.isDarkMode.value),
                ),
                */
                InkWell(
                  onTap: () {
                    Get.toNamed('/contactPage');
                  },
                  child: commonListTile(MyImages.mobile,
                      MyString.helpCentre, controller.isDarkMode.value),
                ),
                if(userType.value.isNotEmpty)
                if(userType.value=="host")
                  InkWell(
                    onTap: () {
                      Get.toNamed('/request360Page');
                    },
                    child: commonListTile(MyImages.congratulation, "طلب تصوير 360", controller.isDarkMode.value),
                  ),
                if(userType.value.isNotEmpty)
                InkWell(
                  onTap: () {
                    Get.toNamed('/PrivacyPolicy');
                  },
                  child: commonListTile(MyImages.privacyScreen, MyString.privacy, controller.isDarkMode.value),
                ),
                if(userType.value.isNotEmpty)
                InkWell(
                  onTap: () {
                    ratingDialog(context, controller.isDarkMode.value);
                  },
                  child: commonListTile(MyImages.rateBookNestScreen,
                      MyString.rateBooKNest, controller.isDarkMode.value),
                ),
                if(userType.value.isNotEmpty)
                InkWell(
                  onTap: () {
                    // عرض ديالوج مشاركة (أنت لاحقاً تضيف share logic هنا)
                    Get.defaultDialog(
                      title: 'مشاركة التطبيق',
                      titleStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                      ),
                      middleText: 'انسخ الرابط وشاركه مع أصدقائك!',
                      middleTextStyle: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Tajawal',
                      ),
                      textConfirm: 'نسخ الرابط',
                      textCancel: 'إلغاء',
                      confirmTextColor: Colors.white,
                      buttonColor: Colors.orange,
                      cancelTextColor: Colors.black,
                      onConfirm: () {
                        Get.back();

                        // هنا مثلاً نسخ الرابط (لو عندك كود نسخ)
                        Get.snackbar(
                          'تم النسخ',
                          'رابط التطبيق تم نسخه ✅',
                          backgroundColor: Colors.orange,
                          colorText: Colors.white,
                        );
                      },
                      onCancel: () {},
                    );
                  },
                  child: commonListTile(
                    MyImages.user, // أيقونة المشاركة
                    'مشاركة التطبيق مع صديق',
                    controller.isDarkMode.value,
                  ),
                ),

                if(userType.value.isNotEmpty)
                ListTile(
                  onTap: () {
                    showModalBottomSheet(
                      useSafeArea: true,
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return CommonBottomSheet(
                          onpressed1: () {
                            Get.back();
                          },
                          text1: MyString.cancel,
                          buttonColor1: controller.isDarkMode.value
                              ? MyColors.white
                              : MyColors.white,
                          shadowColor1: Colors.transparent,
                          textColor1: controller.isDarkMode.value
                              ? MyColors.white
                              : MyColors.white,
                          onpressed2: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.clear(); // حذف جميع الحقول
                            Get.back();
                            Get.offNamedUntil(
                                "/loginOptionScreen", (route) => false);
                          },
                          text2: MyString.yesLogout,
                          mainTitle: MyString.logout,
                          subTitle: MyString.logoutTitle,
                          description: '',
                          status: 'Logout',
                        );
                      },
                    );
                  },
                  leading: SvgPicture.asset(MyImages.logoutScreen, height: 20, width: 20),
                  title: const Text(MyString.logout),
                  titleTextStyle: const TextStyle(
                      color: MyColors.errorColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',),
                ),
                if(userType.value.isNotEmpty)
                  InkWell(
                    onTap: () {
                      // عرض دايلوج تأكيد الحذف
                      Get.defaultDialog(
                        title: 'تأكيد الحذف',
                        titleStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                        ),
                        middleText: 'هل أنت متأكد أنك تريد حذف الحساب؟ هذا الإجراء لا يمكن التراجع عنه.',
                        middleTextStyle: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Tajawal',
                        ),
                        textConfirm: 'نعم، حذف',
                        textCancel: 'إلغاء',
                        confirmTextColor: Colors.white,
                        buttonColor: Colors.redAccent,
                        cancelTextColor: Colors.black,
                        onConfirm: () {
                          Get.back(); // إغلاق الديالوج
                          Get.snackbar(
                            'تم الحذف',
                            'تم حذف حسابك بنجاح.',
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                          );
                        },
                        onCancel: () {},
                      );
                    },
                    child: ListTile(
                      leading: SvgPicture.asset(MyImages.canceled, height: 20, width: 20),
                      title: Text(
                        'حذف حسابي',
                        style: TextStyle(
                          color: Colors.redAccent, // لون النص أحمر
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Tajawal',
                        ),
                      ),

                    ),
                  ),
              ],
            ),
          )),
        ),
      ),
    );
  }

  Widget commonListTile(String image, String title, bool isDarkMode) {
    return ListTile(
      leading: SvgPicture.asset(
        image,
        colorFilter: ColorFilter.mode(
            isDarkMode ? Colors.white : MyColors.profileListTileColor,
            BlendMode.srcIn),
        height: 20,
        width: 20,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDarkMode ? Colors.white : MyColors.profileListTileColor,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
    );
  }
}
