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

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFromDate ? controller.fromDate.value : controller.toDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      selectableDayPredicate: (DateTime day) {
        if (isFromDate) {
          return true;
        } else {
          return controller.isToDateSelectable(day);
        }
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
            title: "Error",
            middleText: "Check-out date must be after check-in date",
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("Close"),
              ),
            ],
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: const CustomFullAppBar(
        title: MyString.selectDate
      ),
      bottomNavigationBar: Container(
        height: 90,
        padding: const EdgeInsets.all(15),
        child: Button(
          onpressed: () {
            return controller.dateTimeValidation(context);
            // Get.toNamed("/dateTimeSelect");
          },
          text: MyString.continueButton,
          textSize: 16,
          fontBold: FontWeight.w700,
          textColor: MyColors.white,
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
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Check In Date", style: TextStyle(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 7),
                          Obx(() => InkWell(
                            onTap: () {
                              _selectDate(context, true);
                              // controller.checkInDate(context);
                            },
                            child: AbsorbPointer(
                              child: SizedBox(
                                child: TextFormField(

                                  controller: controller.checkInDateController.value,
                                  // validator: (value) {
                                  //   return controller.checkInDateValidation(value!);
                                  // },
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.disabledTextFieldColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    hintText: MyString.checkInDate,
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
                          const Text("Check Out Date", style: TextStyle(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 7),
                          InkWell(
                            onTap: () {
                              // controller.checkOutDate(context);
                              _selectDate(context, false);
                            },
                            child: AbsorbPointer(
                              child: SizedBox(
                                child: TextFormField(
                                  readOnly: true,
                                  controller: controller.checkOutDateController.value,
                                  // validator: (value) {
                                  //   return controller.checkOutDateValidation(value!);
                                  // },
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.disabledTextFieldColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    hintText: MyString.checkOutDate,
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
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Check In Time", style: TextStyle(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 7),
                          InkWell(
                            onTap: () {
                              controller.checkInTime(context);
                            },
                            child: AbsorbPointer(
                              child: SizedBox(
                                child: TextFormField(
                                  // readOnly: true,
                                  controller: controller.checkInTimeController.value,
                                  // validator: (value) {
                                  //   return controller.checkInTimeValidation(value!);
                                  // },
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.disabledTextFieldColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    hintText: MyString.checkInTime,
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
                          const Text("Check Out Time", style: TextStyle(fontWeight: FontWeight.w700)),
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
                                  // validator: (value) {
                                  //   return controller.checkOutTimeValidation(value!);
                                  // },
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.disabledTextFieldColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    hintText: MyString.checkOutTime,
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
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Guest (Adult)", style: TextStyle(fontWeight: FontWeight.w700)),
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
                                      borderRadius: BorderRadius.circular(8)
                                    ),
                                    child: const Text("-", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),),
                                  ),
                                ),
                                Text("${controller.adult.value}", style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 24),),
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
                                        borderRadius: BorderRadius.circular(8)
                                    ),
                                    child: const Text("+", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Text()
                        ],
                      ),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Guest (Children)", style: TextStyle(fontWeight: FontWeight.w700)),
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
                                        borderRadius: BorderRadius.circular(8)
                                    ),
                                    child: const Text("-", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),),
                                  ),
                                ),
                                Text("${controller.children.value}", style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 24),),
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
                                    child: const Text("+", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),),
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
              ],
            ),
          )
        ),),
      )
    );
  }
}