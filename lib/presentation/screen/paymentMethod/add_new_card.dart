part of 'payment_import.dart';

class AddNewCard extends StatefulWidget {
  const AddNewCard({super.key});

  @override
  State<AddNewCard> createState() => _AddNewCardState();
}

class _AddNewCardState extends State<AddNewCard> {

  late PaymentController controller;

  bool isLightTheme = false;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;

  @override
  void initState() {
    controller = Get.put(PaymentController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomFullAppBar(
        title: MyString.newCard,
      ),
      bottomNavigationBar: Container(
        height: 90,
        padding: const EdgeInsets.all(15),
        child:
        Button(
          onpressed: () {
            return controller.addCardSubmit();
          },
          text: MyString.addCard,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CreditCardWidget(
              glassmorphismConfig: _getGlassmorphismConfig(),
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              obscureCardNumber: false,
              obscureCardCvv: false,
              isHolderNameVisible: true,
              isSwipeGestureEnabled: true,
              // onCreditCardWidgetChange: (CreditCardBrand ) {},
              // onCreditCardWidgetChange:
              //     (CreditCardBrand creditCardBrand) {},
              customCardTypeIcons: <CustomCardTypeIcon>[
                CustomCardTypeIcon(
                  cardType: CardType.mastercard,
                  cardImage: Image.asset(
                    'assets/mastercard.png',
                    height: 48,
                    width: 10,
                  ),
                ),
              ], onCreditCardWidgetChange: (creditCardBrand) {},
            ),
            CreditCardForm(
              formKey: controller.newCardKey,
              obscureCvv: true,
              isHolderNameVisible: true,
              isCardNumberVisible: true,
              isExpiryDateVisible: true,
              cardNumber: cardNumber,
              cvvCode: cvvCode,
              cardHolderName: cardHolderName,
              expiryDate: expiryDate,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onCreditCardModelChange: onCreditCardModelChange,
              cardNumberValidator: controller.cardNumberValidation,
              cardHolderValidator: controller.nameValidation,
              expiryDateValidator: controller.expiryNumberValidation,
              cvvValidator: controller.cvvNumberValidation,
              inputConfiguration: InputConfiguration(
                cardHolderDecoration: commonInputDecoration(MyString.holderName, controller.themeController.isDarkMode.value),
                cardNumberDecoration: commonInputDecoration(MyString.cardNumber, controller.themeController.isDarkMode.value),
                expiryDateDecoration: commonInputDecoration(MyString.expiry, controller.themeController.isDarkMode.value),
                cvvCodeDecoration: commonInputDecoration(MyString.cvv, controller.themeController.isDarkMode.value),
              ),
            )
          ],
        ),
      ),
    );
  }

  InputDecoration commonInputDecoration(String hintText, bool isDarkMode) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey,fontWeight: FontWeight.w400, fontSize: 14),
      filled: true,
      fillColor: isDarkMode ? MyColors.darkTextFieldColor : MyColors.disabledTextFieldColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: isDarkMode ? Colors.white : Colors.black),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: isDarkMode ? Colors.white : Colors.black),
        borderRadius: BorderRadius.circular(15),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: isDarkMode ? Colors.transparent : Colors.grey.shade300),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: isDarkMode ? Colors.transparent : Colors.grey.shade300),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  Glassmorphism? _getGlassmorphismConfig() {
    if (!useGlassMorphism) {
      return null;
    }
    final LinearGradient gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[Colors.grey.withAlpha(50), Colors.grey.withAlpha(50)],
      stops: const <double>[0.3, 0],
    );

    return isLightTheme
        ? Glassmorphism(blurX: 8.0, blurY: 16.0, gradient: gradient)
        : Glassmorphism.defaultConfig();
  }
}
