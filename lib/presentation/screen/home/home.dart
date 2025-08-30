part of 'home_import.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();

}

class _HomeState extends State<Home> {
  int? selectedCityId; // تخزين `city_id` عند العودة
  late HomeController controller = Get.put(HomeController());
  late bool isDarkMode;
  var userName = ''.obs; // استخدام Rx لتحديث الواجهة عند تغيير القيمة
  var userId = 0.obs; // استخدام Rx لتحديث الواجهة عند تغيير القيمة
  var Token = ''.obs; // استخدام Rx لتحديث الواجهة عند تغيير القيمة
  var userType = ''.obs; // استخدام Rx لتحديث الواجهة عند تغيير القيمة


  Future<void> _handleRefresh() async {



    // استدعاء جميع الدوال التي تقوم بتحديث البيانات
    await controller.getRestAreas();
    await controller.getReservations();

    await controller.getHomeDetail();

    await _loadUserName();
    await _loadToken();
    await _loaduserType();
    await _loadUserId();
    // يمكنك إضافة أي دوال أخرى تحتاج إلى تحديثها هنا
  }
  
  @override
  void initState() {
    super.initState();
    controller.getReservations();
    controller.getRestAreas();
    controller.fetchRecentlyBooked();
    controller.getHomeDetail();
    controller.selectedItem.value = 0;
    controller.passingStatus.value = "Recommended";
    controller.filterList("Recommended");
    _loadUserName(); // استدعاء دالة تحميل الاسم
    _loadToken();
    _loaduserType();
    _loadUserId();
  }

