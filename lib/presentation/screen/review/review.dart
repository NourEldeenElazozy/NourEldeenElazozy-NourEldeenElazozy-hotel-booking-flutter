 part of 'review_import.dart'; // تأكد أن هذا السطر صحيح

class Review extends StatefulWidget {
  const Review({super.key});

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  late ReviewController controller;
  late int restAreaId; // <--- متغير لتخزين معرف الاستراحة
  @override
  void initState() {
    controller = Get.put(ReviewController());
    // استقبال الـ arguments
    if (Get.arguments != null && Get.arguments is Map && Get.arguments['restAreaId'] != null) {
      restAreaId = Get.arguments['restAreaId'] as int;
      controller.fetchReviews(restAreaId: restAreaId); // <--- استدعاء جلب المراجعات باستخدام الـ ID المستلم
    } else {
      // التعامل مع الحالة التي لا يتم فيها تمرير restAreaId
      Get.snackbar(
        "خطأ",
        "معرف الاستراحة غير موجود. لا يمكن جلب التقييمات.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      // يمكنك توجيه المستخدم إلى صفحة سابقة أو عرض شاشة خطأ
    }

    // يمكنك هنا تمرير الـ restAreaId إذا كان متاحًا من شاشة سابقة
    // controller.fetchReviews(restAreaId: Get.arguments['restAreaId']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller.fetchReviews(restAreaId: restAreaId);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: const CustomFullAppBar(title: 'التقييمات'),

        body: Column( // <--- أزل Obx من هنا (حول الـ Column)
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Obx(() => Row( // <--- أضف Obx هنا لملخص التقييم
                children: [
                  const Text(MyString.rating, style: TextStyle(fontSize: 14)),
                  const Spacer(),
                  SvgPicture.asset(MyImages.yellowStar, width: 14),
                  const SizedBox(width: 5),
                  Text(
                    controller.overallRating.value.toStringAsFixed(1), // تقييم إجمالي
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "(${controller.totalReviewsCount.value} reviews)", // عدد المراجعات
                    style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 10),
                  ),
                ],
              )), // <--- أغلق Obx هنا
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() { // <--- احتفظ بـ Obx هنا لقائمة المراجعات
                if (controller.isLoadingReviews.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (controller.allReviews.isEmpty) {
                  return const Center(child: Text("لا توجد مراجعات حتى الآن."));
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.builder(
                      itemCount: controller.allReviews.length,
                      itemBuilder: (context, index) {
                        final review = controller.allReviews[index];
                        return InkWell(
                          onTap: () {
                            // يمكنك عرض تفاصيل المراجعة أو القيام بشيء آخر
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: controller.isDarkMode.value ? MyColors.darkSearchTextFieldColor : Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(color: controller.isDarkMode.value ? Colors.transparent : Colors.grey.shade200, blurRadius: 10),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    ListTile(
                                      contentPadding: const EdgeInsets.all(0),
                                      leading: CircleAvatar(
                                        backgroundImage: review.imageUrl != null && review.imageUrl!.isNotEmpty
                                            ? NetworkImage(review.imageUrl!)
                                            : null,
                                        backgroundColor: controller.isDarkMode.value ? MyColors.disabledColor : MyColors.profileListTileColor,
                                        child: review.imageUrl == null || review.imageUrl!.isEmpty
                                            ? Icon(Icons.person, color: controller.isDarkMode.value ? MyColors.white : MyColors.black)
                                            : null,
                                      ),
                                      title: Text(
                                        review.reviewerName ?? "مستخدم",
                                        style: TextStyle(
                                            color: controller.isDarkMode.value ? MyColors.white : MyColors.textBlackColor,
                                            fontWeight: FontWeight.w700, fontSize: 14),
                                      ),
                                      subtitle: Text(
                                        review.reviewDate ?? "تاريخ غير معروف",
                                        style: TextStyle(color: controller.isDarkMode.value ? MyColors.onBoardingDescriptionDarkColor : MyColors.textPaymentInfo, fontSize: 10),
                                      ),
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
                                            Text(
                                              review.rating?.toStringAsFixed(1) ?? "0.0",
                                              style: const TextStyle(color: MyColors.white,fontWeight: FontWeight.w600, fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Text(
                                      review.comment ?? "لا يوجد تعليق.",
                                      style: const TextStyle(fontSize: 13),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  void ratingBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                    color: controller.isDarkMode.value ? MyColors.darkSearchTextFieldColor : MyColors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(
                        color: controller.isDarkMode.value
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
                          Text("Paris, France", style: TextStyle(color: controller.isDarkMode.value ? MyColors.switchOffColor : MyColors.textPaymentInfo, fontWeight: FontWeight.w400, fontSize: 12)),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              SvgPicture.asset(MyImages.yellowStar),
                              const SizedBox(width: 5),
                              const Text("4.8", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),),
                              const SizedBox(width: 5),
                              Text("(4,378 reviews)", style: TextStyle(color: controller.isDarkMode.value ? MyColors.switchOffColor : MyColors.textPaymentInfo, fontWeight: FontWeight.w400, fontSize: 10)),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          const Text("35", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
                          Text("/ night", style: TextStyle(color: controller.isDarkMode.value ? MyColors.switchOffColor : MyColors.textPaymentInfo, fontWeight: FontWeight.w400, fontSize: 8)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Text(MyString.giveRating, style: TextStyle(color: controller.isDarkMode.value ? MyColors.white : MyColors.profileListTileColor ,fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 15),

                const SizedBox(height: 15),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Button(
                    onpressed: () {
                      // هنا يمكنك استدعاء دالة الإرسال بدلاً من مجرد Get.back()
                      // controller.submitReview(restAreaId: controller.detail.value.id!);
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
                        backgroundColor: controller.isDarkMode.value ? Colors.white.withOpacity(0.20 ) : Colors.black.withOpacity(0.20),
                        foregroundColor: controller.isDarkMode.value ? MyColors.white : MyColors.black,
                      ),
                      child: const Text(MyString.later, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),)
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}