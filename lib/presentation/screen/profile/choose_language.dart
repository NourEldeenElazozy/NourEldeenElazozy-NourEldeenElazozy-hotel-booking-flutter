part of 'profile_import.dart';

class ChooseLanguage extends StatefulWidget {
  const ChooseLanguage({super.key});

  @override
  State<ChooseLanguage> createState() => _ChooseLanguageState();
}

class _ChooseLanguageState extends State<ChooseLanguage> {

  late ProfileController controller;

  @override
  void initState() {
    controller = Get.put(ProfileController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomFullAppBar(
          title: MyString.chooseLanguage
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.scaffoldLightColor ,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: controller.themeController.isDarkMode.value
                          ? MyColors.darkTextFieldColor
                          : Colors.grey.shade300
                    )
                  ),
                  child: Row(
                    children: [
                      Radio (
                        value: index,
                        groupValue: controller.selectLanguage,
                        activeColor: controller.themeController.isDarkMode.value ? Colors.white : Colors.black,
                        fillColor: MaterialStatePropertyAll(controller.themeController.isDarkMode.value ? Colors.white : Colors.black),
                        onChanged: (value) {
                          setState(() {
                            controller.selectLanguage = value!;
                          });
                        },
                      ),
                      Text(MyString.languageList[index], style: const TextStyle( fontWeight: FontWeight.w700, fontSize: 16),)
                    ],
                  ),
                ),
                const SizedBox(height: 15),
              ],
            );
          },
        ),
      ),
    );
  }
}
