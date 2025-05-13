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

  }

  BitmapDescriptor? _markerIcon;

  @override
  Widget build(BuildContext context) {
    _createMarkerImageFromAsset(context);
    print("//////////////////");
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: InkWell(
                      onTap: () {
                        Get.back();
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
                  actions: [
                    SvgPicture.asset(MyImages.bookMarkLight,
                        colorFilter: ColorFilter.mode(
                            innerBoxIsScrolled == true
                                ? controller.themeController.darkMode.value
                                    ? MyColors.white
                                    : MyColors.black
                                : MyColors.white,
                            BlendMode.srcIn)),
                    const SizedBox(width: 15),
                    SvgPicture.asset(MyImages.allMenu,
                        colorFilter: ColorFilter.mode(
                            innerBoxIsScrolled == true
                                ? controller.themeController.darkMode.value
                                    ? MyColors.white
                                    : MyColors.black
                                : MyColors.white,
                            BlendMode.srcIn)),
                    const SizedBox(width: 15),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        CarouselSlider.builder(
                          itemCount: 1,
                          itemBuilder: (context, index, realIndex) {
                            return Image.network(
                                "http://10.0.2.2:8000/storage/${controller.detail.mainImage.toString()}",
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
                        Obx(() => Positioned(
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
                          Row(
                            children: [
                              SvgPicture.asset(
                                MyImages.location,
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
                                "${controller.detail.location}",
                                style: TextStyle(
                                    color: controller
                                            .themeController.isDarkMode.value
                                        ? MyColors.searchTextFieldColor
                                        : MyColors.profileListTileColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12),
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
                                  color: controller.themeController.isDarkMode.value
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
                                  color: controller.themeController.isDarkMode.value
                                      ? MyColors.searchTextFieldColor
                                      : MyColors.profileListTileColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          const SizedBox(height: 10),
                          titleText(
                              MyString.galleryPhotos, controller.isDarkMode, true,
                              () {
                            Get.toNamed("/galleryPhoto", arguments: {'galleryPhoto': controller.detail.galleryPhotos});
                          }),
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
                        itemCount: controller.detail.detailsImages.length > 5 ? 5 : controller.detail.detailsImages.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        child: Container(
                                          width: double.infinity,
                                          height: 400, // يمكنك تعديل الارتفاع حسب الحاجة
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage("http://10.0.2.2:8000/storage/${controller.detail.detailsImages[index].toString()}"),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
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
                                      image: NetworkImage("http://10.0.2.2:8000/storage/${controller.detail.detailsImages[index].toString()}"),
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
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, // عدد الأعمدة
                              mainAxisExtent: 100, // ارتفاع العنصر
                            ),
                            itemBuilder: (context, index) {
                              // بيانات تجريبية لعرضها كمثال
                              List<Map<String, dynamic>> detailsData = [
                                {
                                  "icon": Icons.bed,
                                  "label": "غرف النوم",
                                  "value": "${controller.detail.details[0].numBedrooms ?? 0}",
                                },
                                {
                                  "icon": Icons.people,
                                  "label": "الحد الأقصى للضيوف",
                                  "value": "${controller.detail.details[0].maxGuests ?? 0}",
                                },
                                {
                                  "icon": Icons.kitchen,
                                  "label": "المطبخ",
                                  "value": controller.detail.details[0].kitchenAvailable == true ? "متوفر" : "غير متوفر",
                                },
      
                                {
                                  "icon": Icons.bathtub,
                                  "label": "حمامات داخلية",
                                  "value": "${controller.detail.details[0].numBathroomsIndoor ?? 0}",
                                },
                                {
                                  "icon": Icons.local_parking,
                                  "label": "مرآب",
                                  "value": controller.detail.details[0].garage == true ? "متوفر" : "غير متوفر",
                                },
                                {
                                  "icon": Icons.ac_unit, // أيقونة التكييف
                                  "label": "تكييف/تدفئة",
                                  "value": controller.detail.details[0].hasACHeating == true ? "متوفر" : "غير متوفر",
                                },
                                {
                                  "icon": Icons.tv, // أيقونة التلفاز
                                  "label": "عدد شاشات التلفاز",
                                  "value": "${controller.detail.details[0].tvScreens ?? 0}",
                                },
                                {
                                  "icon": Icons.wifi, // أيقونة الواي فاي
                                  "label": "واي فاي مجاني",
                                  "value": controller.detail.details[0].freeWifi == true ? "نعم" : "لا",
                                },
                                {
                                  "icon": Icons.games, // أيقونة الألعاب
                                  "label": "ألعاب ترفيهية",
                                  "value": controller.detail.details[0].entertainmentGames ?? "لا توجد ألعاب",
                                },
      
      
      
      
      
      
      
                              ];
      
                              return Container(
      
                                margin: const EdgeInsets.all(8), // إضافة هوامش بين العناصر
                                decoration: BoxDecoration(
                                  color: Colors.white, // لون الخلفية
                                  borderRadius: BorderRadius.circular(10), // زوايا مستديرة
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 5,
                                      offset: Offset(2, 2), // ظل بسيط
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
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      detailsData[index]['value'],
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          titleText(MyString.hotelDescription,
                              controller.isDarkMode, false, () {}),
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
      
      
                           const SizedBox(height: 20),
                          titleText(MyString.facilites, controller.isDarkMode,
                              false, () {}),
                          const SizedBox(height: 20),
                          GridView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 15, // عدد العناصر التي تريد عرضها
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, // عدد الأعمدة
                              mainAxisExtent: 100, // ارتفاع العنصر
                            ),
                            itemBuilder: (context, index) {
                              // بيانات تجريبية لعرضها كمثال
                              List<Map<String, dynamic>> detailsData = [
                                {
                                  "icon": Icons.pool, // أيقونة المسبح
                                  "label": "مساحة المسبح",
                                  "value": "${controller.detail.details[0].poolSpace ?? 0}",
                                },
                                {
                                  "icon": Icons.pool, // أيقونة المسبح
                                  "label": "نوع المسبح",
                                  "value": controller.detail.details[0].poolType ?? "لا يوجد",
                                },
                                {
                                  "icon": Icons.water, // أيقونة المياه
                                  "label": "عمق المسبح",
                                  "value": "${controller.detail.details[0].poolDepth ?? 0}",
                                },
                                {
                                  "icon": Icons.outdoor_grill, // أيقونة المساحة الخارجية
                                  "label": "مساحة خارجية",
                                  "value": controller.detail.details[0].outdoorSpace == true ? "متوفر" : "غير متوفر",
                                },
                                {
                                  "icon": Icons.grass, // أيقونة المساحة العشبية
                                  "label": "مساحة عشبية",
                                  "value": controller.detail.details[0].grassSpace == true ? "متوفر" : "غير متوفر",
                                },
                                {
                                  "icon": Icons.local_florist, // أيقونة نباتات
                                  "label": "تدفئة للمسبح",
                                  "value": controller.detail.details[0].poolHeating == true ? "متوفر" : "غير متوفر",
                                },
                                {
                                  "icon": Icons.local_florist, // أيقونة نباتات
                                  "label": "فلتر  للمسبح",
                                  "value": controller.detail.details[0].poolFilter == true ? "متوفر" : "غير متوفر",
                                },
                                {
                                  "icon": Icons.local_parking,
                                  "label": "كراج",
                                  "value": controller.detail.details[0].garage == true ? "متوفر" : "غير متوفر",
                                },
                                {
                                  "icon": Icons.local_parking,
                                  "label": "أماكن جلوس خارجية",
                                  "value": controller.detail.details[0].outdoorSeating == true ? "متوفر" : "غير متوفر",
                                },
                                {
                                  "icon": Icons.gamepad_outlined,
                                  "label": "ألعاب للأطفال",
                                  "value": controller.detail.details[0].childrenGames == true ? "متوفر" : "غير متوفر",
                                },
                                {
                                  "icon": Icons.outdoor_grill, // أيقونة المطبخ الخارجي
                                  "label": "مطبخ خارجي",
                                  "value": controller.detail.details[0].outdoorKitchen == true ? "متوفر" : "غير متوفر",
                                },
                                {
                                  "icon": Icons.local_play, // أيقونة مكان الذبح
                                  "label": "مكان الذبح",
                                  "value": controller.detail.details[0].slaughterPlace == true ? "متوفر" : "غير متوفر",
                                },
                                {
                                  "icon": Icons.local_hospital, // أيقونة البئر
                                  "label": "بئر",
                                  "value": controller.detail.details[0].well == true ? "متوفر" : "غير متوفر",
                                },
                                {
                                  "icon": Icons.power, // أيقونة المولد الكهربائي
                                  "label": "مولد كهربائي",
                                  "value": controller.detail.details[0].powerGenerator == true ? "متوفر" : "غير متوفر",
                                },
                                {
                                  "icon": Icons.power, // أيقونة المولد الكهربائي
                                  "label": "حمام خارجي",
                                  "value": controller.detail.details[0].OutdoorBathroom == true ? "متوفر" : "غير متوفر",
                                },
      
                              ];
      
                              return Container(
      
                                margin: const EdgeInsets.all(8), // إضافة هوامش بين العناصر
                                decoration: BoxDecoration(
                                  color: Colors.white, // لون الخلفية
                                  borderRadius: BorderRadius.circular(10), // زوايا مستديرة
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 5,
                                      offset: Offset(2, 2), // ظل بسيط
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
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      detailsData[index]['value'],
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
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
                              titleText(MyString.location, controller.isDarkMode,
                                  false, () {}),
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
                                    Get.toNamed("/googleMap");
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
                                  Get.toNamed("/review");
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
                          // const SizedBox(height: 15),
                          _review(
                              controller.isDarkMode, controller.detail.allReview),
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
