class RestAreas {
  String name;
  String location;
  List<String> areaType;
  double price;
  int totalSpace;
  int internalSpace;
  int maxGuests;
  int numDoubleBeds;
  int numSingleBeds;
  int numHalls;
  int numBedrooms;
  int numFloors;
  int numBathroomsIndoor;
  int numBathroomsOutdoor;
  bool kitchenAvailable;
  List<String> kitchenContents;
  bool hasAcHeating;
  bool tvScreens;
  bool freeWifi;
  List<String> entertainmentGames;
  bool outdoorSpace;
  bool grassSpace;
  String poolType;
  int poolSpace;
  double poolDepth;
  bool poolHeating;
  bool poolFilter;
  bool garage;
  bool outdoorSeating;
  bool childrenGames;
  bool outdoorKitchen;
  bool slaughterPlace;
  String gamesdetails;
  bool well;
  bool powerGenerator;
  bool outdoorBathroom;
  String otherSpecs;

  String mainImage;
  List<String> detailsImages;
  double rating;
  String description;
  String geoArea;

  int cityId;
  String checkInTime;
  String checkOutTime;
  bool jumpAvailable;
  bool boardPitAvailable;
  bool fishingAvailable;
  double depositValue;
  String googleMapsLocation;
  double holidayPrice;
  String idProofType;
  double eidDaysPrice;

  RestAreas({
    required this.name,
    required this.location,
    required this.areaType,
    required this.price,
    required this.totalSpace,
    required this.internalSpace,
    required this.maxGuests,
    required this.numDoubleBeds,
    required this.numSingleBeds,
    required this.numHalls,
    required this.numBedrooms,
    required this.numFloors,
    required this.numBathroomsIndoor,
    required this.numBathroomsOutdoor,
    required this.kitchenAvailable,
    required this.kitchenContents,
    required this.hasAcHeating,
    required this.tvScreens,
    required this.freeWifi,
    required this.entertainmentGames,
    required this.outdoorSpace,
    required this.grassSpace,
    required this.poolType,
    required this.poolSpace,
    required this.poolDepth,
    required this.poolHeating,
    required this.poolFilter,
    required this.garage,
    required this.outdoorSeating,
    required this.childrenGames,
    required this.outdoorKitchen,
    required this.slaughterPlace,
    required this.gamesdetails,
    required this.well,
    required this.powerGenerator,
    required this.outdoorBathroom,
    required this.otherSpecs,

    required this.mainImage,
    required this.detailsImages,
    required this.rating,
    required this.description,
    required this.geoArea,

    required this.cityId,
    required this.checkInTime,
    required this.checkOutTime,
    required this.jumpAvailable,
    required this.boardPitAvailable,
    required this.fishingAvailable,
    required this.depositValue,
    required this.googleMapsLocation,
    required this.holidayPrice,
    required this.idProofType,
    required this.eidDaysPrice,
  });
  void cleanAreaTypes() {
    areaType.removeWhere((item) => item.isEmpty || item.trim().isEmpty);
  }
  // دالة لتحويل القائمة إلى سلسلة متوافقة مع ENUM
  String? getAreaTypeForDb() {
    cleanAreaTypes();
    if (areaType.isEmpty) return null;

    // إذا كنت تريد إرسال أول قيمة فقط (للتتوافق مع ENUM)
    return areaType.first;

    // أو إذا كان العمود في DB يدعم SET:
    // return areaType.join(',');
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'area_type': areaType.join(','), // تحويل القائمة إلى سلسلة
      'price': price,
      'total_space': totalSpace,
      'internal_space': internalSpace,
      'max_guests': maxGuests,
      'num_double_beds': numDoubleBeds,
      'num_single_beds': numSingleBeds,
      'num_halls': numHalls,
      'num_bedrooms': numBedrooms,
      'num_floors': numFloors,
      'num_bathrooms_indoor': numBathroomsIndoor,
      'num_bathrooms_outdoor': numBathroomsOutdoor,
      'kitchen_available': kitchenAvailable == true ? 1 : 0, // تحويل إلى 1 أو 0
      'kitchen_contents': kitchenContents.join(','),
      'has_ac_heating': hasAcHeating== true ? 1 : 0, // تحويل إلى 1 أو 0,
      'tv_screens': tvScreens== true ? 1 : 0, // تحويل إلى 1 أو 0,
      'free_wifi': freeWifi== true ? 1 : 0, // تحويل إلى 1 أو 0,
      'entertainment_games': entertainmentGames.join(','),
      'outdoor_space': outdoorSpace== true ? 1 : 0, // تحويل إلى 1 أو 0,,
      'grass_space': grassSpace== true ? 1 : 0, // تحويل إلى 1 أو 0,,
      'pool_type': poolType,
      'pool_space': poolSpace,
      'pool_depth': poolDepth,
      'pool_heating': poolHeating== true ? 1 : 0, // تحويل إلى 1 أو 0,,
      'pool_filter': poolFilter== true ? 1 : 0, // تحويل إلى 1 أو 0,,,
      'garage': garage== true ? 1 : 0, // تحويل إلى 1 أو 0,,
      'outdoor_seating': outdoorSeating== true ? 1 : 0, // تحويل إلى 1 أو 0,,
      'children_games': childrenGames== true ? 1 : 0, // تحويل إلى 1 أو 0,,
      'outdoor_kitchen': outdoorKitchen== true ? 1 : 0, // تحويل إلى 1 أو 0,,
      'slaughter_place': slaughterPlace== true ? 1 : 0, // تحويل إلى 1 أو 0,,
      'gamesdetails': gamesdetails,
      'well': well== true ? 1 : 0, // تحويل إلى 1 أو 0,,
      'power_generator': powerGenerator== true ? 1 : 0, // تحويل إلى 1 أو 0,,
      'outdoor_bathroom': outdoorBathroom== true ? 1 : 0, // تحويل إلى 1 أو 0,,
      'other_specs': otherSpecs,

      'main_image': mainImage,
      'details_images[]': detailsImages.join(','),
      'rating': rating,
      'description': description,
      'geo_area': geoArea,

      'city_id': 9,
      'check_in_time': checkInTime,
      'check_out_time': checkOutTime,
      'jump_available': jumpAvailable== true ? 1 : 0, // تحويل إلى 1 أو 0,,,
      'board_pit_available': boardPitAvailable== true ? 1 : 0, // تحويل إلى 1 أو 0,,,
      'fishing_available': fishingAvailable== true ? 1 : 0, // تحويل إلى 1 أو 0,,,
      'deposit_value': depositValue,
      'google_maps_location': googleMapsLocation,
      'holiday_price': holidayPrice,
      'id_proof_type': idProofType,
      'eid_days_price': eidDaysPrice,
    };
  }
}