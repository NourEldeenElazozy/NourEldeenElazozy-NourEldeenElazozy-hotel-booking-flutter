part of 'booking_import.dart';

class Booking extends StatefulWidget {
  const Booking({super.key});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> with SingleTickerProviderStateMixin {
  late BookingController controller = Get.put(BookingController());

  @override
  void initState() {
    super.initState();
    controller.getMyBooking();
    controller.selectedItem.value = 0;
    controller.passingStatus.value = 'Paid';
    controller.filterList('Paid');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppBar(MyString.myBooking, false, controller.themeController.isDarkMode.value),
      body: Obx(() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      controller.selectedItem.value = 0;
                      controller.passingStatus.value = 'Paid';
                      controller.filterList('Paid');
                    },
                    child: customContainerButton(
                      MyString.ongoingButton,
                      0,
                      controller.selectedItem.value,
                      controller.themeController.isDarkMode.value,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      controller.selectedItem.value = 1;
                      controller.passingStatus.value = 'Completed';
                      controller.filterList('Completed');
                    },
                    child: customContainerButton(
                      MyString.completedButton,
                      1,
                      controller.selectedItem.value,
                      controller.themeController.isDarkMode.value,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      controller.selectedItem.value = 2;
                      controller.passingStatus.value = 'Canceled & Refunded';
                      controller.filterList('Canceled & Refunded');
                    },
                    child: customContainerButton(
                      MyString.canceledButton,
                      2,
                      controller.selectedItem.value,
                      controller.themeController.isDarkMode.value,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: controller.isLoading.value
              ? Center(child: CircularProgressIndicator(
                color: controller.themeController.isDarkMode.value ? Colors.white : MyColors.successColor),
              )
              : ListView.builder(
                itemCount: controller.filterListView.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
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
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 90,
                                  width: 90,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(image: NetworkImage("${controller.filterListView[index].image}"))
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${controller.filterListView[index].hotelName}", style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),),
                                    Text("${controller.filterListView[index].location}", style: TextStyle(
                                        color: controller.themeController.isDarkMode.value ? MyColors.onBoardingDescriptionDarkColor : MyColors.textPaymentInfo,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: controller.filterListView[index].status == 'Completed' || controller.filterListView[index].status == 'Paid'
                                            ? controller.themeController.isDarkMode.value ? MyColors.statusBoxDarkColor : MyColors.statusBoxColor
                                            : controller.themeController.isDarkMode.value ? MyColors.statusBoxRedDarkColor : MyColors.statusMessageBoxRedColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text("${controller.filterListView[index].status}",
                                        style: TextStyle(
                                            color: controller.filterListView[index].status == 'Completed' || controller.filterListView[index].status == 'Paid'
                                                ? controller.themeController.isDarkMode.value ? MyColors.white : Colors.green
                                                : MyColors.errorColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 10
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const CustomDivider(size: 1,),
                            const SizedBox(height: 10),
                            controller.filterListView[index].status == 'Paid'
                            ? Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        useSafeArea: true,
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) {
                                          return CommonBottomSheet(
                                            onpressed1: () {
                                              Get.back();
                                            },
                                            text1: MyString.cancel,
                                            buttonColor1: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.skipButtonColor,
                                            shadowColor1: Colors.transparent,
                                            textColor1: controller.themeController.isDarkMode.value ? MyColors.white : MyColors.primaryColor,
                                            onpressed2: () {
                                              Get.back();
                                              Get.toNamed("/cancelBooking");
                                            },
                                            text2: MyString.yesContinue,
                                            mainTitle: MyString.cancelBooking,
                                            subTitle: MyString.cancelBookingSubTitle,
                                            description: MyString.cancelBookingDescription,

                                            shadowColor2: controller.themeController.isDarkMode.value ? Colors.transparent : MyColors.buttonShadowColor,
                                            status: 'cancelBooking',
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: controller.themeController.isDarkMode.value ? MyColors.darkSearchTextFieldColor : MyColors.white,
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: controller.themeController.isDarkMode.value ? MyColors.white : MyColors.primaryColor)
                                      ),
                                      child: Text(
                                        MyString.cancelBookingButton,
                                        style: TextStyle(
                                          color: controller.themeController.isDarkMode.value ? MyColors.white : MyColors.primaryColor,
                                          fontWeight: FontWeight.w600, fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      Get.toNamed("/ticket", arguments: {'message' : 'false'});
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: MyColors.primaryColor,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: MyColors.primaryColor,),
                                      ),
                                      child: const Text(
                                        MyString.viewTicketButton,
                                        style: TextStyle(
                                          color: MyColors.white,
                                          fontWeight: FontWeight.w600, fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                            : Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: controller.filterListView[index].status == 'Completed'
                                    ? controller.themeController.isDarkMode.value
                                      ? MyColors.statusDarkGreenBoxColor
                                      : MyColors.statusBoxColor
                                    : controller.themeController.isDarkMode.value
                                      ? MyColors.statusBoxRedDarkColor
                                      : MyColors.statusMessageBoxRedColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              child: Row(
                                children: [
                                  controller.filterListView[index].status == 'Completed'
                                  ? SvgPicture.asset(MyImages.completed, colorFilter: ColorFilter.mode(controller.themeController.isDarkMode.value ? MyColors.white : MyColors.primaryColor, BlendMode.srcIn),)
                                  : SvgPicture.asset(MyImages.canceled),
                                  const SizedBox(width: 5),
                                  Text(controller.filterListView[index].status == 'Completed' ? MyString.completed : MyString.canceled,
                                    style: TextStyle(
                                        color: controller.filterListView[index].status == 'Completed'
                                            ? Colors.green
                                            : Colors.red,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ))
    );
  }

  // Widget customContainerButton(String text, int index, int selectedItem, bool isDarkMode) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(vertical: 8),
  //     alignment: Alignment.center,
  //     decoration: BoxDecoration(
  //       color: controller.selectedItem.value == index
  //           ? controller.themeController.isDarkMode.value
  //           ? MyColors.successColor
  //           : MyColors.primaryColor
  //           : controller.themeController.isDarkMode.value
  //           ? MyColors.scaffoldDarkColor
  //           : MyColors.white,
  //       borderRadius: BorderRadius.circular(20),
  //       border: Border.all(
  //         color: controller.selectedItem.value == index
  //           ? controller.themeController.isDarkMode.value
  //             ? MyColors.successColor
  //             : MyColors.primaryColor
  //           : controller.themeController.isDarkMode.value
  //             ? MyColors.white
  //             : MyColors.primaryColor,
  //       ),
  //     ),
  //     child: Text(
  //       text,
  //       style: TextStyle(
  //         color: controller.selectedItem.value == index
  //           ? MyColors.white
  //           : controller.themeController.isDarkMode.value
  //             ? MyColors.white
  //             : MyColors.primaryColor,
  //         fontWeight: FontWeight.w700,
  //         fontSize: 15,
  //       ),
  //     ),
  //   );
  // }
}

