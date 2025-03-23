part of 'payment_info_import.dart';

class PaymentInfo extends StatefulWidget {
  const PaymentInfo({super.key});

  @override
  State<PaymentInfo> createState() => _PaymentInfoState();
}

class _PaymentInfoState extends State<PaymentInfo> {

  late PaymentInfoController controller;

  @override
  void initState() {
    controller = Get.put(PaymentInfoController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomFullAppBar(title: MyString.payment),
      bottomNavigationBar: Container(
        height: 90,
        padding: const EdgeInsets.all(15),
        child: Button(
          onpressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return CongratulationDialog(
                  onpressed: () {
                    Get.toNamed('/ticket', arguments: {'message' : 'true'});
                  },
                  status: true,
                  title: MyString.paymentSuccessFull,
                  subTitle: MyString.paymentSuccessFullSubTitle,
                  buttonName: MyString.viewTicket,
                  onpressed2: () {
                     Get.offNamedUntil('/bottomBar', (route) => false);
                  },
                  buttonName2: MyString.cancel,
                  textColor: controller.themeController.isDarkMode.value ? MyColors.white : MyColors.black,
                  buttonColor: controller.themeController.isDarkMode.value ? MyColors.dividerDarkTheme : MyColors.skipButtonColor,
                  shadowColor: Colors.transparent,
                );
              },
            );
          },
          text: MyString.confirmPayment,
          shadowColor: controller.themeController.isDarkMode.value ? Colors.transparent : MyColors.buttonShadowColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: controller.themeController.isDarkMode.value ? MyColors.darkSearchTextFieldColor : MyColors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(
                    color: controller.themeController.isDarkMode.value
                        ? Colors.transparent
                        : Colors.grey.shade200,
                    blurRadius: 10)],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                      ),
                      child: Image.asset(MyImages.hotelSmall),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Royale President", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),),
                        const SizedBox(height: 5),
                        Text("Paris, France", style: TextStyle(color: controller.themeController.isDarkMode.value ? MyColors.switchOffColor : MyColors.textPaymentInfo, fontWeight: FontWeight.w400, fontSize: 11)),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            SvgPicture.asset(MyImages.yellowStar),
                            const SizedBox(width: 5),
                            const Text("4.8", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                            const SizedBox(width: 5),
                            Text("(4,981 reviews)", style: TextStyle(color: controller.themeController.isDarkMode.value ? MyColors.switchOffColor : MyColors.textPaymentInfo, fontWeight: FontWeight.w400, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("29", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
                        Text("/ night", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 8)),
                        SizedBox(height: 12),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: controller.themeController.isDarkMode.value ? MyColors.darkSearchTextFieldColor : MyColors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(
                    color: controller.themeController.isDarkMode.value
                      ? Colors.transparent
                      : Colors.grey.shade200,
                    blurRadius: 10),
                  ],
                ),
                child: Column(
                  children: [
                    commonPaymentInfoText(MyString.checkIn, controller.checkIn, controller.themeController.isDarkMode.value),
                    const SizedBox(height: 12),
                    commonPaymentInfoText(MyString.checkOut, controller.checkOut, controller.themeController.isDarkMode.value),
                    const SizedBox(height: 12),
                    commonPaymentInfoText(MyString.guestAdult, controller.adult.toString(), controller.themeController.isDarkMode.value),
                    const SizedBox(height: 12),
                    commonPaymentInfoText(MyString.guestChildren, controller.children.toString(), controller.themeController.isDarkMode.value),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: controller.themeController.isDarkMode.value ? MyColors.darkSearchTextFieldColor : MyColors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(
                      color: controller.themeController.isDarkMode.value
                          ? Colors.transparent
                          : Colors.grey.shade200,
                      blurRadius: 10),
                  ],
                ),
                child: Column(
                  children: [
                    commonPaymentInfoText(MyString.days, "135.00", controller.themeController.isDarkMode.value),
                    const SizedBox(height: 12),
                    commonPaymentInfoText(MyString.night, "165.00", controller.themeController.isDarkMode.value),
                    const SizedBox(height: 12),
                    commonPaymentInfoText(MyString.taxesFees, "44.50", controller.themeController.isDarkMode.value),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 12),
                    commonPaymentInfoText(MyString.total, "479.50", controller.themeController.isDarkMode.value),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: controller.themeController.isDarkMode.value ? MyColors.darkSearchTextFieldColor : MyColors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(
                    color: controller.themeController.isDarkMode.value
                      ? Colors.transparent
                      : Colors.grey.shade200,
                    blurRadius: 10),
                  ],
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(controller.image.value),
                    const SizedBox(width: 10),
                    Text(controller.paymentTypename.value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        child: const Text(MyString.change, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget commonPaymentInfoText(String titleName, String subTitleName, bool isDarkMode) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(titleName, style: TextStyle(color: isDarkMode ? MyColors.dividerLightTheme : MyColors.textPaymentInfo, fontWeight: FontWeight.w600, fontSize: 14)),
      Text(subTitleName, style: TextStyle(color: isDarkMode ? MyColors.white : MyColors.profileListTileColor, fontWeight: FontWeight.w700, fontSize: 15)),
    ],
  );
}