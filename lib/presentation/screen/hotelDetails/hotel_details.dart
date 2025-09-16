part of 'hotel_detail_import.dart';

class HotelDetail extends StatefulWidget {
  const HotelDetail({
    super.key,
  });

  @override
  State<HotelDetail> createState() => _HotelDetailState();
}

class _HotelDetailState extends State<HotelDetail> {
  HomeDetailController controller = Get.put(HomeDetailController());
  @override
  void initState() {
    super.initState();
    print("reservedDates ${Get.arguments['data']['id']}");

    // استلام restAreaId من الـ arguments
    if (Get.arguments != null && Get.arguments['data']['id'] != null) {
      restAreaId = Get.arguments['data']['id'];
      // استدعاء دالة جلب التواريخ المحجوزة
      controller.fetchReservedDates(restAreaId);
    } else {
      // التعامل مع حالة عدم وجود restAreaId (مثلاً، العودة للخلف أو عرض رسالة خطأ)
      print('لم يتم تحديد معرف الاستراحة.');
      /*
      Get.snackbar('خطأ', 'لم يتم تحديد معرف الاستراحة.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
       */
      Future.delayed(const Duration(seconds: 2), () => Get.back());
    }
  }

  BitmapDescriptor? _markerIcon;
  late int restAreaId;
  // متغيرات خاصة بالتقويم

  var focusedDay = DateTime.now().obs;
  var selectedDay = Rxn<DateTime>(); // Rxn لـ nullable Rx
  var rangeStart = Rxn<DateTime>();
  var rangeEnd = Rxn<DateTime>();
  var calendarFormat = CalendarFormat.month.obs; // تنسيق التقويم
  final TextEditingController CommentController = TextEditingController();
  RxDouble userRating = 0.0.obs;
  void setUserRating(double rating) {
    userRating.value = rating; // <--- هذا هو الجزء المهم!
  }

  void setUserComment(String comment) {
    // ...
  }

  void submitReview() {
    // ...
  }
  // دالة لتحديد ما إذا كان اليوم محجوزًا
  bool _isDayReserved(DateTime day) {
    // قارن اليوم فقط (دون الوقت)
    return controller.reservedDates.any((reservedDay) =>
        reservedDay.year == day.year &&
        reservedDay.month == day.month &&
        reservedDay.day == day.day);
  }

