part of 'login_import.dart';

class LoginOptionScreen extends StatefulWidget {
  const LoginOptionScreen({super.key});

  @override
  State<LoginOptionScreen> createState() => _LoginOptionScreenState();
}

class _LoginOptionScreenState extends State<LoginOptionScreen> {

  late LoginController controller;

  @override
  void initState() {
    controller = Get.put(LoginController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.30,
                  child: const Text(MyString.title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 45),),
                ),
                const SizedBox(height: 20),
                loginOption(context, MyImages.facebook, MyString.facebookTitle, controller.themeController.isDarkMode.value),
                const SizedBox(height: 20),
                loginOption(context, MyImages.google, MyString.googleTitle, controller.themeController.isDarkMode.value),
                const SizedBox(height: 20),
                Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: controller.themeController.isDarkMode.value ? MyColors.dividerDarkTheme : MyColors.dividerLightTheme),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(MyImages.apple, colorFilter: ColorFilter.mode(controller.themeController.isDarkMode.value ? MyColors.white : MyColors.black, BlendMode.srcIn),),
                      const SizedBox(width: 10,),
                      const Text(MyString.appleTitle, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomDivider(size: 0.40),
                    Text(MyString.or, style: TextStyle(color: controller.themeController.isDarkMode.value ? MyColors.white : Colors.black54, fontWeight: FontWeight.w600, fontSize: 18)),
                    const CustomDivider(size: 0.40),
                  ],
                ),
                const SizedBox(height: 50),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Button(
                    onpressed: () {
                      Get.toNamed("/loginScreen");
                    },
                    text: MyString.signInPassword,
                    shadowColor: controller.themeController.isDarkMode.value ? Colors.transparent : MyColors.buttonShadowColor,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(MyString.donAccount, style: TextStyle(color: Colors.grey.shade400,fontWeight: FontWeight.w400, fontSize: 14)),
                    InkWell(
                      onTap: () {
                        Get.toNamed("/registerScreen");
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Text(MyString.signUp, style: TextStyle(
                        color: controller.themeController.isDarkMode.value ? MyColors.textYellowColor : MyColors.primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),),
    );
  }
}

loginOption(BuildContext context, String image, String title, bool isDarkMode) {
  return Container(
    height: 55,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: isDarkMode ? MyColors.dividerDarkTheme : MyColors.dividerLightTheme),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(image),
        const SizedBox(width: 10,),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
      ],
    ),
  );
}
