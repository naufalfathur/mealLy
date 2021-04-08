import 'dart:async';

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
  void initState(){
    super.initState();
    Timer(Duration(seconds: 2), (){
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BuildWelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.orangeAccent,
          image: DecorationImage(
            alignment: Alignment(-1, 0),
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.fitHeight,
          ),
        ),
        alignment: Alignment.center,
        child: Container(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: HexColor("#FF9900").withOpacity(0.45)
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text("mealLy",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 45, color: Colors.white)
                  ),),
              ),
              Positioned(
                bottom: -190,
                right: -150,
                child: Container(
                  height: 480,
                  child:
                  Image(
                    image: AssetImage("assets/images/diet.png"),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  Scaffold BuildWelcomeScreen(){
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: HexColor("#FF9900"),
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
                      textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: HexColor("#FF9900"))
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
                      textStyle: TextStyle(color: HexColor("#FF9900"), fontWeight: FontWeight.w600, fontSize: 35)
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
                      textStyle: TextStyle(color: HexColor("#FF9900"), fontWeight: FontWeight.w600, fontSize: 15)
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
                      color: HexColor("#FF9900"),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text("Start as Customer",
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white)
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Text("or",textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: HexColor("#FF9900"), fontWeight: FontWeight.w600, fontSize: 18)
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
        themeColor: HexColor("#FF9900"),
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
        title: 'One time order',
        description: 'Order just once a day or even once in a week for the whole plan',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/images/delivered.png'),
    SkOnboardingModel(
        title: 'Measured meals',
        description: 'Every meal delivered to you is measured precisely for its calories',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/images/mealsphone.png'),
    SkOnboardingModel(
        title: 'Order by Plan',
        description:
        'Your meals are based on your Generated plan from your calorie intake',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/images/eating.png'),
  ];

  final pages2 = [
    SkOnboardingModel(
        title: 'Greater reach of market',
        description:
        'can reach people that arent aware of the restaurant',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/images/eating.png'),
    SkOnboardingModel(
        title: 'Efficient customer and order management',
        description:
        'Everything is in one app',
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
              color: HexColor("#FF9900"),
              width: MediaQuery.of(context).size.width/2,
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              height: (MediaQuery.of(context).size.height/2),
              //color: HexColor("#FF9900"),
              width: MediaQuery.of(context).size.width/2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("One time order",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 20)
                    ),),
                  Text("Order just once a day or even once in a week for the whole plan",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12)
                    ),),
                  Text("Measured meals",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 20)
                    ),),
                  Text("Every meal delivered to you is measured precisely for its calories",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12)
                    ),),
                  Text("Order by Plan",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 20)
                    ),),
                  Text("Your meals are based on your Generated plan from your calorie intake",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12)
                    ),),
                  Text(" "),
                  Text("And much more..",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600, fontSize: 11)
                    ),),
                ],
              ),
            ),
            SizedBox(height: 30,),
            Text("RM 1 for 1 days and RM 5 for weeks plan",textAlign: TextAlign.center,
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
              color: HexColor("#FF9900"),
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
            Text("mealLy",textAlign: TextAlign.center,
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
              color: HexColor("#FF9900"),
              width: MediaQuery.of(context).size.width/2,
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              height: (MediaQuery.of(context).size.height/2),
              //color: HexColor("#FF9900"),
              width: MediaQuery.of(context).size.width/2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Greater reach of market",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 25)
                    ),),
                  Text("can reach people that arent awarre of the restaurant",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12)
                    ),),
                  Text("Efficient customer and order management",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 22)
                    ),),
                  Text("eveything is in one app",
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
            SizedBox(height: 10,),
            FlatButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RestaurantHome()),
                );
              },
              color: HexColor("#FF9900"),
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
            Text("mealLy",textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.w700, fontSize: 12)
              ),),
          ],
        ),
      ),
    );
  }

}
