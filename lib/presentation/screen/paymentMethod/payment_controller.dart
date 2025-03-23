part of 'payment_import.dart';

class PaymentController extends GetxController {
  ThemeController themeController = Get.put(ThemeController());

  RxInt selectPayment = 0.obs;
  late RxString paymentType;
  late RxString paymentImage;

  @override
  void onInit() {
    paymentType = ''.obs;
    paymentImage = ''.obs;
    super.onInit();
  }

  void paymentContinue(BuildContext context) {
    if(selectPayment.value == 0) {
      showErrorMsg(context: context, message: "Select any One Payment Type");
    }
    else {
      Get.toNamed("/paymentInfo", arguments: {'image' : paymentImage,'name': paymentType});
    }
  }

//----------------------------------- AddNewCard -------------------------------

  final GlobalKey<FormState> newCardKey = GlobalKey<FormState>();

  TextEditingController holderName = TextEditingController();
  TextEditingController cardNumber = TextEditingController();
  TextEditingController expiryDate = TextEditingController();
  TextEditingController cvvNumber = TextEditingController();

  String? nameValidation(String?value) {
    if(value!.isEmpty) {
      return "Holder Name is required.";
    }
    return null;
  }

  String? cardNumberValidation(String? value) {
    if(value!.isEmpty) {
      return "Card Number is required.";
    } else if (value.length < 19) {
      return "Enter valid Card Number";
    }
    return null;
  }

  String? expiryNumberValidation(String? value) {
    if(value!.isEmpty) {
      return "Expiry Number is required.";
    } else if (value.length < 5) {
      return "Enter valid Card Number";
    }
    return null;
  }

  String? cvvNumberValidation(String? value) {
    if(value!.isEmpty) {
      return "CVV Number is required.";
    } else if (value.length < 3) {
      return "Enter valid CVV Number";
    }
    return null;
  }

  void addCardSubmit() {
    final isValid = newCardKey.currentState!.validate();
    Get.focusScope!.unfocus();
    if (!isValid) {
      return;
    } else {
      Get.back();
    }
    newCardKey.currentState!.save();
  }
}