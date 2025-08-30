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

  final args = Get.arguments as Map;
  @override
  void initState() {
    controller = Get.put(PaymentController());
    super.initState();

    print(args['data']); // أو خزّنها في متغير
    print("unpaidData ${args['unpaidData']}"); // أو خزّنها في متغير
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const CustomFullAppBar(title: MyString.payment),
        bottomNavigationBar: Container(
          height: 90,
          padding: const EdgeInsets.all(15),
          child:
          Button(
            onpressed: () {

              controller.price.value = double.parse(args['data'].toString()).roundToDouble();

              print("objects ${controller.price.value}");

              if (args != null && args['unpaidData'] != null) {
                controller.unpaidData = List<Map<String, dynamic>>.from(args['unpaidData']);
                print('Received unpaid data: ${controller.unpaidData}');
              }

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

              const SizedBox(height: 30),
              commonCancelBooking(1, MyImages.money, MyString.cash, controller.themeController.isDarkMode.value),
              const SizedBox(height: 20),
              commonCancelBooking(2, MyImages.tlync, MyString.tlync, controller.themeController.isDarkMode.value),
              const SizedBox(height: 20),
       /*
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
        */
            ],
          ),
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isDarkMode ? MyColors.darkTextFieldColor : MyColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: controller.selectPayment.value == index
                ? MyColors.primaryColor
                : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            ClipOval(
              child: Image.asset(image, height: 50, width: 50, fit: BoxFit.contain),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                paymentName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            Obx(() => Icon(
              controller.selectPayment.value == index
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: controller.selectPayment.value == index
                  ? MyColors.primaryColor
                  : (isDarkMode ? Colors.white54 : Colors.black38),
            )),
          ],
        ),
      ),
    );
  }

/*
  Widget commonTitle(String titleName, String subTitleName, bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(titleName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        InkWell(
          onTap: () {
            Get.toNamed("/PaymentScreen");
          },
          child: Container(
            padding: const EdgeInsets.all(5),
            child: Text(subTitleName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          ),
        ),
      ],
    );
  }

 */
}