  // دالة لتحديد كيف سيبدو اليوم في التقويم (لإضافة مؤشر مرئي)
  List<Widget> _getEventsForDay(DateTime day) {
    if (controller.isDayReserved(day)) {
      return [
        Positioned(
          right: 1,
          bottom: 1,
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Colors.red, // لون أحمر للتواريخ المحجوزة
              shape: BoxShape.circle,
            ),
          ),
        )
      ];
    }
    return [];
  }

  // دوال للتعامل مع تحديد الأيام والنطاق في التقويم
  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    this.selectedDay.value = selectedDay;
    this.focusedDay.value = focusedDay;
    rangeStart.value = null;
    rangeEnd.value = null;
    print("Selected day: $selectedDay");
  }

  // دالة لتحديد ما إذا كان اليوم محجوزًا (تستخدم في enabledDayPredicate)

  // دالة لتغيير تنسيق التقويم (شهري، أسبوعي)

  // دالة لتغيير الصفحة في التقويم (الشهر)

  @override
  Widget build(BuildContext context) {
    _createMarkerImageFromAsset(context);
    print("//////////////////");
    print("photos : ${controller.detail.detailsImages}");
    controller.fetchReservedDates(int.parse(controller.detail.id.toString()));
    print(controller.detail.virtual_tour_link);
    print(controller.reservedDates);
    print(controller.detail.mainImage);
    print(controller.detail.detailsImages[0].toString());
    print(controller.detail.detailsImages.length);
    print("////////////////");
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        bottomNavigationBar: Container(
          height: 90,
          padding: const EdgeInsets.all(15),
          child: Button(
            onpressed: () {
              Get.toNamed(
                "/dateTimeSelect",
                arguments: {
                  'restAreaId': controller.detail.id,
                  'id_proof_type': controller.detail.idProofType,
                  'area_type': controller.detail.areaType,
                },
              );
            },
            text: MyString.bookNow,
            textSize: 16,
            fontBold: FontWeight.w700,
            textColor: MyColors.white,
            shadowColor: controller.themeController.isDarkMode.value
                ? Colors.transparent
                : MyColors.buttonShadowColor,
          ),
        ),
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  floating: false,
                  pinned: true,
                  scrolledUnderElevation: 0,
                  expandedHeight: 250,
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: SvgPicture.asset(MyImages.backArrow,
                            colorFilter: ColorFilter.mode(
                                innerBoxIsScrolled == true
                                    ? controller.themeController.darkMode.value
                                        ? MyColors.white
                                        : MyColors.black
                                    : MyColors.white,
                                BlendMode.srcIn)),
                      ),
                    ),
                  ),

                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        CarouselSlider.builder(
                          itemCount: 1,
                          itemBuilder: (context, index, realIndex) {
                            return Image.network(
                                "https://esteraha.ly/public/${controller.detail.mainImage.toString()}",
                                fit: BoxFit.fill,
                                width: MediaQuery.of(context).size.width);
                          },
                          options: CarouselOptions(
                              onPageChanged: (index, reason) {
                                controller.sliderIndex.value = index;
                              },
                              autoPlay: true,
                              viewportFraction: 1,
                              initialPage: 0,
                              height: MediaQuery.of(context).size.height),
                        ),
                        Obx(
                          () => Positioned(
                            bottom: 15,
                            left: 0,
                            right: 0,
                            child: DotsIndicator(
                              position: controller.sliderIndex.value,
                              dotsCount: controller.detail.detailsImages.length,
                              decorator: DotsDecorator(
                                activeColor: Colors.green,
                                color: MyColors.white,
                                size: const Size.square(8),
                                activeSize: const Size(35, 8),
                                activeShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ];
            },
            body: Obx(
              () => SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.detail.hotelName.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 26),
                          ),
                          const SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "المدينة:${controller.detail.cityname.toString()}",
                                style: TextStyle(
                                  color: controller
                                          .themeController.isDarkMode.value
                                      ? MyColors.searchTextFieldColor
                                      : MyColors.profileListTileColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                "المنطقة الجغرافية:${controller.detail.geoArea.toString()}",
                                style: TextStyle(
                                  color: controller
                                      .themeController.isDarkMode.value
                                      ? MyColors.searchTextFieldColor
                                      : MyColors.profileListTileColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Row(
                                children: [
                                  SvgPicture.asset(
                                    MyImages.location,
                                    colorFilter: ColorFilter.mode(
                                      controller
                                              .themeController.isDarkMode.value
                                          ? MyColors.white
                                          : MyColors.black,
                                      BlendMode.srcIn,
                                    ),
                                    width: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      controller.detail.location.toString(),
                                      style: TextStyle(
                                        color: controller.themeController
                                                .isDarkMode.value
                                            ? MyColors.searchTextFieldColor
                                            : MyColors.profileListTileColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                              // ويدجيت التجول الافتراضي
                              if (controller.detail.id != null &&
                                  controller.detail.id != null
                               && (controller.detail.cityname as String).isNotEmpty)

                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20, top: 10),
                                  child: Row(
                                    children: [

                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed: (controller.detail.virtual_tour_link != null &&
                                              (controller.detail.virtual_tour_link as String).isNotEmpty)
                                              ? () {
                                            // فتح الرابط باستخدام url_launcher
                                            final Uri _url = Uri.parse(controller.detail.virtual_tour_link.toString()); // الرابط من الداتا
                                            launchUrl(_url); // استخدم الدالة المساعدة _launchUrl
                                          }
                                              : null, // يجعل الزر مطفأ إذا لم يتوفر الرابط
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                          ).copyWith(
                                            backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                                              if (states.contains(MaterialState.disabled)) {
                                                // 🎨 زر معطل
                                                return controller.themeController.isDarkMode.value
                                                    ? Colors.grey.shade700 // في الوضع الداكن
                                                    : Colors.grey.shade400; // في الوضع الفاتح
                                              }
                                              // 🎨 زر شغال (الرابط موجود)
                                              return MyColors.primaryColor;
                                            }),
                                          ),

                                          icon: const Icon(Icons.travel_explore, color: Colors.white),
                                          label: const Text(
                                            "تجول افتراضي",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              fontFamily: 'Tajawal',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 10),
                          Row(
                            children: [
                              SvgPicture.asset(
                                MyImages.timePicker,
                                colorFilter: ColorFilter.mode(
                                  controller.themeController.isDarkMode.value
                                      ? MyColors.white
                                      : MyColors.black,
                                  BlendMode.srcIn,
                                ),
                                width: 15,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "وقت الحضور: ${controller.detail.checkin}",
                                style: TextStyle(
                                  color: controller
                                          .themeController.isDarkMode.value
                                      ? MyColors.searchTextFieldColor
                                      : MyColors.profileListTileColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 10), // فارغ أكبر بين النصين
                              Text(
                                "وقت الانصراف: ${controller.detail.checkout}",
                                style: TextStyle(
                                  color: controller
                                          .themeController.isDarkMode.value
                                      ? MyColors.searchTextFieldColor
                                      : MyColors.profileListTileColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            children: [
                              SvgPicture.asset(
                                MyImages.allMenu,
                                colorFilter: ColorFilter.mode(
                                  controller.themeController.isDarkMode.value
                                      ? MyColors.white
                                      : MyColors.black,
                                  BlendMode.srcIn,
                                ),
                                width: 15,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "العدد الأقصي للضيوف : ${controller.detail.maxGuests}",
                                style: TextStyle(
                                  color: controller
                                      .themeController.isDarkMode.value
                                      ? MyColors.searchTextFieldColor
                                      : MyColors.profileListTileColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),

                            ],
                          ),
                          const Divider(),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${controller.detail.price} د.ل / الليلة",
                                style: TextStyle(
                                  color: controller
                                          .themeController.isDarkMode.value
                                      ? MyColors.white
                                      : MyColors.primaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  _showPriceDetailsBottomSheet(context, {
                                    // 'weekday_price': controller.detail.,
                                    'price': controller.detail
                                        .price, // تأكد من وجوده في الموديل

                                    'holiday_price':
                                        controller.detail.holidayPrice,
                                    'eid_days_price':
                                        controller.detail.eidDaysPrice,
                                    'special_event_price':
                                        null, // أضفه إذا كان موجودًا في الموديل
                                  });
                                },
                                child: Text(
                                  "تفاصيل الأسعار",
                                  style: TextStyle(
                                    color: MyColors.primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                MyString.review,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16),
                              ),
                              const SizedBox(width: 5),
                              SvgPicture.asset(
                                MyImages.yellowStar,
                                width: 14,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "${controller.detail.rating}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 12),
                              ),
                              const SizedBox(width: 5),

                              /*
                              Text("(${controller.detail.review} reviews)",
                                  style: TextStyle(
                                      color: controller
                                              .themeController.isDarkMode.value
                                          ? MyColors.switchOffColor
                                          : MyColors
                                              .onBoardingDescriptionDarkColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10)),
                              */
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  // افترض أن 'controller' هو الكنترولر الخاص بالصفحة الحالية
                                  // وأن 'restAreaId' هو معرف الاستراحة التي تريد عرض تقييماتها
                                  // يمكنك استبدال 'controller.detail.value.id' بالمتغير الفعلي لـ 'restAreaId' لديك
                                  final int? currentRestAreaId =
                                      controller.detail.id; // أو من أي مصدر آخر

                                  if (currentRestAreaId != null) {
                                    Get.toNamed(
                                      "/review",
                                      arguments: {
                                        'restAreaId': currentRestAreaId
                                      }, // تمرير restAreaId كـ arguments
                                    );
                                  } else {
                                    // يمكنك عرض رسالة خطأ إذا لم يكن الـ ID متاحًا
                                    Get.snackbar(
                                      "خطأ",
                                      "معرف الاستراحة غير متاح.",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  }
                                },
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                    // color: Colors.red,
                                    child: const Text(
                                      MyString.seeAll,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14),
                                    )),
                              ),
                            ],
                          ),
                          // نوع الاستخدام
                          if (controller.detail.areaType != null &&
                              controller.detail.areaType!.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: MyColors.primaryColor
                                    .withOpacity(0.1), // لون خلفية خفيف
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Text(
                                  "${controller.detail.areaType}",
                                  style: TextStyle(
                                    color: MyColors.primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 10),
                          titleText(
                            MyString.galleryPhotos,
                            controller.isDarkMode,
                            true,
                                () {
                              Get.toNamed(
                                "/galleryPhoto",
                                arguments: {
                                  'galleryPhoto': controller.detail.detailsImages, // القائمة الكاملة
                                },
                              );
                            },
                          )

                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.only(left: 15),
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: controller.detail.detailsImages.length > 5
                            ? 5
                            : controller.detail.detailsImages.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      PageController pageController = PageController(initialPage: index);
                                      int totalImages = controller.detail.detailsImages.length;

                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          int currentPage = index;

                                          pageController.addListener(() {
                                            setState(() {
                                              currentPage = pageController.page?.round() ?? 0;
                                            });
                                          });

                                          return Dialog(
                                            insetPadding: const EdgeInsets.all(10),
                                            child: Container(
                                              color: Colors.black,
                                              child: Stack(
                                                children: [
                                                  PageView.builder(
                                                    controller: pageController,
                                                    itemCount: totalImages,
                                                    itemBuilder: (context, pageIndex) {
                                                      return InteractiveViewer(
                                                        child: Image.network(
                                                          "https://esteraha.ly/public/${controller.detail.detailsImages[pageIndex]}",
                                                          fit: BoxFit.contain,
                                                        ),
                                                      );
                                                    },
                                                  ),

                                                  // زر إغلاق
                                                  Positioned(
                                                    top: 10,
                                                    right: 10,
                                                    child: IconButton(
                                                      icon: const Icon(Icons.close, color: Colors.white, size: 28),
                                                      onPressed: () => Navigator.of(context).pop(),
                                                    ),
                                                  ),

                                                  // زر السابق

                                                    Positioned(
                                                      left: 10,
                                                      top: MediaQuery.of(context).size.height * 0.4,
                                                      child: IconButton(
                                                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 32),
                                                        onPressed: () {
                                                          pageController.previousPage(
                                                            duration: const Duration(milliseconds: 300),
                                                            curve: Curves.easeInOut,
                                                          );
                                                        },
                                                      ),
                                                    ),

                                                  // زر التالي

                                                    Positioned(
                                                      right: 10,
                                                      top: MediaQuery.of(context).size.height * 0.4,
                                                      child: IconButton(
                                                        icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 32),
                                                        onPressed: () {
                                                          pageController.nextPage(
                                                            duration: const Duration(milliseconds: 300),
                                                            curve: Curves.easeInOut,
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  width: 130,
                                  decoration: BoxDecoration(
                                    color: MyColors.disabledColor,
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        "https://esteraha.ly/public/${controller.detail.detailsImages[index]}",
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 15),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    titleText(MyString.hotelDescription, controller.isDarkMode,
                        false, () {}),
                    const SizedBox(height: 10),
                    Text(
                      controller.detail.description.toString(),
                      style: TextStyle(
                          color: controller.themeController.isDarkMode.value
                              ? MyColors.searchTextFieldColor
                              : MyColors.profileListTileColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          titleText(MyString.details, controller.isDarkMode,
                              false, () {}),
                          const SizedBox(height: 20),
                          GridView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 9, // عدد العناصر التي تريد عرضها
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, // عدد الأعمدة
                              mainAxisExtent: 100, // ارتفاع العنصر
                            ),
                            itemBuilder: (context, index) {
                              // بيانات تجريبية لعرضها كمثال
                              List<Map<String, dynamic>> detailsData = [
                                {
                                  "icon": Icons.bed,
                                  "label": "غرف النوم",
                                  "value":
                                      "${controller.detail.details[0].numBedrooms ?? 0}",
                                },
                                {
                                  "icon": Icons.people,
                                  "label": "الحد الأقصى للضيوف",
                                  "value":
                                      "${controller.detail.details[0].maxGuests ?? 0}",
                                },
                                {
                                  "icon": Icons.kitchen,
                                  "label": "المطبخ",
                                  "value": controller.detail.details[0]
                                              .kitchenAvailable ==
                                          true
                                      ? "متوفر"
                                      : "غير متوفر",
                                },
                                {
                                  "icon": Icons.kitchen,
                                  "label": "معدات المطبخ",
                                  "value": controller.detail.details[0].kitchenContents
                                },
                                {
                                  "icon": Icons.bathtub,
                                  "label": "حمامات داخلية",
                                  "value":
                                      "${controller.detail.details[0].numBathroomsIndoor ?? 0}",
                                },
                                {
                                  "icon": Icons.local_parking,
                                  "label": "مرآب",
                                  "value":
                                      controller.detail.details[0].garage ==
                                              true
                                          ? "متوفر"
                                          : "غير متوفر",
                                },
                                {
                                  "icon": Icons.ac_unit, // أيقونة التكييف
                                  "label": "تكييف/تدفئة",
                                  "value": controller
                                              .detail.details[0].hasACHeating ==
                                          true
                                      ? "متوفر"
                                      : "غير متوفر",
                                },
                                {
                                  "icon": Icons.tv, // أيقونة التلفاز
                                  "label": "عدد شاشات التلفاز",
                                  "value":
                                      "${controller.detail.details[0].tvScreens ?? 0}",
                                },
                                {
                                  "icon": Icons.wifi, // أيقونة الواي فاي
                                  "label": "واي فاي مجاني",
                                  "value":
                                      controller.detail.details[0].freeWifi ==
                                              true
                                          ? "نعم"
                                          : "لا",
                                },
                                {
                                  "icon": Icons.games, // أيقونة الألعاب
                                  "label": "ألعاب ترفيهية",
                                  "value": controller.detail.details[0]
                                          .entertainmentGames ??
                                      "لا توجد ألعاب",
                                },
                              ];

                              return Container(
                                margin: const EdgeInsets.all(
                                    8), // إضافة هوامش بين العناصر
                                decoration: BoxDecoration(
                                  color: controller.themeController.isDarkMode.value
                                      ? Colors.grey[850] // لون الخلفية عند الوضع الداكن
                                      : Colors.white,    // اللون الافتراضي للوضع العادي
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: controller.themeController.isDarkMode.value
                                          ? Colors.transparent
                                          : Colors.grey.shade200,
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      detailsData[index]['icon'],
                                      size: 20, // حجم الأيقونة
                                      color: Colors.blue, // لون الأيقونة
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      detailsData[index]['label'],
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      (detailsData[index]['value'] == null || detailsData[index]['value'].toString().isEmpty)
                                          ? "غير متوفر"
                                          : detailsData[index]['value'].toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),

                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),

                          const SizedBox(height: 20),
                          titleText(MyString.facilites, controller.isDarkMode,
                              false, () {}),
                          const SizedBox(height: 20),
                          GridView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 15, // عدد العناصر التي تريد عرضها
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, // عدد الأعمدة
                              mainAxisExtent: 100, // ارتفاع العنصر
                            ),
                            itemBuilder: (context, index) {
                              // بيانات تجريبية لعرضها كمثال
                              List<Map<String, dynamic>> detailsData = [
                                {
                                  "icon": Icons.pool, // أيقونة المسبح
                                  "label": "مساحة المسبح",
                                  "value":
                                      "${controller.detail.details[0].poolSpace ?? 0}",
                                },
                                {
                                  "icon": Icons.pool, // أيقونة المسبح
                                  "label": "نوع المسبح",
                                  "value":
                                      controller.detail.details[0].poolType ??
                                          "لا يوجد",
                                },
                                {
                                  "icon": Icons.water, // أيقونة المياه
                                  "label": "عمق المسبح",
                                  "value":
                                      "${controller.detail.details[0].poolDepth ?? 0}",
                                },
                                {
                                  "icon": Icons
                                      .outdoor_grill, // أيقونة المساحة الخارجية
                                  "label": "مساحة خارجية",
                                  "value": controller
                                              .detail.details[0].outdoorSpace ==
                                          true
                                      ? "متوفر"
                                      : "غير متوفر",
                                },
                                {
                                  "icon": Icons.grass, // أيقونة المساحة العشبية
                                  "label": "مساحة عشبية",
                                  "value":
                                      controller.detail.details[0].grassSpace ==
                                              true
                                          ? "متوفر"
                                          : "غير متوفر",
                                },
                                {
                                  "icon": Icons.local_florist, // أيقونة نباتات
                                  "label": "تدفئة للمسبح",
                                  "value": controller
                                              .detail.details[0].poolHeating ==
                                          true
                                      ? "متوفر"
                                      : "غير متوفر",
                                },
                                {
                                  "icon": Icons.local_florist, // أيقونة نباتات
                                  "label": "فلتر  للمسبح",
                                  "value":
                                      controller.detail.details[0].poolFilter ==
                                              true
                                          ? "متوفر"
                                          : "غير متوفر",
                                },
                                {
                                  "icon": Icons.local_parking,
                                  "label": "كراج",
                                  "value":
                                      controller.detail.details[0].garage ==
                                              true
                                          ? "متوفر"
                                          : "غير متوفر",
                                },
                                {
                                  "icon": Icons.local_parking,
                                  "label": "أماكن جلوس خارجية",
                                  "value": controller.detail.details[0]
                                              .outdoorSeating ==
                                          true
                                      ? "متوفر"
                                      : "غير متوفر",
                                },
                                {
                                  "icon": Icons.gamepad_outlined,
                                  "label": "ألعاب للأطفال",
                                  "value": controller.detail.details[0]
                                              .childrenGames ==
                                          true
                                      ? "متوفر"
                                      : "غير متوفر",
                                },
                                {
                                  "icon": Icons.gamepad_outlined,
                                  "label": "ألعاب ترفيهية",
                                  "value": controller.detail.details[0]
                                      .gamesdetails ==
                                      null
                                      ?"غير متوفر"
                                      : controller.detail.details[0]
                                      .gamesdetails.toString(),
                                },
                                {
                                  "icon": Icons
                                      .outdoor_grill, // أيقونة المطبخ الخارجي
                                  "label": "مطبخ خارجي",
                                  "value": controller.detail.details[0]
                                              .outdoorKitchen ==
                                          true
                                      ? "متوفر"
                                      : "غير متوفر",
                                },
                                {
                                  "icon": Icons.local_play, // أيقونة مكان الذبح
                                  "label": "مكان الذبح",
                                  "value": controller.detail.details[0]
                                              .slaughterPlace ==
                                          true
                                      ? "متوفر"
                                      : "غير متوفر",
                                },
                                {
                                  "icon": Icons.local_hospital, // أيقونة البئر
                                  "label": "بئر",
                                  "value":
                                      controller.detail.details[0].well == true
                                          ? "متوفر"
                                          : "غير متوفر",
                                },
                                {
                                  "icon":
                                      Icons.power, // أيقونة المولد الكهربائي
                                  "label": "مولد كهربائي",
                                  "value": controller.detail.details[0]
                                              .powerGenerator ==
                                          true
                                      ? "متوفر"
                                      : "غير متوفر",
                                },
                                {
                                  "icon":
                                      Icons.power, // أيقونة المولد الكهربائي
                                  "label": "حمام خارجي",
                                  "value": controller.detail.details[0]
                                              .OutdoorBathroom ==
                                          true
                                      ? "متوفر"
                                      : "غير متوفر",
                                },
                              ];

                              return Container(
                                margin: const EdgeInsets.all(
                                    8), // إضافة هوامش بين العناصر
                                decoration: BoxDecoration(
                                  color: controller.themeController.isDarkMode.value
                                      ? Colors.grey[850] // لون الخلفية عند الوضع الداكن
                                      : Colors.white,    // اللون الافتراضي للوضع العادي
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: controller.themeController.isDarkMode.value
                                          ? Colors.transparent
                                          : Colors.grey.shade200,
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      detailsData[index]['icon'],
                                      size: 20, // حجم الأيقونة
                                      color: Colors.blue, // لون الأيقونة
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      detailsData[index]['label'],
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      detailsData[index]['value'],
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              titleText(MyString.location,
                                  controller.isDarkMode, false, () {}),
                              Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    print( controller.detail.google_maps_location);
                                    Get.toNamed(
                                      "/googleMap",
                                      arguments: controller.detail.google_maps_location,
                                    );
                                  },
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Get.isDarkMode
                                        ? Colors.black
                                        : Colors.white,
                                    size: 15,
                                  ),
                                ),
                              )
                            ],
                          ),

                          const SizedBox(height: 20),
                          /*
                          Container(
                            width: double.infinity,
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(controller.detail.lat,
                                      controller.detail.lng),
                                  zoom: 14,
                                ),
                                markers: {_createMarker()},
                                onMapCreated:
                                    (GoogleMapController googleMapController) {},
                              ),
                            ),
                          ),
                           */
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                MyString.review,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16),
                              ),
                              const SizedBox(width: 5),
                              SvgPicture.asset(
                                MyImages.yellowStar,
                                width: 14,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "${controller.detail.rating}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 12),
                              ),
                              const SizedBox(width: 5),

                              /*
                              Text("(${controller.detail.review} reviews)",
                                  style: TextStyle(
                                      color: controller
                                              .themeController.isDarkMode.value
                                          ? MyColors.switchOffColor
                                          : MyColors
                                              .onBoardingDescriptionDarkColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10)),
                              */
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  // افترض أن 'controller' هو الكنترولر الخاص بالصفحة الحالية
                                  // وأن 'restAreaId' هو معرف الاستراحة التي تريد عرض تقييماتها
                                  // يمكنك استبدال 'controller.detail.value.id' بالمتغير الفعلي لـ 'restAreaId' لديك
                                  final int? currentRestAreaId =
                                      controller.detail.id; // أو من أي مصدر آخر

                                  if (currentRestAreaId != null) {
                                    Get.toNamed(
                                      "/review",
                                      arguments: {
                                        'restAreaId': currentRestAreaId
                                      }, // تمرير restAreaId كـ arguments
                                    );
                                  } else {
                                    // يمكنك عرض رسالة خطأ إذا لم يكن الـ ID متاحًا
                                    Get.snackbar(
                                      "خطأ",
                                      "معرف الاستراحة غير متاح.",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  }
                                },
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                    // color: Colors.red,
                                    child: const Text(
                                      MyString.seeAll,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14),
                                    )),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),

                          _review(controller.isDarkMode,
                              controller.detail.allReview),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Obx(
                              () => buildReviewInputWidget(
                                context: context,
                                currentRating: controller.userRating.value,
                                onRatingTap: (rating) {
                                  controller.setUserRating(rating);
                                },
                                commentController: controller.commentController,
                                onCommentChanged: (comment) {
                                  controller.setUserComment(comment);
                                },
                                // استدعي دالة submitReview في الكنترولر مع restAreaId
                                onSubmit: () {
                                  // تأكد أن controller.detail.id موجود ولديه قيمة صحيحة
                                  if (controller.detail.id != null) {
                                    // إذا كان detail هو Rx<DetailModel>
                                    controller.submitReview(
                                        restAreaId: controller.detail.id!);
                                  } else {
                                    Get.snackbar(
                                      "خطأ",
                                      "لا يمكن إرسال التقييم: معرف المكان غير موجود.",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  }
                                },
                                isDarkMode: controller
                                    .isDarkMode, // أو controller.themeController.isDarkMode.value
                                isLoading: controller
                                    .isLoading.value, // <--- تمرير حالة التحميل
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

// هذا الكود يوضع مباشرة قبل Container الذي يحتوي على TableCalendar

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "تقويم الحجوزات:",
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.045, // حجم الخط يتناسب مع عرض الشاشة
                                  fontWeight: FontWeight.bold,
                                  color: controller
                                          .themeController.isDarkMode.value
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.01), // مسافة تتناسب مع ارتفاع الشاشة
                              Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.05, // حجم الدائرة يتناسب مع عرض الشاشة
                                    height: MediaQuery.of(context).size.width *
                                        0.05, // حجم الدائرة يتناسب مع عرض الشاشة
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade400,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02), // مسافة تتناسب مع عرض الشاشة
                                  Text(
                                    "متاح للحجز",
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context)
                                              .size
                                              .width *
                                          0.035, // حجم الخط يتناسب مع عرض الشاشة
                                      color: controller
                                              .themeController.isDarkMode.value
                                          ? Colors.white70
                                          : Colors.black87,
                                    ),
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.04), // مسافة تتناسب مع عرض الشاشة
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                    height: MediaQuery.of(context).size.width *
                                        0.05,
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade400,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02),
                                  Text(
                                    "غير متاح للحجز (محجوز/ماضي)",
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.035,
                                      color: controller
                                              .themeController.isDarkMode.value
                                          ? Colors.white70
                                          : Colors.black87,
                                    ),
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.04),
                                ],
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02), // مسافة قبل بداية التقويم
                            ],
                           ),
                          Container(
                            child: Obx(() {
                              if (controller.isLoading2.value) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return TableCalendar(
                                  locale: 'ar',
                                  firstDay: DateTime.now().copyWith(
                                      hour: 0,
                                      minute: 0,
                                      second: 0,
                                      millisecond: 0,
                                      microsecond: 0),
                                  daysOfWeekStyle: DaysOfWeekStyle(
                                    weekdayStyle: TextStyle(
                                      fontSize: 14, // حجم الخط لأيام الأسبوع العادية
                                      fontWeight: FontWeight.bold,
                                      color: controller
                                          .themeController.isDarkMode.value
                                          ? Colors.white70
                                          : Colors.black87,
                                    ),
                                    weekendStyle: TextStyle(
                                      fontSize: 14 ,// حجم الخط لأيام نهاية الأسبوع
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),

                                  lastDay: DateTime(DateTime.now().year, 12, 31),
                                  focusedDay: controller.focusedDay.value,
                                  calendarFormat: controller.calendarFormat.value,
                                  selectedDayPredicate: (day) => false, // لا يوجد يوم محدد للقراءة فقط
                                  rangeStartDay: null, // لا يوجد نطاق محدد للقراءة فقط
                                  rangeEndDay: null,   // لا يوجد نطاق محدد للقراءة فقط
                                  onDaySelected: (day, focusedDay) {}, // <--- جعلها فارغة لمنع التحديد
                                  onRangeSelected: (start, end, focusedDay) {}, // <--- جعلها فارغة لمنع التحديد
                                  eventLoader: _getEventsForDay,
                                  startingDayOfWeek: StartingDayOfWeek.sunday,
                                  calendarStyle: CalendarStyle(

                                    outsideDaysVisible: false,
                                    weekendTextStyle: const TextStyle(color: Colors.black),
                                    selectedDecoration: BoxDecoration(
                                      color: MyColors.primaryColor.withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    todayDecoration: BoxDecoration(
                                      color: MyColors.primaryColor.withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    rangeStartDecoration: const BoxDecoration(),
                                    rangeEndDecoration: const BoxDecoration(),
                                    withinRangeDecoration: const BoxDecoration(),
                                    disabledDecoration: BoxDecoration(
                                      color: Colors.red.shade400,
                                      shape: BoxShape.circle,
                                    ),
                                    defaultDecoration: BoxDecoration(
                                      color: Colors.green.shade400,
                                      shape: BoxShape.circle,
                                    ),
                                    weekendDecoration: BoxDecoration(
                                      color: Colors.green.shade400,
                                      shape: BoxShape.circle,
                                    ),
                                    holidayDecoration: BoxDecoration(
                                      color: Colors.green.shade400,
                                      shape: BoxShape.circle,
                                    ),
                                    // **NEW:** إضافة decoration للأيام خارج الشهر
                                    outsideDecoration: BoxDecoration(
                                      color: Colors.green.shade400, // نفس لون defaultDecoration
                                      shape: BoxShape.circle,
                                    ),
                                    defaultTextStyle: const TextStyle(color: Colors.black),
                                    holidayTextStyle: const TextStyle(color: Colors.black),
                                  ),
                                  headerStyle: HeaderStyle(
                                    formatButtonVisible: false,
                                    titleCentered: true,
                                    formatButtonShowsNext: false,
                                    rightChevronIcon: Icon(Icons.arrow_forward_ios,
                                        color: MyColors.primaryColor),
                                    leftChevronIcon: Icon(Icons.arrow_back_ios,
                                        color: MyColors.primaryColor),
                                  ),
                                  onFormatChanged: controller.onFormatChanged,
                                  onPageChanged: controller.onPageChanged,
                                  enabledDayPredicate: (day) {
                                    final isToday = isSameDay(day, DateTime.now());
                                    final isPast = day.isBefore(DateTime.now().copyWith(
                                        hour: 0,
                                        minute: 0,
                                        second: 0,
                                        millisecond: 0,
                                        microsecond: 0)) &&
                                        !isToday;

                                    // المنطق هنا يحدد فقط ما إذا كان اليوم محجوزًا/في الماضي ليعطي لون أحمر
                                    // أو غير محجوز/ليس في الماضي ليعطي لون أخضر.
                                    // لا يؤثر هذا على قابلية التحديد بعد الآن.
                                    return !controller.isDayReserved(day) && !isPast;
                                  },
                                );
                              }
                            }),
                          ),

                          const SizedBox(height: 15),
                      /*
                          SizedBox(
                            height: 50,
                            child: ElevatedButton(
                                onPressed: () {
                                  Get.toNamed("/review");
                                },
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: controller
                                            .themeController.isDarkMode.value
                                        ? Colors.white.withOpacity(0.20)
                                        : Colors.black.withOpacity(0.20),
                                    foregroundColor: controller
                                            .themeController.isDarkMode.value
                                        ? MyColors.white
                                        : MyColors.black),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      MyString.more,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.keyboard_arrow_down),
                                  ],
                                )),
                          ),
                       */
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  /*
  Marker _createMarker() {
    if (_markerIcon != null) {
      return Marker(
        markerId: const MarkerId('marker_1'),
        position: LatLng(controller.detail.lat, controller.detail.lng),
        infoWindow: InfoWindow(title: controller.detail.location.toString()),
        icon: _markerIcon!,
      );
    } else {
      return Marker(
        markerId: const MarkerId('marker_1'),
        position: LatLng(controller.detail.lat, controller.detail.lng),
        infoWindow: InfoWindow(title: controller.detail.location.toString()),
      );
    }
  }
   */

  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
    if (_markerIcon == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size.square(48));
      BitmapDescriptor.fromAssetImage(imageConfiguration, MyImages.markerIcon)
          .then(_updateBitmap);
    }
  }

  void _updateBitmap(BitmapDescriptor bitmap) {
    setState(() {
      _markerIcon = bitmap;
    });
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

_review(bool isDarkMode, List<AllReview> allReview) {
  return ListView.builder(
    padding: const EdgeInsets.only(top: 15),
    physics: const NeverScrollableScrollPhysics(),
    itemCount: allReview.length,
    shrinkWrap: true,
    itemBuilder: (context, index) {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color:
                  isDarkMode ? MyColors.darkSearchTextFieldColor : Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color:
                        isDarkMode ? Colors.transparent : Colors.grey.shade200,
                    blurRadius: 10),
              ],
            ),
            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage("${allReview[index].image}"),
                  ),
                  title: Text(
                    "${allReview[index].name}",
                    style: TextStyle(
                        color: isDarkMode
                            ? MyColors.white
                            : MyColors.textBlackColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 14),
                  ),
                  subtitle: Text("${allReview[index].date}",
                      style: TextStyle(
                          color: isDarkMode
                              ? MyColors.onBoardingDescriptionDarkColor
                              : MyColors.textPaymentInfo,
                          fontSize: 10)),
                  trailing: Container(
                    height: 30,
                    width: 52,
                    decoration: BoxDecoration(
                      color: MyColors.primaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(MyImages.whiteStar, width: 10),
                        const SizedBox(width: 5),
                        Text("${allReview[index].rate}",
                            style: const TextStyle(
                                color: MyColors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12)),
                      ],
                    ),
                  ),
                ),
                Text("${allReview[index].description}",
                    style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 15),
        ],
      );
    },
  );
}

