part of 'payment_import.dart';

class Ticket extends StatefulWidget {
  const Ticket({super.key});

  @override
  State<Ticket> createState() => _TicketState();
}

class _TicketState extends State<Ticket> {

  late PaymentController controller;
  late String message;

  @override
  void initState() {
    controller = Get.put(PaymentController());
    message = Get.arguments['message'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: controller.themeController.isDarkMode.value ? MyColors.scaffoldDarkColor : Colors.grey.shade100,
      appBar: const CustomFullAppBar(title: MyString.ticket),
      bottomNavigationBar: Container(
        height: 90,
        padding: const EdgeInsets.all(15),
        child:
        Button(
          onpressed: () {
            message == 'true' ? Get.offNamedUntil('/bottomBar', (route) => false) : Get.back();
            // Get.toNamed("/paymentInfo");
          },
          text: MyString.downloadTicket,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : Colors.white,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  border: Border(
                    right: BorderSide(color: controller.themeController.isDarkMode.value ? Colors.grey.shade800 : Colors.transparent),
                    left: BorderSide(color: controller.themeController.isDarkMode.value ? Colors.grey.shade800 : Colors.transparent),
                    top: BorderSide(color: controller.themeController.isDarkMode.value ? Colors.grey.shade800 : Colors.transparent),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(MyString.hotelName, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
                    const SizedBox(height: 15),
                    SvgPicture.asset(MyImages.barCode),
                  ],
                ),
              ),
              ClipPath(
                clipper: TicketClipper(holeRadius: 30,bottom: 0),
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : Colors.white,
                    border: Border(
                      right: BorderSide(color: controller.themeController.isDarkMode.value ? Colors.grey.shade800 : Colors.grey.shade300),
                      left: BorderSide(color: controller.themeController.isDarkMode.value ? Colors.grey.shade800 : Colors.grey.shade300),
                    ),
                  ),
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return Flex(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        direction: Axis.horizontal,
                        children: List.generate(30, (_) {
                          return const SizedBox(
                            width: 5,
                            height: 2,
                            child: DecoratedBox(
                              decoration: BoxDecoration(color: Colors.grey),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : Colors.white,
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                  border: Border(
                    right: BorderSide(color: controller.themeController.isDarkMode.value ? Colors.grey.shade800 : Colors.transparent),
                    left: BorderSide(color: controller.themeController.isDarkMode.value ? Colors.grey.shade800 : Colors.transparent),
                    bottom: BorderSide(color: controller.themeController.isDarkMode.value ? Colors.grey.shade800 : Colors.transparent),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        qrDetail('Name', 'Daniel Austin'),
                        qrDetail('Check in Date', 'Dec 16, 2024'),
                        qrDetail('Check in Time', '12:30 pm'),
                        qrDetail('Hotel', 'Royale President'),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        qrDetail('Phone Number', '+1 111 467 378 399'),
                        qrDetail('Check out Date', 'Dec 20, 2024'),
                        qrDetail('Dec 20, 2024', '6:00 pm'),
                        Row(
                          children: [
                            qrDetail('Adult', '3'),
                            const SizedBox(width: 10),
                            qrDetail('Children', '3'),
                          ],
                        ),
                      ],
                    ),
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget qrDetail(String title, String subTitle) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
      const SizedBox(height: 2),
      Text(subTitle, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
      const SizedBox(height: 15),
    ],
  );
}
