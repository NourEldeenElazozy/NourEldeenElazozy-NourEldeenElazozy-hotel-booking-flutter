part of 'date_time_select_import.dart';

class DateTimeSelect extends StatefulWidget {
  const DateTimeSelect({super.key});

  @override
  State<DateTimeSelect> createState() => _DateTimeSelectState();
}

class _DateTimeSelectState extends State<DateTimeSelect> {

  late DateTimeSelectController controller;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    controller = Get.put(DateTimeSelectController());

    super.initState();
  }
  Future<String?> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  final restId = Get.arguments['restAreaId'];
  Future<void> _selectDate(BuildContext context, bool isFromDate, int restAreaId) async {
    // جلب الأيام المحجوزة من API
    await controller.fetchReservedDates(restId);

    final DateTime? picked = await showDatePicker(
      context: context,

      //initialDate: isFromDate ? controller.fromDate.value : controller.toDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      selectableDayPredicate: (DateTime day) {
        // تحقق مما إذا كان اليوم محجوزًا
        return !controller.reservedDates.contains(day);
      },
    );

    if (picked != null) {
      if (isFromDate) {
        controller.setFromDate(picked);
        if (picked.isAfter(controller.toDate.value)) {
          controller.setToDate(picked.add(const Duration(days: 1)));
        }
      } else {
        if (picked.isAfter(controller.fromDate.value)) {
          controller.setToDate(picked);
        } else {
          Get.defaultDialog(
            title: "خطاء",
            middleText: "يجب أن يكون تاريخ المغادرة بعد تاريخ تسجيل الوصول",
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("إغلاق"),
              ),
            ],
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    controller.fetchReservedDates(restId);
    return FutureBuilder(
      future: _loadToken(),
      builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text("Error: ${snapshot.error}"));
    } else if (!snapshot.hasData || snapshot.data == null) {
      // توجيه المستخدم إلى صفحة تسجيل الدخول إذا لم يوجد توكن
      Future.microtask(() => Get.offNamed('/loginOptionScreen'));
      return Container();  // العودة بواجهة فارغة مؤقتاً

    }else{


        return  Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(

              appBar: const CustomFullAppBar(
                  title: MyString.selectDate
              ),
              bottomNavigationBar: Container(
                height: 90,
                padding: const EdgeInsets.all(15),
                child: Obx(() => controller.isLoading.value
                    ? Center(child: CircularProgressIndicator()) // عرض دائرة التحميل
                    : Button(

                  onpressed: () async {


                    controller.isSubmitted.value = true;
                    print("Ssss");
                    if (controller.selectedType.value.isEmpty) {
                      Get.snackbar("خطأ", "يرجى اختيار نوع الإقامة", backgroundColor: Colors.red, colorText: Colors.white);
                      return;
                    }
                    if (controller.dateTimeKey.currentState!.validate()) {
                      if(controller.adult.value==0){
                        Get.snackbar("خطأ", "لايمكن ان يكون عدد البالغين صفر",backgroundColor: Colors.red);
                      }else{
                        // استدعاء دالة التحميل
                        print(controller.adult.value);
                        print(controller.children.value);
                        //controller.loading();
                        controller.makeReservation(restId);
                        // معالجة التاريخ
                        String dateText = controller.checkInDateController.value.text; // "27 Mar 2025"
                        DateTime date = intl.DateFormat("dd MMM yyyy").parse(dateText);
                        String formattedDate = intl.DateFormat("dd/MM/yyyy").format(date);




                        // تنفيذ التحقق من التاريخ
                        //controller.dateTimeValidation(context);

                        // إغلاق التحميل بعد الانتهاء من العملية
                        //controller.dismissLoading();

                        // يمكنك الانتقال إلى صفحة أخرى إذا كان ذلك مطلوبًا
                        // Get.toNamed("/dateTimeSelect");
                      }

                    } else {
                      // ❌ أحد التواريخ غير موجود
                      Get.snackbar("خطأ", "يرجى ملء جميع الحقول المطلوبة",backgroundColor: Colors.red);
                    }

                  },
                  text: MyString.continueButton,
                  textSize: 16,
                  fontBold: FontWeight.w700,
                  textColor: MyColors.white,
                ),
                ),
              ),

              body: SingleChildScrollView(
                child: Obx(() => Padding(
                    padding: const EdgeInsets.all(15),
                    child: Form(
                      key: controller.dateTimeKey,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            /*
                            decoration: BoxDecoration(
                              color: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : Colors.green.shade50,
                              borderRadius: BorderRadius.circular(15),
                            ),

                        child: TableCalendar(
                          focusedDay: _focusedDay,
                          firstDay: DateTime.utc(1950),
                          lastDay: DateTime.utc(2050),
                          selectedDayPredicate: (day) {
                            return isSameDay(_selectedDay, day);
                          },
                          rangeStartDay: _rangeStart,
                          rangeEndDay: _rangeEnd,
                          calendarFormat: _calendarFormat,
                          rangeSelectionMode: _rangeSelectionMode,
                          calendarStyle: CalendarStyle(
                            rangeHighlightColor: controller.themeController.isDarkMode.value ? Colors.black : Colors.grey.shade300,
                            rangeStartDecoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                            rangeEndDecoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                          ),
                          onDaySelected: (selectedDay, focusedDay) {
                            if (!isSameDay(_selectedDay, selectedDay)) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                                _rangeStart = null; // Important to clean those
                                _rangeEnd = null;
                                _rangeSelectionMode = RangeSelectionMode.toggledOff;
                              });
                            }
                          },
                          onRangeSelected: (start, end, focusedDay) {
                            setState(() {
                              _selectedDay = null;
                              _focusedDay = focusedDay;
                              _rangeStart = start;
                              _rangeEnd = end;
                              _rangeSelectionMode = RangeSelectionMode.toggledOn;
                            });
                          },
                          onFormatChanged: (format) {
                            if (_calendarFormat != format) {
                              setState(() {
                                _calendarFormat = format;
                              });
                            }
                          },
                          onPageChanged: (focusedDay) {
                            _focusedDay = focusedDay;
                          },
                        ),
                         */
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("تاريخ الوصول", style: TextStyle(fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 7),
                                    Obx(() => InkWell(
                                      onTap: () {
                                        _selectDate(context, true,restId);
                                      },
                                      child: AbsorbPointer(
                                        child: SizedBox(
                                          child: TextFormField(
                                            validator:  (value) {
    if (value == null || value.isEmpty) {
    return 'يرجى اختيار تاريخ الوصول';
    }
    return null;
                                            },
                                            controller: controller.checkInDateController.value,
                                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.disabledTextFieldColor,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(15),
                                                borderSide: BorderSide.none,
                                              ),
                                              hintText: "تاريخ الوصول",
                                              hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 13),
                                              suffixIcon: Padding(
                                                padding: const EdgeInsets.all(15),
                                                child: SvgPicture.asset(MyImages.datePicker),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),)
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                children: [
                                  const SizedBox(height: 20),
                                  SvgPicture.asset(MyImages.dateTimeArrow),
                                ],
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("تاريخ المغادرة", style: TextStyle(fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 7),
                                    InkWell(
                                      onTap: () {
                                        _selectDate(context, false,restId);
                                      },
                                      child: AbsorbPointer(
                                        child: SizedBox(
                                          child: TextFormField(
                                            validator:  (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'يرجى اختيار تاريخ المغادرة';
                                              }
                                              return null;
                                            },
                                            readOnly: true,
                                            controller: controller.checkOutDateController.value,
                                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.disabledTextFieldColor,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(15),
                                                borderSide: BorderSide.none,
                                              ),
                                              hintText: "تاريخ المغادرة",
                                              hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 13),
                                              suffixIcon: Padding(
                                                padding: const EdgeInsets.all(15),
                                                child: SvgPicture.asset(MyImages.datePicker),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),


                        /*
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("وقت الوصول", style: TextStyle(fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 7),
                                    InkWell(
                                      onTap: () {
                                        controller.checkInTime(context);
                                      },
                                      child: AbsorbPointer(
                                        child: SizedBox(
                                          child: TextFormField(
                                            controller: controller.checkInTimeController.value,
                                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.disabledTextFieldColor,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(15),
                                                borderSide: BorderSide.none,
                                              ),
                                              hintText: "وقت الوصول",
                                              hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 13),
                                              suffixIcon: Padding(
                                                padding: const EdgeInsets.all(15),
                                                child: SvgPicture.asset(MyImages.timePicker),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                children: [
                                  const SizedBox(height: 20),
                                  SvgPicture.asset(MyImages.dateTimeArrow),
                                ],
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("وقت المغادرة", style: TextStyle(fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 7),
                                    InkWell(
                                      onTap: () {
                                        controller.checkOutTime(context);
                                      },
                                      child: AbsorbPointer(
                                        child: SizedBox(
                                          child: TextFormField(
                                            readOnly: true,
                                            controller: controller.checkOutTimeController.value,
                                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.disabledTextFieldColor,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(15),
                                                borderSide: BorderSide.none,
                                              ),
                                              hintText: "وقت المغادرة",
                                              hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 13),
                                              suffixIcon: Padding(
                                                padding: const EdgeInsets.all(15),
                                                child: SvgPicture.asset(MyImages.timePicker),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                         */
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("عدد النزلاء (البالغين)", style: TextStyle(fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 7),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: controller.themeController.isDarkMode.value ? Colors.grey.shade700 : Colors.black.withOpacity(0.2)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              return controller.adultDecrement();
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                color: controller.themeController.isDarkMode.value ? Colors.grey.shade700 :  Colors.black.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: const Text("-", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
                                            ),
                                          ),
                                          Text("${controller.adult.value}", style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 24)),
                                          InkWell(
                                            onTap: () {
                                              return controller.adultIncrement();
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                color: controller.themeController.isDarkMode.value ? Colors.grey.shade700 : Colors.black.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: const Text("+", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 30),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("عدد النزلاء (الأطفال)", style: TextStyle(fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 7),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: controller.themeController.isDarkMode.value ? Colors.grey.shade700 : Colors.black.withOpacity(0.2)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              return controller.childrenDecrement();
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                color: controller.themeController.isDarkMode.value ? Colors.grey.shade700 : Colors.black.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: const Text("-", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
                                            ),
                                          ),
                                          Text("${controller.children.value}", style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 24)),
                                          InkWell(
                                            onTap: () {
                                              return controller.childrenIncrement();
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                color: controller.themeController.isDarkMode.value ? Colors.grey.shade700 : Colors.black.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: const Text("+", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("نوع الإقامة", style: TextStyle(fontWeight: FontWeight.w700)),

                              Obx(() => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: RadioListTile<String>(
                                          title: const Text("عائلات"),
                                          value: "عائلات",
                                          groupValue: controller.selectedType.value,
                                          onChanged: (value) {
                                            controller.selectedType.value = value!;
                                          },
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                      Expanded(
                                        child: RadioListTile<String>(
                                          title: const Text("شباب"),
                                          value: "شباب",
                                          groupValue: controller.selectedType.value,
                                          onChanged: (value) {
                                            controller.selectedType.value = value!;
                                          },
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                      Expanded(
                                        child: RadioListTile<String>(
                                          title: const Text("مناسبة"),
                                          value: "مناسبة",
                                          groupValue: controller.selectedType.value,
                                          onChanged: (value) {
                                            controller.selectedType.value = value!;
                                          },
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ],
                                  ),

                                  // شرط الفلديشن: عرض رسالة إذا لم يتم اختيار نوع الإقامة
                                  if (controller.isSubmitted.value && controller.selectedType.value.isEmpty)
                                    const Padding(
                                      padding: EdgeInsets.only(right: 12.0, top: 4),
                                      child: Text(
                                        "يرجى اختيار نوع الإقامة",
                                        style: TextStyle(color: Colors.red, fontSize: 12),
                                      ),
                                    ),
                                ],
                              )),
                            ],
                          ),

                        ],
                      ),
                    )
                ),),
              )
          ),
        );
    }
      },

    );
  }
}