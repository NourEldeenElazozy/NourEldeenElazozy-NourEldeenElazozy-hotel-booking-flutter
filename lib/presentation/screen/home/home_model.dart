
import 'package:get/get.dart';
import 'package:hotel_booking/Model/AllReview.dart';
import 'package:hotel_booking/presentation/screen/hotelDetails/Modelclass/review_model.dart';

import '../hotelDetails/Modelclass/details_model.dart';
import '../hotelDetails/Modelclass/facilites_model.dart';
import '../galleryPhoto/gallery_photo_model.dart';

class Detail {
  int? id;
  String? hotelName;
  String? location;
  String?cityname;
  String? description;
  String? mainImage;
  double rating = 0.0;
  String? geoArea;
  String? checkin;
  String? checkout;

  // تفاصيل المساحة
  String? areaType; // نوع المنطقة
  double? totalSpace; // المساحة الإجمالية
  double? internalSpace; // المساحة الداخلية
  int? maxGuests; // الحد الأقصى للضيوف
  int? numDoubleBeds; // عدد الأسرة المزدوجة
  int? numSingleBeds; // عدد الأسرة الفردية
  int? numHalls; // عدد القاعات
  int? numBedrooms; // عدد غرف النوم
  int? numFloors; // عدد الطوابق
  int? numBathroomsIndoor; // عدد الحمامات الداخلية
  int? numBathroomsOutdoor; // عدد الحمامات الخارجية

  // مرافق إضافية
  bool? kitchenAvailable; // هل المطبخ متوفر
  String? kitchenContents; // محتويات المطبخ
  bool? hasACHeating; // هل هناك تدفئة أو تكييف
  int? tvScreens; // عدد شاشات التلفاز
  bool? freeWifi; // هل الواي فاي مجاني
  String? entertainmentGames; // ألعاب ترفيهية متاحة
  bool? outdoorSpace; // هل هناك مساحة خارجية
  bool? grassSpace; // هل هناك مساحة عشبية
  String? poolType; // نوع المسبح
  double? poolSpace; // مساحة المسبح
  double? poolDepth; // عمق المسبح
  bool? poolHeating; // هل المسبح مدفأ
  bool? poolFilter; // هل يوجد فلتر للمسبح
  bool? garage; // هل يوجد مرآب
  bool? outdoorSeating; // هل يوجد جلوس خارجي
  bool? childrenGames; // هل توجد ألعاب للأطفال
  bool? outdoorKitchen; // هل يوجد مطبخ خارجي
  bool? slaughterPlace; // هل يوجد مكان للذبح
  bool? well; // هل يوجد بئر
  bool? powerGenerator; // هل يوجد مولد كهربائي
  bool?OutdoorBathroom;
  String? otherSpecs;
  double? holidayPrice;
  double? price;
  String? idProofType;
  double? eidDaysPrice;
  String?virtual_tour_link;
  String?google_maps_location;
  // الصور
 // List<String> detailsImages = []; // صور التفاصيل
  List<String> detailsImages = []; // صور إضافية
  List<GalleryPhoto> galleryPhotos = []; // صور المعرض
  List<Details> details = []; // تفاصيل إضافية
  List<Facility> facility = []; // المرافق
  List<AllReview> allReview = []; // المراجعات
  final RxList<AllReviews> allReviews = <AllReviews>[].obs; // <--- هذا هو التغيير الرئيسي



  Detail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hotelName = json['name'];
    location = json['location'];
    cityname = json['city_name'];
    description = json['description'];
    mainImage = json['main_image'];
    rating = _parseDouble(json['rating']);
    geoArea = json['geo_area'];
    checkin = json['check_in_time'];
    checkout = json['check_out_time'];
    areaType = json['area_type'];
    totalSpace = _parseDouble(json['total_space']);
    internalSpace = _parseDouble(json['internal_space']);

    maxGuests = _parseInt(json['max_guests']);
    numDoubleBeds = _parseInt(json['num_double_beds']);
    numSingleBeds = _parseInt(json['num_single_beds']);
    numHalls = _parseInt(json['num_halls']);
    numBedrooms = _parseInt(json['num_bedrooms']);
    numFloors = _parseInt(json['num_floors']);
    numBathroomsIndoor = _parseInt(json['num_bathrooms_indoor']);
    numBathroomsOutdoor = _parseInt(json['num_bathrooms_outdoor']);

