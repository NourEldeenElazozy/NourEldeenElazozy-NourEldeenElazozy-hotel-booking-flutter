part of 'register_import.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  late RegisterController controller;
  late TabController _tabController;
  final GlobalKey<FormState> customerFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> hostFormKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    controller = Get.put(RegisterController());
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<RegisterController>(
        init: controller,
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('تسجيل'),
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: "التسجيل كزبون"),
                  Tab(text: "التسجيل كمقيم"),
                ],
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildCustomerRegistration(controller),
                _buildHostRegistration(controller),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCustomerRegistration(RegisterController controller) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Form(
            key: customerFormKey, // استخدم المفتاح الفريد هنا
            child: Column(
              children: [

                Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: const Text(MyString.registerTitle, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 45)),
                ),
                CustomTextFormField(
                  controller: controller.nameController,
                  obscureText: false,
                  maxLength: 30,
                  validator: Validations().nameValidation,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(15),
                    child: SvgPicture.asset(MyImages.user),
                  ),
                  hintText: "اسم المستخدم",
                  fillColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.disabledTextFieldColor,
                ),
                const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: controller.gender.value.isEmpty ? null : controller.gender.value, // استخدام قيمة افتراضية
                decoration: InputDecoration(
                  filled: true,
                  fillColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.disabledTextFieldColor,
                  hintText: "اختر الجنس",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(15),
                    child: SvgPicture.asset(MyImages.user), // استخدم أيقونة مناسبة للجنس
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'male',
                    child: Text('ذكر'),
                  ),
                  DropdownMenuItem(
                    value: 'female',
                    child: Text('أنثى'),
                  ),
                ],
                onChanged: (value) {
                  controller.gender.value = value ?? ''; // تحديث القيمة في الـ controller
                },
                validator: (value) {
                  if (value == null) {
                    return 'يرجى اختيار الجنس';
                  }
                  return null;
                },
              ),
                const SizedBox(height: 20),
              TextFormField(
                readOnly: true, // لجعل الحقل للعرض فقط
                controller: TextEditingController(text: controller.birthDate.value), // تعيين القيمة
                decoration: InputDecoration(
                  hintText: "تاريخ الميلاد",
                  filled: true,
                  fillColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.disabledTextFieldColor,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(15),
                    child: SvgPicture.asset(MyImages.datePicker), // استخدم أيقونة التقويم
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        controller.birthDate.value = "${pickedDate.toLocal()}".split(' ')[0]; // تعيين تاريخ الميلاد
                      }
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال تاريخ الميلاد';
                  }
                  return null;
                },
              ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: controller.phoneController,
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  validator: Validations().phoneValidation,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(15),
                    child: SvgPicture.asset(MyImages.mobile),
                  ),
                  hintText: MyString.emailHintText,
                  fillColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.disabledTextFieldColor,
                ),
                const SizedBox(height: 20),
                Obx(() => CustomTextFormField(
                  controller: controller.passwordController,
                  obscureText: controller.showPassword.value,
                  validator: Validations().passwordValidation,
                  textInputAction: TextInputAction.done,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(15),
                    child: SvgPicture.asset(MyImages.passwordLock),
                  ),
                  hintText: MyString.passwordHintText,
                  fillColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.disabledTextFieldColor,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: InkWell(
                      onTap: () {
                        controller.showPassword.value = !controller.showPassword.value;
                      },
                      child: SvgPicture.asset(
                        controller.showPassword.value ? MyImages.hidePassword : MyImages.showPassword,
                        colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                      ),
                    ),
                  ),
                )),
                const SizedBox(height: 40),
                SizedBox(
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  child: Button(
                    onpressed: () {
                      return controller.submit();
                    },
                    text: MyString.signUp,
                    shadowColor: controller.themeController.isDarkMode.value ? Colors.transparent : MyColors.buttonShadowColor,
                  ),
                ),
                const SizedBox(height: 30),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'By signing up you agree to BookNest’s ',
                        style: TextStyle(color: controller.themeController.isDarkMode.value ? MyColors.white : MyColors.textBlackColor, fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                      const TextSpan(
                        text: 'Terms of Services and Privacy Policy.',
                        style: TextStyle(color: MyColors.successColor, fontWeight: FontWeight.w600, fontSize: 14, height: 1.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(MyString.alreadyAccount, style: TextStyle(color: controller.themeController.isDarkMode.value ? MyColors.white : Colors.grey.shade400, fontWeight: FontWeight.w400, fontSize: 14)),
                    InkWell(
                      onTap: () {
                        Get.off(const LoginScreen());
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          MyString.signIn,
                          style: TextStyle(
                            color: controller.themeController.isDarkMode.value ? MyColors.textYellowColor : MyColors.primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHostRegistration(RegisterController controller) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Form(
            key: hostFormKey, // استخدم المفتاح الفريد هنا
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: const Text(MyString.registerTitle, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 45)),
                ),
                CustomTextFormField(
                  controller: controller.nameController,
                  obscureText: false,
                  maxLength: 30,
                  validator: Validations().nameValidation,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(15),
                    child: SvgPicture.asset(MyImages.user),
                  ),
                  hintText: "اسم المستخدم",
                  fillColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.disabledTextFieldColor,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: controller.phoneController,
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validations().phoneValidation,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(15),
                    child: SvgPicture.asset(MyImages.mobile),
                  ),
                  hintText: MyString.emailHintText,
                  fillColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.disabledTextFieldColor,
                ),
                const SizedBox(height: 20),
                Obx(() => CustomTextFormField(
                  controller: controller.passwordController,
                  obscureText: controller.showPassword.value,
                  validator: Validations().passwordValidation,
                  textInputAction: TextInputAction.done,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(15),
                    child: SvgPicture.asset(MyImages.passwordLock),
                  ),
                  hintText: MyString.passwordHintText,
                  fillColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.disabledTextFieldColor,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: InkWell(
                      onTap: () {
                        controller.showPassword.value = !controller.showPassword.value;
                      },
                      child: SvgPicture.asset(
                        controller.showPassword.value ? MyImages.hidePassword : MyImages.showPassword,
                        colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                      ),
                    ),
                  ),
                )),
                const SizedBox(height: 40),
                // أضف المزيد من الحقول المطلوبة هنا
                ElevatedButton(
                  onPressed: () {
                    controller.submit();
                  },
                  child: const Text('تسجيل كمقيم'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
