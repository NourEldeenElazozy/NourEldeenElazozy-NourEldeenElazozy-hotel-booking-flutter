part of 'profile_import.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late ProfileController controller;
  late bool isDarkMode;

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
    return Scaffold(
      appBar: homeAppBar(
          MyString.profile, false, controller.themeController.isDarkMode.value),
      body: SafeArea(
        child: SingleChildScrollView(
        child: Obx(() => Column(
            children: [
              InkWell(
                onTap: () {
                  showOptions();
                },
                child: Stack(
                  children: [
                    selectedImage != null
                        ? CircleAvatar(
                            radius: 70,
                            backgroundImage: FileImage(selectedImage!),
                          )
                        : CircleAvatar(
                            radius: 70,
                            backgroundColor:
                                controller.themeController.isDarkMode.value
                                    ? MyColors.profilePersonDark
                                    : MyColors.profilePerson,
                            child: Image.asset(
                              MyImages.profilePerson,
                            ),
                          ),
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: SvgPicture.asset(
                        MyImages.editProfile,
                        colorFilter: ColorFilter.mode(
                            controller.themeController.isDarkMode.value
                                ? MyColors.white
                                : MyColors.black,
                            BlendMode.srcIn),
                      ),
                      // child: Icon(Icons.edit),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Daniel Austin",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              ),
              const SizedBox(height: 5),
              const Text(
                "daniel_austin@yourdomain.com",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 20),
              Divider(
                color: Colors.grey.shade300,
              ),
              InkWell(
                onTap: () {
                  Get.toNamed("/editProfile");
                },
                child: commonListTile(MyImages.editProfileScreen,
                    MyString.editProfile, controller.isDarkMode.value),
              ),
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
              InkWell(
                onTap: () {
                  Get.toNamed('/PrivacyPolicy');
                },
                child: commonListTile(MyImages.privacyScreen, MyString.privacy, controller.isDarkMode.value),
              ),
              InkWell(
                onTap: () {
                  ratingDialog(context, controller.isDarkMode.value);
                },
                child: commonListTile(MyImages.rateBookNestScreen,
                    MyString.rateBooKNest, controller.isDarkMode.value),
              ),
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
                            ? MyColors.dividerDarkTheme
                            : MyColors.skipButtonColor,
                        shadowColor1: Colors.transparent,
                        textColor1: controller.isDarkMode.value
                            ? MyColors.white
                            : MyColors.primaryColor,
                        onpressed2: () {
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
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
            ],
          ),
        )),
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
