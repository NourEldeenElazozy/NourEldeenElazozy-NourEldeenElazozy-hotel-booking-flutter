part of 'profile_import.dart';

class ProfileNotification extends StatefulWidget {
  const ProfileNotification({super.key});

  @override
  State<ProfileNotification> createState() => _ProfileNotificationState();
}

class _ProfileNotificationState extends State<ProfileNotification> {

  late ProfileController controller;

  @override
  void initState() {
    controller = Get.put(ProfileController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomFullAppBar(
        title: MyString.notification
      ),
      body: Obx(() => Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSwitchRow(MyString.generalNotification, controller.generalNotification.value, (newValue) {
                controller.generalNotification.value = newValue;
              },),
              const SizedBox(height: 20),
              buildSwitchRow(MyString.sound, controller.sound.value, (newValue) {
                controller.sound.value = newValue;
              },),
              const SizedBox(height: 20),
              buildSwitchRow(MyString.vibrate, controller.vibrate.value, (newValue) {
                controller.vibrate.value = newValue;
              },),
              const SizedBox(height: 20),
              buildSwitchRow(MyString.appUpdates, controller.appUpdates.value, (newValue) {
                controller.appUpdates.value = newValue;
              },),
              const SizedBox(height: 20),
              buildSwitchRow(MyString.serviceAvailable, controller.serviceAvailable.value, (newValue) {
                controller.serviceAvailable.value = newValue;
              },),
              const SizedBox(height: 20),
              buildSwitchRow(MyString.tipsAvailable, controller.tipsAvailable.value, (newValue) {
                controller.tipsAvailable.value = newValue;
              },),
            ],
          ),
        ),
      ),)
    );
  }
}

Widget buildSwitchRow(
    String title, bool value, void Function(bool) onChanged) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
      CustomSwitch(
        value: value,
        onChanged: onChanged,
      ),
    ],
  );
}
