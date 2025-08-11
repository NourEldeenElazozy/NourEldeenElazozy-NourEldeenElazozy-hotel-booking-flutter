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

    controller.loadFavorites();
    print("controller.restAreas.length ${controller.restAreas.length}");
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: CustomFullAppBar(
          title: 'المفضلة',
          action: [
            /*
            InkWell(
              onTap: () => controller.selectedButton.value = 0,
              child: Obx(() => SvgPicture.asset(
                controller.selectedButton.value == 0
                    ? MyImages.selectedDocument
                    : MyImages.unselectedDocument,
                colorFilter: ColorFilter.mode(
                  controller.themeController.isDarkMode.value ? MyColors.white : MyColors.black,
                  BlendMode.srcIn,
                ),
                width: 18,
              )),
            ),

            const SizedBox(width: 15),
            InkWell(
              onTap: () => controller.selectedButton.value = 1,
              child: Obx(() => SvgPicture.asset(
                controller.selectedButton.value == 0
                    ? MyImages.unselectedCategory
                    : MyImages.selectedCategory,
                colorFilter: ColorFilter.mode(
                  controller.themeController.isDarkMode.value ? MyColors.white : MyColors.black,
                  BlendMode.srcIn,
                ),
                width: 18,
              )),
            ),
              */

            const SizedBox(width: 25),
          ],
        ),

        body: Obx(() {
          if (controller.homeController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final favorites = controller.favorites;  // القائمة التي تريد عرضها
          if (favorites.isEmpty) {
            return const Center(child: Text("لا توجد مفضلات بعد"));
          }

          return Padding(
            padding: const EdgeInsets.all(15),
            child: controller.selectedButton.value == 0
                ? ListView.builder(
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    var favorite = favorites[index];
                    var restArea = favorite;


                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            print("description");
                            print(restArea["description"]);
                            print("----------------------");

                            Detail detail = Detail.fromJson(favorite);
                            controller.homeController.homeDetails.add(detail);
                           Get.toNamed("/hotelDetail", arguments: {'data': favorite});
                            print("favorite item: $favorite");
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: controller.themeController.isDarkMode.value
                                  ? MyColors.darkSearchTextFieldColor
                                  : MyColors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: controller.themeController.isDarkMode.value
                                      ? Colors.transparent
                                      : Colors.grey.shade200,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 90,
                                  width: 90,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        "https://esteraha.ly/public/${restArea['main_image']}",
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${restArea['name']}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700, fontSize: 16),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "${restArea['location']}",
                                        style: TextStyle(
                                          color: controller.themeController.isDarkMode.value
                                              ? MyColors.switchOffColor
                                              : MyColors.textPaymentInfo,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          SvgPicture.asset(MyImages.yellowStar),
                                          const SizedBox(width: 5),
                                          Text(
                                            "${restArea['rating']}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600, fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${restArea['price']} د.ل",
                                      style: TextStyle(
                                        color: controller.themeController.isDarkMode.value
                                            ? MyColors.white
                                            : MyColors.primaryColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 12),

                                    Obx(() {
                                      bool isFavorite = controller.favoriteIds.contains(restArea['id']);

                                      return InkWell(
                                        onTap: () {
                                          controller.toggleFavorite(restArea['id']);
                                        },
                                        child: isFavorite
                                            ? SvgPicture.asset(
                                          MyImages.selectedBookMarkBlack,
                                          colorFilter: ColorFilter.mode(
                                            controller.themeController.isDarkMode.value ? MyColors.white : MyColors.black,
                                            BlendMode.srcIn,
                                          ),
                                        )
                                            : SvgPicture.asset(
                                          MyImages.unSelectBookMark,
                                          colorFilter: ColorFilter.mode(
                                            controller.themeController.isDarkMode.value ? MyColors.white : MyColors.black,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      );
                                    })

                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  },
                )
                : GridView.builder(
              itemCount: favorites.length,
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
          );
        }),

      ),
    );
  }
}