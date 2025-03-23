part of 'date_time_select_import.dart';

class DateTimeSelectController extends GetxController {
  ThemeController themeController = Get.put(ThemeController());

  final GlobalKey<FormState> dateTimeKey = GlobalKey<FormState>();

  Rx<TextEditingController> checkInDateController = TextEditingController().obs;
  Rx<TextEditingController> checkOutDateController = TextEditingController().obs;

  /*DateTime selectCheckInDate = DateTime.now();
  DateTime selectCheckOutDate = DateTime.now();*/


  Rx<DateTime> fromDate = DateTime.now().obs;
  Rx<DateTime> toDate = DateTime.now().obs;

  void setFromDate(DateTime date) {
    fromDate.value = date;
    checkInDateController.value.text=  DateFormat('dd MMM yyyy').format(fromDate.value);
  }

  void setToDate(DateTime date) {
    toDate.value = date;
    checkOutDateController.value.text=  DateFormat('dd MMM yyyy').format(toDate.value);
  }

  bool isToDateSelectable(DateTime day) {
    return day.isAfter(fromDate.value.subtract(const Duration(days: 1))) || day.isAtSameMomentAs(fromDate.value);
  }

 /* Future<void> checkInDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectCheckInDate,
      firstDate:  DateTime.now(), // Sets minimum date selection to today
      lastDate: DateTime(2050),
    );
    if (pickedDate != null && pickedDate != selectCheckInDate) {
      selectCheckInDate = pickedDate;
      checkInDateController.value.text = DateFormat('MMMd').format(selectCheckInDate);
    }
  }

  Future<void> checkOutDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectCheckOutDate,
      firstDate:  DateTime.now(), // Sets minimum date selection to today
      lastDate: DateTime(2050),
    );
    if (pickedDate != null && pickedDate != selectCheckOutDate) {
      selectCheckOutDate = pickedDate;
      checkOutDateController.value.text = DateFormat('MMMd').format(selectCheckOutDate);
    }
  }*/

//--------------------------------- Time Picker ---------------------------------
  Rx<TextEditingController> checkInTimeController = TextEditingController().obs;
  Rx<TextEditingController> checkOutTimeController = TextEditingController().obs;

  TimeOfDay selectCheckInTime = TimeOfDay.now();
  TimeOfDay selectCheckOutTime = TimeOfDay.now();

  Future<void> checkInTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectCheckInTime,

    );
    if (pickedTime != null) {
      selectCheckInTime = pickedTime;
      String period = selectCheckInTime.period == DayPeriod.am ? 'am' : 'pm';
      String formattedTime = '${selectCheckInTime.hourOfPeriod.toString().padLeft(2,'0')} : ${selectCheckInTime.minute.toString().padLeft(2,'0')} $period';
      checkInTimeController.value.text = formattedTime;
    }
  }

  Future<void> checkOutTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectCheckOutTime,
    );
    if (pickedTime != null) {
        selectCheckOutTime = pickedTime;
        String period = selectCheckOutTime.period == DayPeriod.am ? 'am' : 'pm';
        String formattedTime = '${selectCheckOutTime.hourOfPeriod.toString().padLeft(2,'0')} : ${selectCheckOutTime.minute.toString().padLeft(2,'0')} $period';
        checkOutTimeController.value.text = formattedTime;
      }
  }
//--------------------------------- Adult - Children ---------------------------------
  RxInt adult = 0.obs;
  RxInt children = 0.obs;

  void adultIncrement() async {
    adult.value ++;
  }

  void adultDecrement() async {
    if(adult.value != 0 ) {
      adult.value --;
    }
  }

  void childrenIncrement() async {
    children.value ++;
  }

  void childrenDecrement() async {
    if(children.value != 0 ) {
      children.value --;
    }
  }

  void dateTimeValidation(BuildContext context) {
    if(checkInDateController.value.text.isEmpty) {
      showErrorMsg(context: context, message: "Select Check In Date");
    } else if(checkOutDateController.value.text.isEmpty) {
      showErrorMsg(context: context, message: "Select Check Out Date");
    } else if(checkInTimeController.value.text.isEmpty) {
      showErrorMsg(context: context, message: "Select Check In Time");
    } else if(checkOutTimeController.value.text.isEmpty) {
      showErrorMsg(context: context, message: "Select Check Out Time");
    } else if(adult <= 0) {
      showErrorMsg(context: context, message: "1 Adult Compulsory");
    } else {
      Get.toNamed("/selectRoom");
    }
  }
}