  Future<void> _loadUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userName.value = prefs.getString('userName') ?? '';

  }
  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // حذف التوكن
    print("تم حذف التوكن بنجاح!"); // اختبار للتأكد
  }
  Future<void> _loadToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Token.value = prefs.getString('token') ?? '';


  }
  Future<void> _loaduserType() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userType.value = prefs.getString('user_type') ?? '';


  }
  Future<void> _loadUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId.value = prefs.getInt('user_id') ??0;

  }
  @override
  Widget build(BuildContext context) {
    //controller.getRestAreas(cityId: 1);

    controller.loadFavoritesFromPrefs();
    _loaduserType();
   //controller.getReservations();
   controller.fetchRecentlyBooked();

    print("filteredReservations");
   print(controller.filteredReservations.length);
     controller.getReservations();
    //removeToken();
    debugPrint('════════ Tokens ════════', wrapWidth: 1029);
    debugPrint(Token.value , wrapWidth: 1029);
    debugPrint('═══════════════════════', wrapWidth: 1029);
   print(" usertypes ${userType.value}");
    print(" restAreas length ${controller.restAreas.length}");

    print("userId ${userId.value}");
   return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: homeAppBar(context,MyString.bookNest, true, controller.themeController.isDarkMode.value),
        body: RefreshIndicator(
          onRefresh: _handleRefresh, // ⬅️ استدعاء دالة التحديث
          child: Obx(() => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(), // ⬅️ ضروري ليعمل السحب دائمًا
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        userName.value.isNotEmpty ? "مرحبا ${userName.value} 👋" : "مرحبا زائر 👋",
                        style: TextStyle(
                          color: controller.themeController.isDarkMode.value ? MyColors.white : MyColors.successColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 26,
                        ),
                      ),
                      const SizedBox(height: 18),
                      // Search
          
                      InkWell(
                        onTap: () {
                          Get.to(const Search(status: 'home'));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: controller.themeController.isDarkMode.value
                                ? MyColors.darkSearchTextFieldColor
                                : MyColors.searchTextFieldColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(MyImages.unSelectedSearch,
                                colorFilter: ColorFilter.mode(controller.themeController.isDarkMode.value ? MyColors.white : MyColors.onBoardingDescriptionDarkColor, BlendMode.srcIn),
                                width: 22,
                              ),
                              const SizedBox(width: 15),
                              Text(MyString.search, style: TextStyle(color: controller.themeController.isDarkMode.value ? MyColors.white : MyColors.onBoardingDescriptionDarkColor,fontWeight: FontWeight.w400, fontSize: 14)),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    backgroundColor: Get.isDarkMode ? MyColors.scaffoldDarkColor : Colors.white,
                                    useSafeArea: true,
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) {
                                      return FilterBottomSheet();
                                    },
                                  );
                                  // return filterBottomSheet(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  child: SvgPicture.asset(MyImages.filter, colorFilter: ColorFilter.mode(controller.themeController.isDarkMode.value ? MyColors.white : MyColors.primaryColor, BlendMode.srcIn)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
          
                      const SizedBox(height: 20),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Expanded(
                      //       child: InkWell(
                      //         onTap: () {
                      //           controller.selectedItem.value = 0;
                      //           controller.passingStatus.value = 'Recommended';
                      //           controller.filterList('Recommended');
                      //         },
                      //         child: customContainerButton(
                      //           MyString.recommended,
                      //           0,
                      //           controller.selectedItem.value,
                      //           controller.themeController.isDarkMode.value,
                      //         ),
                      //       ),
                      //     ),
                      //     const SizedBox(width: 5),
                      //     Expanded(
                      //       child: InkWell(
                      //         onTap: () {
                      //           controller.selectedItem.value = 1;
                      //           controller.passingStatus.value = 'Popular';
                      //           controller.filterList('Popular');
                      //         },
                      //         child: customContainerButton(
                      //           MyString.popular,
                      //           1,
                      //           controller.selectedItem.value,
                      //           controller.themeController.isDarkMode.value,
                      //         ),
                      //       ),
                      //     ),
                      //     const SizedBox(width: 5),
                      //     Expanded(
                      //       child: InkWell(
                      //         onTap: () {
                      //           controller.selectedItem.value = 2;
                      //           controller.passingStatus.value = 'Trending';
                      //           controller.filterList('Trending');
                      //         },
                      //         child: customContainerButton(
                      //           MyString.trending,
                      //           2,
                      //           controller.selectedItem.value,
                      //           controller.themeController.isDarkMode.value,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: MyString.itemSelect.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Obx(() => InkWell(
                                  onTap: () async {
                                    controller.selectedItem.value = index;
                                    switch (index) {
                                      case 0:
                                        controller.passingStatus.value = 'Recommended';
                                        break;
                                      case 1:
                                        controller.passingStatus.value = 'Popular';
                                        break;
                                      case 2:
                                        controller.passingStatus.value = 'Trending';
                                        break;
                                      default:
                                        controller.passingStatus.value = 'New Arrive';
                                    }
                                   // controller.filterList(controller.passingStatus.value);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: controller.selectedItem.value == index
                                          ? (controller.themeController.isDarkMode.value
                                          ? MyColors.successColor
                                          : MyColors.black)
                                          : (controller.themeController.isDarkMode.value
                                          ? MyColors.scaffoldDarkColor
                                          : MyColors.white),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: controller.selectedItem.value == index
                                            ? (controller.themeController.isDarkMode.value
                                            ? MyColors.successColor
                                            : Colors.black)
                                            : (controller.themeController.isDarkMode.value
                                            ? MyColors.white
                                            : MyColors.black),
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 18),
                                    child: Text(
                                      MyString.itemSelect[index],
                                      style: TextStyle(
                                        color: controller.selectedItem.value == index
                                            ? MyColors.white
                                            : (controller.themeController.isDarkMode.value
                                            ? MyColors.white
                                            : MyColors.black),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                )),
                                const SizedBox(width: 12),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
               //الاصلية
                /*
                 SizedBox(
                  height: 300,
                  child: controller.isLoading.value
                    ? Center(child: CircularProgressIndicator(
                      color: controller.themeController.isDarkMode.value ? Colors.white : MyColors.successColor),
                    )
                    : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: controller.filterListView.length,
                      itemBuilder: (context, index) {
                      return Row(
                        children: [
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              Get.toNamed("/hotelDetail", arguments: {'data' : controller.homeDetails[index]});
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                              width: 230,
                              decoration: BoxDecoration(
                                  color: MyColors.disabledColor,
                                  borderRadius: BorderRadius.circular(40),
                                  image: DecorationImage(image: NetworkImage("${controller.filterListView[index].image}"), fit: BoxFit.cover)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                        decoration: BoxDecoration(
                                            color: MyColors.primaryColor,
                                            borderRadius: BorderRadius.circular(20)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(MyImages.whiteStar, width: 10,),
                                            const SizedBox(width: 5),
                                            Text("${controller.homeDetails[index].rate}", style: const TextStyle(color: MyColors.white, fontWeight: FontWeight.w600, fontSize: 12),),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Text("${controller.homeDetails[index].hotelName}", style: const TextStyle(color: MyColors.white, fontWeight: FontWeight.w700, fontSize: 18),),
                                  const SizedBox(height: 5),
                                  Text("${controller.homeDetails[index].location}", style: const TextStyle(color: MyColors.white, fontWeight: FontWeight.w400, fontSize: 14),),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text("${controller.homeDetails[index].price}", style: const TextStyle(color: MyColors.white, fontWeight: FontWeight.w700, fontSize: 20),),
                                      const Text(" / per night", style: TextStyle(color: MyColors.white, fontWeight: FontWeight.w400, fontSize: 14),),
                                      const Spacer(),
                                      SvgPicture.asset(MyImages.bookMarkLight),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      );
                    },
                  ),
                ),
                 */
              SizedBox(
                height: 300,
                child: Obx(() => controller.isLoading2.value
                    ? Center(
                  child: CircularProgressIndicator(
                    color: controller.themeController.isDarkMode.value ? Colors.white : MyColors.successColor,
                  ),
                )
                    : controller.restAreas.isNotEmpty
                    ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.restAreas.length,
                  itemBuilder: (context, index) {
                    var reservation = controller.restAreas[index];
                    int id = reservation['id'];

                    bool isFav = controller.favoriteIds.contains(id);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: InkWell(
                        onTap: () {
                          Detail detail = Detail.fromJson(reservation);
                          controller.homeDetails.add(detail);
                          Get.toNamed("/hotelDetail", arguments: {'data': reservation});
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                          width: 230,
                          decoration: BoxDecoration(
                            color: MyColors.disabledColor,
                            borderRadius: BorderRadius.circular(40),
                            image: DecorationImage(
                              image: NetworkImage('https://esteraha.ly/public/${reservation['main_image']}'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: MyColors.primaryColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(MyImages.whiteStar, width: 10),
                                        const SizedBox(width: 5),
                                        Text(
                                          reservation['rating'].toString(),
                                          style: const TextStyle(color: MyColors.white, fontWeight: FontWeight.w600, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Obx(() => GestureDetector(
                                    onTap: () => controller.toggleFavorite(id),
                                    child: SvgPicture.asset(
                                      controller.favoriteIds.contains(id)
                                          ? MyImages.selectedBookMarkBlack
                                          : MyImages.unSelectBookMark,
                                      width: 25,
                                      height: 25,
                                    ),
                                  )),

                                ],
                              ),
                              const Spacer(),
                              Text(
                                reservation['name'],
                                style: const TextStyle(color: MyColors.white, fontWeight: FontWeight.w700, fontSize: 18),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                reservation['location'],
                                style: const TextStyle(color: MyColors.white, fontWeight: FontWeight.w400, fontSize: 14),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Text(
                                    " السعر/",
                                    style: TextStyle(color: MyColors.white, fontWeight: FontWeight.w400, fontSize: 14),
                                  ),
                                  Text(
                                    reservation['price'],
                                    style: const TextStyle(color: MyColors.white, fontWeight: FontWeight.w700, fontSize: 20),
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
                    : Center(
                  child: Text(
                    'لايوجد بيانات مطابقة لبحثك',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )),
              ),

          
              const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // للتنقل إلى صفحة الخريطة
                      // لو تستخدم GetX:
                      Get.to(() =>  MapPickerScreen(restAreas: controller.restAreas,));
          
                      // أو لو تستخدم Navigator:
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => NearbyRestAreasPage()),
                      // );
                    },
                    child: Text(' عرض الاستراحات القريبة منك',style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16,fontFamily:'Tajawal'  ),),
                  ),
                ),
                // في ودجت الـ Container
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              MyString.recentlyBooked,
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                            InkWell(
                              onTap: () {
                                Get.toNamed("/Booking");
                              },
                              child: const Text(
                                MyString.seeAll,
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          child: Obx(() {
                            // الحالة الأولى: عرض مؤشر التحميل
                            if (controller.isbookLoading.value) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            // الحالة الثانية: إذا كان التوكن فارغاً (بعد اكتمال التحميل)
                            if (controller.token == null) {
                              return Column(
                                children: [
                                  Text('سجّل الدخول لمشاهدة اخر حجوزاتك'),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Get.offNamedUntil('/loginOptionScreen', (route) => false);
                                      },
                                      child: Text('تسجيل الدخول', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, fontFamily: 'Tajawal', ),),
                                    ),
                                  ),
                                ],
                              );
                            }
                            // الحالة الثالثة: إذا كانت البيانات فارغة (بعد التحميل ووجود التوكن)
                            if (controller.filteredReservations.isEmpty) {
                              return const Center(
                                child: Text("لا توجد بيانات حالياً"),
                              );
                            }
                            // الحالة الرابعة: عرض البيانات
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: controller.filteredReservations.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    // الإجراء عند الضغط
                                  },
                                  child: VerticalView(index: index),
                                );
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),),
        )
      ),
    );
  }
}
