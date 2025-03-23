part of 'payment_info_import.dart';

class PaymentInfoController extends GetxController {
  ThemeController themeController = Get.put(ThemeController());
  DateTimeSelectController dateTimeSelectController = Get.put(DateTimeSelectController());
  late RxString image;
  late RxString paymentTypename;
  late String checkIn;
  late String checkOut;
  late int adult;
  late int children;

  @override
  void onInit() {
    image = Get.arguments['image'];
    paymentTypename = Get.arguments['name'];
    convertDateFormat();
    super.onInit();
  }

  void convertDateFormat() {
    checkIn = DateFormat('MMMM dd, yyyy').format(dateTimeSelectController.fromDate.value);
    checkOut = DateFormat('MMMM dd, yyyy').format(dateTimeSelectController.toDate.value);
    adult = dateTimeSelectController.adult.value;
    children = dateTimeSelectController.adult.value;
  }

}