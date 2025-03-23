part of 'help_center_import.dart';

class HelpCenter extends StatefulWidget {
  const HelpCenter({super.key});

  @override
  State<HelpCenter> createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {

  late HelpCenterController controller;

  @override
  void initState() {
    controller = Get.put(HelpCenterController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomFullAppBar(title: MyString.helpCenter),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
              color: MyColors.successColor,
              child: Column(
                children: [
                  const Text(MyString.helpYou, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 22),),
                  const SizedBox(height: 25),
                  SizedBox(
                    height: 58,
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: TextField(
                      controller: controller.searchController.value,
                      focusNode: controller.searchFocus.value,
                      autofocus: false,
                      decoration: InputDecoration(
                        focusColor: Colors.green,
                        filled: true,
                        fillColor: MyColors.focusButtonColor,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: MyColors.focusButtonColor),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SvgPicture.asset(MyImages.unSelectedSearch, colorFilter: const ColorFilter.mode(MyColors.white, BlendMode.srcIn),width: 20,),
                        ),
                        hintText: "Search",
                        hintStyle: const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(MyString.browseTopics, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: MyImages.browserTopicList.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        mainAxisExtent: 110,
                      ),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            // Get.toNamed('/helpCenterFaq', arguments: {'title': MyString.browserTopicList[index]});
                            Get.to(HelpCenterFaq(title: MyString.browserTopicList[index],));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(controller.themeController.isDarkMode.value ? MyImages.browserTopicListDark[index] : MyImages.browserTopicList[index]),
                                const SizedBox(height: 10),
                                Text(MyString.browserTopicList[index], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

