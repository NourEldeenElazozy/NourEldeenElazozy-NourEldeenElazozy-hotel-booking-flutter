class MyImages {
  static const String path = "assets/images/";
  static const String loginScreenPath = "assets/images/login_screen/";
  static const String registerScreenPath = "assets/images/register_screen/";
  static const String forgotPasswordPath = "assets/images/forgot_password/";
  static const String bottomBarPath = "assets/images/bottom_Bar/";
  static const String homePath = "assets/images/home/";
  static const String searchPath = "assets/images/search/";
  static const String filterHotelPath = "assets/images/filterHotel/";
  static const String hotelDetailPath = "assets/images/hotelDetail/";
  static const String paymentPath = "assets/images/payment/";
  static const String profilePath = "assets/images/profile/";
  static const String myBookingPath = "assets/images/myBooking/";
  static const String helpCenterPath = "assets/images/helpCenter/";

  static const String splashLogo = "${path}splashlogo.svg";
  static const String welcome = "${path}welcome.png";
  static const String logo = "${path}logo.jpg";

  static const String appIcon = "${path}logo.jpg";
  static const String dateTimeArrow = "${path}datetimearrow.svg";
  static const String timePicker = "${path}timePicker.svg";
  static const String rating = "${path}rating.svg";

//-----------------------------------Onboarding_Screen------------------------------
  static List images = [
  "${path}onboarding1.png",
  "${path}onboarding2.png",
  "${path}onboarding3.png",
  ];

//-----------------------------------Login_Option_Screen------------------------------
  static const String backArrow = "${loginScreenPath}back_arrow.svg";
  static const String facebook = "${loginScreenPath}facebook.svg";
  static const String google = "${loginScreenPath}google.svg";
  static const String apple = "${loginScreenPath}apple.svg";

//-----------------------------------Login_Screen------------------------------
  static const String emailBox = "${loginScreenPath}emailbox.svg";
  static const String mobile = "${loginScreenPath}mobile.svg";
  static const String passwordLock = "${loginScreenPath}passwordlock.svg";
  static const String hidePassword = "${loginScreenPath}hidepassword.svg";
  static const String showPassword = "${loginScreenPath}showPassword.svg";

//-----------------------------------Register_Screen------------------------------
  static const String user = "${registerScreenPath}user.svg";

//-----------------------------------FillProfile_Screen------------------------------
  static const String addUser = "${registerScreenPath}adduser.png";
  static const String editProfile = "${registerScreenPath}editProfile.svg";
  static const String datePicker = "${registerScreenPath}datePicker.svg";
  static const String datePickerLight = "${registerScreenPath}datePickerLight.svg";
  static const String fillEmailBoxDark = "${registerScreenPath}fillEmailBoxDark.svg";
  static const String fillEmailBoxLight = "${registerScreenPath}fillEmailBoxLight.svg";
  static const String profilePerson = "${registerScreenPath}profilePerson.png";

//-----------------------------------ChoicePassword_Screen------------------------------
  static const String forgotPasswordLock = "${forgotPasswordPath}passwordLock.png";
  static const String viaSms = "${forgotPasswordPath}viaSms.svg";
  static const String viaEmail = "${forgotPasswordPath}viaEmail.svg";

//-----------------------------------CreateNewPassword_Screen------------------------------
  static const String newPassword = "${forgotPasswordPath}newPassword.png";
  static const String congratulation = "${forgotPasswordPath}congratulation.svg";

//-----------------------------------BottomBar_Screen------------------------------
  static const String selectedBooking = "${bottomBarPath}selectedBooking.svg";
  static const String selectedHome = "${bottomBarPath}selectedHome.svg";
  static const String selectedHomewhite = "${bottomBarPath}selectedHomewhite.svg";
  static const String selectedProfile = "${bottomBarPath}selectedProfile.svg";
  static const String selectedSearch = "${bottomBarPath}selectedSearch.svg";
  static const String selectedSearchwhite = "${bottomBarPath}selectedSearchwhite.svg";
  static const String unSelectedBooking = "${bottomBarPath}unSelectedBooking.svg";
  static const String unSelectedHome = "${bottomBarPath}unSelectedHome.svg";
  static const String unSelectedProfile = "${bottomBarPath}unSelectedProfile.svg";
  static const String unSelectedSearch = "${bottomBarPath}unSelectedSearch.svg";

//-----------------------------------Home_Screen------------------------------
  static const String notification = "${homePath}notification.svg";
  static const String bookMarkBlack = "${homePath}bookMarkBlack.svg";
  static const String selectedBookMarkBlack = "${homePath}selectedBookMarkBlack.svg";
  static const String unSelectBookMark = "${homePath}unSelectBookMark.svg";
  static const String filter = "${homePath}filter.svg";
  static const String whiteStar = "${homePath}whiteStar.svg";
  static const String bookMarkLight = "${homePath}bookMarkLight.svg";
  static const String yellowStar = "${homePath}yellowStar.svg";
  static const String hotelSmall = "${homePath}hotelSmall.png";

//-----------------------------------RecentlyBooked_Screen------------------------------
  static const String selectedDocument = "${homePath}selectedDocument.svg";
  static const String selectedDocumentwhite = "${homePath}selectedDocumentwhite.svg";
  static const String unselectedDocument = "${homePath}unselectedDocument.svg";
  static const String selectedCategory = "${homePath}selectedCategory.svg";
  static const String unselectedCategory = "${homePath}unselectedCategory.svg";

//-----------------------------------Search_Screen------------------------------
  static const String closeSearch = "${searchPath}closeSearch.svg";

//-----------------------------------filterHotel_Screen------------------------------
  static List selectTime = [
    "${filterHotelPath}Morning.svg",
    "${filterHotelPath}unselectedMorning.svg",
    "${filterHotelPath}Evening.svg",
  ];
  static const String unselectStar = "${filterHotelPath}unselectStar.svg";

//-----------------------------------HotelDetail_Screen------------------------------
  static const String allMenu = "${hotelDetailPath}allMenu.svg";
  static const String location = "${hotelDetailPath}location.svg";
  static const String badRoom = "${hotelDetailPath}badRoom.svg";
  static const String bathroom = "${hotelDetailPath}bathroom.svg";
  static const String sqft = "${hotelDetailPath}sqft.svg";
  static const String map = "${hotelDetailPath}map.png";
  static const String map2 = "${hotelDetailPath}map2.png";
  static const String outlineStar = "${hotelDetailPath}outlineStar.svg";
  static const String selectStar = "${hotelDetailPath}selectStar.svg";
  static const String markerIcon = "${path}ic_marker.png";

//----------------------------------- PaymentChoice_Screen ------------------------------
  static const List<String> choicePaymentList = [
  "${paymentPath}payPal.svg",
  "${paymentPath}googlePay.svg",
  "${paymentPath}applePay.svg",
  ];
  static const List<String> choicePaymentCardList = [
    "${paymentPath}cardType.svg",
  ];
  static const String applePay = "${paymentPath}applePay.svg";
  static const String googlePay = "${paymentPath}googlePay.svg";
  static const String paypal = "${paymentPath}payPal.svg";
  static const String cardType = "${paymentPath}cardType.png";
  static const String cardTypeSvg = "${paymentPath}cardType.svg";

//----------------------------------- AddNewCard_Screen ------------------------------
  static const String newCard = "${paymentPath}newCard.svg";

//----------------------------------- Ticket_Screen ------------------------------
  static const String barCode = "${paymentPath}barCode.svg";

//----------------------------------- Profile_Screen ------------------------------
  static const String editProfileScreen = "${profilePath}editProfile.svg";
  static const String myHost = "${hotelDetailPath}badRoom.svg";
  static const String notificationScreen = "${profilePath}notifications.svg";
  static const String darkThemeScreen = "${profilePath}darkTheme.svg";
  static const String languageScreen = "${profilePath}language.svg";
  static const String helpCenterScreen = "${profilePath}helpCenter.svg";
  static const String privacyScreen = "${profilePath}privacy.svg";
  static const String rateBookNestScreen = "${profilePath}rateBookNest.svg";
  static const String logoutScreen = "${profilePath}logout.svg";

//----------------------------------- MyBooking_Screen ------------------------------
  static const String canceled = "${myBookingPath}canceled.svg";
  static const String completed = "${myBookingPath}completed.svg";

//----------------------------------- helpCenter_Screen ------------------------------
  static List browserTopicList = [
    "${helpCenterPath}gettingStarted.svg",
    "${helpCenterPath}accountProfile.svg",
    "${helpCenterPath}learning.svg",
    "${helpCenterPath}purchaseRefund.svg",
    "${helpCenterPath}mobile.svg",
    "${helpCenterPath}trustSafety.svg",
  ];

  static List browserTopicListDark = [
    "${helpCenterPath}gettingStartedDark.svg",
    "${helpCenterPath}accountProfileDark.svg",
    "${helpCenterPath}learningDark.svg",
    "${helpCenterPath}purchaseRefundDark.svg",
    "${helpCenterPath}mobileDark.svg",
    "${helpCenterPath}trustSafetyDark.svg",
  ];

}
