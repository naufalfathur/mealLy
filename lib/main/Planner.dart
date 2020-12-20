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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            height: 500,
            width: MediaQuery.of(context).size.width,
            child: ClipRRect(
              child: Image(
                image: AssetImage("assets/images/Schedule.png"),
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
          Column(
            children: [
              Text("You are on a ------- program "),
              Text("Thus, your calorie intake should be: ------"),
              Text("How many meals you want to eat per day ?"),
            ],
          ),
          Container(
            //color: Colors.black26,
            height: 100,
            alignment: Alignment.center,
            child: FlatButton(
              onPressed: getAllProfilePost,
              child: Container(
                width: MediaQuery.of(context).size.width/2,
                height: 40.0,
                child: Text("Continue",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.white)
                  ),),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Hexcolor("#FF9900"),
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
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
