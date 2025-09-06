import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hotel_booking/Model/RestAreas.dart';
import 'package:hotel_booking/core/constants/my_colors.dart';
import 'package:hotel_booking/presentation/common_widgets/custom_button.dart';
import 'package:hotel_booking/presentation/screen/RestAreaController.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
class AddRestAreaScreen extends StatefulWidget {
  @override
  _AddRestAreaScreenState createState() => _AddRestAreaScreenState();
}

class _AddRestAreaScreenState extends State<AddRestAreaScreen> {
  final _formKey = GlobalKey<FormState>();
  RxInt userId = 0.obs;
  bool _isEditMode = false; // 🔴 متغير لتحديد وضع التعديل
  Future<void> loadUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId.value = prefs.getInt('user_id') ?? 0;
  }
  final _restArea = RestAreas(
    id: 0,
    areaType: [], // 🔴 تم التعديل هنا من [''] إلى []
    name: "Rest Area Name",
    location: "123 Main St, City, Country",
    gamesdetails: "",
    price: 0,
    totalSpace: 0,
    internalSpace: 0,
    maxGuests: 0,
    numDoubleBeds: 0,
    numSingleBeds: 0,
    numBedrooms: 0,
    numFloors: 0,
    numBathroomsIndoor: 0,
    numBathroomsOutdoor: 0,
    kitchenAvailable: false,
    kitchenContents: [""],
    hasAcHeating: true,
    tvScreens: true,
    freeWifi: true,
    entertainmentGames: [""],
    outdoorSpace: false,
    grassSpace: false,
    poolType: "Infinity",
    poolSpace: 0,
    poolDepth: 0,
    poolHeating: true,
    poolFilter: true,
    garage: true,
    outdoorSeating: true,
    childrenGames: true,
    outdoorKitchen: true,
    slaughterPlace: false,
    well: true,
    powerGenerator: true,
    outdoorBathroom: false,
    otherSpecs: "",

    mainImage: "",
    detailsImages: [],
    rating: 0,
    description: "",
    geoArea: "Geo Area Description",

    cityId: 9,
    checkInTime: "14:00",
    checkOutTime: "12:00",
    jumpAvailable: false,
    boardPitAvailable: false,
    fishingAvailable: false,
    depositValue: 0,
    googleMapsLocation: "",
    holidayPrice: 0,
    idProofType: "لا يشترط",
    eidDaysPrice: 0,
  );

  XFile? _mainImage;
  List<XFile> _detailsImages = [];
  // 🔴🔴🔴 متغيرات جديدة لتخزين روابط الصور المحملة من قاعدة البيانات 🔴🔴🔴
  String? _initialMainImageUrl;
  List<String> _initialDetailsImageUrls = [];
  int _currentStep = 0;
  late RestAreaController controller;
  late TextEditingController nameController;
  late TextEditingController locationController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController totalSpaceController;
  late TextEditingController internalSpaceController;
  late TextEditingController maxGuestsController;
  late TextEditingController checkInTimeController;
  late TextEditingController otherSpecsController;
  late TextEditingController entertainmentGamesController;

  late TextEditingController checkOutTimeController;
  late TextEditingController googleMapsLocationController;
  late TextEditingController holidayPriceController;
  late TextEditingController eidDaysPriceController;
  late TextEditingController depositValueController;
  late TextEditingController numFloorsController; // 🔴 إضافة كنترولر لعدد الطوابق
  late TextEditingController numBedroomsController; // 🔴 إضافة كنترولر لعدد غرف النوم
  late TextEditingController numDoubleBedsController; // 🔴 إضافة كنترولر لعدد الأسرة المزدوجة
  late TextEditingController numSingleBedsController; // 🔴 إضافة كنترولر لعدد الأسرة المفردة
  late TextEditingController numBathroomsIndoorController; // 🔴 إضافة كنترولر لدورات المياه الداخلية
  late TextEditingController numBathroomsOutdoorController; // 🔴 إضافة كنترولر لدورات المياه الخارجية
  late TextEditingController kitchenContentsController; // 🔴 إضافة كنترولر لمحتويات المطبخ
  late TextEditingController poolSpaceController; // 🔴 إضافة كنترولر لمساحة المسبح
  late TextEditingController poolDepthController; // 🔴 إضافة كنترولر لعمق المسبح
  late TextEditingController poolTypeController; // 🔴 إضافة كنترولر لنوع المسبح
  late TextEditingController gamesdetailsController; // 🔴 إضافة كنترولر لتفاصيل الألعاب

