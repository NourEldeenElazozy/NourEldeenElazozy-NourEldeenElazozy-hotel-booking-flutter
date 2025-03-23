part of 'notification_import.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  late NotificationController controller;

  @override
  void initState() {
    controller = Get.put(NotificationController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomFullAppBar(
        title: MyString.notification
      ),
      body: Obx(() => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.allNotification.length,
              itemBuilder: (context, mainIndex) {
                final data = controller.allNotification[mainIndex].data;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(DateFormat('MMMM dd, yyyy').format(controller.allNotification[mainIndex].date).toString(), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
                    const SizedBox(height: 15),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: controller.themeController.isDarkMode.value ? MyColors.darkSearchTextFieldColor : Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(color: controller.themeController.isDarkMode.value ? Colors.transparent : Colors.grey.shade200, blurRadius: 10)
                                ],
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(data[index].image, width: 70,),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(data[index].heading, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
                                        const SizedBox(height: 3),
                                        Text(data[index].description, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                          ],
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
      ),
      ),
    );
  }
}
