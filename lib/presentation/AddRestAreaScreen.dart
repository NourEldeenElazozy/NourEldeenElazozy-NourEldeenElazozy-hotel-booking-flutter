import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hotel_booking/MapPickerScreens.dart';
import 'package:hotel_booking/Model/RestAreas.dart';
import 'package:hotel_booking/core/constants/my_colors.dart';
import 'package:hotel_booking/presentation/MyGoogleMapWidget.dart';
import 'package:hotel_booking/presentation/common_widgets/custom_button.dart';
import 'package:hotel_booking/presentation/screen/RestAreaController.dart';

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



  // 🔴🔴🔴 متغيرات جديدة لتخزين روابط الصور المحملة من قاعدة البيانات 🔴🔴🔴
  String? _initialMainImageUrl;
  List<String> _initialDetailsImageUrls = [];
  int _currentStep = 0;



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
  var value = data["max_guests"];
  _restArea.maxGuests = (value is num) ? value.toInt() : int.tryParse(value?.toString() ?? "0") ?? 0;



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

  _restArea.numDoubleBeds = (data["num_double_beds"] is num)
      ? (data["num_double_beds"] as num).toInt()
      : int.tryParse(data["num_double_beds"]?.toString() ?? "0") ?? 0;

  _restArea.numSingleBeds = (data["num_single_beds"] is num)
      ? (data["num_single_beds"] as num).toInt()
      : int.tryParse(data["num_single_beds"]?.toString() ?? "0") ?? 0;

  _restArea.numBedrooms = (data["num_bedrooms"] is num)
      ? (data["num_bedrooms"] as num).toInt()
      : int.tryParse(data["num_bedrooms"]?.toString() ?? "0") ?? 0;
 print("_restArea.numBedrooms ${_restArea.numBedrooms}");
  _restArea.numFloors = (data["num_floors"] is num)
      ? (data["num_floors"] as num).toInt()
      : int.tryParse(data["num_floors"]?.toString() ?? "0") ?? 0;

  _restArea.numBathroomsIndoor = (data["num_bathrooms_indoor"] is num)
      ? (data["num_bathrooms_indoor"] as num).toInt()
      : int.tryParse(data["num_bathrooms_indoor"]?.toString() ?? "0") ?? 0;

  _restArea.numBathroomsOutdoor = (data["num_bathrooms_outdoor"] is num)
      ? (data["num_bathrooms_outdoor"] as num).toInt()
      : int.tryParse(data["num_bathrooms_outdoor"]?.toString() ?? "0") ?? 0;




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

print("maxGuests ${_restArea.numBedrooms.toString()}");
  // إذا كانت هناك صور موجودة، قم بتحميلها (هذا يتطلب منطقًا إضافيًا لتحميل الصور من URL إلى XFile)
  // حاليًا، هذا الجزء غير مدعوم بشكل مباشر في هذا الكود، ستحتاج إلى تنفيذه
   //_mainImage = XFile(data["main_image"]);
// _detailsImages = (data["details_images"] as List).map((url) => XFile(url)).toList();

  setState(() {}); // لتحديث واجهة المستخدم بعد ملء البيانات
}

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

    List<String> parsedAreaType = _parseStringList(_restArea.areaType);
    print("Parsed Area Type: ${_restArea.checkInTime}"); // سيطبع: [للعائلات, للشباب]
    print("Parsed Area Type: ${_restArea.checkOutTime}"); // سيطبع: [للعائلات, للشباب]

    //_isLoading = false;
    return Obx(() {
      if (userId.value == 0) {
        print(userId.value);
        return Center(child: Scaffold(body: Center(child: CircularProgressIndicator()))); // جاري التحميل
      } else {



      return Container();
    }  }
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