Widget _buildReviewItem(
  BuildContext context,
  bool isDarkMode,
  String reviewerName,
  double rating,
  String comment,
  String? imageUrl,
  String reviewDate,
) {
  // ... (نفس الكود الذي قدمته لـ _buildReviewItem سابقًا) ...
  return Container(
    padding: const EdgeInsets.all(15),
    margin: const EdgeInsets.only(bottom: 15),
    decoration: BoxDecoration(
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: isDarkMode ? Colors.transparent : Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            imageUrl != null && imageUrl.isNotEmpty
                ? CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(imageUrl),
                    backgroundColor: Colors.grey[200],
                  )
                : CircleAvatar(
                    radius: 20,
                    backgroundColor: isDarkMode
                        ? MyColors.disabledColor
                        : MyColors.profileListTileColor,
                    child: Icon(Icons.person,
                        color: isDarkMode ? MyColors.white : MyColors.black),
                  ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reviewerName,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: isDarkMode ? MyColors.white : MyColors.black,
                    ),
                  ),
                  Text(
                    reviewDate,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode
                          ? MyColors.searchTextFieldColor
                          : MyColors.profileListTileColor,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: List.generate(5, (index) {
                return SvgPicture.asset(
                  MyImages.yellowStar,
                  width: 16,
                  colorFilter: ColorFilter.mode(
                    index < rating.floor()
                        ? Colors.amber
                        : (index < rating && rating % 1 != 0)
                            ? Colors.amber
                            : Colors.grey[300]!,
                    BlendMode.srcIn,
                  ),
                );
              }),
            ),
            const SizedBox(width: 5),
            Text(
              rating.toStringAsFixed(1),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isDarkMode ? MyColors.white : MyColors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          comment,
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: isDarkMode
                ? MyColors.searchTextFieldColor
                : MyColors.profileListTileColor,
          ),
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}

