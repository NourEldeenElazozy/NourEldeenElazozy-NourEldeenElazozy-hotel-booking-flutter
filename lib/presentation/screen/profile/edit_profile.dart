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
  late String usertype;
  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      controller.nameController.text = prefs.getString('userName') ?? '';
      String gender = prefs.getString('gender') ?? '';
      usertype = prefs.getString('user_type') ?? 'user';

      // اضبط الـ switch بحسب نوع الحساب
      controller.isHost.value = (usertype == "host");

      if (gender.isNotEmpty && genderList.contains(gender)) {
        controller.selectedGender = gender;
      }

      print("gender $gender");
      print("usertype $usertype");
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
          // داخل زر التحديث
          child: Obx(() {
            return ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () async {
                final prefs = await SharedPreferences.getInstance();
                final oldUserType = prefs.getString('user_type') ?? "user";
                final newUserType = controller.isHost.value ? "host" : "user";

                // تحقق إذا تم تغيير النوع مسبقًا
                final accountChanged = prefs.getBool('account_changed_once') ?? false;
                if (oldUserType != newUserType && !accountChanged) {
                  // ✅ لو نوع الحساب اتغير
                  Get.defaultDialog(
                    title: "تأكيد",
                    middleText:
                    "سيتم تغيير نوع الحساب إلى ${newUserType == "host" ? "صاحب استراحة" : "مستخدم"}.\n\nسيتم تسجيل خروجك وإعادة تسجيل الدخول.",
                    textCancel: "إلغاء",
                    textConfirm: "موافق",
                    confirmTextColor: Colors.white,
                    onConfirm: () async {
                      Get.back(); // اغلاق الديالوج

                      // تحديث البيانات
                      await controller.fillProfileSubmit(status: 'update');

                      // حفظ النوع الجديد
                      await prefs.setString('user_type', newUserType);
                      await prefs.setBool('account_changed_once', true);
                      // تسجيل خروج
                      await prefs.remove('token');
                      await prefs.remove('userId');
                      await prefs.remove('userName');
                      await prefs.remove('userPhone');
                      await prefs.remove('gender');

                      Get.offNamedUntil("/loginOptionScreen", (route) => false);
                    },


    );
    }else if (oldUserType != newUserType && accountChanged) {
    // لو حاول المستخدم تغييره مرة ثانية
    Get.snackbar(

    "تنبيه",
    "يمكنك تغيير نوع الحساب مرة واحدة فقط.",
    backgroundColor: Colors.orange,
    colorText: Colors.white,

    );
    } else {
        // النوع لم يتغير
        await controller.fillProfileSubmit(status: 'update');
        }
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
                      child: Obx(() => commonDropdownButton(
                        controller.selectedGender,
                        MyString.genderSelect,
                        controller.themeController.isDarkMode.value,
                      )),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'نوع الحساب',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: const [
                            Icon(Icons.person, color: Colors.blue),
                            Text("مستخدم"),
                          ],
                        ),
                        Obx(() => Switch(
                          value: controller.isHost.value,
                          onChanged: (val) {
                            controller.isHost.value = val;
                            controller.selectedUserType.value = val ? "host" : "user";
                            print("تم اختيار نوع الحساب مؤقتًا: ${controller.selectedUserType.value}");
                          },
                          activeColor: controller.isHost.value ? Colors.green : Colors.blue,
                          activeTrackColor: controller.isHost.value
                              ? Colors.green.withOpacity(0.5)
                              : Colors.blue.withOpacity(0.5),
                        )),

                        Column(
                          children: const [
                            Icon(Icons.house, color: Colors.green),
                            Text("صاحب استراحة"),
                          ],
                        ),
                      ],
                    )



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
