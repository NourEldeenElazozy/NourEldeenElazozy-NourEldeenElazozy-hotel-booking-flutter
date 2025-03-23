part of "welcome_import.dart";

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  WelcomeController welcomeController = Get.put(WelcomeController());

  @override
  void initState() {
    welcomeController.init();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(MyImages.welcome,fit: BoxFit.cover),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30, bottom: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(MyString.welcome, style: TextStyle(color: Colors.white, fontSize: 45, fontWeight: FontWeight.w700)),
                  GradientText(
                    MyString.bookNest,
                    style: TextStyle(fontSize: 65, fontWeight: FontWeight.w900),
                    gradient: LinearGradient(
                      colors: [
                        MyColors.green,
                        MyColors.darkGreen,
                      ],
                    ),
                  ),
                  Text(MyString.vacation,style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
