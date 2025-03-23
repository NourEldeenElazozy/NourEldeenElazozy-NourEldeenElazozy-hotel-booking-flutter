part of 'payment_import.dart';

class PaymentChoice extends StatefulWidget {
  final String? cardNumber;
  final bool? status;
  const PaymentChoice({super.key, this.cardNumber, this.status});

  @override
  State<PaymentChoice> createState() => _PaymentChoiceState();
}

class _PaymentChoiceState extends State<PaymentChoice> {

  late PaymentController controller;

  @override
  void initState() {
    controller = Get.put(PaymentController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomFullAppBar(title: MyString.payment),
      bottomNavigationBar: Container(
        height: 90,
        padding: const EdgeInsets.all(15),
        child:
        Button(
          onpressed: () {
            return controller.paymentContinue(context);
          },
          text: MyString.continueButton,
          shadowColor: controller.themeController.isDarkMode.value ? Colors.transparent : MyColors.buttonShadowColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            commonTitle(MyString.paymentMethod, MyString.addNewCard, controller.themeController.isDarkMode.value),
            const SizedBox(height: 30),
            commonCancelBooking(1, MyImages.paypal, MyString.paypal, controller.themeController.isDarkMode.value),
            const SizedBox(height: 20),
            commonCancelBooking(2, MyImages.googlePay, MyString.googlePay, controller.themeController.isDarkMode.value),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                controller.selectPayment.value = 3;
                controller.paymentImage.value = MyImages.applePay;
                controller.paymentType.value = MyString.applePay;
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(MyImages.applePay, colorFilter: ColorFilter.mode(controller.themeController.isDarkMode.value ? MyColors.white : MyColors.black , BlendMode.srcIn),),
                    const SizedBox(width: 12),
                    const Text(MyString.applePay, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    const Spacer(),
                    Obx(() => Radio(
                      value: 3,
                      groupValue: controller.selectPayment.value,
                      activeColor: controller.themeController.isDarkMode.value ? Colors.white : Colors.black,
                      fillColor: MaterialStatePropertyAll(controller.themeController.isDarkMode.value ? Colors.white : Colors.black),
                      onChanged: (value) {
                        controller.selectPayment.value = value!;
                        controller.paymentImage.value = MyImages.applePay;
                        controller.paymentType.value = MyString.applePay;
                      },
                    ),),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            commonTitle(MyString.payDebitCreditCard, MyString.changeCard, controller.themeController.isDarkMode.value),
            const SizedBox(height: 30),
            commonCancelBooking(4, MyImages.cardTypeSvg, MyString.cardNumberShow, controller.themeController.isDarkMode.value),
          ],
        ),
      ),
    );
  }

  Widget commonCancelBooking(int index, String image, String paymentName, bool isDarkMode) {
    return InkWell(
      onTap: () {
        controller.selectPayment.value = index;
        controller.paymentImage.value = image;
        controller.paymentType.value = paymentName;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: isDarkMode ? MyColors.darkTextFieldColor : MyColors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            SvgPicture.asset(image),
            const SizedBox(width: 12),
            Text(paymentName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const Spacer(),
            Obx(() => Radio(
              value: index,
              groupValue: controller.selectPayment.value,
              activeColor: controller.themeController.isDarkMode.value ? Colors.white : Colors.black,
              fillColor: MaterialStatePropertyAll(controller.themeController.isDarkMode.value ? Colors.white : Colors.black),
              onChanged: (value) {
                controller.selectPayment.value = value!;
                controller.paymentImage.value = image;
                controller.paymentType.value = paymentName;
              },
            ),),
          ],
        ),
      ),
    );
  }

  Widget commonTitle(String titleName, String subTitleName, bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(titleName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        InkWell(
          onTap: () {
            Get.toNamed("/addNewCard");
          },
          child: Container(
            padding: const EdgeInsets.all(5),
            child: Text(subTitleName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          ),
        ),
      ],
    );
  }
}




