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
  var userType = ''.obs; // استخدام Rx لتحديث الواجهة عند تغيير القيمة
  @override
  void initState() {
    super.initState();
    Hocontroller.getReservations();
    controller.getMyBooking();
    controller.selectedItem.value = 0;
    controller.passingStatus.value = 'Paid';
    Hocontroller.filterList('pending');
    _loaduserType();
  }
  Future<void> _loaduserType() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userType.value = prefs.getString('user_type') ?? '';


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: homeAppBar(MyString.myBooking, false,
            controller.themeController.isDarkMode.value),
        body: Obx(() {
          //controller.getToken();
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator()); // عنصر التحميل الدائري
          }
          print("controller.getToken ${controller.token}");
          if (controller.token.isEmpty) {

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'سجّل الدخول لمشاهدة حجوزاتك',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Get.offNamedUntil('/loginScreen', (route) => false);
                    },
                    child: Text('تسجيل الدخول'),
                  ),
                ],
              ),
            );
          }else{
            return Padding(
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
                            InkWell(

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
                                              borderRadius: BorderRadius.circular(15),
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(

                                                      "http://10.0.2.2:8000/storage/${Hocontroller.filteredReservations[index]['rest_area']['main_image']}"))),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${Hocontroller.filteredReservations[index]['rest_area']['name']}",
                                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                                            ),
                                            const SizedBox(height: 10),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                              decoration: BoxDecoration(
                                                color: bgColor,
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: Text(
                                                status == 'pending'
                                                    ? MyString.ongoingButton
                                                    : status == 'completed'
                                                    ? MyString.completed
                                                    : MyString.canceled,
                                                style: TextStyle(
                                                  color: textColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                            // Buttons for "Cancel Reservation" and "Confirm Reservation"
                                            if (status == 'pending')
                                              Padding(
                                                padding: const EdgeInsets.only(top: 10),
                                                child: Row(
                                                  children: [
                                                    // Cancel Reservation Button
                                                    GestureDetector(
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
                                                            Get.back(); // Close dialog
                                                            // Hocontroller.cancelReservation(Hocontroller.filteredReservations[index]['id']);
                                                          },
                                                          onCancel: () {},
                                                        );
                                                      },
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                                        decoration: BoxDecoration(
                                                          color: Colors.redAccent,
                                                          borderRadius: BorderRadius.circular(5),
                                                        ),
                                                        child: const Row(
                                                          children: [
                                                            Icon(Icons.cancel, color: Colors.white, size: 16),
                                                            SizedBox(width: 5),
                                                            Text(
                                                              "إلغاء الحجز",
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10), // Space between buttons
                                                    // Confirm Reservation Button (only for host and pending status)
                                                    if (userType.value == 'host')
                                                      GestureDetector(
                                                        onTap: () {
                                                          Get.defaultDialog(
                                                            title: "تأكيد",
                                                            middleText: "هل أنت متأكد من تأكيد الحجز؟",
                                                            textConfirm: "نعم",
                                                            textCancel: "لا",
                                                            confirmTextColor: Colors.white,
                                                            buttonColor: Colors.green,
                                                            cancelTextColor: Colors.black,
                                                            onConfirm: () {
                                                              Get.back(); // Close dialog
                                                              // Hocontroller.confirmReservation(Hocontroller.filteredReservations[index]['id']);
                                                            },
                                                            onCancel: () {},
                                                          );
                                                        },
                                                        child: Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                                          decoration: BoxDecoration(
                                                            color: Colors.green,
                                                            borderRadius: BorderRadius.circular(5),
                                                          ),
                                                          child: const Row(
                                                            children: [
                                                              Icon(Icons.check_circle, color: Colors.white, size: 16),
                                                              SizedBox(width: 5),
                                                              Text(
                                                                "تأكيد الحجز",
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    const CustomDivider(
                                      size: 1,
                                    ),
                                    const SizedBox(height: 10),
                                    Hocontroller.filteredReservations[index]['status'] == 'Paid'
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
                                                    buttonColor1: controller.themeController.isDarkMode.value
                                                        ? MyColors.darkTextFieldColor
                                                        : MyColors.skipButtonColor,
                                                    shadowColor1: Colors.transparent,
                                                    textColor1: controller.themeController.isDarkMode.value
                                                        ? MyColors.white
                                                        : MyColors.primaryColor,
                                                    onpressed2: () {
                                                      Get.back();
                                                      Get.toNamed("/cancelBooking");
                                                    },
                                                    text2: MyString.yesContinue,
                                                    mainTitle: MyString.cancelBooking,
                                                    subTitle: MyString.cancelBookingSubTitle,
                                                    description: MyString.cancelBookingDescription,
                                                    shadowColor2: controller.themeController.isDarkMode.value
                                                        ? Colors.transparent
                                                        : MyColors.buttonShadowColor,
                                                    status: 'cancelBooking',
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(vertical: 8),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: controller.themeController.isDarkMode.value
                                                      ? MyColors.darkSearchTextFieldColor
                                                      : MyColors.white,
                                                  borderRadius: BorderRadius.circular(20),
                                                  border: Border.all(
                                                      color: controller.themeController.isDarkMode.value
                                                          ? MyColors.white
                                                          : MyColors.primaryColor)),
                                              child: Text(
                                                MyString.cancelBookingButton,
                                                style: TextStyle(
                                                  color: controller.themeController.isDarkMode.value
                                                      ? MyColors.white
                                                      : MyColors.primaryColor,
                                                  fontWeight: FontWeight.w600,
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
                                              Get.toNamed("/ticket", arguments: {'message': 'false'});
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(vertical: 8),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: MyColors.primaryColor,
                                                borderRadius: BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: MyColors.primaryColor,
                                                ),
                                              ),
                                              child: const Text(
                                                MyString.viewTicketButton,
                                                style: TextStyle(
                                                  color: MyColors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                        : Container(),
                                  ],
                                ),
                              ),
                              onTap: () {
                                // Assuming 'index' is available in the context of the onTap,
                                // indicating which specific reservation was tapped.
                                // If this onTap is inside a ListView.builder, 'index' would be the builder's index.
                                if (Hocontroller.filteredReservations.isNotEmpty) {
                                  Get.to(() => Reservation(
                                    reservationData: {
                                      "reservations": [Hocontroller.filteredReservations[index]]
                                    },
                                  ));
                                } else {
                                  // Handle case where filteredReservations is empty (optional)
                                  Get.snackbar('خطأ', 'لا توجد بيانات حجز لعرضها.');
                                }
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }

    }
    ));

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
}}
