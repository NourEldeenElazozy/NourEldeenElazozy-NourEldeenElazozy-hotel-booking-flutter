part of 'onboarding_import.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  OnboardingController onboardingController = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Obx(() => Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 70 / 100,
                  // width: MediaQuery.of(context).size.width,
                  child: PageView.builder(
                    controller: onboardingController._pageController.value,
                    onPageChanged: (val) {
                      onboardingController.changeValue.value = val;
                    },
                    itemCount: MyImages.images.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            // color: Colors.red,
                              child: Image.asset(MyImages.images[index],fit: BoxFit.fitWidth,)
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  MyString.text[index],
                                  style: TextStyle(
                                    color: onboardingController.themeController.isDarkMode.value ? MyColors.white : MyColors.onBoardingTextColor,fontWeight: FontWeight.w700, fontSize: MediaQuery.of(context).size.height/ 22),
                                ),
                                const SizedBox(height: 18),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40, right: 20),
                      child: Button(
                        onpressed: () {
                          onboardingController.storeValue();
                        },
                        text: MyString.skip,
                        shadowColor: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 30 / 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      MyString.description,
                      style: TextStyle(color: onboardingController.themeController.isDarkMode.value ? MyColors.onBoardingDescriptionDarkColor : MyColors.textPaymentInfo, fontWeight: FontWeight.w400, fontSize: 16),
                      textAlign: TextAlign.justify,
                    ),
                    DotsIndicator(
                      dotsCount: 3,
                      position: onboardingController.changeValue.value,
                      decorator: DotsDecorator(
                        size: const Size.square(8),
                        activeSize: const Size(35, 8),
                        activeColor: MyColors.green,
                        color: MyColors.disabledColor,
                        spacing: const EdgeInsets.symmetric(horizontal: 3),
                        activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: Button(
                            onpressed: () {
                              onboardingController.changeValue.value == 2
                                ? onboardingController.storeValue()
                                : onboardingController.nextButton();
                            },
                            text: MyString.next,
                            shadowColor: Colors.transparent,
                          ),
                        ),
                        // SizedBox(
                        //   height: 45,
                        //   width: MediaQuery.of(context).size.width,
                        //   child: Button(
                        //     onpressed: () {
                        //       onboardingController.storeValue();
                        //     },
                        //     text: MyString.skip,
                        //     buttonColor: MyColors.skipButtonColor,
                        //     textColor: MyColors.black,
                        //     fontBold: FontWeight.w700,
                        //   ),
                        // ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );

  }
}