    kitchenAvailable = json['kitchen_available'] == 1; // Assuming 1 means true
    kitchenContents = json['kitchen_contents'];
    hasACHeating = json['has_ac_heating'] == 1;
    tvScreens = _parseInt(json['tv_screens']);
    freeWifi = json['free_wifi'] == 1;
    entertainmentGames = json['entertainment_games'];
    outdoorSpace = json['outdoor_space'] == 1;
    grassSpace = json['grass_space'] == 1;
    poolType = json['pool_type'];
    poolSpace = _parseDouble(json['pool_space']);
    poolDepth = _parseDouble(json['pool_depth']);
    poolHeating = json['pool_heating'] == 1;
    poolFilter = json['pool_filter'] == 1;
    garage = json['garage'] == 1;
    outdoorSeating = json['outdoor_seating'] == 1;
    childrenGames = json['children_games'] == 1;
    outdoorKitchen = json['outdoor_kitchen'] == 1;
    slaughterPlace = json['slaughter_place'] == 1;
    well = json['well'] == 1;
    powerGenerator = json['power_generator'] == 1;
    OutdoorBathroom = json['outdoor_bathroom'] == 1;
    google_maps_location=json['google_maps_location'];
    virtual_tour_link=json['resthouse_requests'];
    // معالجة الصور

    if (json['details_images'] != null) {
      // افترض أن الصور مفصولة بفواصل
      final imagesString = json['details_images'] as String;
      final List<String> imagesList = imagesString.split(',').map((image) {
        return image;
      }).toList();

      detailsImages = imagesList;
      holidayPrice = _parseDouble(json['holiday_price']);
      idProofType = json['id_proof_type'];
      eidDaysPrice = _parseDouble(json['eid_days_price']);
      otherSpecs = json['other_specs'];
      price = _parseDouble(json['price']);




    }


    // إضافة تفاصيل إضافية إلى القائمة
    details.add(Details(
      areaType: areaType,
      totalSpace: totalSpace,
      internalSpace: internalSpace,
      maxGuests: maxGuests,
      numDoubleBeds: numDoubleBeds,
      numSingleBeds: numSingleBeds,
      numHalls: numHalls,
      numBedrooms: numBedrooms,
      numFloors: numFloors,
      numBathroomsIndoor: numBathroomsIndoor,
      numBathroomsOutdoor: numBathroomsOutdoor,
      kitchenAvailable: kitchenAvailable,
      kitchenContents: kitchenContents,
      hasACHeating: hasACHeating,
      tvScreens: tvScreens,
      freeWifi: freeWifi,
      entertainmentGames: entertainmentGames,
      outdoorSpace: outdoorSpace,
      grassSpace: grassSpace,
      poolType: poolType,
      poolSpace: poolSpace,
      poolDepth: poolDepth,
      poolHeating: poolHeating,
      poolFilter: poolFilter,
      garage: garage,
      outdoorSeating: outdoorSeating,
      childrenGames: childrenGames,
      outdoorKitchen: outdoorKitchen,
      slaughterPlace: slaughterPlace,
      well: well,
      powerGenerator: powerGenerator,
      OutdoorBathroom: OutdoorBathroom,


    ));
  }
}

//----------------------------------- RecentlyBook_model ----------------------------------

class RecentlyBook {
  int? id;
  String? hotelName;
  String? roomType;
  String? available;
  String? location;
  String? status;
  String? rate;
  String? review;
  String? price;
  String? image;

  RecentlyBook({
    required this.id,
    required this.hotelName,
    required this.roomType,
    required this.available,
    required this.location,
    required this.status,
    required this.rate,
    required this.review,
    required this.price,
    required this.image,
  });

  RecentlyBook.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hotelName = json['hotelName'];
    roomType = json['roomType'];
    available = json['available'];
    location = json['location'];
    status = json['Status'];
    rate = json['rate'];
    review = json['review'];
    price = json['price'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic> {};
    data['id'] = id;
    data['hotelName'] = hotelName;
    data['roomType'] = roomType;
    data['available'] = available;
    data['location'] = location;
    data['Status'] = status;
    data['rate'] = rate;
    data['review'] = review;
    data['price'] = price;
    data['image'] = image;
    return data;
  }
}
double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    return double.tryParse(value) ?? 0.0;
  }
  return 0.0;
}
int _parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is String) {
    return int.tryParse(value) ?? 0;
  }
  return 0;
}