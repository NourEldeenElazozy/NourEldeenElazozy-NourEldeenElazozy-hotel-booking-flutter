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
      page: () => const Reservation(),
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
      name: "/PrivacyPolicy",
      page: () => const PrivacyPolicyScreen(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 600),
    ),
  ];
}


class AuthMiddleware extends GetMiddleware {
  var token = ''.obs; // تخزين التوكن باستخدام RxString

  // تحميل التوكن من التخزين المحلي
  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    token.value = prefs.getString('token') ?? '';
  }

  @override
  RouteSettings? redirect(String? route) {
    if (token.value.isEmpty) {
      return const RouteSettings(name: "/loginScreen"); // توجيه المستخدم إلى صفحة تسجيل الدخول
    }
    return null; // السماح بالانتقال
  }

  @override
  GetPage? onPageCalled(GetPage? page) {
    loadToken(); // تحميل التوكن عند استدعاء الصفحة
    return super.onPageCalled(page);
  }
}
