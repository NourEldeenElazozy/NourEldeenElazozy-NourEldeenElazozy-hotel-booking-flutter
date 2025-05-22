part of 'password_import.dart';

class SelectSmsEmailScreen extends GetView<PasswordController> {
  final String icon;
  final String sms;
  final String hintText;
  final bool status; // true for SMS, false for Email

  const SelectSmsEmailScreen({
    super.key,
    required this.icon,
    required this.sms,
    required this.hintText,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const CustomFullAppBar(title: MyString.choiceForgotPassword),
        bottomNavigationBar: Container(
          height: 90,
          padding: const EdgeInsets.all(15),
          child: Button(
            onpressed: () {
              // استدعاء دالة selectSmsEmailSubmit من المتحكم
              controller.selectSmsEmailSubmit(context);
            },
            text: "متابعة",
            textSize: 16,
            fontBold: FontWeight.w700,
            textColor: MyColors.white,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: controller.smsEmailKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SvgPicture.asset(icon),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    sms,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    hintText,
                    style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    maxLength: 10,
                    controller: controller.smsController,
                    keyboardType: status ? TextInputType.phone : TextInputType.emailAddress,
                    validator: (value) => status
                        ? controller.mobileNumberValidation(value!)
                        : controller.emailValidation(value!),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: hintText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
