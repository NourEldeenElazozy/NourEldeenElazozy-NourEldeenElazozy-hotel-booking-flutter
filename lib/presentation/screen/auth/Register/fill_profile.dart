part of 'register_import.dart';

class FillProfileScreen extends StatefulWidget {
  const FillProfileScreen({super.key});

  @override
  State<FillProfileScreen> createState() => _FillProfileScreenState();
}

class _FillProfileScreenState extends State<FillProfileScreen> {

  // DateTime selectedDate = DateTime.now();
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

  late RegisterController controller = RegisterController();
  bool isMobileNumberEmpty  = false;
  @override
  void initState() {
    super.initState();
    controller = Get.put(RegisterController());
  }

  File? selectedImage;
  Future<void> selectImageFromGallery() async {
    XFile? pickedFile = (await ImagePicker().pickImage(source: ImageSource.gallery));
    if(pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> selectImageFroCamera() async {
    XFile? pickedFile = (await ImagePicker().pickImage(source: ImageSource.camera));
    if(pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future showOptions() async {
    // final ThemeData theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Wrap(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        selectImageFromGallery();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        // color: Colors.red,
                        child: const Text("Open Gallery",style: TextStyle(fontSize: 14,)),
                      ),
                    ),
                    Divider(color: Colors.grey.shade300),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        selectImageFroCamera();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        // color: Colors.blue,
                        child: const Text("Open Camera",style: TextStyle(fontSize: 14,)),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomFullAppBar(title: MyString.fillProfile),
      bottomNavigationBar: Container(
        height: 90,
        padding: const EdgeInsets.all(15),
        child:
        Button(
          onpressed: () {
            return controller.fillProfileSubmit(status: 'fill');
          },
          text: MyString.continueButton,
        ),
      ),
      body: GetBuilder<RegisterController>(
        builder: (controller) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 50, 15, 20),
              child: Form(
                key: controller.fillFormKey,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        showOptions();
                      },
                      child: Stack(
                        children: [
                          selectedImage != null
                          ? CircleAvatar(
                            radius: 70,
                            backgroundImage: FileImage(selectedImage!),
                          )
                          : CircleAvatar(
                            radius: 70,
                            backgroundColor: controller.themeController.isDarkMode.value ? MyColors.profilePersonDark : MyColors.profilePerson,
                            child: Image.asset(MyImages.profilePerson,),
                          ),
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: SvgPicture.asset(MyImages.editProfile, colorFilter: ColorFilter.mode(controller.themeController.isDarkMode.value ? MyColors.white : MyColors.black, BlendMode.srcIn),),
                            // child: Icon(Icons.edit),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 29),
                    CustomTextFormField(
                      controller: controller.nameController,
                      obscureText: false,
                      hintText: MyString.fullName,
                      fillColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.disabledTextFieldColor,
                      validator: Validations().nameValidation,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      controller: controller.nickNameController,
                      obscureText: false,
                      hintText: MyString.nickName,
                      fillColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.disabledTextFieldColor,
                      validator: Validations().nameValidation,
                      textInputAction: TextInputAction.next,
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
                      validator: Validations().emailValidation,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      hintText: MyString.email,
                      fillColor: MyColors.disabledTextFieldColor,
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
                            textInputAction: TextInputAction.next,
                            hintText: MyString.phoneNumber,
                            fillColor: MyColors.disabledTextFieldColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    commonDropdownButton(controller.selectedGender, MyString.genderSelect, controller.themeController.isDarkMode.value),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