@override
void initState() {
loadUserId();
super.initState();

nameController = TextEditingController();
locationController = TextEditingController();
descriptionController = TextEditingController();
priceController = TextEditingController();
totalSpaceController = TextEditingController();
internalSpaceController = TextEditingController();
maxGuestsController = TextEditingController();
checkInTimeController = TextEditingController();
checkOutTimeController = TextEditingController();
googleMapsLocationController = TextEditingController();

holidayPriceController = TextEditingController();
eidDaysPriceController = TextEditingController();
depositValueController = TextEditingController();

entertainmentGamesController= TextEditingController();
numFloorsController = TextEditingController(); // 🔴 تهيئة كنترولر
numBedroomsController = TextEditingController(); // 🔴 تهيئة كنترولر
numDoubleBedsController = TextEditingController(); // 🔴 تهيئة كنترولر
numSingleBedsController = TextEditingController(); // 🔴 تهيئة كنترولر
numBathroomsIndoorController = TextEditingController(); // 🔴 تهيئة كنترولر
numBathroomsOutdoorController = TextEditingController(); // 🔴 تهيئة كنترولر
kitchenContentsController = TextEditingController(); // 🔴 تهيئة كنترولر
poolSpaceController = TextEditingController(); // 🔴 تهيئة كنترولر
poolDepthController = TextEditingController(); // 🔴 تهيئة كنترولر
poolTypeController = TextEditingController(); // 🔴 تهيئة كنترولر
gamesdetailsController = TextEditingController(); // 🔴 تهيئة كنترولر
otherSpecsController = TextEditingController(); // 🔴 تهيئة كنترولر
// جلب الوسائط (arguments) لتحديد ما إذا كانت عملية تعديل
final args = Get.arguments;
if (args != null && args['isEdit'] == true && args['restAreaData'] != null) {
  _isEditMode = true; // 🔴 تحديد وضع التعديل
  final data = args['restAreaData'] as Map<String, dynamic>;

  // مِلء كائن الاستراحة الحالي بالقيم القادمة
  _restArea.name = data["name"] ?? "";
  _restArea.location = data["location"] ?? "";
  _restArea.description = data["description"] ?? "";
  _restArea.price = double.tryParse(data["price"].toString()) ?? 0.0;
  _restArea.totalSpace = int.tryParse(data["total_space"]?.toString() ?? "0") ?? 0;


  _restArea.internalSpace = int.tryParse(data["internal_space"]?.toString() ?? "0") ?? 0;
  _restArea.maxGuests = int.tryParse(data["maxGuests"]?.toString() ?? "0") ?? 0;


  // 🔴🔴🔴 إضافة طباعة تصحيح هنا 🔴�🔴
  debugPrint('DEBUG: Data from args["restAreaData"] for num_bedrooms: ${data["num_bedrooms"]}');
  debugPrint('DEBUG: Data from args["restAreaData"] for num_double_beds: ${data["num_double_beds"]}');
  debugPrint('DEBUG: Data from args["restAreaData"] for num_single_beds: ${data["num_single_beds"]}');
  debugPrint('DEBUG: Data from args["restAreaData"] for num_bathrooms_indoor: ${data["num_bathrooms_indoor"]}');
  debugPrint('DEBUG: Data from args["restAreaData"] for num_bathrooms_outdoor: ${data["num_bathrooms_outdoor"]}');


  // تحديث حالة الـ boolean من القيم النصية أو الرقمية
  _restArea.kitchenAvailable = _parseBool(data["kitchen_available"]);
  _restArea.hasAcHeating = _parseBool(data["has_ac_heating"]);
  _restArea.tvScreens = _parseBool(data["tv_screens"]);
  _restArea.freeWifi = _parseBool(data["free_wifi"]);
  _restArea.outdoorSpace = _parseBool(data["outdoor_space"]);
  _restArea.grassSpace = _parseBool(data["grass_space"]);
  _restArea.poolHeating = _parseBool(data["pool_heating"]);
  _restArea.poolFilter = _parseBool(data["pool_filter"]);
  _restArea.garage = _parseBool(data["garage"]);
  _restArea.outdoorSeating = _parseBool(data["outdoor_seating"]);
  _restArea.childrenGames = _parseBool(data["children_games"]);
  _restArea.outdoorKitchen = _parseBool(data["outdoor_kitchen"]);
  _restArea.slaughterPlace = _parseBool(data["slaughter_place"]);
  _restArea.well = _parseBool(data["well"]);
  _restArea.powerGenerator = _parseBool(data["power_generator"]);
  _restArea.outdoorBathroom = _parseBool(data["outdoor_bathroom"]);
  _restArea.jumpAvailable = _parseBool(data["jump_available"]);
  _restArea.boardPitAvailable = _parseBool(data["board_pit_available"]);
  _restArea.fishingAvailable = _parseBool(data["fishing_available"]);

  // تحديث حالة _hasPool بناءً على وجود بيانات المسبح
  if (data["pool_type"] != null && data["pool_type"].isNotEmpty && data["pool_type"] != "null") {
    _hasPool = true;
    _restArea.poolType = data["pool_type"];
    //_restArea.poolSpace = double.tryParse(data["pool_space"].toString()) ?? 0.0;
    _restArea.poolDepth = double.tryParse(data["pool_depth"].toString()) ?? 0.0;
  } else {
    _hasPool = false;
  }
  _restArea.numDoubleBeds = int.tryParse(data["num_double_beds"]?.toString() ?? "0") ?? 0;
  _restArea.numSingleBeds = int.tryParse(data["num_single_beds"]?.toString() ?? "0") ?? 0;
  _restArea.numBedrooms = int.tryParse(data["numBedrooms"]?.toString() ?? "0") ?? 0;
  _restArea.numFloors = int.tryParse(data["num_floors"]?.toString() ?? "0") ?? 0;
  _restArea.numBathroomsIndoor = int.tryParse(data["num_bathrooms_indoor"]?.toString() ?? "0") ?? 0;
  _restArea.numBathroomsOutdoor = int.tryParse(data["num_bathrooms_outdoor"]?.toString() ?? "0") ?? 0;



  // 🔴🔴🔴 إضافة طباعة تصحيح هنا بعد تعيين القيم لـ _restArea 🔴🔴🔴
  debugPrint('DEBUG: _restArea.numBedrooms after assignment: ${_restArea.numBedrooms}');
  debugPrint('DEBUG: _restArea.numDoubleBeds after assignment: ${_restArea.numDoubleBeds}');
  debugPrint('DEBUG: _restArea.numSingleBeds after assignment: ${_restArea.numSingleBeds}');
  debugPrint('DEBUG: _restArea.numBathroomsIndoor after assignment: ${_restArea.numBathroomsIndoor}');
  debugPrint('DEBUG: _restArea.numBathroomsOutdoor after assignment: ${_restArea.numBathroomsOutdoor}');

  _restArea.id = data["id"] ?? 0; // تأكد من أن city_id هو int
  _restArea.kitchenContents = _parseStringList(data["kitchen_contents"]);
  //_restArea.entertainmentGames = _parseStringList(data["entertainment_games"]);
  _restArea.otherSpecs = data["other_specs"] ?? "";
  _restArea.gamesdetails = data["gamesdetails"] ?? "";
  _restArea.cityId = int.tryParse(data["city_id"]?.toString() ?? "0") ?? 0;

  _restArea.checkInTime = data["check_in_time"] ?? "00:00";
  _restArea.checkOutTime = data["check_out_time"] ?? "00:00";
  _restArea.googleMapsLocation = data["google_maps_location"] ?? "";
  _restArea.idProofType = data["id_proof_type"] ?? "لا يشترط";
  _restArea.holidayPrice = double.tryParse(data["holiday_price"].toString()) ?? 0.0;
  _restArea.eidDaysPrice = double.tryParse(data["eid_days_price"].toString()) ?? 0.0;
  _restArea.depositValue = double.tryParse(data["deposit_value"].toString()) ?? 0.0;
  _restArea.geoArea = data["geo_area"] ?? "";
  _restArea.areaType = _parseStringList(data["area_type"]);

  _restArea.cleanAreaTypes(); // 🔴 تنظيف قائمة areaType بعد التحميل

  // 🔴🔴🔴 تعيين روابط الصور المحملة من قاعدة البيانات 🔴🔴🔴
  _initialMainImageUrl = data["main_image"] ?? "";
  _initialDetailsImageUrls = _parseStringList(data["details_images"]);
  // تعبئة الكنترولات
  nameController.text = _restArea.name;
  locationController.text = _restArea.location;
  descriptionController.text = _restArea.description;
  priceController.text = (_restArea.price % 1 == 0)
      ? _restArea.price.toInt().toString()  // إذا كان عدد صحيح، بدون كسور
      : _restArea.price.toString();
  totalSpaceController.text = _restArea.totalSpace.toString();
  internalSpaceController.text = _restArea.internalSpace.toString();
  maxGuestsController.text = _restArea.maxGuests.toString();
  checkInTimeController.text = _restArea.checkInTime;
  checkOutTimeController.text = _restArea.checkOutTime;
  googleMapsLocationController.text = _restArea.googleMapsLocation;
  holidayPriceController.text = _restArea.holidayPrice.toString();
  eidDaysPriceController.text = _restArea.eidDaysPrice.toString();
  depositValueController.text = _restArea.depositValue.toString();
  numFloorsController.text = _restArea.numFloors.toString(); // 🔴 تعبئة كنترولر
  numBedroomsController.text = _restArea.numBedrooms.toString(); // 🔴 تعبئة كنترولر
  numDoubleBedsController.text = _restArea.numDoubleBeds.toString(); // 🔴 تعبئة كنترولر
  numSingleBedsController.text = _restArea.numSingleBeds.toString(); // 🔴 تعبئة كنترولر
  numBathroomsIndoorController.text = _restArea.numBathroomsIndoor.toString(); // 🔴 تعبئة كنترولر
  numBathroomsOutdoorController.text = _restArea.numBathroomsOutdoor.toString(); // 🔴 تعبئة كنترولر
  kitchenContentsController.text = _restArea.kitchenContents.join(', '); // 🔴 تعبئة كنترولر
  poolSpaceController.text = _restArea.poolSpace.toString(); // 🔴 تعبئة كنترولر
  poolDepthController.text = _restArea.poolDepth.toString(); // 🔴 تعبئة كنترولر
  poolTypeController.text = _restArea.poolType; // 🔴 تعبئة كنترولر
  gamesdetailsController.text = _restArea.gamesdetails; // 🔴 تعبئة كنترولر
  otherSpecsController.text = _restArea.otherSpecs; // 🔴 تعبئة كنترولر


  // إذا كانت هناك صور موجودة، قم بتحميلها (هذا يتطلب منطقًا إضافيًا لتحميل الصور من URL إلى XFile)
  // حاليًا، هذا الجزء غير مدعوم بشكل مباشر في هذا الكود، ستحتاج إلى تنفيذه
   //_mainImage = XFile(data["main_image"]);
// _detailsImages = (data["details_images"] as List).map((url) => XFile(url)).toList();

  setState(() {}); // لتحديث واجهة المستخدم بعد ملء البيانات
}
controller = Get.put(RestAreaController());
}
  // دالة مساعدة لتحويل القيم إلى List<String>
  // دالة مساعدة لتحويل القيم إلى bool
  bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value.toLowerCase() == 'true' || value == '1';
    return false;
  }

  // دالة مساعدة لتحويل القيم إلى List<String>
  // دالة مساعدة لتحويل القيم إلى List<String>
  List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    if (value is String) {
      // إذا كانت مخزنة كسلسلة JSON
      try {
        final decoded = jsonDecode(value);
        if (decoded is List) {
          return decoded.map((e) => e.toString()).toList();
        }
      } catch (e) {
        // 🔴🔴🔴 التعديل هنا: تقسيم السلسلة بواسطة الفاصلة (,) وتنظيف المسافات 🔴🔴🔴
        return value.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      }
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    print("_initialMainImageUrls $_initialMainImageUrl");
    print("_mainImagefinal $_mainImage");
    List<String> parsedAreaType = _parseStringList(_restArea.areaType);
    print("Parsed Area Type: ${_restArea.checkInTime}"); // سيطبع: [للعائلات, للشباب]
    print("Parsed Area Type: ${_restArea.checkOutTime}"); // سيطبع: [للعائلات, للشباب]

    //_isLoading = false;
    return Obx(() {
      if (userId.value == 0) {
        print(userId.value);
        return Center(child: Scaffold(body: Center(child: CircularProgressIndicator()))); // جاري التحميل
      } else {



      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
                _isEditMode ? 'تعديل الاستراحة' : 'إضافة استراحة جديدة', // 🔴 تغيير العنوان هنا
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: 'Tajawal',
                )),
            centerTitle: true,
            backgroundColor: MyColors.primaryColor,
            elevation: 0,
           // iconTheme: IconThemeData(color: MyColors.primaryColor),
          ),
          body: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: MyColors.primaryColor,
              ),
            ),
            child: Stepper(
              currentStep: _currentStep,
              onStepContinue: () {
                final isLastStep = _currentStep == 3;
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  if (isLastStep) {
                    //_submitForm();
                  } else {
                    setState(() => _currentStep += 1);
                  }
                }
                /*
                if (_currentStep < 3) {
                  setState(() => _currentStep += 1);
                } else {
                  _submitForm();
                }
               */
              },
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() => _currentStep -= 1);
                }
              },
              steps: [
                _buildBasicInfoStep(),
                _buildRoomsAndFacilitiesStep(),
                _buildOutdoorFeaturesStep(),
                _buildImagesStep(),
              ],
              controlsBuilder: (context, details) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentStep != 0)
                        ElevatedButton(
                          onPressed: details.onStepCancel,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('السابق',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily: 'Tajawal',
                              )),
                        ),


                // 🔴🔴🔴 هذا هو الجزء الذي تم تعديله 🔴🔴🔴
                      Obx(() => ElevatedButton(
                        onPressed: controller.isLoading.value // تعطيل الزر أثناء التحميل
                            ? null
                            : () async {
                          if (_currentStep == 3) { // إذا كانت هذه هي الخطوة الأخيرة (خطوة الصور)
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save(); // حفظ البيانات من النموذج

                              // 🔴 لا حاجة لـ setState(_isLoading = true/false) هنا
                              // لأن controller.isLoading سيتولى إدارة حالة التحميل

                              try {
                                print("_isEditMode $_isEditMode");
                                // 🔴 استدعاء دالة saveRestArea من الكنترولر
                                if (_isEditMode==false){
                                  await controller.saveRestArea(_restArea, _mainImage, _detailsImages);
                                }else{
                                  print("_isEditMode $_isEditMode");
                                  print("_mainImagefinal $_mainImage");
                                  print("_initialMainImageUrlfinal $_initialMainImageUrl");
                                  print("_restArea mainImage ${_restArea.mainImage}");

                                await controller.updateRestArea(_restArea, _mainImage, _detailsImages, _initialMainImageUrl,_initialDetailsImageUrls);
                                }

                                // 🔴 التنقل بعد النجاح (الكنترولر سيعرض snackbar النجاح)
                                Get.toNamed("/myHosting");
                              } catch (e) {
                                // 🔴 يتم التعامل مع الأخطاء وعرضها بواسطة _handleError في الكنترولر
                                // لا حاجة لـ Get.snackbar هنا
                                print("Error during saveRestArea: $e");
                              }
                            }
                          } else { // إذا لم تكن الخطوة الأخيرة
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save(); // حفظ البيانات
                              details.onStepContinue!(); // الانتقال للخطوة التالية
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.primaryColor, // لون زر التالي/الحفظ
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: controller.isLoading.value // عرض مؤشر التحميل أو النص
                            ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : Text(
                          _currentStep == 3 ? 'حفظ البيانات' : 'التالي',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      )),


                ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    }  }
    );
  }

  Step _buildBasicInfoStep() {
    return Step(
      title: Text('المعلومات الأساسية',
          style: TextStyle(color: MyColors.tealColor)),
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildTextFormField(
              controller: nameController,
              'اسم الاستراحة',
              Icons.home_work,
              (value) {
                print(value);
                _restArea.name = value!; // تحديث الكائن هنا
              },
              validator: _requiredValidator,
            ),
            _buildTextFormField(
              controller: descriptionController,
              'وصف قصير للإستراحة',
              Icons.description,
                  (value) {
                print(value);
                _restArea.description = value!; // تحديث الكائن هنا
              },
              maxLines: 3, // 🔴 تم إضافة خاصية maxLines
              validator: _requiredValidator,
            ),
            _buildTextFormField(
              controller: otherSpecsController,
              'مواصفات اضافية',
              Icons.info_outline,
                  (value) {
                print(value);
                _restArea.otherSpecs = value!; // تحديث الكائن هنا
              },
              maxLines: 3, // 🔴 تم إضافة خاصية maxLines
              validator: _requiredValidator,
            ),


            _buildTextFormField(
              'المساحة الداخلية',
              Icons.area_chart, // أي رمز مناسب هنا
              controller:internalSpaceController ,
              (value) {
                _restArea.internalSpace =
                    int.tryParse(value!) ?? 0; // تحديث الكائن هنا
              },
              validator: _requiredValidator,
            ),
            _buildTextFormField(
              'المساحة الإجمالية',
              Icons.grid_view, // أي رمز مناسب هنا
              controller:totalSpaceController ,
              (value) {
                _restArea.totalSpace =
                    int.tryParse(value!) ?? 0; // تحديث الكائن هنا
              },
              validator: _requiredValidator,
            ),
            _buildTextFormField( // 🔴 تم تعديل هذا ليستخدم controller
              controller: numFloorsController,
              'عدد الطوابق',
              Icons.apps,
                  (value) {
                _restArea.numFloors = int.tryParse(value!) ?? 0;
              },
              validator: _requiredValidator,
            ),
            _buildTextFormField(
              controller: locationController,
              'العنوان او اقرب نقطة دالة',
              Icons.location_on,
                  (value) => _restArea.location = value!,
              validator: _requiredValidator,
            ),

            _buildNumberField(
              controller: priceController,
              'السعر',
              Icons.attach_money,
                  (value) => _restArea.price = value,
              validator: _priceValidator,
            ),
            _buildNumberField(
              controller: maxGuestsController,
              'العدد الأقصى للضيوف',
              Icons.people,
                  (value) => _restArea.maxGuests = value.toInt(),
              validator: _requiredValidator,
            ),
            _buildNumberField(
              controller: depositValueController,
              'قيمة العربون',
              Icons.monetization_on_outlined,
                  (value) => _restArea.depositValue = value,
              validator: _requiredValidator,
            ),
            _buildTextFormField(
              controller: googleMapsLocationController,
              'الموقع على خرائط جوجل (رابط)',
              Icons.map,
                  (value) => _restArea.googleMapsLocation = value ?? "",
              //validator: _requiredValidator,
            ),
            _buildNumberField(
              controller: holidayPriceController,
              'سعر العطل الرسمية',
              Icons.event,
                  (value) => _restArea.holidayPrice = value,
              validator: _requiredValidator,
            ),
            _buildNumberField(
              controller: eidDaysPriceController,
              'سعر أيام العيد',
              Icons.celebration,
                  (value) => _restArea.eidDaysPrice = value,
              validator: _requiredValidator,
            ),
            _buildDropdown(
              'نوع اثبات الهوية المطلوب',
              Icons.credit_card,
              [
                'جواز سفر ساري المفعول',
                'كتيب عائلة',
                'وثيقة زواج',
                'لا يشترط'
              ],
              _restArea.idProofType,
                  (value) => setState(() => _restArea.idProofType = value ?? 'لا يشترط'),
            ),
            _buildDropdown(
              'المنطقة الجغرافية',
              Icons.map,
              [
                'مطلة على البحر',
                'قريبة من البحر',
                'وسط البلاد',
                'في منطقة سياحية'
              ],
              _restArea.geoArea,
                  (value) => setState(() => _restArea.geoArea = value ?? ''),
            ),
            _buildAreaTypeCheckboxes(),
            _buildTimeRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildAreaTypeCheckboxes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(' فئة الزوار', style: TextStyle(fontSize: 16)),
        CheckboxListTile(
          title: Text('للعائلات'),
          value: _restArea.areaType.contains('للعائلات'),
          onChanged: (bool? isChecked) {
            setState(() {
              if (isChecked == true) {
                _restArea.areaType.add('للعائلات');
              } else {
                _restArea.areaType.remove('للعائلات');
              }
            });
          },
        ),
        CheckboxListTile(
          title: Text('للشباب'),
          value: _restArea.areaType.contains('للشباب'),
          onChanged: (bool? isChecked) {
            setState(() {
              if (isChecked == true) {
                _restArea.areaType.add('للشباب');
              } else {
                _restArea.areaType.remove('للشباب');
              }
            });
          },
        ),
        CheckboxListTile(
          title: Text('للمناسبات'),
          value: _restArea.areaType.contains('للمناسبات'),
          onChanged: (bool? isChecked) {
            setState(() {
              if (isChecked == true) {
                _restArea.areaType.add('للمناسبات');
              } else {
                _restArea.areaType.remove('للمناسبات');
              }
            });
          },
        ),
      ],
    );
  }

  Step _buildRoomsAndFacilitiesStep() {
    return Step(
      title:
      Text('الغرف والمرافق', style: TextStyle(color: MyColors.tealColor)),
      content: Column(
        children: [
          _buildSectionTitle(
            'الغرف والأسرة',
          ),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildNumberInputChip(
                  'غرف نوم',
                  Icons.bed,
                  _restArea.numBedrooms ?? 0,
                      (value) => setState(() => _restArea.numBedrooms = value)), // 🔴 استخدام setState
              _buildNumberInputChip(
                  'أسرة مزدوجة',
                  Icons.bed,
                  _restArea.numDoubleBeds ?? 0,
                      (value) => setState(() => _restArea.numDoubleBeds = value)), // 🔴 استخدام setState
              _buildNumberInputChip(
                  'أسرة مفردة',
                  Icons.single_bed,
                  _restArea.numSingleBeds ?? 0,
                      (value) => setState(() => _restArea.numSingleBeds = value)), // 🔴 استخدام setState
              _buildNumberInputChip(
                  'دورات مياه داخلية',
                  Icons.bathtub,
                  _restArea.numBathroomsIndoor ?? 0,
                      (value) => setState(() => _restArea.numBathroomsIndoor = value)), // 🔴 استخدام setState
              _buildNumberInputChip(
                  'دورات مياه خارجية',
                  Icons.water,
                  _restArea.numBathroomsOutdoor ?? 0,
                      (value) => setState(() => _restArea.numBathroomsOutdoor = value)), // 🔴 استخدام setState
            ],
          ),
          _buildSectionTitle('المرافق الداخلية'),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildFeatureChip(
                'مطبخ',
                Icons.kitchen,
                _restArea.kitchenAvailable ?? false,
                    (value) {
                  setState(() {
                    _restArea.kitchenAvailable = value;
                  });
                },
              ),
              _buildFeatureChip(
                  'تكييف/تدفئة',
                  Icons.ac_unit,
                  _restArea.hasAcHeating ?? false,
                      (value) => setState(() => _restArea.hasAcHeating = value)),
              _buildFeatureChip(
                  'تلفزيون',
                  Icons.tv,
                  _restArea.tvScreens ?? false,
                      (value) => setState(() => _restArea.tvScreens = value)),
              _buildFeatureChip(
                  'واي فاي',
                  Icons.wifi,
                  _restArea.freeWifi ?? false,
                      (value) => setState(() => _restArea.freeWifi = value)),
            ],
          ),
          if (_restArea.kitchenAvailable ?? false) ...[
            _buildTextFormField(
              controller: kitchenContentsController, // 🔴 استخدام الكنترولر الصحيح
              'ادخل محتويات المطبخ (افصلها بفاصلة)',
              Icons.kitchen,
                  (value) {
                _restArea.kitchenContents = value!.split(',').map((e) => e.trim()).toList();
              },
              validator: _requiredValidator,
              maxLines: 3,
            ),
          ],
        ],
      ),
    );
  }

  bool _hasPool = false;
  Step _buildOutdoorFeaturesStep() {
    return Step(
      title:
          Text('المرافق الخارجية', style: TextStyle(color: MyColors.tealColor)),
      content: Column(
        children: [
          _buildSectionTitle('المسبح'),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              // خيار يوجد مسبح
              _buildFeatureChip('يوجد مسبح', Icons.pool, _hasPool, (value) {
                setState(() {
                  _hasPool = value; // تحديث المتغير عند التحديد
                  if (!value) {
                    _restArea.poolType = ""; // إعادة تعيين نوع المسبح
                    _restArea.poolSpace = 0; // إعادة تعيين مساحة المسبح
                    _restArea.poolHeating = false; // إعادة تعيين حالة التدفئة
                    _restArea.poolFilter = false; // إعادة تعيين حالة الفلتر
                  } else {
                    _restArea.poolType = 'عادي'; // تعيين نوع المسبح عند التحديد
                  }
                });
              }),

              // إذا كان هناك مسبح، عرض الخيارات الإضافية
              if (_hasPool) ...[
                _buildNumberInputChip(
                  'مساحة المسبح',
                  Icons.square_foot,
                  (_restArea.poolSpace ?? 0).toInt(), // تحويل إلى int
                  (value) => _restArea.poolSpace =
                      value.toInt(), // تحويل القيمة المدخلة إلى double
                ),
                _buildFeatureChip(
                    'تدفئة', Icons.thermostat, _restArea.poolHeating ?? false,
                    (value) {
                  _restArea.poolHeating = value; // تحديث حالة التدفئة
                }),
                _buildFeatureChip(
                    'فلتر', Icons.filter_alt, _restArea.poolFilter ?? false,
                    (value) {
                  _restArea.poolFilter = value; // تحديث حالة الفلتر
                }),
              ],
            ],
          ),

          _buildSectionTitle('مرافق أخرى'),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildFeatureChip(
                'جلسات خارجية',
                Icons.chair,
                _restArea.outdoorSeating ?? false,
                (value) => _restArea.outdoorSeating = value,
              ),
              _buildFeatureChip(
                'مساحة خارجية',
                Icons.nature    , // أيقونة شرفة/مساحة خارجية
                _restArea.outdoorSpace ?? false,
                    (value) => _restArea.outdoorSpace = value,
              ),
              _buildFeatureChip(
                'مساحة عشب',
                Icons.yard  ,
                _restArea.grassSpace ?? false,
                    (value) => _restArea.grassSpace = value,
              ),

              _buildFeatureChip(
                'بئر',
                Icons.water,
                _restArea.well ?? false,
                (value) => _restArea.well = value,
              ),
              _buildFeatureChip(
                'مولد كهربائي',
                Icons.power,
                _restArea.powerGenerator ?? false,
                (value) => _restArea.powerGenerator = value,
              ),
              _buildFeatureChip(
                'مكان للذبح',
                Icons.local_hospital,
                _restArea.slaughterPlace ?? false,
                (value) => _restArea.slaughterPlace = value,
              ),
              _buildFeatureChip(
                'ألعاب أطفال',
                Icons.child_friendly,
                _restArea.childrenGames ?? false,
                (value) => _restArea.childrenGames = value,
              ),
              _buildFeatureChip(
                'لوح للقفز',
                Icons.sports_kabaddi,
                _restArea.jumpAvailable ?? false,
                    (value) => _restArea.jumpAvailable = value,
              ),
              _buildFeatureChip(
                'مطبخ خارجي',
                Icons.outdoor_grill,
                _restArea.outdoorKitchen ?? false,
                (value) => _restArea.outdoorKitchen = value,
              ),
              _buildFeatureChip(
                'كراج',
                Icons.garage,
                _restArea.garage ?? false,
                (value) => _restArea.garage = value,
              ),
              _buildFeatureChip(
                'حفرة بورديم',
                Icons.panorama_photosphere_outlined,
                _restArea.boardPitAvailable ?? false,
                    (value) => _restArea.boardPitAvailable = value,
              ),
              _buildFeatureChip(
                'فسكية',
                Icons.anchor ,
                _restArea.fishingAvailable ?? false,
                    (value) => _restArea.fishingAvailable = value,
              ),
            ],
          ),

