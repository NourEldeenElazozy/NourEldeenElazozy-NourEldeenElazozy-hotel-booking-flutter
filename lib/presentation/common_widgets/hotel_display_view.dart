import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/core/constants/my_colors.dart';
import 'package:hotel_booking/core/constants/my_images.dart';
import 'package:hotel_booking/presentation/common_widgets/custom_button.dart';
import 'package:hotel_booking/presentation/screen/home/home_import.dart';
import 'package:hotel_booking/presentation/screen/home/home_model.dart';

class VerticalView extends StatefulWidget {
  final int index;
  const VerticalView({super.key, required this.index});

  @override
  State<VerticalView> createState() => _VerticalViewState();
}

class _VerticalViewState extends State<VerticalView> {

  int? expandedIndex;
  bool bookMark = false;

  late HomeController controller;
  @override
  void initState() {
    super.initState();
    controller = Get.put(HomeController());
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        InkWell(
          onTap: () {
            var reservation = controller.recently[widget.index]; // الوصول إلى بيانات الحجز
            print("----------------------");
            print(controller.recently[widget.index]["description"]);
            print("----------------------");
            Detail detail = Detail.fromJson(reservation);

            // إضافة الكائن إلى homeDetails إذا كان ذلك مطلوبًا
            controller.homeDetails.add(detail);


            //Get.toNamed("/hotelDetail", arguments: {'data': reservation});
            print("reservation");
            print(reservation);
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: controller.themeController.isDarkMode.value ? MyColors.darkSearchTextFieldColor : MyColors.white,
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
                      image: NetworkImage("https://esteraha.ly/storage/${controller.recently[widget.index]['rest_area']['main_image']}"),
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
                        "${controller.recently[widget.index]['rest_area']['name']}",
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "${controller.recently[widget.index]['rest_area']['location']}",
                        style: TextStyle(
                          color: controller.themeController.isDarkMode.value ? MyColors.switchOffColor : MyColors.textPaymentInfo,
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
                            "${controller.recently[widget.index]['rest_area']['rating']}", // استخدام "rating" بدلاً من "rate"
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                          const SizedBox(width: 5),

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
                      "${controller.recently[widget.index]['rest_area']['price']} د.ل",
                      style: TextStyle(
                        color: controller.themeController.isDarkMode.value ? MyColors.white : MyColors.primaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () {
                        setState(() {
                          controller.bookMark.value = !controller.bookMark.value;
                        });
                      },
                      child: controller.bookMark.value
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
}

// ignore: must_be_immutable
class HorizontalView extends StatefulWidget {
  int index;
  HorizontalView({super.key, required this.index});

  @override
  State<HorizontalView> createState() => _HorizontalViewState();
}

class _HorizontalViewState extends State<HorizontalView> {

  late HomeController controller;

  @override
  void initState() {
    controller = Get.put(HomeController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('------------');
        print(controller.homeDetails[widget.index]);
        print('------------');
        Get.toNamed("/hotelDetail", arguments: {'data' : controller.homeDetails[widget.index]});
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: controller.themeController.isDarkMode.value ? MyColors.darkSearchTextFieldColor : MyColors.white,
            boxShadow: [BoxShadow(
                color: controller.themeController.isDarkMode.value
                    ? Colors.transparent
                    : Colors.grey.shade200,
                blurRadius: 10)]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(image: NetworkImage("${controller.recently[widget.index].mainImage}"), fit: BoxFit.cover)
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text("${controller.recently[widget.index].name}", style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                maxLines: 1,overflow: TextOverflow.ellipsis,),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                SvgPicture.asset(MyImages.yellowStar),
                const SizedBox(width: 3),
                Text("${controller.recently[widget.index].rating}", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                const SizedBox(width: 5),
                Flexible(
                  child: Text("${controller.recently[widget.index].location}",
                    style: TextStyle(
                      color: controller.themeController.isDarkMode.value ? MyColors.switchOffColor : MyColors.textPaymentInfo,
                      fontWeight: FontWeight.w400,
                      fontSize: 11,
                    ),
                    maxLines: 1,overflow: TextOverflow.ellipsis,),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Text("${controller.recently[widget.index].price}", style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
                Text(" / night", style: TextStyle(color: controller.themeController.isDarkMode.value ? MyColors.switchOffColor : MyColors.textPaymentInfo, fontWeight: FontWeight.w400, fontSize: 10),),
                const Spacer(),
                InkWell(
                  onTap: () {
                    bottomSheet(context);
                  },
                  child: SvgPicture.asset(MyImages.bookMarkBlack, width: 24,
                    colorFilter: ColorFilter.mode(controller.themeController.isDarkMode.value ? MyColors.white : MyColors.black,BlendMode.srcIn),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void bottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
        height: 310,
        width: MediaQuery.of(context).size.width,
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
            const Text("Remove from Bookmark?", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),),
            const SizedBox(height: 10),
            Divider(color: Colors.grey.shade200,),
            const SizedBox(height: 12),
            // VerticalView(index: ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: Button(
                      onpressed: () {
                        Get.back();
                      },
                      text: "Cancel",
                      textColor: MyColors.black,
                      buttonColor: MyColors.disabledColor,
                      textSize: 16,
                      fontBold: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: Button(
                      onpressed: () {},
                      text: "Yes, Remove",
                      textColor: MyColors.white,
                      buttonColor: MyColors.primaryColor,
                      textSize: 16,
                      fontBold: FontWeight.w700,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      );
    },
  );
}

