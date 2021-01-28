import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meally2/HomePage.dart';
import 'package:meally2/main/RestaurantHome.dart';
import 'package:meally2/main/restaurantList.dart';
import 'package:meally2/models/restaurant.dart';
import 'package:meally2/widgets/ProgressWidget.dart';
import 'package:meally2/models/user.dart';

class Planner extends StatefulWidget {
  final String userProfileId;
  Planner({this.userProfileId});
  @override
  _PlannerState createState() => _PlannerState(userProfileId: userProfileId);
}

class _PlannerState extends State<Planner> {
  final String userProfileId;
  _PlannerState({this.userProfileId});
  PageController pageController = PageController();
  int pageChanged = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                alignment: Alignment(-1, 0),
                image: AssetImage("assets/images/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: PageView(
              //physics:new NeverScrollableScrollPhysics(),
              pageSnapping: true,
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  pageChanged = index;
                });
                print(pageChanged);
              },
              children: [
                //page0(),
                page1(),
                page2(),
                page3(),
                page4(),
                page5()
              ],
            ),
          ),
        ],
      ),
    );
  }

  page1(){
    return Container(
      height: 500,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(40),
      //color: Colors.redAccent,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/hello.png"),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          SizedBox(height: 10,),
          Text("Welcome to Meal Planning Page in MealLy", textAlign: TextAlign.center, style: GoogleFonts.poppins(textStyle:
          TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white)
          ),),
          SizedBox(height: 10,),
          Text("Swipe to see how this works", style: GoogleFonts.poppins(textStyle:
          TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.white)
          ),),
          SizedBox(height: 10,),
          GestureDetector(
            onTap: (){
              pageController.animateToPage(++pageChanged, duration: Duration(milliseconds: 250), curve: Curves.bounceInOut);
            },
            child: Container(
              decoration: const ShapeDecoration(
                color: Colors.white,
                shape: CircleBorder(),
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_forward),
                color: Colors.orangeAccent,
                onPressed: (){

                },
              ),
            )
          ),
        ],
      ),
    );
  }
  page2(){
    return Container(
      padding: EdgeInsets.all(20),
      height: 500,
      width: MediaQuery.of(context).size.width,
      //color: Colors.black,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 500,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/plan1.png"),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          SizedBox(height: 10,),
          Text("First\nFilter your desired\nrestaurant", textAlign: TextAlign.center, style: GoogleFonts.poppins(textStyle:
          TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white)
          ),),
          Text("and select your plan", style: GoogleFonts.poppins(textStyle:
          TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.white)
          ),),
        ],
      ),
    );
  }
  page3(){
    return Container(
      height: 500,
      padding: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      //color: Colors.blue,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 500,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/plan2.png"),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          SizedBox(height: 10,),
          Text("Second\nArrange your plan!", textAlign: TextAlign.center, style: GoogleFonts.poppins(textStyle:
          TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white)
          ),),
        ],
      ),
    );
  }
  page4(){
    return Container(
      height: 500,
      padding: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      //color: Colors.blue,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 500,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/plan3.png"),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          SizedBox(height: 10,),
          Text("Lastly\nSubmit your plan", textAlign: TextAlign.center, style: GoogleFonts.poppins(textStyle:
          TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white)
          ),),
        ],
      ),
    );
  }
  page5(){
    return Container(
      height: 500,
      padding: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      //color: Colors.blue,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Its very simple\nLets get started!", textAlign: TextAlign.center, style: GoogleFonts.poppins(textStyle:
          TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white)
          ),),
          SizedBox(height: 15,),
          GestureDetector(
            onTap: (){
              getAllProfilePost();
            },
            child: Container(
              height: 50,
              width: 160,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text("Continue", textAlign: TextAlign.center, style: GoogleFonts.poppins(textStyle:
              TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.orangeAccent)
              ),),
            ),
          ),
        ],
      ),
    );
  }

  getAllProfilePost() async{
    final String currentOnlineUserId = currentUser.id;
    QuerySnapshot querySnapshot = await restReference.getDocuments();
    querySnapshot.documents.forEach((document) {
      Restaurant eachRest = Restaurant.fromDocument(document);
      print(eachRest.RestaurantName);
      followingReference.document(currentOnlineUserId)
          .collection("userFollowing")
          .document(eachRest.id)
          .setData({});
      followersReference.document(eachRest.id)
          .collection("userFollowers")
          .document(currentOnlineUserId)
          .setData({});
      generatePlan();
    });
  }

  generatePlan(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => restaurantList(userProfileId: userProfileId)));
  }
}
