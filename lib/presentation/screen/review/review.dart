part of 'review_import.dart';

class Review extends StatefulWidget {
  const Review({super.key});

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {

  late ReviewController controller;

  @override
  void initState() {
    controller = Get.put(ReviewController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomFullAppBar(title: 'Review'),
      body: Obx(() => Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20),
            child: SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: MyString.reviewRate.length,
                itemBuilder: (context, index) {
                  return Obx(() => Row(
                    children: [
                      InkWell(
                        onTap: () {
                          controller.selectedRate.value = index;
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: controller.selectedRate.value == index
                                ? controller.themeController.isDarkMode.value
                                ? MyColors.successColor
                                : MyColors.black
                                : controller.themeController.isDarkMode.value
                                ? MyColors.scaffoldDarkColor
                                : MyColors.white,
                            border: Border.all(
                                color: controller.selectedRate.value == index
                                    ? controller.themeController.isDarkMode.value
                                    ? MyColors.successColor
                                    : Colors.black
                                    : controller.themeController.isDarkMode.value
                                    ? MyColors.white
                                    : MyColors.black
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                controller.selectedRate.value == index
                                    ? MyImages.whiteStar
                                    : MyImages.unselectStar,
                                colorFilter: ColorFilter.mode(controller.selectedRate.value == index
                                    ? MyColors.white
                                    : controller.themeController.isDarkMode.value
                                    ? MyColors.white
                                    : MyColors.black, BlendMode.srcIn),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                MyString.reviewRate[index],
                                style: TextStyle(
                                    color: controller.selectedRate.value == index
                                        ? MyColors.white
                                        : controller.themeController.isDarkMode.value
                                        ? MyColors.white
                                        : MyColors.black,
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ));
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Text(MyString.rating, style: TextStyle(fontSize: 14)),
                const Spacer(),
                SvgPicture.asset(MyImages.yellowStar, width: 14),
                const SizedBox(width: 5),
                const Text("4.8", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                const SizedBox(width: 5),
                const Text("(4,378 reviews)", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                itemCount: controller.allReview.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      ratingBottomSheet(context);
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: controller.themeController.isDarkMode.value ? MyColors.darkSearchTextFieldColor : Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(color: controller.themeController.isDarkMode.value ? Colors.transparent : Colors.grey.shade200, blurRadius: 10),
                            ],
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage("${controller.allReview[index].image}"),
                                ),
                                title: Text("${controller.allReview[index].name}", style: TextStyle(
                                    color: controller.themeController.isDarkMode.value ? MyColors.white : MyColors.textBlackColor,
                                    fontWeight: FontWeight.w700, fontSize: 14),),
                                subtitle: Text("${controller.allReview[index].date}", style: TextStyle(color: controller.themeController.isDarkMode.value ? MyColors.onBoardingDescriptionDarkColor : MyColors.textPaymentInfo, fontSize: 10),),
                                trailing: Container(
                                  height: 30,
                                  width: 52,
                                  decoration: BoxDecoration(
                                    color: MyColors.primaryColor,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(MyImages.whiteStar, width: 10),
                                      const SizedBox(width: 5),
                                      Text("${controller.allReview[index].rate}", style: const TextStyle(color: MyColors.white,fontWeight: FontWeight.w600, fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ),
                              Text("${controller.allReview[index].description}", style: const TextStyle(fontSize: 13)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),)
    );
  }
  void ratingBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
            child: Column(
              children: [
                Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: MyColors.disabledColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(MyString.rateHotel, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),),
                const SizedBox(height: 10),
                Divider(color: Colors.grey.shade300,),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: controller.themeController.isDarkMode.value ? MyColors.darkSearchTextFieldColor : MyColors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(
                        color: controller.themeController.isDarkMode.value
                            ? Colors.transparent
                            : Colors.grey.shade200,
                        blurRadius: 10)],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Image.asset(MyImages.hotelSmall),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("President Hotel", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),),
                          const SizedBox(height: 5),
                          Text("Paris, France", style: TextStyle(color: controller.themeController.isDarkMode.value ? MyColors.switchOffColor : MyColors.textPaymentInfo, fontWeight: FontWeight.w400, fontSize: 12)),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              SvgPicture.asset(MyImages.yellowStar),
                              const SizedBox(width: 5),
                              const Text("4.8", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),),
                              const SizedBox(width: 5),
                              Text("(4,378 reviews)", style: TextStyle(color: controller.themeController.isDarkMode.value ? MyColors.switchOffColor : MyColors.textPaymentInfo, fontWeight: FontWeight.w400, fontSize: 10)),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          const Text("35", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
                          Text("/ night", style: TextStyle(color: controller.themeController.isDarkMode.value ? MyColors.switchOffColor : MyColors.textPaymentInfo, fontWeight: FontWeight.w400, fontSize: 8)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Text(MyString.giveRating, style: TextStyle(color: controller.themeController.isDarkMode.value ? MyColors.white : MyColors.profileListTileColor ,fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 15),
                RatingBar(
                  itemCount: 5,
                  allowHalfRating: true,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 8),
                  ratingWidget: RatingWidget(
                    full: const Icon(Icons.star_rounded, color: MyColors.textYellowColor, size: 50),
                    // full: SvgPicture.asset(MyImages.selectStar),
                    half: const Icon(Icons.star_half_rounded, color: MyColors.textYellowColor, size: 50),
                    empty: SvgPicture.asset(MyImages.outlineStar, colorFilter: ColorFilter.mode(
                      controller.themeController.isDarkMode.value ? MyColors.white : MyColors.profileListTileColor, BlendMode.srcIn)),
                  ),
                  itemSize: 30,
                  onRatingUpdate: (value) {},
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(15),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: controller.themeController.isDarkMode.value ? MyColors.darkSearchTextFieldColor : MyColors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(MyString.ratingDescription, style: TextStyle(fontSize: 12)),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Button(
                    onpressed: () {
                      Get.back();
                    },
                    text: MyString.rateNow,
                    shadowColor: Colors.transparent,
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: controller.themeController.isDarkMode.value ? Colors.white.withOpacity(0.20 ) : Colors.black.withOpacity(0.20),
                      foregroundColor: controller.themeController.isDarkMode.value ? MyColors.white : MyColors.black,
                    ),
                    child: const Text(MyString.later, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),)
                  ),
                ),
                // VerticalView(index: ),
              ],
            ),
          ),
        );
      },
    );
  }
}
