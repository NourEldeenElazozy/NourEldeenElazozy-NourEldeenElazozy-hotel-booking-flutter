
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/core/constants/my_colors.dart';
import 'package:hotel_booking/core/constants/my_images.dart';
import 'package:hotel_booking/core/constants/my_strings.dart';
import 'package:hotel_booking/presentation/common_widgets/bottom_sheet_controller.dart';
import 'package:hotel_booking/presentation/common_widgets/custom_button.dart';
import 'package:hotel_booking/presentation/screen/home/home_import.dart';

class FilterBottomSheet extends StatelessWidget {
  FilterBottomSheet({super.key});

  final BottomSheetController controller = Get.put(BottomSheetController());
  final HomeController homecontroller = Get.put(HomeController());
  final TextEditingController guestController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    int cityId=0;
    controller.fetchCities();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: FractionallySizedBox(
        heightFactor: 0.9,
        child: Container(
          decoration: BoxDecoration(
              color: controller.themeController.isDarkMode.value ? MyColors.scaffoldDarkColor : Colors.white,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20))),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 100),
                  child: Column(
                    children: [
                      Container(
                        height: 4,
                        width: 40,
                        decoration: BoxDecoration(
                          color: MyColors.disabledColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        MyString.filterHotel,
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          titleText(
                              MyString.country,
                              controller.themeController.isDarkMode.value,
                              true,
                                  () {}),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 40,
                            child: Obx(() {
                              if (controller.isLoading.value) {
                                return const Center(child: CircularProgressIndicator());
                              }

                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: controller.cities.length,
                                itemBuilder: (context, index) {
                                  return Obx(() => Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          controller.selectedCityIndex.value = index;
                                          controller.selectedCityId.value = controller.cities[index].id; // تحديث `city_id`
                                          controller.selectedCityId.value=0;
                                          print("تم اختيار المدينة رقم: ${controller.selectedCityIndex.value}"); // طباعة `city_id`

                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: controller.selectedCityIndex.value == index
                                                ? MyColors.successColor
                                                : MyColors.white,
                                            border: Border.all(
                                                color: controller.selectedCityIndex.value == index
                                                    ? MyColors.successColor
                                                    : MyColors.black),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 18),
                                          child: Text(
                                            controller.cities[index].name, // عرض اسم المدينة
                                            style: TextStyle(
                                                color: controller.selectedCityIndex.value == index
                                                    ? MyColors.white
                                                    : MyColors.primaryColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                  ));
                                },
                              );
                            }),
                          ),


                          const SizedBox(height: 20),
                          titleText(
                              MyString.sortResults,
                              controller.themeController.isDarkMode.value,
                              false,
                                  () {}),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 40,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: MyString.resultsName.length,
                              itemBuilder: (context, index) {
                                return Obx(() => Row(
                                  children: [
                                    InkWell(
                                      onTap: () {


                                        if(MyString.resultsName[index]=="الأقل شعبية"){
                                          homecontroller.getRestAreas(sortBy:"most_popular" );
                                        }
                                        if(MyString.resultsName[index]=="الأقل سعرًا"){
                                          homecontroller.getRestAreas(sortBy:"lowest_price" );
                                        }
                                        print(MyString.resultsName[index]);
                                        controller.selectedResult.value = index;

                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: controller
                                              .selectedResult.value ==
                                              index
                                              ? controller.themeController
                                              .isDarkMode.value
                                              ? MyColors.successColor
                                              : MyColors.black
                                              : controller.themeController
                                              .isDarkMode.value
                                              ? MyColors.scaffoldDarkColor
                                              : MyColors.white,
                                          border: Border.all(
                                              color: controller.selectedResult
                                                  .value ==
                                                  index
                                                  ? controller.themeController
                                                  .isDarkMode.value
                                                  ? MyColors.successColor
                                                  : Colors.black
                                                  : controller.themeController
                                                  .isDarkMode.value
                                                  ? MyColors.white
                                                  : MyColors.black),
                                          borderRadius:
                                          BorderRadius.circular(20),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18),
                                        child: Text(
                                          MyString.resultsName[index],
                                          style: TextStyle(
                                            color: controller.selectedResult
                                                .value ==
                                                index
                                                ? MyColors.white
                                                : controller.themeController
                                                .isDarkMode.value
                                                ? MyColors.white
                                                : MyColors.primaryColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'المنطقة الجغرافية',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Obx(() => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white, // لون الخلفية
                                    borderRadius: BorderRadius.circular(12), // الحواف الدائرية
                                    border: Border.all(color: Colors.grey.shade300, width: 1), // حدود ناعمة
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12, // ظل خفيف
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: homecontroller.selectedGeoArea.value, // القيمة الحالية
                                      isExpanded: true, // يجعل القائمة تمتد بعرض `Container`
                                      icon: const Icon(Icons.arrow_drop_down, color: Colors.black54), // أيقونة السهم
                                      dropdownColor: Colors.white, // لون القائمة عند الفتح
                                      style: const TextStyle(
                                        color: Colors.black87, // لون النص
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      items: const [
                                        DropdownMenuItem(
                                          value: "مطلة على البحر",
                                          child: Row(
                                            children: [
                                              Text("🌊 "),
                                              SizedBox(width: 8),
                                              Text("مطلة على البحر"),
                                            ],
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: "قريبة من البحر",
                                          child: Row(
                                            children: [
                                              Text("🏖 "),
                                              SizedBox(width: 8),
                                              Text("قريبة من البحر"),
                                            ],
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: "وسط البلاد",
                                          child: Row(
                                            children: [
                                              Text("🏙 "),
                                              SizedBox(width: 8),
                                              Text("وسط البلاد"),
                                            ],
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: "في منطقة سياحية",
                                          child: Row(
                                            children: [
                                              Text("🏕 "),
                                              SizedBox(width: 8),
                                              Text("في منطقة سياحية"),
                                            ],
                                          ),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        homecontroller.selectedGeoArea.value = value!;

                                      },
                                    ),
                                  ),
                                )),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'عدد الضيوف',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),


                                TextField(
                                  controller: guestController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'أدخل عدد الضيوف',
                                    hintText: 'مثل: 2',
                                    prefixIcon: Icon(Icons.person),
                                  ),
                                ),
                                const SizedBox(height: 16),

                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          titleText(
                              MyString.priceRange,
                              controller.themeController.isDarkMode.value,
                              false,
                                  () {}),
                          const SizedBox(height: 20),
                    Obx(() => RangeSlider(
                      values: controller.sliderValue.value,
                      onChanged: (RangeValues values) {
                        controller.changeSliderValue(values);
                        // يمكنك تحديث قيم السعر هنا إذا كنت تستخدمها في متحكم آخر
                        homecontroller.priceMin.value = values.start.toInt();
                        homecontroller.priceMax.value = values.end.toInt();
                      },
                      min: 0, // الحد الأدنى للنطاق
                      max: 1000, // الحد الأقصى للنطاق
                      divisions: 1000, // عدد الأقسام
                      activeColor: Colors.green,
                      labels: RangeLabels(
                        "${controller.sliderValue.value.start.toInt()} د.ل", // إضافة العملة
                        "${controller.sliderValue.value.end.toInt()} د.ل", // إضافة العملة
                      ),
                      inactiveColor: controller.themeController.isDarkMode.value
                          ? MyColors.dividerDarkTheme
                          : MyColors.disabledColor,
                    )
                          ),
                          const SizedBox(height: 20),
                          titleText(
                              MyString.accommodationType,
                              controller.themeController.isDarkMode.value,
                              false,
                                  () {}),
                          const SizedBox(height: 15),
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: MyString.selectedTime.length,
                              itemBuilder: (context, index) {
                                return Obx(
                                  () => Row(
                                    children: [
                                      InkWell(
                                        onTap: () {

                                          controller.selectedTime.value = index;
                                          controller.selectedTimeString.value = MyString.selectedTime[index].toString();
                                          print(controller.selectedTimeString.value);
                                        },
                                        child: Container(
                                          width: 115,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: MyColors.scaffoldLightColor,
                                            border: Border.all(
                                                color: controller.selectedTime.value == index
                                                    ? MyColors.black
                                                    : MyColors.disabledColor),
                                            borderRadius:
                                            BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [

                                              const SizedBox(height: 3),
                                              Text(
                                                MyString.selectedTime[index],
                                                style: TextStyle(
                                                    color: controller.selectedTime.value == index
                                                        ? MyColors.black
                                                        : Colors.grey,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 12),
                                              ),
                                              const SizedBox(height: 3),

                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          titleText(
                              MyString.rating,
                              controller.themeController.isDarkMode.value,
                              true,
                                  () {}),
                          const SizedBox(height: 15),
                          SizedBox(
                            height: 35,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: MyString.rate.length,
                              itemBuilder: (context, index) {
                                return Obx(
                                      () => Row(
                                    children: [
                                      InkWell(
                                        onTap: () {

                                          controller.selectedRate.value = index;

                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: controller
                                                .selectedRate.value ==
                                                index
                                                ? controller.themeController
                                                .isDarkMode.value
                                                ? MyColors.successColor
                                                : MyColors.black
                                                : controller.themeController
                                                .isDarkMode.value
                                                ? MyColors.scaffoldDarkColor
                                                : MyColors.white,
                                            border: Border.all(
                                                color: controller.selectedRate
                                                    .value ==
                                                    index
                                                    ? controller.themeController
                                                    .isDarkMode.value
                                                    ? MyColors.successColor
                                                    : Colors.black
                                                    : controller.themeController
                                                    .isDarkMode.value
                                                    ? MyColors.white
                                                    : MyColors.black),
                                            borderRadius:
                                            BorderRadius.circular(20),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 18),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                controller.selectedRate.value ==
                                                    index
                                                    ? MyImages.whiteStar
                                                    : MyImages.unselectStar,
                                                colorFilter: ColorFilter.mode(
                                                    controller.selectedRate
                                                        .value ==
                                                        index
                                                        ? MyColors.white
                                                        : controller
                                                        .themeController
                                                        .isDarkMode
                                                        .value
                                                        ? MyColors.white
                                                        : MyColors.black,
                                                    BlendMode.srcIn),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                MyString.rate[index],
                                                style: TextStyle(
                                                    color: controller
                                                        .selectedRate
                                                        .value ==
                                                        index
                                                        ? MyColors.white
                                                        : controller
                                                        .themeController
                                                        .isDarkMode
                                                        .value
                                                        ? MyColors.white
                                                        : MyColors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        /*
                          const SizedBox(height: 15),
                          titleText(
                              MyString.accommodationType,
                              controller.themeController.isDarkMode.value,
                              true,
                                  () {}),
                          const SizedBox(height: 5),
                          SizedBox(
                            height: 30,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: MyString.accommodationName.length,
                              itemBuilder: (context, index) {
                                return Obx(() => Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 17,
                                      child: Checkbox(
                                        value: controller.selectedAccommodationName[index],
                                        focusColor: Colors.black,
                                        activeColor: controller
                                            .themeController
                                            .isDarkMode
                                            .value
                                            ? MyColors.successColor
                                            : MyColors.primaryColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(5)),
                                        side: BorderSide(
                                            color: controller.themeController
                                                .isDarkMode.value
                                                ? MyColors.white
                                                : MyColors.black),
                                        onChanged: (value) {
                                          controller.selectedAccommodationName[index] = value!;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      MyString.accommodationName[index],
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                ));
                              },
                            ),
                          ),
                         */
                          const SizedBox(height: 10),
                          titleText(
                              MyString.facilities,
                              controller.themeController.isDarkMode.value,
                              true,
                                  () {}),
                          const SizedBox(height: 5),
                          SizedBox(
                            height: 30,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: MyString.facilitiesName.length, // تأكد من صحة هذا
                              itemBuilder: (context, index) {
                                return Obx(() {
                                  if (index >= controller.selectedFacilities.length) {
                                    return Container(); // تجنب الوصول إلى فهرس غير صحيح
                                  }

                                  bool isSelected = controller.selectedFacilities[index];

                                  return Row(
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 17,
                                        child: Checkbox(
                                          value: isSelected,
                                          focusColor: MyColors.primaryColor,
                                          activeColor: controller.themeController.isDarkMode.value
                                              ? MyColors.successColor
                                              : MyColors.primaryColor,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                          side: BorderSide(
                                            color: controller.themeController.isDarkMode.value
                                                ? MyColors.white
                                                : MyColors.black,
                                          ),
                                          onChanged: (value) {
                                            controller.selectedFacilities[index] = value!;
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(MyString.facilitiesName[index], style: const TextStyle(fontSize: 15)),
                                      const SizedBox(width: 8),
                                    ],
                                  );
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  width: MediaQuery.of(context).size.width,
                  color: controller.themeController.isDarkMode.value ? MyColors.black : MyColors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: Button(
                            onpressed: () {
                              controller.selectedCityIndex.value = -1;
                              controller.selectedCityId=(-1).obs;
                              cityId=0;
                              controller.selectedCityId.value=0;
                              controller.selectedCountry.value = 99;
                              controller.selectedResult.value = 99;
                              controller.selectedTime.value = 99;
                              controller.selectedRate.value = (-2);
                              controller.selectedTimeString.value ="";
                              for(int i = 0 ; i < controller.selectedAccommodationName.length ; i ++) {
                                controller.selectedAccommodationName[i] = false;
                              }
                              for(int i = 0 ; i < controller.selectedFacilities.length; i++) {
                                controller.selectedFacilities[i] = false;
                              }
                              // controller.selectedAccommodationName.refresh();
                            },
                            text: MyString.reset,
                            textColor: controller.themeController.isDarkMode.value ? MyColors.white : MyColors.black,
                            buttonColor: controller.themeController.isDarkMode.value ? MyColors.dividerDarkTheme : MyColors.disabledColor,
                            textSize: 16,
                            fontBold: FontWeight.w700,
                            shadowColor: Colors.transparent,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: Button(
                            onpressed: () {
                              int? maxGuests = int.tryParse(guestController.text);
                              if (maxGuests != null) {
                                // استخدم maxGuests في دالة getRestAreas
                                Get.find<HomeController>().getRestAreas(maxGuests: maxGuests);
                              }
                              print("  maxGuests $maxGuests");
                              print("  cityId ${controller.selectedCityIndex.value}");
                              print("  priceMin ${homecontroller.priceMin.value}");
                              print("  priceMax ${homecontroller.priceMax.value}");
                              // تجميع المرافق المختارة
                              // تجميع المرافق المختارة
                              List<String> selectedFacilities = [];
                              for (int i = 0; i < MyString.facilitiesName.length; i++) {
                                // تأكد من أن selectedFacilities تحتوي على العناصر المطلوبة
                                if (i < controller.selectedFacilities.length && controller.selectedFacilities[i]) {
                                  selectedFacilities.add(MyString.facilitiesName[i]);
                                }
                              }
                              // استدعاء getRestAreas مع cityId ونطاق السعر
                              homecontroller.getRestAreas(

                                maxGuests:maxGuests ,
                                   areaTypes: controller.selectedTimeString.value,
                                  cityId: controller.selectedCityIndex.value,
                                  priceMin: homecontroller.priceMin.value, // إضافة الحد الأدنى للسعر
                                  priceMax: homecontroller.priceMax.value,  // إضافة الحد الأقصى للسعر
                                rating:  controller.selectedRate.value+1,
                                selectedFacilities: selectedFacilities, // تمرير المرافق المحددة
                                geoArea: homecontroller.selectedGeoArea.value
                              );
                              Get.back();
                            },
                            text: MyString.applyFilter,
                            textColor: MyColors.white,
                            buttonColor: controller.themeController.isDarkMode.value ? MyColors.successColor : MyColors.primaryColor,
                            textSize: 16,
                            fontBold: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget titleText(
    String title, bool isDarkMode, bool seeAllStatus, VoidCallback onPress) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      ),
      seeAllStatus == true
      ? InkWell(
        onTap: onPress,
        child: Container(
          padding: const EdgeInsets.all(5),
          child: const Text(
            MyString.seeAll,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          )),
      )
      : const SizedBox(),
    ],
  );
}

class CommonBottomSheet extends StatelessWidget {
  final String status;
  final String? mainTitle;
  final String? subTitle;
  final String? description;
  final Color? buttonColor1;
  final Color? buttonColor2;
  final Color? shadowColor1;
  final Color? shadowColor2;
  final double? textSize;
  final String text1;
  final String text2;
  final FontWeight? fontBold;
  final Color? textColor1;
  final Color? textColor2;
  final VoidCallback onpressed1;
  final VoidCallback onpressed2;

  CommonBottomSheet({
    super.key,
    required this.status,
    this.mainTitle,
    this.subTitle,
    this.description,
    this.buttonColor1,
    this.buttonColor2,
    this.shadowColor1,
    this.shadowColor2,
    required this.onpressed1,
    required this.onpressed2,
    required this.text1,
    required this.text2,
    this.textSize,
    this.textColor1,
    this.textColor2,
    this.fontBold,
  });

  final BottomSheetController controller = Get.put(BottomSheetController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          children: [
            Text(
              mainTitle.toString(),
              style: const TextStyle(
                  color: MyColors.errorColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
            ),
            const SizedBox(height: 10),
            Divider(color: controller.themeController.isDarkMode.value ? MyColors.dividerDarkTheme : Colors.grey.shade300),
            const SizedBox(height: 10),
            Text(
              subTitle.toString(),
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            status == 'cancelBooking'
                ? Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(description.toString(),
                          style: TextStyle(
                              color: controller.themeController.isDarkMode.value
                                  ? MyColors.onBoardingDescriptionDarkColor
                                  : MyColors.textPaymentInfo,
                              fontWeight: FontWeight.w400,
                              fontSize: 12),
                          textAlign: TextAlign.center),
                    ],
                  )
                : const SizedBox(),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                    child: SizedBox(
                  height: 55,
                  child: Button(
                    onpressed: onpressed1,
                    text: text1,
                    buttonColor: buttonColor1,
                    shadowColor: shadowColor1,
                    textColor: textColor1,
                  ),
                )),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: Button(
                      onpressed: onpressed2,
                      text: text2,
                      buttonColor: buttonColor2,
                      shadowColor: shadowColor2,
                      textColor: textColor2,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