// حقل إدخال الألعاب إذا كان هناك ألعاب أطفال
          if (_restArea.childrenGames ?? false) ...[
            _buildTextFormField(
              controller: gamesdetailsController,
              'ادخل نوع  الالعاب',
              Icons.gamepad, // أي رمز مناسب هنا
              (value) {
                _restArea.gamesdetails = value; // تخزين تفاصيل الألعاب
              },
              validator: _requiredValidator,
            ),
          ],
        ],
      ),
    );
  }

  Step _buildImagesStep() {
    print("_initialMainImageUrl $_initialMainImageUrl");
    print("_initialDetailsImageUrls $_initialDetailsImageUrls");
    // 🔴🔴🔴 دمج الصور المحملة من الروابط مع الصور الجديدة المختارة 🔴🔴🔴
    List<dynamic> allDetailsImagesForDisplay = [];
    allDetailsImagesForDisplay.addAll(_initialDetailsImageUrls); // إضافة الروابط المحملة أولاً
    allDetailsImagesForDisplay.addAll(_detailsImages); // ثم إضافة ملفات XFile الجديدة

    return Step(
      title: Text('الصور', style: TextStyle(color: MyColors.tealColor)),
      content: Column(
        children: [
          Center(
            child: _buildImageCard(
              'الصورة الرئيسية',
              _mainImage, // الصورة الجديدة (XFile)
              _initialMainImageUrl, // الرابط الأولي (String)
                  (image) => setState(() => _mainImage = image),
              required: true,
            ),
          ),
          SizedBox(height: 20),
          _buildImageCard(
            'إضافة صور تفاصيل', // تم تغيير العنوان ليعكس وظيفة الإضافة
            null, // لا يوجد ملف XFile مبدئيًا لبطاقة "الإضافة" هذه
            null, // لا يوجد رابط URL مبدئي لبطاقة "الإضافة" هذه
                (image) => setState(() => _detailsImages.add(image!)),
            multiSelect: true,
          ),
          if (allDetailsImagesForDisplay.isNotEmpty) ...[ // التحقق من القائمة المدمجة
            SizedBox(height: 10),
            //صور التفاصيل
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: allDetailsImagesForDisplay.map((imageSource) {
                Widget imageWidget;
                if (imageSource is XFile) {
                  // إذا كانت الصورة ملف XFile (صورة جديدة تم اختيارها)
                  imageWidget = Image.file(File(imageSource.path), fit: BoxFit.cover);
                } else if (imageSource is String && imageSource.isNotEmpty) {
                  // إذا كانت الصورة رابط URL (صورة محملة من قاعدة البيانات)
                  imageWidget = Image.network('https://esteraha.ly/public/$imageSource', fit: BoxFit.cover, // 🔴🔴🔴 تم التعديل هنا 🔴🔴🔴
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 40, color: Colors.red), // fallback في حالة فشل تحميل الصورة
                  );
                } else {
                  imageWidget = Container(); // حالة لا ينبغي أن تحدث إذا كانت القائمة مفلترة
                }

                return Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: imageWidget, // عرض الودجت الصحيح للصورة
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.close, size: 18, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            // إزالة الصورة من القائمة الصحيحة
                            if (imageSource is XFile) {
                              _detailsImages.remove(imageSource);
                            } else if (imageSource is String) {
                              _initialDetailsImageUrls.remove(imageSource);
                            }
                          });
                        },
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTextFormField(
      String label,
      IconData icon,
      Function(String) onSaved, {
        String? Function(String?)? validator,
        int? maxLines, // 🔴 تم إضافة خاصية maxLines
        TextEditingController? controller,
      }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: TextFormField(
        maxLines: maxLines, // 🔴 استخدام maxLines هنا
        controller: controller,
        onChanged: (value) => onSaved(value),
        onSaved: (value) => onSaved(value ?? ''),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: MyColors.textPaymentInfo),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: MyColors.primaryColor),
          ),
        ),
        validator: validator,
      ),
    );
  }


  Widget _buildNumberField(
      String label,
      IconData icon,
      Function(double) onChanged, {
        String? Function(String?)? validator,
        required TextEditingController controller,
      }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller, // ✅ تم إضافته هنا
        onSaved: (value) => onChanged(double.tryParse(value ?? '0') ?? 0),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: MyColors.textPaymentInfo),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: MyColors.primaryColor),
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    IconData icon,
    List<String> items,
    String? value,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        onSaved: (value) => onChanged(value),
        value: items.contains(value)
            ? value
            : null, // تعيين القيمة إلى null إذا لم تكن موجودة
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: MyColors.textPaymentInfo),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: MyColors.primaryColor),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeRow() {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.login, color: MyColors.primaryColor),
          title: Text('وقت الدخول: ${_restArea.checkInTime}'),
          onTap: () => _selectTime(true),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.logout, color: MyColors.primaryColor),
          title: Text('وقت الخروج: ${_restArea.checkOutTime}'),
          onTap: () => _selectTime(false),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: MyColors.tealColor,
        ),
      ),
    );
  }

  Widget _buildNumberInputChip(
      String label, IconData icon, int value, Function(int) onChanged) {
    // 🔴🔴🔴 إضافة طباعة تصحيح هنا 🔴🔴🔴
    debugPrint('DEBUG: _buildNumberInputChip for "$label" received value: $value');

    return InputChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: MyColors.tealColor),
          SizedBox(width: 5),
          Text('$value'),
        ],
      ),
      backgroundColor: Colors.teal[50],
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            int tempValue = value;
            return AlertDialog(
              title: Text('تعديل $label'),
              content: TextField(
                keyboardType: TextInputType.number,
                onChanged: (v) => tempValue = int.tryParse(v) ?? 0,
                decoration: InputDecoration(
                  hintText: 'أدخل العدد',
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('إلغاء'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() => onChanged(tempValue));
                    Navigator.pop(context);
                  },
                  child: Text('حفظ'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildFeatureChip(
      String label, IconData icon, bool value, Function(bool) onChanged) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 18, color: value ? Colors.white : MyColors.tealColor),
          SizedBox(width: 5),
          Text(label,
              style: TextStyle(color: value ? Colors.white : Colors.black)),
        ],
      ),
      selected: value,
      onSelected: (selected) {
        onChanged(selected); // استدعاء onChanged
        setState(() {}); // تحديث الحالة
      },
      selectedColor: MyColors.tealColor,
      checkmarkColor: Colors.white,
      backgroundColor: Colors.teal[50],
      shape: StadiumBorder(side: BorderSide(color: Colors.teal)),
    );
  }

  // 🔴🔴🔴 تم تعديل دالة _buildImageCard لتدعم عرض الصور من روابط URL 🔴🔴🔴
  Widget _buildImageCard(String title, XFile? pickedImageFile, String? initialImageUrl, Function(XFile?) onImagePicked, {bool required = false, bool multiSelect = false}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () async {
          final ImagePicker _picker = ImagePicker();
          if (multiSelect) {
            final List<XFile> pickedFiles = await _picker.pickMultiImage();
            if (pickedFiles.isNotEmpty) { // التحقق من أن القائمة ليست فارغة
              pickedFiles.forEach((file) => onImagePicked(file));
            }
          } else {
            final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
            if (pickedFile != null) {
              onImagePicked(pickedFile);
            }
          }
        },
        child: Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: required && pickedImageFile == null && (initialImageUrl == null || initialImageUrl.isEmpty) ? Colors.red : Colors.grey.shade300),
          ),
          child: pickedImageFile != null // إذا كان هناك ملف XFile (صورة جديدة مختارة)
              ? Image.file(File(pickedImageFile.path), fit: BoxFit.cover)
              : (initialImageUrl != null && initialImageUrl.isNotEmpty) // وإلا، إذا كان هناك رابط URL أولي
              ? Image.network('https://esteraha.ly/public/$initialImageUrl', fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => // في حالة فشل تحميل الصورة من الرابط
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("https://esteraha.ly/public/$initialImageUrl"),
                const Icon(Icons.broken_image, size: 40, color: Colors.red),
                const SizedBox(height: 8),
                Text('فشل تحميل الصورة', style: TextStyle(color: Colors.red, fontFamily: 'Tajawal')),
              ],
            ),
          )
              : multiSelect // إذا لم يكن هناك أي صورة، وعملية الاختيار متعددة
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey),
              const SizedBox(height: 8),
              Text(title, style: TextStyle(color: Colors.grey, fontFamily: 'Tajawal')),
            ],
          )
              : Column( // إذا لم يكن هناك أي صورة، وعملية الاختيار فردية
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
              const SizedBox(height: 8),
              Text(title, style: TextStyle(color: Colors.grey, fontFamily: 'Tajawal')),
              if (required) Text('(مطلوب)', style: TextStyle(color: Colors.red, fontSize: 12, fontFamily: 'Tajawal')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview(XFile image, Function(XFile?) onRemove) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(image.path),
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: Icon(Icons.close, size: 18, color: Colors.red),
            onPressed: () => onRemove(null),
          ),
        ),
      ],
    );
  }

  Future<void> _selectTime(bool isCheckIn) async {
    final currentTime =
        isCheckIn ? _restArea.checkInTime : _restArea.checkOutTime;
    final parts = currentTime.split(':');
    final initialTime =
        TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        final timeStr =
            '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
        if (isCheckIn) {
          _restArea.checkInTime = timeStr;
        } else {
          _restArea.checkOutTime = timeStr;
        }
      });
    }
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'هذا الحقل مطلوب';
    }
    return null;
  }
  String? _priceValidator(String? value) {
    // التحقق من أن الحقل ليس فارغًا
    if (value == null || value.isEmpty) {
      return 'هذا الحقل مطلوب';
    }

    // التحقق من أن القيمة المدخلة رقمية وتحويلها
    final price = int.tryParse(value);
    if (price == null) {
      return 'أدخل سعرًا صحيحًا';
    }

    // التحقق من أن القيمة ضمن النطاق المطلوب
    if (price < 50 || price > 10000) {
      return 'يجب أن يكون السعر بين 50 و 10,000';
    }

    // إذا كانت كل الشروط صحيحة، لا توجد أخطاء
    return null;
  }
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print("_detailsImages ${_detailsImages}");
      if (_mainImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('الصورة الرئيسية مطلوبة')),
        );
        return;
      }

      if (_detailsImages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('يجب إضافة صور تفصيلية واحدة على الأقل')),
        );
        return;
      }
/*
      try {
        await _sendDataToServer();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تمت إضافة الاستراحة بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _sendDataToServer() async {
    var uri = Uri.parse('https://your-api-url/rest-areas');
    var request = http.MultipartRequest('POST', uri);

    // إضافة الحقول النصية
    // request.fields.addAll(_restArea.toJson());

    // إضافة الصورة الرئيسية
    if (_mainImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'main_image',
        _mainImage!.path,
      ));
    }

    // إضافة صور التفاصيل
    for (var image in _detailsImages) {
      request.files.add(await http.MultipartFile.fromPath(
        'details_images[]',
        image.path,
      ));
    }

    var response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('فشل في إرسال البيانات: ${response.statusCode}');
    }
  }
  */
    }
}
}
