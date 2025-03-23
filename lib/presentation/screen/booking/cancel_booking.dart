part of 'booking_import.dart';

class CancelBooking extends StatefulWidget {
  const CancelBooking({super.key});

  @override
  State<CancelBooking> createState() => _CancelBookingState();
}

class _CancelBookingState extends State<CancelBooking> {

  late BookingController controller;

  @override
  void initState() {
    controller = Get.put(BookingController());
    controller.selectPayment.value = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomFullAppBar(title: MyString.cancelHotelBooking),
      bottomNavigationBar: Container(
        height: 90,
        padding: const EdgeInsets.all(15),
        child: Button(
          onpressed: () {
            return controller.cancelContinue(context);
            // Get.toNamed("/paymentInfo");
          },
          text: MyString.confirmCancel,
        ),
      ),
      body: Obx(() => Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const Text(MyString.refundDescription, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),),
            const SizedBox(height: 30),
            commonCancelBooking(1, MyImages.paypal, MyString.paypal),
            const SizedBox(height: 20),
            commonCancelBooking(2, MyImages.googlePay, MyString.googlePay),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                controller.selectPayment.value = 3;
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
                      },
                    ),),
                  ],
                ),
              ),
            ),
            // commonCancelBooking(3, MyImages.applePay, MyString.applePay, controller.themeController.isDarkMode.value),
            const SizedBox(height: 20),
            commonCancelBooking(4, MyImages.cardTypeSvg, MyString.cardNumberShow),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${MyString.paid}: 379.5",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: controller.themeController.isDarkMode.value ? MyColors.white : MyColors.profileListTileColor,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: controller.themeController.isDarkMode.value ? MyColors.white : MyColors.profileListTileColor
                  ),
                ),
                const SizedBox(width: 15),
                Text("${MyString.refund}: 383.8", style: TextStyle(color: controller.themeController.isDarkMode.value ? MyColors.white : MyColors.profileListTileColor, fontWeight: FontWeight.w700, fontSize: 16)),
              ],
            ),
          ],
        ),
      ),)
    );
  }
  Widget commonCancelBooking(int index, String image, String paymentName) {
    return InkWell(
      onTap: () {
        controller.selectPayment.value = index;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.white,
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
              },
            ),),
          ],
        ),
      ),
    );
  }
}



