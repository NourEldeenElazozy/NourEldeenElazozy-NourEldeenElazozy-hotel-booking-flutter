class MyString {
  static String custom_ref = ""; // ✅ يمكن تغييره
  static int duration = 0; // ✅ يمكن تغييره
  static double commission_rate = 0; // ✅ يمكن تغييره
  static int packageId = 0; // ✅ يمكن تغييره
//----------------------------- Welcome_Screen -----------------------------
  static const String welcome = "مرحبا بك في";
  static const String bookNest = "إستراحة-Esteraha";
  static const String vacation = "أفضل حجز فندقي لهذا القرن\nليرافق عطلتك";

//----------------------------- Onboarding_Screen -----------------------------
  static List text = [
    "مرحباً بك في تطبيق\nإستراحة – Esteraha",
    "مميزات\n  ذكية لتجربتك ",
    "هل تمتلك استراحة أو منتجع؟",
  ];


  static const String description = "احجز استراحتك أو منتجعك المفضل بخطوات بسيطة، وابدأ عطلتك براحة وبدون عمولة .";
  static const String description2 = "ابحث عن الاستراحه او المنتجع عبر خرائط Google واستمتع بجولة افتراضية من داخلها من هاتفك بإستخدام افضل تقنيات التصوير.";
  static const String description3 = "سجّل الآن وابدأ بعرض استراحتك، جذّب العملاء، وتابع حجوزاتك بكل سهولة واحترافية من مكان واحد.";
  static const String next = "التالي";
  static const String skip = "تخطي";

//----------------------------- Login_Option_Screen -----------------------------
  static const String title = "دعنا نبدأ";
  static const String facebookTitle = "تسجيل الدخول عبر فيسبوك";
  static const String googleTitle = "تسجيل الدخول عبر جوجل";
  static const String appleTitle = "تسجيل الدخول عبر آبل";
  static const String or = "أو";
  static const String signInPassword = "تسجيل الدخول بكلمة المرور";
  static const String donAccount = "لا تملك حسابًا؟";
  static const String alreadyAccount = "هل لديك حساب بالفعل؟";
  static const String signUp = "إنشاء حساب";

//-----------------------------------Login_Screen------------------------------
  static const String loginTitle = "تسجيل الدخول إلى حسابك";
  static const String emailHintText = "رقم الهاتف";
  static const String passwordHintText = "كلمة المرور";
  static const String signIn = "تسجيل الدخول";
  static const String forgotPassword = "نسيت كلمة المرور؟";
  static const String orContinue = "أو متابعة باستخدام";

//-----------------------------------Register_Screen------------------------------
  static const String registerTitle = "إنشاء حسابك";

//-----------------------------------FillProfile_Screen------------------------------
  static const String fillProfile = "إكمال ملفك الشخصي";
  static const String fullName = "الاسم الكامل";
  static const String nickName = "اسم الشهرة";
  static const String dateBirth = "تاريخ الميلاد";
  static const String email = "البريد الإلكتروني";
  static const String phoneNumber = "رقم الهاتف";
  static const String gender = "الجنس";
  static const String continueButton = "استمرار";
  static List<String> genderSelect = [
    "ذكر",
    "أنثى",
    "آخر",
  ];

//-----------------------------------ChoicePassword_Screen------------------------------
  static const String choiceForgotPassword = "نسيت كلمة المرور";
  static const String passwordDescription = "اختر وسيلة الاتصال التي نستخدمها لإعادة تعيين كلمة المرور";
  static const String viaSms = "عبر الرسائل النصية:";
  static const String mobileNumber = "أدخل رقم الجوال";
  static const String viaEmail = "عبر البريد الإلكتروني:";
  static const String emailId = "أدخل عنوان البريد الإلكتروني";

//-----------------------------------OtpSend_Screen------------------------------
  static const String codeSend = "تم إرسال الرمز إلى ";
  static const String codeResend = "إعادة إرسال الرمز بعد 53 ثانية";
  static const String verify = "تحقق";

//-----------------------------------CreateNewPassword_Screen------------------------------
  static const String newPassword = "إنشاء كلمة مرور جديدة";
  static const String yourNewPassword = "أدخل كلمة المرور الجديدة";
  static const String enterPassword = "أدخل كلمة المرور";
  static const String confirmPassword = "تأكيد كلمة المرور الجديدة";
  static const String congratulation = "تهانينا!";
  static const String congratsDescription = "حسابك جاهز للاستخدام";
  static const String homepage = "الذهاب إلى الصفحة الرئيسية";

//-----------------------------------BottomBar_Screen------------------------------
  static const String home = "الرئيسية";
  static const String search = "بحث";
  static const String booking = "الحجوزات";
  static const String profile = "الملف الشخصي";

//-----------------------------------Home_Screen------------------------------
  static List itemSelect = [
    "موصى به",
    "شائع",
    "رائج",
    "وصل حديثًا",
  ];
  static const String recommended = "موصى به";
  static const String popular = "شائع";
  static const String trending = "رائج";
  static const String recentlyBooked = "تم حجزه مؤخرًا";
  static const String seeAll = "عرض الكل";

//-----------------------------------Notification_Screen------------------------------
  static const String notification = "الإشعارات";

//-----------------------------------filterBottomSheet------------------------------
  static const String filterHotel = "تصفية الفنادق";
  static const String country = "البلد";
  static const String reset = "إعادة ضبط";
  static const String applyFilter = "تطبيق التصفية";
  static List countryName = [
    "أرمينيا",
    "فرنسا",
    "إيطاليا",
    "ألمانيا",
    "الهند",
    "باكستان",
  ];
  static const String sortResults = "ترتيب النتائج";
  static List resultsName = [
    "الأكثر شعبية",
    "الأعلى سعرًا",
    "الأقل شعبية",
    "الأقل سعرًا",
  ];
  static const String priceRange = "نطاق السعر لكل ليلة";
  static const String availabilityTime = "التوافر حسب الوقت";
  static List selectedTime = [
    "للعائلات",
    "للعائلات أو الشباب",
    "للمناسبات",
    "لكل الاستخدامات",
  ];
/*
  static List selectedTimeRange = [
    "(5:00 صباحًا - 11:59 صباحًا)",
    "(12:00 ظهرًا - 5:59 مساءً)",
    "(6:00 مساءً - 11:59 مساءً)",
  ];
 */
  static List rate = [
    "1",
    "2",
    "3",
    "4",
    "5",
  ];
  static const String accommodationType = "نوع الإقامة";
  static List<String> accommodationName = [
    "فنادق",
    "منتجعات",
    "فلل",
    "شقق",
    "بيوت ضيافة",
  ];
  static const String facilities = "المرافق";
  static Map<String, String> facilitiesMap = {
    "واي فاي": "free_wifi",
    "مسبح": "pool",
    "موقف سيارات": "garage",

    "تدفئة وتكييف": "has_ac_heating",
    "شاشات تلفزيون": "tv_screens",
    "مطبخ متاح": "kitchen_available",
    "حمام خارجي": "outdoor_bathroom",
    "مساحة خارجية": "outdoor_space",
    "مساحة عشب": "grass_space",
    "تدفئة للمسبح": "pool_heating",
    "فلتر للمسبح": "pool_filter",
    "أماكن جلوس خارجية": "outdoor_seating",
    "ألعاب للأطفال": "children_games",
    "مطبخ خارجي": "outdoor_kitchen",
    "مكان للذبح": "slaughter_place",
    "بئر": "well",
    "مولد كهربائي": "power_generator",
  };
  static List facilitiesName = [
    "واي فاي",
    "مسبح",
    "موقف سيارات",
    "مطعم",
    "تدفئة وتكييف",
    "شاشات تلفزيون",
    "مطبخ متاح",
    "حمام خارجي",
    "مساحة خارجية",
    "مساحة عشب",
    "تدفئة للمسبح",
    "فلتر للمسبح",
    "أماكن جلوس خارجية",
    "ألعاب للأطفال",
    "مطبخ خارجي",
    "مكان للذبح",
    "بئر",
    "مولد كهربائي",
  ];

//-----------------------------------hotelDetails------------------------------
  static const String hotelName = "فندق رويال بريزيدنت";
  static const String galleryPhotos = "معرض الصور";
  static const String details = "المرافق الأساسية";
  static const String badRooms = "4 غرف نوم";
  static const String bathrooms = "2 حمام";
  static const String sqft = "4000 قدم مربع";
  static const String hotelDescription = "الوصف";
  static const String hotelLongDescription = "لوريم إيبسوم هو نص افتراضي يُستخدم في التصاميم والنماذج.";
  static const String facilites = "المرافق الخارجية";
  static const String location = "الموقع";
  static const String review = "التقييم";
  static const String more = "المزيد";
  static const String bookNow = "أرسل الطلب";

//-----------------------------------Review_Screen------------------------------
  static List reviewRate = [
    "الكل",
    "5",
    "4",
    "3",
    "2",
    "1",
  ];
  static const String rating = "التقييم";

//----------------------------------- Rating_BottomSheet ------------------------------
  static const String rateHotel = "قيّم الفندق";
  static const String giveRating = "يرجى إدخال تقييمك ومراجعتك";
  static const String ratingDescription = "الغرف مريحة جدًا والإطلالات الطبيعية رائعة، لا أستطيع الانتظار للعودة مرة أخرى!";
  static const String rateNow = "قيّم الآن";
  static const String later = "لاحقًا";

//----------------------------------- GalleryPhoto ------------------------------
  static const String galleryHotelPhotos = "صور فندق المعرض";

//----------------------------------- GoogleMap ------------------------------
  static const String hotelLocation = "موقع الفندق";

//----------------------------------- DateTimeSelect ------------------------------
  static const String selectDate = "ارسال طلب الحجز";
  static const String checkInDate = "تاريخ تسجيل الدخول";
  static const String checkOutDate = "تاريخ تسجيل الخروج";
  static const String checkInTime = "وقت تسجيل الدخول";
  static const String checkOutTime = "وقت تسجيل الخروج";
  static const String guestAdult = "ضيف (بالغ)";
  static const String guestChildren = "ضيف (أطفال)";

//----------------------------------- SelectRoom ------------------------------
  static const String selectRoom = "اختر الغرفة";

//----------------------------------- Reservation ------------------------------
  static const String nameReservation = "اسم الحجز";

//----------------------------------- PaymentChoice ------------------------------
  static const List<String> choicePaymentList = [
    "باي بال",
    "جوجل باي",
    "آبل باي",
  ];
  static const List<String> choicePaymentCardList = [
    "•••• •••• •••• •••• 4679",
  ];
  static const String payment = "الدفع";
  static const String paymentMethod = "طرق الدفع";
  static const String addNewCard = "إضافة بطاقة جديدة";
  static const String paypal = "باي بال";
  static const String cash = "نقدي";
  static const String googlePay = "جوجل باي";
  static const String tlync = "T-lync";

  static const String applePay = "آبل باي";
  static const String payDebitCreditCard = "ادفع باستخدام بطاقة الخصم/الائتمان";
  static const String changeCard = "تغيير البطاقة";
  static const String cardNumberShow = "•••• •••• •••• •••• 4679";

//----------------------------------- cancelPayment ------------------------------
  static const String paid = "مدفوع";
  static const String refund = "استرداد";

//----------------------------------- AddNewCard ------------------------------
  static const String newCard = "بطاقة جديدة";
  static const String addCard = "إضافة البطاقة";
  static const String holderName = "اسم حامل البطاقة";
  static const String cardNumber = "رقم البطاقة";
  static const String expiry = "تاريخ الانتهاء";
  static const String cvv = "رمز CVV";

//----------------------------------- PaymentInfo ------------------------------
  static const String confirmPayment = "تأكيد الدفع";
  static const String checkIn = "تسجيل الدخول";
  static const String checkOut = "تسجيل الخروج";
  static const String days = "4 أيام";
  static const String night = "4 ليالٍ";
  static const String taxesFees = "الضرائب والرسوم (10%)";
  static const String total = "الإجمالي";
  static const String paymentSuccessFull = "تم الدفع بنجاح!";
  static const String paymentSuccessFullSubTitle = "تمت عملية الدفع وحجز الفندق بنجاح";
  static const String viewTicket = "عرض التذكرة";
  static const String cancel = "إلغاء";
  static const String change = "تغيير";

//----------------------------------- Ticket ------------------------------
  static const String downloadTicket = "تحميل التذكرة";
  static const String ticket = "التذكرة";

//----------------------------------- profile_Screen ------------------------------
  static const String editProfile = "تعديل الملف الشخصي";
  static const String myHost = "إسترحاتي";
  static const String myBook = "حجوزاتي";
  static const String notifications = "الإشعارات";
  static const String darkTheme = "الوضع الداكن";
  static const String language = "اللغة";
  static const String helpCentre = "اتصل بنا";
  static const String privacy = "الشروط و الاحكام";
  static const String rateBooKNest = "قيّم إستراحة";
  static const String logout = "تسجيل الخروج";
  static const String submit = "إرسال";
  static const String rateTitle = "قيّم تطبيقنا";
  static const String rateSubTitle = "اضغط على نجمة لتقييمك. شكرًا!";

//----------------------------------- ProfileNotification_Screen ------------------------------
  static const String generalNotification = "إشعار عام";
  static const String sound = "الصوت";
  static const String vibrate = "الاهتزاز";
  static const String appUpdates = "تحديثات التطبيق";
  static const String serviceAvailable = "خدمة جديدة متاحة";
  static const String tipsAvailable = "نصائح جديدة متاحة";

//----------------------------------- EditProfile_Screen ------------------------------
  static const String update = "تحديث";

//----------------------------------- ChooseLanguage_Screen ------------------------------
  static const String chooseLanguage = "اختر اللغة";
  static const languageList = [
    'الإنجليزية',
    'الماندرين',
    'الهندية',
    'التاميلية',
    'الجوجاراتية',
  ];

//----------------------------------- helpCenter_Screen ------------------------------
  static const String helpCenter = "مركز المساعدة";
  static const String helpYou = "كيف يمكننا مساعدتك؟";
  static const String browseTopics = "تصفح حسب الموضوعات";
  static const browserTopicList = [
    'البدء',
    'الحساب أو الملف الشخصي',
    'التعلم',
    'الشراء أو الاسترداد',
    'التطبيقات المحمولة',
    'الثقة والسلامة',
  ];

//----------------------------------- Booking_Screen ------------------------------
  static const String myBooking = "حجوزاتي";
  static const String ongoingButton = "جارية";
  static const String completedButton = "مكتملة";
  static const String canceledButton = "ملغاة";
  static const String cancelBookingButton = "إلغاء الحجز";
  static const String viewTicketButton = "عرض التذكرة";
  static const String completed = "تهانينا، لقد أكملت الحجز!";
  static const String confirmed = "هذ الحجز مؤكد";
  static const String canceled = "لقد قمت بإلغاء هذا الحجز الفندقي";

//----------------------------------- CancelBooking ------------------------------
  static const String cancelBooking = "إلغاء الحجز";
  static const String cancelBookingSubTitle = "هل أنت متأكد أنك تريد إلغاء حجزك الفندقي؟";
  static const String cancelBookingDescription = "يمكنك استرداد 80% فقط من المبلغ المدفوع وفقًا لسياساتنا";
  static const String yesContinue = "نعم، استمرار";
  static const String cancelHotelBooking = "إلغاء الحجز الفندقي";
  static const String refundDescription = "يرجى اختيار طريقة استرداد الدفع (سيتم استرداد 80% فقط).";
  static const String confirmCancel = "تأكيد الإلغاء";
  static const String successFull = "تم بنجاح!";
  static const String successFullDescription = "لقد ألغيت الحجز بنجاح. سيتم إعادة 80% من الأموال إلى حسابك";

  static const String descriptions = "في Viral Pitch نؤمن بأن بداية كل يوم يجب أن تكون أنت، أفضل وأسعد من الأمس. نحن هنا لدعمك، شاركنا استفساراتك أو تحقق من الأسئلة الشائعة المدرجة أدناه.";

  //----------------------------------- logOut ------------------------------
  static const String logoutTitle = "هل أنت متأكد أنك تريد تسجيل الخروج؟";
  static const faqList = [
    'ما هو الكورس؟',
    'كيف يمكنني التقديم على حملة؟',
    'كيف يمكنني معرفة حالة الحملة؟',
    'كيف يمكنني معرفة حالة الحملة؟',
    'كيف يمكنني التقديم على حملة؟',
    'ما هو الكورس؟',
    'كيف يمكنني معرفة حالة الحملة؟',
  ];
  static const String yesLogout = "نعم، تسجيل الخروج";
}
