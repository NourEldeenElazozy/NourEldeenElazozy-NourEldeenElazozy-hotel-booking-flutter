part of 'help_center_import.dart';

class HelpCenterFaq extends StatefulWidget {
  final String title;
  const HelpCenterFaq({super.key, required this.title});

  @override
  State<HelpCenterFaq> createState() => _HelpCenterFaqState();
}

class _HelpCenterFaqState extends State<HelpCenterFaq> {

  late HelpCenterController controller;

  @override
  void initState() {
    controller = Get.put(HelpCenterController());
    controller.isExpandedList.value = List.generate(MyString.browserTopicList.length, (index) => false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomFullAppBar(
        title: widget.title
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: ListView.builder(
          shrinkWrap: true,
            itemCount: MyString.browserTopicList.length,
            itemBuilder: (context, index) {
              return Obx(() => Column(
                children: [
                  ExpansionTile(
                    title: Text(MyString.faqList[index], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
                    trailing: Icon(controller.isExpandedList[index] ? Icons.close : Icons.add, size: 20,),
                    childrenPadding: const EdgeInsets.symmetric(horizontal:15, vertical: 15),
                    collapsedShape: RoundedRectangleBorder(
                      side: BorderSide(color:controller.themeController.isDarkMode.value ? Colors.transparent : Colors.grey.shade300),
                      borderRadius: const BorderRadius.all(Radius.circular(15),),
                    ),
                    shape: const RoundedRectangleBorder(
                      // side: controller.themeController.isDarkMode.value ? BorderSide.none : BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.all(Radius.circular(15),),
                    ),
                    onExpansionChanged: (value) {
                      controller.isExpandedList[index] = value;
                    },
                    children: [
                      Text(MyString.descriptions, style: TextStyle(color: controller.themeController.isDarkMode.value ? MyColors.white : MyColors.faqDescriptionColor ,fontWeight: FontWeight.w500, fontSize: 13),),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ));
            },
        ),
      ),
    );
  }
}
