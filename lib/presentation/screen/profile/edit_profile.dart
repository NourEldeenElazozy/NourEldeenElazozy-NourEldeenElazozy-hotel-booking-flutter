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
      controller.nickNameController.text = prefs.getString('userName')?.split(' ').first ?? '';
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
          child:Button(
            onpressed: () {
              controller.fillProfileSubmit(status: 'update');
            },
            text: MyString.update,
          ),
        ),
        body: Obx(() => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
            child: Form(
                key: controller.fillFormKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      controller: controller.nameController,
                      obscureText: false,
                      hintText: MyString.fullName,
                      fillColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.disabledTextFieldColor,
                      textInputAction: TextInputAction.next,
                      validator: Validations().nameValidation,
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                        controller: controller.nickNameController,
                        obscureText: false,
                        hintText: MyString.nickName,
                        fillColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.disabledTextFieldColor,
                        textInputAction: TextInputAction.next,
                        validator: Validations().nameValidation
                    ),
                    const SizedBox(height: 20),
                    Obx(() => InkWell(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: AbsorbPointer(
                        child: CustomTextFormField(
                          controller: controller.dateController,
                          obscureText: false,
                          validator: Validations().dateValidation,
                          textInputAction: TextInputAction.next,
                          hintText:  MyString.dateBirth,
                          fillColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.disabledTextFieldColor,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(15),
                            child: SvgPicture.asset(MyImages.datePicker),
                          ),
                        ),
                      ),
                    ),),
                    const SizedBox(height: 20),

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 25 /100,
                            child: countryPickerDropdown(controller.countryCode, controller.countryCodes)
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 62 /100,
                          child: CustomTextFormField(
                            controller: controller.mobileNumberController,
                            obscureText: false,
                            validator: Validations().mobileNumberValidation,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.done,
                            hintText: MyString.phoneNumber,
                            fillColor: MyColors.disabledTextFieldColor,
                          ),
                        ),
                      ],
                    ),
                    // IntlPhoneField(
                    //   controller: controller.mobileNumberController,
                    //   initialCountryCode: 'US',
                    //   onChanged: (number) {
                    //     // _phoneNumber = number.number;
                    //   },
                    //   validator: (phoneNumber) {
                    //     if (phoneNumber == null || phoneNumber.number.isEmpty) {
                    //       return 'Phone number is required';
                    //     }
                    //     // else {
                    //     //   final phoneNumber = PhoneNumber.fromCompleteNumber(completeNumber: 'Us');
                    //     //   if (phoneNumber.isValidNumber) {
                    //     //     return 'Invalid phone number';
                    //     //   }
                    //     // }
                    //     return null;
                    //   },
                    //   dropdownIconPosition: IconPosition.trailing,
                    //   dropdownIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey,),
                    //   autovalidateMode: AutovalidateMode.onUserInteraction,
                    //   // validator: (value) {
                    //   //   controller.mobileNumberValidation(value);
                    //   // },
                    //   decoration: InputDecoration(
                    //     filled: true,
                    //     fillColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.disabledTextFieldColor,
                    //     counterText: "",
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(15),
                    //       borderSide: BorderSide(color: Colors.grey.shade300),
                    //     ),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(color: controller.themeController.isDarkMode.value ? Colors.white : Colors.black),
                    //       borderRadius: BorderRadius.circular(15),
                    //     ),
                    //     focusedErrorBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(color: controller.themeController.isDarkMode.value ? Colors.white : Colors.black),
                    //       borderRadius: BorderRadius.circular(15),
                    //     ),
                    //     enabledBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(15),
                    //       borderSide: BorderSide(color: controller.themeController.isDarkMode.value ? Colors.transparent : Colors.grey.shade300),
                    //     ),
                    //     errorBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(15),
                    //       borderSide: BorderSide(color: controller.themeController.isDarkMode.value ? Colors.transparent : Colors.grey.shade300),
                    //     ),
                    //     hintText: MyString.phoneNumber,
                    //     hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 14),
                    //   ),
                    // ),
                    const SizedBox(height: 20),
                    commonDropdownButton(
                      controller.selectedGender,
                      MyString.genderSelect,
                      controller.themeController.isDarkMode.value,

                    ),
                  ],
                )
            ),
          ),
        ),),
      ),
    );
  }
}
