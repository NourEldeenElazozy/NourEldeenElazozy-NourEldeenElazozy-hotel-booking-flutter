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
    controller.nameController.text='Daniel Austin';
    controller.nickNameController.text='Daniel';
    controller.dateController.text='1995-05-08';
    controller.emailController.text='daniel_austin@yourdomain.com';
    controller.mobileNumberController.text='9898989898';
    controller.selectedGender = "Male";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  CustomTextFormField(
                    controller: controller.emailController,
                    obscureText: false,
                    hintText: MyString.email,
                    fillColor: MyColors.disabledTextFieldColor,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: Validations().emailValidation,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(15),
                      child: SvgPicture.asset(MyImages.fillEmailBoxDark),
                    ),
                  ),
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
                  commonDropdownButton(controller.selectedGender, MyString.genderSelect, controller.themeController.isDarkMode.value),
                ],
              )
          ),
        ),
      ),),
    );
  }
}
