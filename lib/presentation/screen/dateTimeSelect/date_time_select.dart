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
  final id_proof_type = Get.arguments['id_proof_type'];
  final areaTypeString = Get.arguments['area_type'] ?? '';


  final proofTypes = {
    'valid_passport': ' جواز سفر ساري',
    'family_book': 'كتاب عائلة',
    'marriage_certificate': 'وثيقة زواج',
  };



  Future<void> _selectDate(
      BuildContext context, bool isFromDate, int restAreaId
      ) async {
    // جلب الأيام المحجوزة من API
    await controller.fetchReservedDates(restAreaId);

    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      selectableDayPredicate: (DateTime day) {
        if (isFromDate) {
          // تاريخ الوصول: يمنع الأيام المحجوزة
          return !controller.reservedDates.contains(day);
        } else {
          // تاريخ المغادرة: يمنع الأيام قبل الوصول فقط، يسمح بيوم دخول شخص آخر
          return day.isAfter(controller.fromDate.value) ||
              day.isAtSameMomentAs(controller.fromDate.value);
        }
      },
    );

    if (picked != null) {
      if (isFromDate) {
        controller.setFromDate(picked);
        // ضبط تاريخ المغادرة إذا أقل من الوصول
        if (picked.isAfter(controller.toDate.value)) {
          controller.setToDate(picked.add(const Duration(days: 1)));
        }
      } else {
        if (picked.isAfter(controller.fromDate.value) ||
            picked.isAtSameMomentAs(controller.fromDate.value)) {
          controller.setToDate(picked);
        } else {
          Get.defaultDialog(
            title: "خطأ",
            middleText: "يجب أن يكون تاريخ المغادرة بعد تاريخ تسجيل الوصول",
            actions: [
              TextButton(
                onPressed: () => Get.back(),
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
    final areaTypes = areaTypeString.split(','); // مثال: ["عائلات", "شباب", "مناسبات"]
    print("id_proof_type ${id_proof_type}");
    print("area_type ${areaTypeString}");
    String proofTypeText = proofTypes[id_proof_type.toString()] ?? 'غير محدد';
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
          return Container(); // العودة بواجهة فارغة مؤقتاً
        } else {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
                appBar: const CustomFullAppBar(title: MyString.selectDate),
                bottomNavigationBar: Container(
                  height: 90,
                  padding: const EdgeInsets.all(15),
                  child: Obx(
                    () => controller.isLoading.value
                        ? Center(
                            child:
                                CircularProgressIndicator()) // عرض دائرة التحميل
                        : Button(
                            onpressed: () async {
                              controller.isSubmitted.value = true;
                              print(controller.selectedType.value);

                              if (controller.selectedType.value.isEmpty ||
                                  controller.selectedType.value == '') {
                                _showErrorSnackBar(
                                    context, "يرجى اختيار نوع الإقامة");
                                return;
                              }
                              if (controller.isTermsAccepted.value==false
                                 ) {
                                _showErrorSnackBar(
                                    context, "يرجي الموافقة علي الشروط قبل الإستمرار");
                                return;
                              }

                              if (controller.dateTimeKey.currentState!
                                  .validate()) {
                                bool isTypeAllowZero =
                                    (controller.selectedType.value ==
                                        "مناسبات");

                                if (!isTypeAllowZero &&
                                    controller.adult.value == 0) {
                                  _showErrorSnackBar(context,
                                      "لا يمكن أن يكون عدد البالغين صفر");
                                  return;
                                }

                                // لو النوع لا يسمح بصفر أطفال، نجبر الأطفال على 0
                                if (!isTypeAllowZero &&
                                    controller.children.value > 0) {
                                  controller.children.value = 0;
                                }

                                // استدعاء دالة الحجز
                                print(controller.adult.value);
                                print(controller.children.value);

                                // معالجة التاريخ
                                String dateText =
                                    controller.checkInDateController.value.text;
                                DateTime date = intl.DateFormat("yyyy-MM-dd")
                                    .parse(dateText);
                                String formattedDate =
                                    intl.DateFormat("dd/MM/yyyy").format(date);
                                print("Formatted Date: $formattedDate");
                                controller.makeReservation(restId);
                              } else {
                                _showErrorSnackBar(
                                    context, "يرجى ملء جميع الحقول المطلوبة");
                              }
                            },
                            text: "إرسال طلب",
                            textSize: 16,
                            fontBold: FontWeight.w700,
                            textColor: MyColors.white,
                          ),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Obx(
                    () => Padding(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("تاريخ الوصول",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700)),
                                        const SizedBox(height: 7),
                                        Obx(
                                          () => InkWell(
                                            onTap: () {
                                              _selectDate(
                                                  context, true, restId);
                                            },
                                            child: AbsorbPointer(
                                              child: SizedBox(
                                                child: TextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'يرجى اختيار تاريخ الوصول';
                                                    }
                                                    return null;
                                                  },
                                                  controller: controller
                                                      .checkInDateController
                                                      .value,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14),
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: controller
                                                            .themeController
                                                            .isDarkMode
                                                            .value
                                                        ? MyColors
                                                            .darkTextFieldColor
                                                        : MyColors
                                                            .disabledTextFieldColor,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      borderSide:
                                                          BorderSide.none,
                                                    ),
                                                    hintText: "تاريخ الوصول",
                                                    hintStyle: const TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 13),
                                                    suffixIcon: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15),
                                                      child: SvgPicture.asset(
                                                          MyImages.datePicker),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    children: [
                                      const SizedBox(height: 20),
                                      Transform(
                                        alignment: Alignment.center,
                                        transform: Matrix4.rotationY(3.1416), // 180 درجة
                                        child: SvgPicture.asset(MyImages.dateTimeArrow),
                                      )

                                    ],
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("تاريخ المغادرة",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700)),
                                        const SizedBox(height: 7),
                                        InkWell(
                                          onTap: () {
                                            _selectDate(context, false, restId);
                                          },
                                          child: AbsorbPointer(
                                            child: SizedBox(
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'يرجى اختيار تاريخ المغادرة';
                                                  }
                                                  return null;
                                                },
                                                readOnly: true,
                                                controller: controller
                                                    .checkOutDateController
                                                    .value,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14),
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: controller
                                                          .themeController
                                                          .isDarkMode
                                                          .value
                                                      ? MyColors
                                                          .darkTextFieldColor
                                                      : MyColors
                                                          .disabledTextFieldColor,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  hintText: "تاريخ المغادرة",
                                                  hintStyle: const TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 13),
                                                  suffixIcon: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    child: SvgPicture.asset(
                                                        MyImages.datePicker),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("عدد النزلاء (البالغين)",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700)),
                                        const SizedBox(height: 7),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: controller.themeController
                                                    .isDarkMode.value
                                                ? MyColors.darkTextFieldColor
                                                : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                color: controller
                                                        .themeController
                                                        .isDarkMode
                                                        .value
                                                    ? Colors.grey.shade700
                                                    : Colors.black
                                                        .withOpacity(0.2)),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  return controller
                                                      .adultDecrement();
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                    color: controller
                                                            .themeController
                                                            .isDarkMode
                                                            .value
                                                        ? Colors.grey.shade700
                                                        : Colors.black
                                                            .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: const Text("-",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 20)),
                                                ),
                                              ),
                                              Text("${controller.adult.value}",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 24)),
                                              InkWell(
                                                onTap: () {
                                                  return controller
                                                      .adultIncrement();
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                    color: controller
                                                            .themeController
                                                            .isDarkMode
                                                            .value
                                                        ? Colors.grey.shade700
                                                        : Colors.black
                                                            .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: const Text("+",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 20)),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("عدد النزلاء (الأطفال)",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700)),
                                        const SizedBox(height: 7),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: controller.themeController
                                                    .isDarkMode.value
                                                ? MyColors.darkTextFieldColor
                                                : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                color: controller
                                                        .themeController
                                                        .isDarkMode
                                                        .value
                                                    ? Colors.grey.shade700
                                                    : Colors.black
                                                        .withOpacity(0.2)),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  return controller
                                                      .childrenDecrement();
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                    color: controller
                                                            .themeController
                                                            .isDarkMode
                                                            .value
                                                        ? Colors.grey.shade700
                                                        : Colors.black
                                                            .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: const Text("-",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 20)),
                                                ),
                                              ),
                                              Text(
                                                  "${controller.children.value}",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 24)),
                                              InkWell(
                                                onTap: () {
                                                  return controller
                                                      .childrenIncrement();
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                    color: controller
                                                            .themeController
                                                            .isDarkMode
                                                            .value
                                                        ? Colors.grey.shade700
                                                        : Colors.black
                                                            .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: const Text("+",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 20)),
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: areaTypes.map<Widget>((type) {
                                  return Flexible(
                                    child: RadioListTile<String>(
                                      title: Text(
                                        type,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: controller.themeController.isDarkMode.value
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      value: type,
                                      groupValue: controller.selectedType.value,
                                      onChanged: (value) {
                                        controller.selectedType.value = value!;
                                      },
                                      contentPadding: EdgeInsets.zero,
                                      dense: true,
                                    ),
                                  );
                                }).toList(), // ✅ حل المشكلة
                              ),

                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 4,
                                margin: const EdgeInsets.all(12),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "إثبات الهوية المطلوب:",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.perm_identity, color: Colors.teal, size: 28),
                                          const SizedBox(width: 12),
                                          Text(
                                            proofTypeText,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 4,
                                margin: const EdgeInsets.all(12),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 16,right: 16),

                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      // عنوان الشروط
                                      const Text(
                                        "شروط الإقامة",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54,
                                          fontFamily: "Tajawal",
                                        ),
                                      ),
                                      const SizedBox(height: 12),

                                      // نص الشروط مع Checkbox
                                      Obx(
                                            () => CheckboxListTile(
                                          value: controller.isTermsAccepted.value,
                                          onChanged: (value) {
                                            controller.isTermsAccepted.value = value ?? false;
                                          },
                                          activeColor: Colors.teal,
                                          title: RichText(

                                            text: const TextSpan(
                                              style: TextStyle(
                                                fontSize: 15,

                                                color: Colors.black87,
                                                fontFamily: "Tajawal",
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: "نرجو من ضيوفنا الكرام\n",
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                                TextSpan(
                                                  text:
                                                  "الالتزام بمواعيد الحضور والمغادرة المحددة، والمحافظة على نظافة المكان وممتلكاته وعدم إحداث أي أضرار بالأثاث أو المرافق، مع ارتداء الملابس المخصصة عند استخدام المسبح ومراقبة الأطفال لضمان سلامتهم. كما يُرجى تجنب إصدار الأصوات الصاخبة أو إزعاج الجيران أو إيقاف السيارات أمام منازلهم، وعدم التدخين في الأماكن المغلقة أو استخدام الاستراحة في أنشطة مخالفة للقانون أو الآداب العامة. في حال حدوث أي أضرار، يتحمل الضيف تكاليف الإصلاح كاملة، ويُعفى صاحب الاستراحة من المسؤولية عن فقدان المقتنيات الشخصية، وله الحق في إنهاء الإقامة عند مخالفة هذه الشروط دون استرداد المبلغ المدفوع.",
                                                ),
                                              ],
                                            ),
                                          ),
                                          controlAffinity: ListTileControlAffinity.leading,
                                        ),
                                      ),
                                      const SizedBox(height: 16),

                                      // زر التواصل على الواتس

                                    ],
                                  ),
                                ),
                              ),



                              const SizedBox(height: 12),


                            ],
                          ),
                        )),
                  ),
                )),
          );
        }
      },
    );
  }
}

void _showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