Widget buildReviewInputWidget({
  required BuildContext context, // نحتاج Context لعرض SnackBar
  required double
      currentRating, // التقييم الحالي (يجب أن يأتي من State/Controller)
  required ValueChanged<double>
      onRatingTap, // دالة لتحديث التقييم عند النقر على نجمة
  required TextEditingController commentController, // متحكم النص للتعليق
  required ValueChanged<String> onCommentChanged, // دالة عند تغيير التعليق
  required VoidCallback onSubmit, // دالة عند الضغط على زر الإرسال
  required bool isDarkMode, // لتمرير وضع الليل/النهار
  required bool isLoading, // <--- متغير جديد لحالة التحميل
}) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ما هو تقييمك؟", // يمكنك استخدام MyString.yourRatingText هنا
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: isDarkMode ? MyColors.white : MyColors.black,
          ),
        ),
        const SizedBox(height: 15),
        // جزء اختيار النجوم
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () {
                onRatingTap((index + 1)
                    .toDouble()); // استدعاء دالة الـ callback لتحديث التقييم
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: SvgPicture.asset(
                  MyImages.yellowStar, // استخدم أيقونة النجمة الخاصة بك
                  width: 35, // حجم أكبر للنجمة
                  colorFilter: ColorFilter.mode(
                    index < currentRating ? Colors.amber : Colors.grey[300]!,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 20),
        Text(
          "أخبرنا بتعليقك", // يمكنك استخدام MyString.yourCommentText هنا
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: isDarkMode ? MyColors.white : MyColors.black,
          ),
        ),
        const SizedBox(height: 10),
        // حقل إدخال التعليق
        TextField(
          controller: commentController,
          onChanged: onCommentChanged, // تمرير التعليق للوالد عند الكتابة
          maxLines: 4,
          style: TextStyle(color: isDarkMode ? MyColors.white : MyColors.black),
          decoration: InputDecoration(
            hintText:
                "اكتب تعليقك هنا...", // يمكنك استخدام MyString.writeYourComment here
            hintStyle: TextStyle(
                color: isDarkMode
                    ? MyColors.searchTextFieldColor
                    : MyColors.profileListTileColor),
            filled: true,
            fillColor: isDarkMode
                ? MyColors.disabledColor.withOpacity(0.2)
                : Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: MyColors.green, width: 1.5), // لون عند التركيز
            ),
          ),
        ),
        const SizedBox(height: 20),
        // زر الإرسال
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (currentRating > 0) {
                // تأكد أن المستخدم اختار تقييمًا
                onSubmit(); // استدعاء دالة الإرسال
              } else {
                // أظهر رسالة للمستخدم لاختيار تقييم
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("الرجاء اختيار تقييم بالنجوم.")),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              "أرسل تقييمك", // يمكنك استخدام MyString.submitReview هنا
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

