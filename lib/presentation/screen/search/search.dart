part of 'search_import.dart';

class Search extends StatefulWidget {
  final String? status;
  const Search({super.key, this.status});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  late SearchControllers controller;

  @override
  void initState() {
    controller = Get.put(SearchControllers());
    super.initState();
  }
  HomeController homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          leadingWidth: widget.status == 'home' ? 43 : 0,
          leading: widget.status == 'home'
          ? Row(
            children: [
            const SizedBox(width: 15),
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: SvgPicture.asset(
                  MyImages.backArrow,
                  width: 20, // العرض
                  height: 20, // الارتفاع
                  colorFilter: ColorFilter.mode(
                    controller.themeController.isDarkMode.value
                        ? MyColors.white
                        : MyColors.black,
                    BlendMode.srcIn,
                  ),
                ),
              ),

            ],
        ) : const SizedBox(),
          title: TextField(
            controller: controller.searchController.value,
            focusNode: controller.searchFocus.value,
            autofocus: false,
            onSubmitted: (value) {
              if(value.isNotEmpty) {
                controller.selectItem.value = true;
                controller.addSearchData(value);
              }
            },
            onTap: () {
              controller.selectItem.value = false;
            },
            onChanged: (value) {
              if (value.isNotEmpty) {
                controller.selectItem.value = true;
                controller.searchLive(value);
              } else {
                controller.selectItem.value = false;
              }
            },
            decoration: InputDecoration(
              focusColor: Colors.green,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              filled: true,
              fillColor: controller.themeController.isDarkMode.value ? MyColors.darkSearchTextFieldColor : MyColors.searchTextFieldColor,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: MyColors.black),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SvgPicture.asset(MyImages.unSelectedSearch,
                  colorFilter: ColorFilter.mode(controller.themeController.isDarkMode.value ? MyColors.white : Colors.black, BlendMode.srcIn),
                  width: 15,
                ),
              ),
              hintText: "ابحث هنا ...",
              hintStyle: const TextStyle(color: Colors.grey),
              // suffixIcon: Padding(
              //   padding: const EdgeInsets.all(15.0),
              //   child: SvgPicture.asset(MyImages.filter, color: controller.themeController.isDarkMode.value ? MyColors.white : Colors.black),
              // ),
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                controller.searchController.value.clear();
                controller.selectItem.value = false;
              },
              child: const Icon(Icons.close),
            ),
            const SizedBox(width: 20),
          ],
        ),
        body: Obx(() => Padding(
          padding: const EdgeInsets.all(20),
          child: controller.selectItem.value == false
          ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //const Text("Recent", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
              const SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  itemCount: SearchControllers.searchText.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            controller.selectItem.value = true;
                            controller.searchFocus.value.unfocus();
                          },
                          child: Row(
                            children: [
                              Text(SearchControllers.searchText[index], style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  controller.removeSearchData(index);
                                },
                                child: SvgPicture.asset(MyImages.closeSearch, width: 20,),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  },
                ),
              )
            ],
          )
          : Column(
            children: [
              Row(
                children: [

                  const Spacer(),

                  const SizedBox(width: 20),

                ],
              ),
              const SizedBox(height: 15),
              Expanded(
                child: Obx(() {
                  // إذا لم يتم اختيار أي عنصر أو لا توجد نتائج، نعرض Recent أو رسالة فارغة
                  if (!controller.selectItem.value || controller.searchResults.isEmpty) {
                    return Center(
                      child: Text(
                        "لا توجد نتائج",
                        style: TextStyle(
                          color: controller.themeController.isDarkMode.value
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    );
                  }

                  // عرض نتائج البحث الحية
                  return ListView.builder(
                    itemCount: controller.searchResults.length,
                    itemBuilder: (context, index) {
                      var restArea = controller.searchResults[index];

                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Detail detail = Detail.fromJson(restArea);
                           homeController.homeDetails.add(detail);
                              Get.toNamed("/hotelDetail", arguments: {'data': restArea});
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
                  );
                }),
              )

              ,
            ],
          ),
        ),)
      ),
    );
  }
}
