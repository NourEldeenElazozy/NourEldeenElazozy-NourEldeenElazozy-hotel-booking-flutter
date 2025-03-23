part of 'bookmark_import.dart';

class BookMark extends StatefulWidget {
  const BookMark({super.key});

  @override
  State<BookMark> createState() => _BookMarkState();
}

class _BookMarkState extends State<BookMark> {

  late BookMarkController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(BookMarkController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomFullAppBar(
        title: 'My Bookmark',
        action: [
          InkWell(
            onTap: () {
              setState(() {
                controller.selectedButton.value = 0;
              });
            },
            child: controller.selectedButton.value == 0
                ? SvgPicture.asset(
              MyImages.selectedDocument,
              colorFilter: ColorFilter.mode(
                controller.themeController.isDarkMode.value ? MyColors.white : MyColors.black, BlendMode.srcIn,
              ),
              width: 18,
            )
                : SvgPicture.asset(
              MyImages.unselectedDocument,
              colorFilter: ColorFilter.mode(controller.themeController.isDarkMode.value ? MyColors.white : MyColors.black, BlendMode.srcIn,),
              width: 18,
            ),
          ),
          const SizedBox(width: 15),
          InkWell(
            onTap: () {
              setState(() {
                controller.selectedButton.value = 1;
              });
            },
            child: SvgPicture.asset(
              controller.selectedButton.value == 0
                  ? MyImages.unselectedCategory
                  : MyImages.selectedCategory,
              colorFilter: ColorFilter.mode(controller.themeController.isDarkMode.value ? MyColors.white : MyColors.black, BlendMode.srcIn,),
              width: 18,
            ),
          ),
          const SizedBox(width: 25),
        ],
      ),

      body: Obx(() => Padding(
        padding: const EdgeInsets.all(15),
        child: controller.selectedButton.value == 0
          ? ListView.builder(
            itemCount: 8,
            itemBuilder: (context, index) {
              return VerticalView(index: index);
            }
          )
          : GridView.builder(
            itemCount: 8,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 25,
              mainAxisSpacing: 20,
              mainAxisExtent: 215,
            ),
            itemBuilder: (context, index) {
              return HorizontalView(index: index);
            },
          ),
        ),
      ),
    );
  }
}
