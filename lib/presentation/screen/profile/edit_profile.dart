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
        controller.dateController.text =
        "${controller.selectedDate.toLocal()}".split(" ")[0];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    controller = Get.put(RegisterController());
    _loadUserData();
  }

  List<String> genderList = ["ذكر", "انثي"];

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      controller.nameController.text = prefs.getString('userName') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    //controller.selectedGender = genderList[0];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const CustomFullAppBar(title: MyString.editProfile),
        bottomNavigationBar: Container(
          height: 90,
          padding: const EdgeInsets.all(15),
          child: Obx(() {
            return ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () {
                controller.fillProfileSubmit(status: 'update');
              },
              child: controller.isLoading.value
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : const Text(
                MyString.update,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
              ),
            );
          }),
        ),
        body: Obx(
              () => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
              child: Form(
                key: controller.fillFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // الاسم الكامل
                    const Text(
                      'الاسم الكامل',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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

                    // كلمة المرور
                    const Text(
                      'كلمة المرور الجديدة',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    CustomTextFormField(
                      controller: controller.passwordController,
                      obscureText: true,
                      hintText: 'أدخل كلمة المرور الجديدة',
                      fillColor: controller.themeController.isDarkMode.value
                          ? MyColors.darkTextFieldColor
                          : MyColors.disabledTextFieldColor,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value != null && value.isNotEmpty && value.length < 6) {
                          return 'كلمة المرور يجب أن تكون على الأقل 6 أحرف';
                        }
                        return null; // يسمح بتركه فارغ
                      },
                    ),
                    const SizedBox(height: 20),

                    // تأكيد كلمة المرور
                    const Text(
                      'تأكيد كلمة المرور',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    CustomTextFormField(
                      controller: controller.passwordController,
                      obscureText: true,
                      hintText: 'أعد إدخال كلمة المرور',
                      fillColor: controller.themeController.isDarkMode.value
                          ? MyColors.darkTextFieldColor
                          : MyColors.disabledTextFieldColor,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (controller.passwordController.text.isNotEmpty &&
                            value != controller.passwordController.text) {
                          return 'كلمتا المرور غير متطابقتين';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // الجنس
                    const Text(
                      'الجنس',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
          ),
        ),
      ),
    );
  }
}
