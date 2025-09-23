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
  var isLoading = true.obs; // إضافة حالة تحميل
  @override
  void initState() {
    super.initState();
    _loadUserType(); // أقرأ نوع المستخدم بسرعة
    _initData();     // بعدين خلي باقي البيانات تنزل
  }

  Future<void> _initData() async {
    try {
      await Future.wait([
        Hocontroller.getReservations(),
        controller.getMyBooking(),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

// دالة لعرض bottom sheet لفلترة الاستراحات
  void _showRestAreaFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // لتكون قابلة للتمرير إذا كانت المحتويات طويلة
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bc) {
        return Obx(() => Directionality(
              // إضافة Directionality هنا
              textDirection:
                  TextDirection.rtl, // تحديد الاتجاه من اليمين لليسار
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: controller.themeController.isDarkMode.value
                      ? MyColors.scaffoldDarkColor // لون خلفية للـ sheet
                      : MyColors.white,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // يبدأ من اليمين في RTL
                  children: <Widget>[
                    // مقبض السحب
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Text(
                      "فرز حسب الاستراحة",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: controller.themeController.isDarkMode.value
                            ? MyColors.white
                            : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Divider(color: Colors.grey.shade300), // فاصل جميل
                    ListTile(
                      title: Text(
                        'جميع الاستراحات',
                        style: TextStyle(
                          color: controller.themeController.isDarkMode.value
                              ? MyColors.white
                              : Colors.black,
                        ),
                      ),
                      trailing: Radio<int>(
                        // استخدام trailing ليكون الراديو على اليسار في RTL
                        value: -1, // قيمة خاصة لـ "الكل"
                        groupValue: Hocontroller.selectedRestAreaIdFilter.value,
                        onChanged: (int? value) {
                          // **الأهم: قم بتحديث المتغير الملاحظ داخل Obx أو دالة GetX**
                          Hocontroller.selectedRestAreaIdFilter.value =
                              null; // إعادة تعيين الفلتر
                          String currentStatus = '';
                          if (Hocontroller.selectedItem.value == 0) {
                            currentStatus = 'pending';
                          } else if (Hocontroller.selectedItem.value == 1) {
                            currentStatus = 'completed';
                          } else if (Hocontroller.selectedItem.value == 2) {
                            currentStatus = 'canceled';
                          } else if (Hocontroller.selectedItem.value == 3) {
                            currentStatus = 'confirmed';
                          }
                          Hocontroller.filterList(currentStatus);
                          Get.back(); // إغلاق الـ BottomSheet
                        },
                        activeColor: MyColors.primaryColor, // لون التحديد
                      ),
                      onTap: () {
                        // للسماح بالنقر على أي جزء من ListTile للتحديد
                        Hocontroller.selectedRestAreaIdFilter.value = null;
                        String currentStatus = '';
                        if (Hocontroller.selectedItem.value == 0) {
                          currentStatus = 'pending';
                        } else if (Hocontroller.selectedItem.value == 1) {
                          currentStatus = 'completed';
                        } else if (Hocontroller.selectedItem.value == 2) {
                          currentStatus = 'canceled';
                        } else if (Hocontroller.selectedItem.value == 3) {
                          currentStatus = 'confirmed';
                        }
                        Hocontroller.filterList(currentStatus);
                        Get.back();
                      },
                    ),
                    ...Hocontroller.hostRestAreas.map((restArea) {
                      return ListTile(
                        title: Text(
                          restArea['name'] ?? 'غير معروف',
                          style: TextStyle(
                            color: controller.themeController.isDarkMode.value
                                ? MyColors.white
                                : Colors.black,
                          ),
                        ),
                        trailing: Radio<int>(
                          // استخدام trailing
                          value: restArea['id'],
                          groupValue:
                              Hocontroller.selectedRestAreaIdFilter.value,
                          onChanged: (int? value) {
                            Hocontroller.selectedRestAreaIdFilter.value = value;
                            String currentStatus = '';
                            if (Hocontroller.selectedItem.value == 0) {
                              currentStatus = 'pending';
                            } else if (Hocontroller.selectedItem.value == 1) {
                              currentStatus = 'completed';
                            } else if (Hocontroller.selectedItem.value == 2) {
                              currentStatus = 'canceled';
                            } else if (Hocontroller.selectedItem.value == 3) {
                              currentStatus = 'confirmed';
                            }
                            Hocontroller.filterList(currentStatus);
                            Get.back();
                          },
                          activeColor: MyColors.primaryColor,
                        ),
                        onTap: () {
                          // للسماح بالنقر على أي جزء من ListTile للتحديد
                          Hocontroller.selectedRestAreaIdFilter.value =
                              restArea['id'];
                          String currentStatus = '';
                          if (Hocontroller.selectedItem.value == 0) {
                            currentStatus = 'pending';
                          } else if (Hocontroller.selectedItem.value == 1) {
                            currentStatus = 'completed';
                          } else if (Hocontroller.selectedItem.value == 2) {
                            currentStatus = 'canceled';
                          } else if (Hocontroller.selectedItem.value == 3) {
                            currentStatus = 'confirmed';
                          }
                          Hocontroller.filterList(currentStatus);
                          Get.back();
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),
            ));
      },
    );
  }

// دالة لعرض bottom sheet لفرز التاريخ
  void _showDateSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bc) {
        return Obx(() => Directionality(
              // إضافة Directionality هنا
              textDirection:
                  TextDirection.rtl, // تحديد الاتجاه من اليمين لليسار
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: controller.themeController.isDarkMode.value
                      ? MyColors.scaffoldDarkColor
                      : MyColors.white,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // مقبض السحب
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Text(
                      "فرز حسب التاريخ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: controller.themeController.isDarkMode.value
                            ? MyColors.white
                            : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Divider(color: Colors.grey.shade300),
                    ListTile(
                      title: Text(
                        'ترتيب بأحدث الطلبات',
                        style: TextStyle(
                          color: controller.themeController.isDarkMode.value
                              ? MyColors.white
                              : Colors.black,
                        ),
                      ),
                      trailing: Radio<String>(
                        // استخدام trailing
                        value: 'newest',
                        groupValue: Hocontroller.selectedDateSortOrder.value,
                        onChanged: (String? value) {
                          Hocontroller.selectedDateSortOrder.value = value!;
                          String currentStatus = '';
                          if (Hocontroller.selectedItem.value == 0) {
                            currentStatus = 'pending';
                          } else if (Hocontroller.selectedItem.value == 1) {
                            currentStatus = 'completed';
                          } else if (Hocontroller.selectedItem.value == 2) {
                            currentStatus = 'canceled';
                          } else if (Hocontroller.selectedItem.value == 3) {
                            currentStatus = 'confirmed';
                          }
                          Hocontroller.filterList(currentStatus);
                          Get.back();
                        },
                        activeColor: MyColors.primaryColor,
                      ),
                      onTap: () {
                        // للسماح بالنقر على أي جزء من ListTile للتحديد
                        Hocontroller.selectedDateSortOrder.value = 'newest';
                        String currentStatus = '';
                        if (Hocontroller.selectedItem.value == 0) {
                          currentStatus = 'pending';
                        } else if (Hocontroller.selectedItem.value == 1) {
                          currentStatus = 'completed';
                        } else if (Hocontroller.selectedItem.value == 2) {
                          currentStatus = 'canceled';
                        } else if (Hocontroller.selectedItem.value == 3) {
                          currentStatus = 'confirmed';
                        }
                        Hocontroller.filterList(currentStatus);
                        Get.back();
                      },
                    ),
                    ListTile(
                      title: Text(
                        'ترتيب بأقرب تاريخ',
                        style: TextStyle(
                          color: controller.themeController.isDarkMode.value
                              ? MyColors.white
                              : Colors.black,
                        ),
                      ),
                      trailing: Radio<String>(
                        // استخدام trailing
                        value: 'oldest',
                        groupValue: Hocontroller.selectedDateSortOrder.value,
                        onChanged: (String? value) {
                          Hocontroller.selectedDateSortOrder.value = value!;
                          String currentStatus = '';
                          if (Hocontroller.selectedItem.value == 0) {
                            currentStatus = 'pending';
                          } else if (Hocontroller.selectedItem.value == 1) {
                            currentStatus = 'completed';
                          } else if (Hocontroller.selectedItem.value == 2) {
                            currentStatus = 'canceled';
                          } else if (Hocontroller.selectedItem.value == 3) {
                            currentStatus = 'confirmed';
                          }
                          Hocontroller.filterList(currentStatus);
                          Get.back();
                        },
                        activeColor: MyColors.primaryColor,
                      ),
                      onTap: () {
                        // للسماح بالنقر على أي جزء من ListTile للتحديد
                        Hocontroller.selectedDateSortOrder.value = 'oldest';
                        String currentStatus = '';
                        if (Hocontroller.selectedItem.value == 0) {
                          currentStatus = 'pending';
                        } else if (Hocontroller.selectedItem.value == 1) {
                          currentStatus = 'completed';
                        } else if (Hocontroller.selectedItem.value == 2) {
                          currentStatus = 'canceled';
                        } else if (Hocontroller.selectedItem.value == 3) {
                          currentStatus = 'confirmed';
                        }
                        Hocontroller.filterList(currentStatus);
                        Get.back();
                      },
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  Future<void> _loadUserType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userType.value = prefs.getString('user_type') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          floatingActionButton: Obx(() {
            if (userType.value.isEmpty) {
              return const SizedBox.shrink(); // بدلاً من Container()
            }
            return userType.value == 'host'
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton.extended(
                        onPressed: () {
                          Get.toNamed("/myHosting");
                        },
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text(
                          "إضافة حجز خارجي",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: MyColors.primaryColor,
                        heroTag: 'uniqueTag',
                      ),
                    ],
                  )
                : const SizedBox.shrink(); // يجب إرجاع Widget دائماً
          }),
          appBar: homeAppBar(
              context,
              MyString.myBooking,
              false,
              showBackButton: true,
              backToHome: true,
              controller.themeController.isDarkMode.value),
          body: Obx(() {
            //controller.getToken();
            if (Hocontroller.isLoading.value || controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
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
                        Get.offNamedUntil(
                            '/loginOptionScreen', (route) => false);
                      },
                      child: Text('تسجيل الدخول'),
                    ),
                  ],
                ),
              );
            } else {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
                              Hocontroller.selectedItem.value = 3;
                              Hocontroller.filterList('confirmed');
                            },
                            child: customContainerButton(
                              "مؤكدة",
                              3,
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
                    // أزرار الفرز (تظهر فقط للمضيف)
                    if (userType.value == 'host')
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  _showRestAreaFilterBottomSheet(context);
                                },
                                child: _buildSortButton(
                                  text: "فرز حسب الاستراحة",
                                  icon: Icons.filter_list,
                                  isDarkMode: controller
                                      .themeController.isDarkMode.value,
                                  // يمكنك إضافة حالة تحديد الزر هنا إذا أردت إظهار لون مختلف له
                                  // مثلاً إذا كان هناك فلتر استراحة مطبق
                                  isSelected: Hocontroller
                                          .selectedRestAreaIdFilter.value !=
                                      null,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  _showDateSortBottomSheet(context);
                                },
                                child: _buildSortButton(
                                  text: "فرز حسب التاريخ",
                                  icon: Icons.sort,
                                  isDarkMode: controller
                                      .themeController.isDarkMode.value,
                                  // مثلاً إذا كان هناك فلتر تاريخ مطبق
                                  isSelected: Hocontroller
                                          .selectedDateSortOrder.value !=
                                      'newest', // إذا كان ليس الافتراضي
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),

                    Expanded(
                      child: controller.isLoading.value
                          ? Center(
                              child: CircularProgressIndicator(
                                  color: controller
                                          .themeController.isDarkMode.value
                                      ? Colors.white
                                      : MyColors.successColor),
                            )
                          : ListView.builder(
                              itemCount:
                                  Hocontroller.filteredReservations.length,
                              itemBuilder: (context, index) {
                                status = Hocontroller
                                    .filteredReservations[index]['status'];
                                final currentReservation =
                                    Hocontroller.filteredReservations[index];
                                final DateTime checkInDate = DateTime.parse(
                                    currentReservation['check_in']);
                                // نخصم يوم واحد من التاريخ الحالي
                                final DateTime todayMinusOne = DateTime.now()
                                    .subtract(const Duration(days: 1));

// الشرط: يعتبر Expired إذا checkInDate أصغر من اليوم ناقص يوم
                                final bool isExpired =
                                    checkInDate.isBefore(todayMinusOne);
                                Color bgColor;
                                Color textColor;
                                if (status == 'pending') {
                                  bgColor = controller
                                          .themeController.isDarkMode.value
                                      ? Colors.orange.shade900
                                      : Colors.orange.shade100;
                                  textColor = controller
                                          .themeController.isDarkMode.value
                                      ? Colors.orange.shade200
                                      : Colors.orange.shade800;
                                } else if (status == 'completed') {
                                  bgColor = controller
                                          .themeController.isDarkMode.value
                                      ? Colors.green.shade900
                                      : Colors.green.shade100;
                                  textColor = controller
                                          .themeController.isDarkMode.value
                                      ? Colors.green.shade200
                                      : Colors.green.shade800;
                                } else if (status == 'confirmed') {
                                  bgColor = controller
                                          .themeController.isDarkMode.value
                                      ? Colors.blue.shade900
                                      : Colors.blue.shade100;
                                  textColor = controller
                                          .themeController.isDarkMode.value
                                      ? Colors.blue.shade200
                                      : Colors.blue.shade800;
                                } else {
                                  // canceled
                                  bgColor = controller
                                          .themeController.isDarkMode.value
                                      ? Colors.red.shade900
                                      : Colors.red.shade100;
                                  textColor = controller
                                          .themeController.isDarkMode.value
                                      ? Colors.red.shade200
                                      : Colors.red.shade800;
                                }
                                return Column(
                                  children: [
                                    InkWell(
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: controller.themeController
                                                  .isDarkMode.value
                                              ? MyColors
                                                  .darkSearchTextFieldColor
                                              : MyColors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                                color: controller
                                                        .themeController
                                                        .isDarkMode
                                                        .value
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
                                                      color:
                                                          Colors.grey.shade300,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(
                                                              "https://esteraha.ly/public/${Hocontroller.filteredReservations[index]['rest_area']['main_image']}"))),
                                                ),
                                                const SizedBox(width: 10),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    // إذا انتهت صلاحية الحجز
                                                    if (status == 'canceled' &&
                                                        isExpired)
                                                      const Text(
                                                        "لقد انتهت صلاحية الطلب",
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'Tajawal',
                                                        ),
                                                      ),
                                                    Text(
                                                      "${Hocontroller.filteredReservations[index]['rest_area']['name']}",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 16),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    if (status != 'pending' &&
                                                        !(status ==
                                                                'canceled' &&
                                                            isExpired))
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 15,
                                                                vertical: 5),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: bgColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        child: Text(
                                                          _getStatusText(
                                                              status),
                                                          style: TextStyle(
                                                            color: textColor,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      ),

                                                    // Buttons for "Cancel Reservation" and "Confirm Reservation"
                                                    if (status == 'pending' &&
                                                        !isExpired)
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 10),
                                                        child: Row(
                                                          children: [
                                                            // Cancel Reservation Button
                                                            GestureDetector(
                                                              onTap: () {
                                                                Get.defaultDialog(
                                                                  title:
                                                                      "تأكيد",
                                                                  middleText:
                                                                      "هل أنت متأكد من إلغاء الحجز؟",
                                                                  textConfirm:
                                                                      "نعم",
                                                                  textCancel:
                                                                      "لا",
                                                                  confirmTextColor:
                                                                      Colors
                                                                          .white,
                                                                  buttonColor:
                                                                      Colors
                                                                          .red,
                                                                  cancelTextColor:
                                                                      Colors
                                                                          .black,
                                                                  onConfirm:
                                                                      () async {
                                                                    Get.back(); // إغلاق حوار التأكيد فقط

                                                                    try {
                                                                      final currentReservation =
                                                                          Hocontroller
                                                                              .filteredReservations[index];
                                                                      final reservationId =
                                                                          currentReservation[
                                                                              'id'];

                                                                      // عرض مؤشر تحميل

                                                                      await controller
                                                                          .markReservationAscanceled(
                                                                              reservationId);

                                                                      // تحديث البيانات
                                                                      await Hocontroller
                                                                          .getReservations();
                                                                      await controller
                                                                          .getMyBooking();

                                                                      // إغلاق مؤشر التحميل
                                                                      if (Get
                                                                          .isDialogOpen!)
                                                                        Get.back();
                                                                    } catch (e) {
                                                                      // إغلاق أي حوارات مفتوحة في حالة الخطأ
                                                                      if (Get
                                                                          .isDialogOpen!)
                                                                        Get.back();

                                                                      Get.snackbar(
                                                                        "خطأ",
                                                                        "فشل في إلغاء الحجز: ${e.toString()}",
                                                                        snackPosition:
                                                                            SnackPosition.BOTTOM,
                                                                        backgroundColor:
                                                                            Colors.red,
                                                                        colorText:
                                                                            Colors.white,
                                                                        duration:
                                                                            Duration(seconds: 3),
                                                                      );
                                                                    }
                                                                  },
                                                                  onCancel:
                                                                      () {},
                                                                );
                                                              },
                                                              child: Container(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        15,
                                                                    vertical:
                                                                        8),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .redAccent,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                ),
                                                                child:
                                                                    const Row(
                                                                  children: [
                                                                    Icon(
                                                                        Icons
                                                                            .cancel,
                                                                        color: Colors
                                                                            .white,
                                                                        size:
                                                                            16),
                                                                    SizedBox(
                                                                        width:
                                                                            5),
                                                                    Text(
                                                                      "إلغاء الحجز",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            12,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width:
                                                                    10), // Space between buttons
                                                            // Confirm Reservation Button (only for host and pending status)
                                                            if (userType
                                                                    .value ==
                                                                'host')
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Get.defaultDialog(
                                                                    title:
                                                                        "تأكيد",
                                                                    middleText:
                                                                        "هل أنت متأكد من تأكيد الحجز؟",
                                                                    textConfirm:
                                                                        "نعم",
                                                                    textCancel:
                                                                        "لا",
                                                                    confirmTextColor:
                                                                        Colors
                                                                            .white,
                                                                    buttonColor:
                                                                        Colors
                                                                            .green,
                                                                    cancelTextColor:
                                                                        Colors
                                                                            .black,
                                                                    onConfirm:
                                                                        () async {
                                                                      Get.back(); // Close dialog

                                                                      // Hocontroller.confirmReservation(Hocontroller.filteredReservations[index]['id']);
                                                                      final currentReservation =
                                                                          Hocontroller
                                                                              .filteredReservations[index];

                                                                      final DateTime
                                                                          currentStartDate =
                                                                          DateTime.parse(
                                                                              currentReservation['check_in']);

                                                                      final restHouseId =
                                                                          currentReservation['rest_area']
                                                                              [
                                                                              'id'];

                                                                      final reservationId =
                                                                          currentReservation[
                                                                              'id'];
                                                                      // ابحث عن أي حجز آخر بنفس التاريخ ونفس الاستراحة

                                                                      final overlapping = Hocontroller
                                                                          .filteredReservations
                                                                          .where(
                                                                              (res) {
                                                                        final sameResthouse =
                                                                            res['rest_area']['id'] ==
                                                                                restHouseId;

                                                                        final sameDate =
                                                                            DateTime.parse(res['check_in']) ==
                                                                                currentStartDate;
                                                                        final notSame =
                                                                            res['id'] !=
                                                                                reservationId;
                                                                        final isPending =
                                                                            res['status'] ==
                                                                                'pending';
                                                                        return sameResthouse &&
                                                                            sameDate &&
                                                                            notSame &&
                                                                            isPending;
                                                                      }).toList();

                                                                      if (overlapping
                                                                          .isNotEmpty) {
                                                                        // يوجد حجز آخر بنفس التوقيت
                                                                        Get.defaultDialog(
                                                                          title:
                                                                              "تنبيه",
                                                                          middleText:
                                                                              "يوجد حجز آخر في نفس التوقيت لهذه الاستراحة. سيتم إلغاؤه تلقائيًا إذا قمت بتأكيد هذا الحجز. ماذا تريد أن تفعل؟",
                                                                          contentPadding: const EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 20,
                                                                              vertical: 10),
                                                                          confirm:
                                                                              const SizedBox(), // لمنع استخدام الزر الافتراضي
                                                                          cancel:
                                                                              const SizedBox(), // لمنع استخدام الزر الافتراضي
                                                                          actions: [
                                                                            // زر متابعة
                                                                            ElevatedButton(
                                                                              onPressed: () async {
                                                                                Get.back(); // إغلاق هذا التنبيه

                                                                                //await Hocontroller.confirmReservation(reservationId);
                                                                                await controller.markReservationAsCompleted(reservationId);
                                                                                Hocontroller.getReservations();
                                                                                controller.getMyBooking();
                                                                                for (var res in overlapping) {
                                                                                  // MY Edit
                                                                                  await controller.markReservationAscanceled(res['id']);
                                                                                }

                                                                                await Hocontroller.fetchRecentlyBooked();
                                                                                Hocontroller.update(); // 3. تحديث الواجهة
                                                                              },
                                                                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                                                              child: const Text("نعم، متابعة",
                                                                                  style: TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontFamily: 'Tajawal',
                                                                                  )),
                                                                            ),
                                                                            // زر عرض الحجوزات
                                                                            OutlinedButton(
                                                                              onPressed: () {
                                                                                Get.back(); // إغلاق التنبيه

                                                                                // فتح صفحة الحجوزات لنفس اليوم
                                                                                Get.dialog(
                                                                                  AlertDialog(
                                                                                    title: const Text("الحجوزات في هذا اليوم"),
                                                                                    content: SizedBox(height: 300, width: double.maxFinite, child: SameDayReservationsPage(reservations: overlapping)),
                                                                                    actions: [
                                                                                      TextButton(
                                                                                        onPressed: () => Get.back(),
                                                                                        child: const Text("إغلاق"),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                              },
                                                                              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                                                                              child: const Text("عرض الحجوزات لنفس اليوم", style: TextStyle(color: Colors.white)),
                                                                            ),
                                                                            // زر الإلغاء
                                                                            TextButton(
                                                                              onPressed: () {
                                                                                Get.back(); // إغلاق التنبيه
                                                                              },
                                                                              child: const Text("إلغاء", style: TextStyle(color: Colors.black)),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      } else {
                                                                        // لا يوجد تضارب
                                                                        //await Hocontroller.confirmReservation(reservationId);

                                                                        await controller
                                                                            .markReservationAsCompleted(reservationId);
                                                                        await Hocontroller
                                                                            .fetchRecentlyBooked();
                                                                        Hocontroller
                                                                            .getReservations();
                                                                        controller
                                                                            .getMyBooking();
                                                                      }
                                                                    },
                                                                    onCancel:
                                                                        () {},
                                                                  );
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          15,
                                                                      vertical:
                                                                          8),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .green,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                  ),
                                                                  child:
                                                                      const Row(
                                                                    children: [
                                                                      Icon(
                                                                          Icons
                                                                              .check_circle,
                                                                          color: Colors
                                                                              .white,
                                                                          size:
                                                                              16),
                                                                      SizedBox(
                                                                          width:
                                                                              5),
                                                                      Text(
                                                                        "تأكيد الحجز",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              12,
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
                                            Hocontroller.filteredReservations[
                                                        index]['status'] ==
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
                                                              builder:
                                                                  (context) {
                                                                return CommonBottomSheet(
                                                                  onpressed1:
                                                                      () {
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
                                                                  shadowColor1:
                                                                      Colors
                                                                          .transparent,
                                                                  textColor1: controller
                                                                          .themeController
                                                                          .isDarkMode
                                                                          .value
                                                                      ? MyColors
                                                                          .white
                                                                      : MyColors
                                                                          .primaryColor,
                                                                  onpressed2:
                                                                      () {
                                                                    Get.back();
                                                                    Get.toNamed(
                                                                        "/cancelBooking");
                                                                  },
                                                                  text2: MyString
                                                                      .yesContinue,
                                                                  mainTitle:
                                                                      MyString
                                                                          .cancelBooking,
                                                                  subTitle: MyString
                                                                      .cancelBookingSubTitle,
                                                                  description:
                                                                      MyString
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
                                                                    vertical:
                                                                        8),
                                                            alignment: Alignment
                                                                .center,
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
                                                                    ? MyColors
                                                                        .white
                                                                    : MyColors
                                                                        .primaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
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
                                                            Get.toNamed(
                                                                "/ticket",
                                                                arguments: {
                                                                  'message':
                                                                      'false'
                                                                });
                                                          },
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        8),
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: MyColors
                                                                  .primaryColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              border:
                                                                  Border.all(
                                                                color: MyColors
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                            child: const Text(
                                                              MyString
                                                                  .viewTicketButton,
                                                              style: TextStyle(
                                                                color: MyColors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
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
                                        if (Hocontroller
                                            .filteredReservations.isNotEmpty) {
                                          Get.to(() => Reservation(
                                                reservationData: {
                                                  "reservations": [
                                                    Hocontroller
                                                            .filteredReservations[
                                                        index]
                                                  ]
                                                },
                                              ));
                                        } else {
                                          // Handle case where filteredReservations is empty (optional)
                                          Get.snackbar('خطأ',
                                              'لا توجد بيانات حجز لعرضها.');
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
          })),
    );

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
}

// **أضف هذه الدالة المساعدة داخل _BookingState**
Widget _buildSortButton({
  required String text,
  required IconData icon,
  required bool isDarkMode,
  bool isSelected = false, // لتحديد ما إذا كان الزر في حالة "محدد"
}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: isSelected
          ? isDarkMode
              ? MyColors.successColor // لون عندما يكون محدد وفي الوضع الداكن
              : MyColors.primaryColor // لون عندما يكون محدد وفي الوضع الفاتح
          : isDarkMode
              ? MyColors.scaffoldDarkColor // لون عادي في الوضع الداكن
              : MyColors.white, // لون عادي في الوضع الفاتح
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: isSelected
            ? isDarkMode
                ? MyColors.successColor
                : MyColors.primaryColor
            : isDarkMode
                ? Colors.grey.shade700 // حدود أقل وضوحًا في الداكن
                : Colors.grey.shade300, // حدود خفيفة في الفاتح
      ),
      boxShadow: isSelected
          ? [
              BoxShadow(
                color: isDarkMode ? Colors.transparent : Colors.grey.shade300,
                blurRadius: 5,
                offset: const Offset(0, 3),
              )
            ]
          : [], // لا يوجد ظل إذا لم يكن محدداً
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isSelected
              ? MyColors.white
              : isDarkMode
                  ? MyColors.white
                  : MyColors.primaryColor,
          size: 18,
        ),
        const SizedBox(width: 5),
        Flexible(
          // استخدم Flexible لتجنب تجاوز النص للحدود
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected
                  ? MyColors.white
                  : isDarkMode
                      ? MyColors.white
                      : MyColors.primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 12, // حجم خط أصغر ليتناسب مع الزر
            ),
          ),
        ),
      ],
    ),
  );
}

class SameDayReservationsPage extends StatelessWidget {
  final List<dynamic> reservations;

  const SameDayReservationsPage({super.key, required this.reservations});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: ListView.builder(
          itemCount: reservations.length,
          itemBuilder: (context, index) {
            final res = reservations[index];
            return Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                title: Text(res['rest_area']['name'] ?? '---'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('من: ${res['check_in'] ?? '---'}'),
                    Text('إلى: ${res['check_out'] ?? '---'}'),
                    Text('الحالة: ${res['status'] ?? '---'}'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// دالة مساعدة
String _getStatusText(String status) {
  switch (status) {
    case 'pending':
      return MyString.ongoingButton;
    case 'completed':
      return MyString.completed;
    case 'confirmed':
      return MyString.confirmed;
    case 'canceled':
      return MyString.canceled;
    default:
      return status; // أو يمكنك إرجاع قيمة افتراضية
  }
}
