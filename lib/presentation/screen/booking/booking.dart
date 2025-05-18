part of 'booking_import.dart';

class Booking extends StatefulWidget {
  const Booking({super.key});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> with SingleTickerProviderStateMixin {
  late BookingController controller = Get.put(BookingController());
  late HomeController Hocontroller = Get.put(HomeController());

  String status = "";

  @override
  void initState() {
    super.initState();
    Hocontroller.getReservations();
    controller.getMyBooking();
    controller.selectedItem.value = 0;
    controller.passingStatus.value = 'Paid';
    Hocontroller.filterList('pending');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: homeAppBar(MyString.myBooking, false,
            controller.themeController.isDarkMode.value),
        body: Obx(() => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Hocontroller.selectedItem.value = 0;
                            Hocontroller.filterList('pending');
                          },
                          child: customContainerButton(
                            MyString
                                .ongoingButton, // يمكن تغييره إلى "قيد الانتظار" إن أردت
                            0,
                            Hocontroller.selectedItem.value,
                            controller.themeController.isDarkMode.value,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Hocontroller.selectedItem.value = 1;
                            Hocontroller.filterList('completed');
                          },
                          child: customContainerButton(
                            MyString.completedButton,
                            1,
                            Hocontroller.selectedItem.value,
                            controller.themeController.isDarkMode.value,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Hocontroller.selectedItem.value = 2;
                            Hocontroller.filterList('canceled');
                          },
                          child: customContainerButton(
                            MyString.canceledButton,
                            2,
                            Hocontroller.selectedItem.value,
                            controller.themeController.isDarkMode.value,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: controller.isLoading.value
                        ? Center(
                            child: CircularProgressIndicator(
                                color:
                                    controller.themeController.isDarkMode.value
                                        ? Colors.white
                                        : MyColors.successColor),
                          )
                        : ListView.builder(
                            itemCount: Hocontroller.filteredReservations.length,
                            itemBuilder: (context, index) {
                              status = Hocontroller.filteredReservations[index]
                                  ['status'];
                              Color bgColor;
                              Color textColor;
                              if (status == 'pending') {
                                bgColor =
                                    controller.themeController.isDarkMode.value
                                        ? Colors.orange.shade900
                                        : Colors.orange.shade100;
                                textColor =
                                    controller.themeController.isDarkMode.value
                                        ? Colors.orange.shade200
                                        : Colors.orange.shade800;
                              } else if (status == 'completed') {
                                bgColor =
                                    controller.themeController.isDarkMode.value
                                        ? Colors.green.shade900
                                        : Colors.green.shade100;
                                textColor =
                                    controller.themeController.isDarkMode.value
                                        ? Colors.green.shade200
                                        : Colors.green.shade800;
                              } else {
                                // canceled
                                bgColor =
                                    controller.themeController.isDarkMode.value
                                        ? Colors.red.shade900
                                        : Colors.red.shade100;
                                textColor =
                                    controller.themeController.isDarkMode.value
                                        ? Colors.red.shade200
                                        : Colors.red.shade800;
                              }
                              return Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: controller
                                              .themeController.isDarkMode.value
                                          ? MyColors.darkSearchTextFieldColor
                                          : MyColors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                            color: controller.themeController
                                                    .isDarkMode.value
                                                ? Colors.transparent
                                                : Colors.grey.shade200,
                                            blurRadius: 10)
                                      ],
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
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          "${Hocontroller.filteredReservations[index]['rest_area']['main_image']}"))),
                                            ),
                                            const SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "${Hocontroller.filteredReservations[index]['rest_area']['name']}",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 16),
                                                ),
                                                /*
                                    Text(
                                      "${Hocontroller.reservations[index]['rest_area']['location']}",
                                      style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: controller.themeController.isDarkMode.value
                                            ? MyColors.onBoardingDescriptionDarkColor
                                            : MyColors.textPaymentInfo,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                      ),
                                      maxLines: 1, // يمكنك تحديد عدد الأسطر
                                    ),
                                    */
                                                const SizedBox(height: 10),

                                                // ✅ زر إلغاء الحجز يظهر فقط إذا الحالة pending


                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 15,
                                                      vertical: 5),
                                                  decoration: BoxDecoration(
                                                    color: bgColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Text(
                                                    status == 'pending'
                                                        ? MyString.ongoingButton
                                                        : status == 'completed'
                                                            ? MyString.completed
                                                            : MyString.canceled,
                                                    style: TextStyle(
                                                      color: textColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ),
                                                if (status == 'pending')
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 10),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Get.defaultDialog(
                                                          title: "تأكيد",
                                                          middleText: "هل أنت متأكد من إلغاء الحجز؟",
                                                          textConfirm: "نعم",
                                                          textCancel: "لا",
                                                          confirmTextColor: Colors.white,
                                                          buttonColor: Colors.red,
                                                          cancelTextColor: Colors.black,
                                                          onConfirm: () {
                                                            Get.back(); // إغلاق مربع الحوار
                                                            //Hocontroller.cancelReservation(Hocontroller.filteredReservations[index]['id']);
                                                          },
                                                          onCancel: () {},
                                                        );
                                                      },
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 6),
                                                        decoration: BoxDecoration(
                                                          color: Colors.redAccent,
                                                          borderRadius: BorderRadius.circular(5),
                                                        ),
                                                        child: Text(
                                                          "إلغاء الحجز",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        const CustomDivider(
                                          size: 1,
                                        ),
                                        const SizedBox(height: 10),
                                        Hocontroller.filteredReservations[index]
                                                    ['status'] ==
                                                'Paid'
                                            ? Row(
                                                children: [
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () {
                                                        showModalBottomSheet(
                                                          useSafeArea: true,
                                                          isScrollControlled:
                                                              true,
                                                          context: context,
                                                          builder: (context) {
                                                            return CommonBottomSheet(
                                                              onpressed1: () {
                                                                Get.back();
                                                              },
                                                              text1: MyString
                                                                  .cancel,
                                                              buttonColor1: controller
                                                                      .themeController
                                                                      .isDarkMode
                                                                      .value
                                                                  ? MyColors
                                                                      .darkTextFieldColor
                                                                  : MyColors
                                                                      .skipButtonColor,
                                                              shadowColor1: Colors
                                                                  .transparent,
                                                              textColor1: controller
                                                                      .themeController
                                                                      .isDarkMode
                                                                      .value
                                                                  ? MyColors
                                                                      .white
                                                                  : MyColors
                                                                      .primaryColor,
                                                              onpressed2: () {
                                                                Get.back();
                                                                Get.toNamed(
                                                                    "/cancelBooking");
                                                              },
                                                              text2: MyString
                                                                  .yesContinue,
                                                              mainTitle: MyString
                                                                  .cancelBooking,
                                                              subTitle: MyString
                                                                  .cancelBookingSubTitle,
                                                              description: MyString
                                                                  .cancelBookingDescription,
                                                              shadowColor2: controller
                                                                      .themeController
                                                                      .isDarkMode
                                                                      .value
                                                                  ? Colors
                                                                      .transparent
                                                                  : MyColors
                                                                      .buttonShadowColor,
                                                              status:
                                                                  'cancelBooking',
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 8),
                                                        alignment:
                                                            Alignment.center,
                                                        decoration: BoxDecoration(
                                                            color: controller
                                                                    .themeController
                                                                    .isDarkMode
                                                                    .value
                                                                ? MyColors
                                                                    .darkSearchTextFieldColor
                                                                : MyColors
                                                                    .white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            border: Border.all(
                                                                color: controller
                                                                        .themeController
                                                                        .isDarkMode
                                                                        .value
                                                                    ? MyColors
                                                                        .white
                                                                    : MyColors
                                                                        .primaryColor)),
                                                        child: Text(
                                                          MyString
                                                              .cancelBookingButton,
                                                          style: TextStyle(
                                                            color: controller
                                                                    .themeController
                                                                    .isDarkMode
                                                                    .value
                                                                ? MyColors.white
                                                                : MyColors
                                                                    .primaryColor,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 15),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () {
                                                        Get.toNamed("/ticket",
                                                            arguments: {
                                                              'message': 'false'
                                                            });
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 8),
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: MyColors
                                                              .primaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          border: Border.all(
                                                            color: MyColors
                                                                .primaryColor,
                                                          ),
                                                        ),
                                                        child: const Text(
                                                          MyString
                                                              .viewTicketButton,
                                                          style: TextStyle(
                                                            color:
                                                                MyColors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Container(
                                                /*
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Hocontroller.reservations[index]['status'] == 'Completed'
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
                                  Hocontroller.reservations[index]['status'] == 'Completed'
                                  ? SvgPicture.asset(MyImages.completed, colorFilter: ColorFilter.mode(controller.themeController.isDarkMode.value ? MyColors.white : MyColors.primaryColor, BlendMode.srcIn),)
                                  : SvgPicture.asset(MyImages.canceled),
                                  const SizedBox(width: 5),
                                /*
                                  Text(Hocontroller.reservations[index]['status'] == 'completed' ? MyString.completed : MyString.canceled,
                                    style: TextStyle(
                                        color: Hocontroller.reservations[index]['status'] == 'Completed'
                                            ? Colors.green
                                            : Colors.red,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10
                                    ),
                                  ),
                                 */
                                ],
                              ),
                             */
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
            )));
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
