part of 'routes_imports.dart';

class Routes {
  static List<GetPage> navigator = [
    GetPage(
      name: "/welcome",
      page: () => const WelcomeScreen(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: "/onboarding",
      page: () => const OnboardingScreen(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: "/loginOptionScreen",
      page: () => const LoginOptionScreen(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),

    GetPage(
      name: "/AddRestAreaScreen",
      page: () => AddRestAreaScreen(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),

    GetPage(
      name: "/PaymentScreen",
      page: () => PaymentScreen(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: "/PaymentCashScreen",
      page: () => PaymentCachScreen(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),

    GetPage(
      name: "/PackageCard",
      page: () => PackagesScreen(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),

    GetPage(
      name: "/loginScreen",
      page: () => const LoginScreen(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: "/registerScreen",
      page: () => const RegisterScreen(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: "/fillProfileScreen",
      page: () => const FillProfileScreen(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(name: "/choicePassword", page: () => const ChoicePasswordScreen()),
    GetPage(
      name: "/selectSmsEmail",
      page: () => const SelectSmsEmailScreen(
          icon: MyImages.viaSms,
          sms: MyString.viaSms,
          hintText: MyString.mobileNumber,
          status: false),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: "/otpSend",
      page: () => const OtpSendScreen(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: "/createNewPassword",
      page: () => const CreateNewPasswordScreen(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: "/bottomBar",
      page: () => const BottomBar(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: "/RecentlyBooked",
      page: () => const RecentlyBooked(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: "/notification",
      page: () => const NotificationScreen(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: "/bookMark",
      page: () => const BookMark(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: "/search",
      page: () => const Search(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: "/hotelDetail",
      page: () => const HotelDetail(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: "/profile",
      page: () => const Profile(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: "/review",
      page: () => const Review(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: "/galleryPhoto",
      page: () => const GalleryPhotoScreen(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: "/googleMap",
      page: () => const GoogleMapScreen(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: "/dateTimeSelect",
      page: () =>  DateTimeSelect(),
      transition: Transition.leftToRight,
      middlewares: [AuthMiddleware()], // ✅ إضافة الوسيط هنا
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: "/selectRoom",
      page: () => const SelectRoom(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: "/reservation",
      page: () =>  Reservation(reservationData: {
  "reservations": [
  {
  "id": 5,
  "user_id": 7,
  "rest_area_id": 6,
  "check_in": "2025-01-13",
  "check_out": "2025-01-15",
  "deposit_amount": "50.00",
  "status": "pending",
  "created_at": "2025-01-12T11:13:43.000000Z",
  "updated_at": "2025-01-12T11:13:43.000000Z",
  "adults_count": 1,
  "children_count": 0,
  "user": {
  "id": 7,
  "name": "Jaeden Bartoletti PhD",
  "phone": "346-825-6547",
  "created_at": "2025-01-12T11:13:43.000000Z",
  "updated_at": "2025-01-12T11:13:43.000000Z",
  "date_of_birth": null,
  "city": "Riyadh",
  "gender": null,
  "user_type": "user"
  },
  "rest_area": {
  "id": 6,
  "name": "استراحة الفردوس",
  "check_in_time": "00:00:00",
  "check_out_time": "00:00:00",
  "host_id": 36,
  "location": "88000 Christelle LakesHegmanntown, NM 59790",
  "geo_area": "قريبة من البحر",
  "main_image": "https://via.placeholder.com/600x400",
  "details_images": "[\"images\\/detail1.jpg\",\"images\\/detail2.jpg\"]",
  "rating": 4.9,
  "description": "Autem rerum quo voluptates reiciendis nesciunt necessitatibus praesentium accusamus. Dolore sint blanditiis natus repudiandae officia molestiae. Id fuga et autem debitis ut dolores est. Placeat nobis deleniti nisi perspiciatis. Aut aspernatur aliquam fuga.",
  "area_type": "للمناسبات",
  "total_space": 272,
  "internal_space": 273,
  "max_guests": 14,
  "num_double_beds": 2,
  "num_single_beds": 5,
  "num_halls": 1,
  "num_bedrooms": 5,
  "num_floors": 1,
  "num_bathrooms_indoor": 1,
  "num_bathrooms_outdoor": 1,
  "kitchen_available": true,
  "kitchen_contents": "Rerum quas quia non quam cum.",
  "has_ac_heating": true,
  "tv_screens": 1,
  "free_wifi": 1,
  //"entertainment_games": "quo",
  "outdoor_space": 0,
  "grass_space": 0,
  "pool_type": "خارجي",
  "pool_space": 99,
  "pool_depth": 1.3,
  "pool_heating": 0,
  "pool_filter": 0,
  "garage": 0,
  "outdoor_seating": 1,
  "children_games": 0,
  "outdoor_kitchen": 0,
  "slaughter_place": 0,
  "well": 0,
  "power_generator": 0,
  "outdoor_bathroom": 1,
  "other_specs": "Dolores aut rerum occaecati quae.",
  "price": "131.29",
  "created_at": "2025-01-12T11:13:43.000000Z",
  "updated_at": "2025-02-20T09:32:16.000000Z",
  "city_id": 0,
  "booking_count": 0,
  "gamesdetails": null,
  "jump_available": 0,
  "board_pit_available": 0,
  "fishing_available": 0,
  "deposit_value": "0.00",
  "Maps_location": "",
  "holiday_price": "0.00",
  "id_proof_type": "valid_passport",
  "eid_days_price": "0.00"
  }
  }
  ]
  },
  ),

      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: "/paymentChoice",
      page: () => const PaymentChoice(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: "/addNewCard",
      page: () => const AddNewCard(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: "/paymentInfo",
      page: () => const PaymentInfo(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: "/ticket",
      page: () => const Ticket(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: "/profileNotification",
      page: () => const ProfileNotification(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: "/cancelBooking",
      page: () => const CancelBooking(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: "/Booking",
      page: () => const Booking(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 600),
    ),

    GetPage(
      name: "/myHosting",
      page: () =>  MySotingScreen(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),

    GetPage(
      name: "/editProfile",
      page: () => const EditProfile(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: "/chooseLanguage",
      page: () => const ChooseLanguage(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: "/helpCenter",
      page: () => const HelpCenter(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: "/contactPage",
      page: () =>  ContactPage(),

      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: "/pointsPage",
      page: () =>  PointsPage(),

      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: "/request360Page",
      page: () =>  Request360Page(),

      transitionDuration: const Duration(milliseconds: 600),
    ),


    GetPage(
      name: "/PrivacyPolicy",
      page: () => const PrivacyPolicyScreen(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),
  ];

  final Map<String, dynamic> myReservationData = {
    "reservations": [
      {
        "id": 5,
        "user_id": 7,
        "rest_area_id": 6,
        "check_in": "2025-01-13",
        "check_out": "2025-01-15",
        "deposit_amount": "50.00",
        "status": "pending",
        "created_at": "2025-01-12T11:13:43.000000Z",
        "updated_at": "2025-01-12T11:13:43.000000Z",
        "adults_count": 1,
        "children_count": 0,
        "user": {
          "id": 7,
          "name": "Jaeden Bartoletti PhD",
          "phone": "346-825-6547",
          "created_at": "2025-01-12T11:13:43.000000Z",
          "updated_at": "2025-01-12T11:13:43.000000Z",
          "date_of_birth": null,
          "city": "Riyadh",
          "gender": null,
          "user_type": "user"
        },
        "rest_area": {
          "id": 6,
          "name": "استراحة الفردوس",
          "check_in_time": "00:00:00",
          "check_out_time": "00:00:00",
          "host_id": 36,
          "location": "88000 Christelle LakesHegmanntown, NM 59790",
          "geo_area": "قريبة من البحر",
          "main_image": "https://via.placeholder.com/600x400",
          "details_images": "[\"images\\/detail1.jpg\",\"images\\/detail2.jpg\"]",
          "rating": 4.9,
          "description": "Autem rerum quo voluptates reiciendis nesciunt necessitatibus praesentium accusamus. Dolore sint blanditiis natus repudiandae officia molestiae. Id fuga et autem debitis ut dolores est. Placeat nobis deleniti nisi perspiciatis. Aut aspernatur aliquam fuga.",
          "area_type": "للمناسبات",
          "total_space": 272,
          "internal_space": 273,
          "max_guests": 14,
          "num_double_beds": 2,
          "num_single_beds": 5,
          "num_halls": 1,
          "num_bedrooms": 5,
          "num_floors": 1,
          "num_bathrooms_indoor": 1,
          "num_bathrooms_outdoor": 1,
          "kitchen_available": true,
          "kitchen_contents": "Rerum quas quia non quam cum.",
          "has_ac_heating": true,
          "tv_screens": 1,
          "free_wifi": 1,
          //"entertainment_games": "quo",
          "outdoor_space": 0,
          "grass_space": 0,
          "pool_type": "خارجي",
          "pool_space": 99,
          "pool_depth": 1.3,
          "pool_heating": 0,
          "pool_filter": 0,
          "garage": 0,
          "outdoor_seating": 1,
          "children_games": 0,
          "outdoor_kitchen": 0,
          "slaughter_place": 0,
          "well": 0,
          "power_generator": 0,
          "outdoor_bathroom": 1,
          "other_specs": "Dolores aut rerum occaecati quae.",
          "price": "131.29",
          "created_at": "2025-01-12T11:13:43.000000Z",
          "updated_at": "2025-02-20T09:32:16.000000Z",
          "city_id": 0,
          "booking_count": 0,
          "gamesdetails": null,
          "jump_available": 0,
          "board_pit_available": 0,
          "fishing_available": 0,
          "deposit_value": "0.00",
          "Maps_location": "",
          "holiday_price": "0.00",
          "id_proof_type": "valid_passport",
          "eid_days_price": "0.00"
        }
      }
    ]
  };
}


class AuthMiddleware extends GetMiddleware {
  var token = ''.obs; // تخزين التوكن باستخدام RxString

  // تحميل التوكن من التخزين المحلي
  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    token.value = prefs.getString('token') ?? '';
    print("token.value ${token.value}");
  }

  @override
  RouteSettings? redirect(String? route) {
    // استخدام Future للتأكد من تحميل التوكن قبل التحقق
    loadToken().then((_) {
      if (token.value.isEmpty) {
        return const RouteSettings(name: "/loginScreen"); // توجيه المستخدم إلى صفحة تسجيل الدخول
      }
    });
    return null; // السماح بالانتقال
  }

  @override
  GetPage? onPageCalled(GetPage? page) {
    loadToken(); // تحميل التوكن عند استدعاء الصفحة
    return super.onPageCalled(page);
  }
}
