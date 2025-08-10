part of 'profile_import.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  late RegisterController controller = RegisterController();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );
    if (pickedDate != null && pickedDate != controller.selectedDate) {
      setState(() {
        controller.selectedDate = pickedDate;
        controller.dateController.text = "${controller.selectedDate.toLocal()}".split(" ")[0];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    controller = Get.put(RegisterController());
    _loadUserData();
  }
  List<String> genderList = ["ذكر", "أنثى"];
  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      controller.nameController.text = prefs.getString('userName') ?? '';

      controller.phoneController.text = prefs.getString('userPhone') ?? '';
      controller.mobileNumberController.text = prefs.getString('userPhone') ?? '';

      // يمكنك إضافة المزيد من الحقول حسب ما يتم تخزينه
    });
  }
  @override
  Widget build(BuildContext context) {
    controller.selectedGender = genderList[0]; // يعني "ذكر"
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const CustomFullAppBar(title: MyString.editProfile),
        bottomNavigationBar: Container(
          height: 90,
          padding: const EdgeInsets.all(15),
          child:Obx(() {
            return ElevatedButton(
              onPressed: controller.isLoading.value ? null : () {
                controller.fillProfileSubmit(status: 'update');
              },
              child: controller.isLoading.value
                  ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : Text(MyString.update,style: TextStyle(    fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',),),
            );
          }),

        ),
        body: Obx(() => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
            child: Form(
              key: controller.fillFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label للاسم الكامل
                  const Text(
                    'الاسم الكامل',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 5),
                  CustomTextFormField(
                    controller: controller.nameController,
                    obscureText: false,
                    hintText: MyString.fullName,
                    fillColor: controller.themeController.isDarkMode.value
                        ? MyColors.darkTextFieldColor
                        : MyColors.disabledTextFieldColor,
                    textInputAction: TextInputAction.next,
                    validator: Validations().nameValidation,
                  ),
                  const SizedBox(height: 20),

                  // Label لرقم الهاتف
                  const Text(
                    'رقم الهاتف',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 5),
                  CustomTextFormField(
                    controller: controller.mobileNumberController,
                    obscureText: false,
                    validator: Validations().mobileNumberValidation,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    hintText: MyString.phoneNumber,
                    fillColor: MyColors.disabledTextFieldColor,
                  ),
                  const SizedBox(height: 20),

                  // Label للجنس
                  const Text(
                    'الجنس',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerRight,
                    child: commonDropdownButton(
                      controller.selectedGender,
                      MyString.genderSelect,
                      controller.themeController.isDarkMode.value,
                    ),
                  ),
                ],
              ),
            ),

          ),
        ),),
      ),
    );
  }
}
