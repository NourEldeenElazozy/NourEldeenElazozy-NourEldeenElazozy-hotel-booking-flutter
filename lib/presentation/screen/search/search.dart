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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leadingWidth: widget.status == 'home' ? 43 : 0,
        leading: widget.status == 'home'
        ? Row(
          children: [
          const SizedBox(width: 15),
          InkWell(
            onTap: () {
              return Get.back();
            },
            child: SvgPicture.asset(
              MyImages.backArrow,
              colorFilter: ColorFilter.mode(
                  controller.themeController.isDarkMode.value
                      ? MyColors.white
                      : MyColors.black,
                  BlendMode.srcIn),
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
            hintText: "Search",
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
            const Text("Recent", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
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
                const Text("Search Result (2,379)", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
                const Spacer(),
                InkWell(
                  onTap: () {
                    controller.selectedButton.value = 0;
                  },
                  child: SvgPicture.asset(
                  controller.selectedButton.value == 0
                    ? MyImages.selectedDocument
                    : MyImages.unselectedDocument,
                    width: 20,
                  colorFilter: ColorFilter.mode(controller.themeController.isDarkMode.value ? Colors.white : Colors.black, BlendMode.srcIn),
                  )
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    controller.selectedButton.value = 1;
                  },
                  child: SvgPicture.asset(controller.selectedButton.value == 0
                    ? MyImages.unselectedCategory
                    : MyImages.selectedCategory,
                    width: 20,
                  colorFilter: ColorFilter.mode(controller.themeController.isDarkMode.value ? Colors.white : Colors.black, BlendMode.srcIn),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Expanded(
              child: controller.selectedButton.value == 0
              ? ListView.builder(
                itemCount: 8,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      // Get.toNamed("/hotelDetail", arguments: {'data' : controller.homeDetails[index]});
                    },
                      child: VerticalView(index: index),
                  );
                },
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
          ],
        ),
      ),)
    );
  }
}