// دالة لعرض نافذة تفاصيل الأسعار المنبثقة
void _showPriceDetailsBottomSheet(
    BuildContext context, Map<String, dynamic> pricingDetails) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: MyColors.disabledColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "تفاصيل الأسعار",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
              ),
              const SizedBox(height: 15),
              _buildPriceDetailRow("أيام الأسبوع:",
                  "${pricingDetails['price'] ?? 'غير متاح'} د.ل"),
              _buildPriceDetailRow("نهاية الأسبوع :",
                  "${pricingDetails['holiday_price'] ?? 'غير متاح'} د.ل"),
              _buildPriceDetailRow("أيام الأعياد :",
                  "${pricingDetails['eid_days_price'] ?? 'غير متاح'} د.ل"),
              _buildPriceDetailRow("المناسبات الاجتماعية :",
                  "${pricingDetails['special_event_price'] ?? 'غير متاح'} د.ل"),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Button(
                  onpressed: () {
                    Get.back();
                  },
                  text: "إغلاق",
                  textColor: MyColors.white,
                  buttonColor: MyColors.primaryColor,
                  textSize: 16,
                  fontBold: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// دالة مساعدة لإنشاء صف تفاصيل السعر
Widget _buildPriceDetailRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
        ),
        Text(
          value,
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: MyColors.primaryColor),
        ),
      ],
    ),
  );
}
