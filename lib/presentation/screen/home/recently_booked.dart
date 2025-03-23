part of 'home_import.dart';

class RecentlyBooked extends StatefulWidget {
  const RecentlyBooked({super.key});

  @override
  State<RecentlyBooked> createState() => _RecentlyBookedState();
}

class _RecentlyBookedState extends State<RecentlyBooked> {

  late HomeController controller ;

  @override
  void initState() {
    controller = Get.put(HomeController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomFullAppBar(
        title: 'Recently Booked',
        action: [
          InkWell(
            onTap: () {
              setState(() {
                controller.selectedButton.value = 0;
              });
            },
            child: SvgPicture.asset(
              controller.selectedButton.value == 0
                    ? MyImages.selectedDocument
                    : MyImages.unselectedDocument, width: 18,
              colorFilter: ColorFilter.mode(controller.themeController.isDarkMode.value ? Colors.white : Colors.black, BlendMode.srcIn),
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
                    : MyImages.selectedCategory, width: 18,
                colorFilter: ColorFilter.mode(controller.themeController.isDarkMode.value ? Colors.white : Colors.black, BlendMode.srcIn),
            ),
          ),
          const SizedBox(width: 25),
        ],
      ),
      body: Obx(() => Padding(
        padding: const EdgeInsets.all(15),
        child: controller.selectedButton.value == 0
          ? ListView.builder(
            itemCount: controller.recentlyBooked.length,
            itemBuilder: (context, index) {
              return VerticalView(index: index);
            }
          )
          : GridView.builder(
            itemCount: controller.recentlyBooked.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 25,
              mainAxisSpacing: 20,
              mainAxisExtent: 220,
            ),
            itemBuilder: (context, index) {
              return HorizontalView(index: index,);
            },
          ),
      ),
      ),
    );
  }
}
