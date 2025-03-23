part of 'reservation_import.dart';

class Reservation extends StatefulWidget {
  const Reservation({super.key});

  @override
  State<Reservation> createState() => _ReservationState();
}

class _ReservationState extends State<Reservation> {

  late ReservationController controller;

  @override
  void initState() {
    controller = Get.put(ReservationController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomFullAppBar(title: MyString.nameReservation),
      bottomNavigationBar: Container(
        height: 90,
        padding: const EdgeInsets.all(15),
        child:
        Button(
          onpressed: () {
            return controller.reservationSubmit();
          },
          text: MyString.continueButton,
          shadowColor: controller.themeController.isDarkMode.value ? Colors.transparent : MyColors.buttonShadowColor,
        ),
      ),
      body: Obx(() => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: controller.reservationKey,
            child: Column(
              children: [
                CustomTextFormField(
                  controller: controller.nameController,
                  obscureText: false,
                  validator: Validations().nameValidation,
                  hintText: MyString.fullName,
                  textInputAction: TextInputAction.next,
                  fillColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.disabledTextFieldColor,
                ),
                const SizedBox(height: 20),
                commonDropdownButton(controller.selectedGender, MyString.genderSelect, controller.themeController.isDarkMode.value),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    controller._selectDate(context);
                  },
                  child: AbsorbPointer(
                    child: CustomTextFormField(
                      controller: controller.dateController,
                      obscureText: false,
                      validator: Validations().dateValidation,
                      hintText:  MyString.dateBirth,
                      fillColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.disabledTextFieldColor,
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(15),
                        child: SvgPicture.asset(MyImages.datePicker),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: controller.emailController,
                  obscureText: false,
                  validator: Validations().emailValidation,
                  keyboardType: TextInputType.emailAddress,
                  hintText: MyString.email,
                  fillColor: MyColors.disabledTextFieldColor,
                  textInputAction: TextInputAction.next,
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
                        child: countryPickerDropdown(controller.countryCode.value, controller.countryCodes)
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 62 /100,
                      child: CustomTextFormField(
                        controller: controller.mobileNumberController,
                        obscureText: false,
                        validator: Validations().mobileNumberValidation,
                        keyboardType: TextInputType.phone,
                        hintText: MyString.phoneNumber,
                        fillColor: MyColors.disabledTextFieldColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),)
    );
  }
}