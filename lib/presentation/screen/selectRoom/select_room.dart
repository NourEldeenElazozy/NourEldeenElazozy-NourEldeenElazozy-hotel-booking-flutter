part of 'select_room_import.dart';

class SelectRoom extends StatefulWidget {
  const SelectRoom({super.key});

  @override
  State<SelectRoom> createState() => _SelectRoomState();
}

class _SelectRoomState extends State<SelectRoom> {

  late SelectRoomController controller;

  @override
  void initState() {
    controller = Get.put(SelectRoomController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomFullAppBar(title: MyString.selectRoom,
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
                controller.themeController.isDarkMode.value
                    ? MyColors.white // If dark mode, set color to white
                    : MyColors.black, // Otherwise, set color to black
                BlendMode.srcIn,
              ),
              width: 18,
            )
            : SvgPicture.asset(
              MyImages.unselectedDocument,
              colorFilter: ColorFilter.mode(
                controller.themeController.isDarkMode.value
                    ? MyColors.white // If dark mode, set color to white
                    : MyColors.black, // Otherwise, set color to black
                BlendMode.srcIn,
              ),
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
              colorFilter: ColorFilter.mode(
                controller.themeController.isDarkMode.value
                    ? MyColors.white
                    : MyColors.black,
                BlendMode.srcIn,
              ),
              width: 18,
            ),
          ),
          const SizedBox(width: 25),
        ],
      ),
      bottomNavigationBar: Container(
        height: 90,
        padding: const EdgeInsets.all(15),
        child: Button(
          onpressed: () {
            Get.toNamed("/reservation");
          },
          text: MyString.continueButton,
          textSize: 16,
          fontBold: FontWeight.w700,
          textColor: MyColors.white,
          shadowColor: controller.themeController.isDarkMode.value ? Colors.transparent : MyColors.buttonShadowColor,
        ),
      ),
      body: Obx(() => Padding(
        padding: const EdgeInsets.all(15),
        child: controller.selectedButton.value == 0
          ? ListView.builder(
            itemCount: controller.selectRoom.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                      });
                        controller.selectRoomIndex.value = index;
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: controller.selectRoomIndex.value == index
                          ? MyColors.black
                          : controller.themeController.isDarkMode.value
                            ? MyColors.darkSearchTextFieldColor
                            : MyColors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(color: controller.themeController.isDarkMode.value ? Colors.transparent : Colors.grey.shade200,
                            blurRadius: 10
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
                              image: DecorationImage(image: NetworkImage("${controller.selectRoom[index].image}"))
                            ),
                            // child: Image.asset(MyImages.hotelSmall),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${controller.selectRoom[index].roomType}",
                                style: TextStyle(
                                  color: controller.selectRoomIndex.value == index
                                    ? MyColors.white
                                    : controller.themeController.isDarkMode.value
                                      ? MyColors.white
                                      : MyColors.textBlackColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text("${controller.selectRoom[index].available}",
                                style: TextStyle(
                                  color: controller.selectRoomIndex.value == index
                                      ? MyColors.white
                                      : controller.themeController.isDarkMode.value
                                      ? MyColors.white
                                      : MyColors.textPaymentInfo,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  SvgPicture.asset(MyImages.yellowStar),
                                  const SizedBox(width: 5),
                                  Text("${controller.selectRoom[index].rate}",
                                    style: TextStyle(
                                      color: controller.selectRoomIndex.value == index
                                        ? MyColors.white
                                        : controller.themeController.isDarkMode.value
                                        ? MyColors.white
                                        : MyColors.primaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text("(${controller.selectRoom[index].review} reviews)",
                                    style: TextStyle(
                                      color: controller.selectRoomIndex.value == index
                                          ? MyColors.white
                                          : controller.themeController.isDarkMode.value
                                          ? MyColors.white
                                          : MyColors.textPaymentInfo,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("${controller.selectRoom[index].price}",
                                style: TextStyle(
                                  color: controller.selectRoomIndex.value == index
                                    ? MyColors.white
                                    : controller.themeController.isDarkMode.value
                                    ? MyColors.white
                                    : MyColors.primaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                              ),
                              Text("/ night",
                                style: TextStyle(
                                  color: controller.selectRoomIndex.value == index
                                    ? MyColors.white
                                    : controller.themeController.isDarkMode.value
                                    ? MyColors.white
                                    : MyColors.textPaymentInfo,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 8,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            }
          )
          : GridView.builder(
            itemCount: controller.selectRoom.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 25,
              mainAxisSpacing: 20,
              mainAxisExtent: 250,
            ),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    controller.selectRoomIndex.value = index;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: controller.selectRoomIndex.value == index
                          ? MyColors.black
                          : controller.themeController.isDarkMode.value
                          ? MyColors.darkSearchTextFieldColor
                          : MyColors.white,
                      boxShadow: [
                        BoxShadow(
                          color: controller.themeController.isDarkMode.value
                            ? Colors.transparent
                            : Colors.grey.shade200,
                          blurRadius: 10,
                        ),
                    ]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(image: NetworkImage("${controller.selectRoom[index].image}"), fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text("${controller.selectRoom[index].roomType}",
                        style: TextStyle(
                          color: controller.selectRoomIndex.value == index
                              ? MyColors.white
                              : controller.themeController.isDarkMode.value
                              ? MyColors.white
                              : MyColors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        )
                      ),
                      const SizedBox(height: 5),
                      Text("${controller.selectRoom[index].available}",
                        style: TextStyle(
                            color: controller.selectRoomIndex.value == index
                                ? MyColors.white
                                : controller.themeController.isDarkMode.value
                                ? MyColors.white
                                : MyColors.textPaymentInfo,
                            fontWeight: FontWeight.w400,
                            fontSize: 12
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          SvgPicture.asset(MyImages.yellowStar),
                          const SizedBox(width: 3),
                          Text("${controller.selectRoom[index].rate}",
                            style: TextStyle(
                              color: controller.selectRoomIndex.value == index
                                  ? MyColors.white
                                  : controller.themeController.isDarkMode.value
                                  ? MyColors.white
                                  : MyColors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text("(${controller.selectRoom[index].review} reviews)",
                            style: TextStyle(
                              color: controller.selectRoomIndex.value == index
                                  ? MyColors.white
                                  : controller.themeController.isDarkMode.value
                                  ? MyColors.white
                                  : MyColors.textPaymentInfo,
                                fontWeight: FontWeight.w400,
                                fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text("${controller.selectRoom[index].price}",
                            style: TextStyle(
                              color: controller.selectRoomIndex.value == index
                                  ? MyColors.white
                                  : controller.themeController.isDarkMode.value
                                  ? MyColors.white
                                  : MyColors.primaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                            ),
                          ),
                          Text(" / night",
                            style: TextStyle(
                                color: controller.selectRoomIndex.value == index
                                    ? MyColors.white
                                    : controller.themeController.isDarkMode.value
                                    ? MyColors.white
                                    : MyColors.textPaymentInfo,
                                fontWeight: FontWeight.w400,
                                fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
