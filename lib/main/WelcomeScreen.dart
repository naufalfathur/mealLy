import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meally2/HomePage.dart';
import 'package:meally2/main/RestaurantHome.dart';
import 'package:meally2/widgets/HeaderPage.dart';
import 'package:sk_onboarding_screen/sk_onboarding_screen.dart';
import 'package:sk_onboarding_screen/flutter_onboarding.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Hexcolor("#FF9900"),
            ),
          ),
          Positioned(
            bottom: -120,
            right: -170,
            child: Container(
              height: 420,
              child:
              Image(
                image: AssetImage("assets/images/rest.png"),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BuildOnboardScreen(pages2, TryPartner())),
                );
              },
              child: Container(
                height: 90,
                width: 120.0,
                margin: EdgeInsets.only(bottom: 50,left: 20),
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text("Start as Restaurant instead",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Hexcolor("#FF9900"))
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height-170,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 40, right: 40, top: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
            ),
            child: Column(
              children: <Widget>[
                Text("mealLy",textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Hexcolor("#FF9900"), fontWeight: FontWeight.w600, fontSize: 35)
                  ),),
                Container(
                  //height: 500,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    child: Image(
                      image: AssetImage("assets/images/train.png"),
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
                Text("your personalized meal planning and ordering system",textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Hexcolor("#FF9900"), fontWeight: FontWeight.w600, fontSize: 15)
                  ),),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BuildOnboardScreen(pages1, TryFree())),
                    );
                  },
                  child: Container(
                    height: 50,
                    width: 270.0,
                    margin: EdgeInsets.only(top: 15, bottom: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Hexcolor("#FF9900"),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text("Start as Customer",
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white)
                      ),
                    ),
                  ),
                ),
                Text("or",textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Hexcolor("#FF9900"), fontWeight: FontWeight.w600, fontSize: 18)
                  ),),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Scaffold BuildOnboardScreen(List<SkOnboardingModel> pages, Widget widget){
    return Scaffold(
      key: _globalKey,
      body: SKOnboardingScreen(
        bgColor: Colors.white,
        themeColor: Hexcolor("#FF9900"),
        pages: pages,
        skipClicked: (value) {
          print(value);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => widget),
          );
        },
        getStartedClicked: (value) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => widget),
          );
        },
      ),
    );
  }

  final pages1 = [
    SkOnboardingModel(
        title: 'Choose your item',
        description:
        'Easily find your grocery items and you will get delivery in wide range',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/images/eating.png'),
    SkOnboardingModel(
        title: 'Pick Up or Delivery',
        description:
        'Easily find your grocery items and you will get delivery in wide range',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/images/eating.png'),
    SkOnboardingModel(
        title: 'Pay quick and easy',
        description: 'Pay for order using credit or debit card',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/images/eating.png'),
  ];

  final pages2 = [
    SkOnboardingModel(
        title: 'Benefit 1',
        description:
        'Easily find your grocery items and you will get delivery in wide range',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/images/eating.png'),
    SkOnboardingModel(
        title: 'Benefit 2',
        description:
        'Easily find your grocery items and you will get delivery in wide range',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/images/eating.png'),
    SkOnboardingModel(
        title: 'Benefit 3',
        description: 'Pay for order using credit or debit card',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/images/eating.png'),
  ];

  Scaffold TryFree(){
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 80),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Text("Try it Free",textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 25)
              ),),
            Container(
              margin: EdgeInsets.only(top: 10),
              height: 5,
              color: Hexcolor("#FF9900"),
              width: MediaQuery.of(context).size.width/2,
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              height: (MediaQuery.of(context).size.height/2),
              //color: Hexcolor("#FF9900"),
              width: MediaQuery.of(context).size.width/2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Delivery",textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 25)
                    ),),
                  Text("Easily find your grocery items and you will get delivery in wide range",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12)
                    ),),
                  Text("Plan",textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 22)
                    ),),
                  Text("Easily find your grocery items and you will get delivery in wide range",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12)
                    ),),
                  Text("Cashless",textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 25)
                    ),),
                  Text("Easily find your grocery items and you will get delivery in wide range",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12)
                    ),),
                  Text(" "),
                  Text("And much more..",textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600, fontSize: 11)
                    ),),
                ],
              ),
            ),
            SizedBox(height: 30,),
            Text("1 days free, then RM 3/days or RM5/week",textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 12)
              ),),
            SizedBox(height: 10,),
            FlatButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage()),
                );
              },
              color: Hexcolor("#FF9900"),
              child: Container(
                width: MediaQuery.of(context).size.width/2,
                height: 40.0,
                child: Text("Continue",textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)
                  ),),
                alignment: Alignment.center,
              ),
            ),
            SizedBox(height: 20,),
            Text("Cancel anytime",textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.w700, fontSize: 12)
              ),),
          ],
        ),
      ),
    );
  }
  Scaffold TryPartner(){
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 80),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Text("Partner with us!",textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 25)
              ),),
            Container(
              margin: EdgeInsets.only(top: 10),
              height: 5,
              color: Hexcolor("#FF9900"),
              width: MediaQuery.of(context).size.width/2,
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              height: (MediaQuery.of(context).size.height/2),
              //color: Hexcolor("#FF9900"),
              width: MediaQuery.of(context).size.width/2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Delivery",textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 25)
                    ),),
                  Text("Easily find your grocery items and you will get delivery in wide range",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12)
                    ),),
                  Text("Plan",textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 22)
                    ),),
                  Text("Easily find your grocery items and you will get delivery in wide range",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12)
                    ),),
                  Text("Cashless",textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 25)
                    ),),
                  Text("Easily find your grocery items and you will get delivery in wide range",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12)
                    ),),
                  Text(" "),
                  Text("And much more..",textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600, fontSize: 11)
                    ),),
                ],
              ),
            ),
            SizedBox(height: 30,),
            Text("1 days free, then RM 3/days or RM5/week",textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 12)
              ),),
            SizedBox(height: 10,),
            FlatButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RestaurantHome()),
                );
              },
              color: Hexcolor("#FF9900"),
              child: Container(
                width: MediaQuery.of(context).size.width/2,
                height: 40.0,
                child: Text("Continue",textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)
                  ),),
                alignment: Alignment.center,
              ),
            ),
            SizedBox(height: 20,),
            Text("Cancel anytime",textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.w700, fontSize: 12)
              ),),
          ],
        ),
      ),
    );
  }

}
