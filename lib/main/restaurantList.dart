import 'package:flutter/material.dart';
import 'package:meally2/main/MealPlanning.dart';
import 'package:meally2/main/MenuPlanning.dart';
import 'package:meally2/main/RestaurantHome.dart';
import 'package:meally2/models/restaurant.dart';
import 'package:meally2/models/restaurantProfile.dart';
import 'package:meally2/models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ProfilePage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meally2/widgets/ProgressWidget.dart';
import 'package:meally2/HomePage.dart';
//import 'package:geolocator/geolocator.dart';
//import 'package:great_circle_distance/great_circle_distance.dart';
import 'dart:math';
class Item {
  const Item(this.name, this.value);
  final String name;
  final int value;
}
class restaurantList extends StatefulWidget {
  final String userProfileId;
  restaurantList({this.userProfileId});
  @override
  _restaurantListState createState() => _restaurantListState(userProfileId: userProfileId);
}

class _restaurantListState extends State<restaurantList> {
  Item item;
  int plan;
  bool selected = false;
  List<Item> items = <Item>[
    const Item('One Day Plan',1),
    const Item('One Week Plan',7),
  ];
  final String userProfileId;
  _restaurantListState({this.userProfileId});
  String name;
  //double longitude;
  ///double latitude;


  displayUsersFoundScreen(double long, double lat){
    return FutureBuilder(
      future: restReference.getDocuments(),
      builder: (context, dataSnapshot){
        if(!dataSnapshot.hasData){
          return circularProgress(Colors.blue);
        }
        List<RestResult> restList = [];
        dataSnapshot.data.documents.forEach((document){
          Restaurant eachRest = Restaurant.fromDocument(document);
          RestResult restResult = RestResult(eachRest, long, lat);
          restList.add(restResult);
        });

        return ListView(children: restList);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //getCustTDEE();
    return FutureBuilder(
      future: userReference.document(widget.userProfileId).get(),
      builder: (context, dataSnapshot){
        if(!dataSnapshot.hasData){
          return circularProgress(Colors.orangeAccent);
        }
        User user = User.fromDocument(dataSnapshot.data);
        return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
              padding: EdgeInsets.only(top:50),
              child: Column(
                children: [
                  Text("Plan your meals",textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20)
                    ),),
                  Container(
                    margin: EdgeInsets.only(left: 90),
                    height: 5,
                    color: HexColor("#FF9900"),
                    width: MediaQuery.of(context).size.width/4,
                  ),
                  SizedBox(height: 20,),
                  Text("Hi " + user.profileName ,textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 20)
                    ),),
                  Container(
                    padding: EdgeInsets.only(left: 50, right: 50, top: 20),
                    child:  Column(
                      children: [
                        Text("Before we make a plan for you "
                            "below are the list of restaurant that are partnering with us "
                            "feel free to see and you can block which restaurant that doesnt suits you",textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 11)
                          ),),
                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                  Expanded(child: displayUsersFoundScreen(user.longitude, user.latitude),),
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(left: 10, right: 10),
                    margin: EdgeInsets.only(left: 50, right: 50, bottom: 20),
                    //width: 270,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<Item>(
                      hint:  Text("Select Program", style: TextStyle( fontSize: 12),),
                      value: item,
                      onChanged: (Item Value) {
                        setState(() {
                          item = Value;
                          plan = item.value;
                          print(plan);
                          selected = true;
                        });
                      },
                      items: items.map((Item items) {
                        return  DropdownMenuItem<Item>(
                          value: items,
                          child:Container(
                            //width: MediaQuery.of(context).size.width,
                            child: Text(
                              items.name,
                              style:  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      if(selected){
                        displayMenuPlanning();
                      }else{
                        print("not selected");
                      }
                    },
                    child: Container(
                      decoration: selected ? BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          image: AssetImage("assets/images/bg.png"),
                          fit: BoxFit.cover,
                        ),
                      ) : BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.black45
                      ),
                      width: MediaQuery.of(context).size.width-100,
                      height: 40.0,
                      child: Text("Ready and Go",textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)
                        ),),
                      alignment: Alignment.center,
                    ),
                  ),
                  SizedBox(height: 25,),
                ],
              )
          ),
        );
      },
    );

  }


  displayMenuPlanning(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => MealPlanning(userProfileId: userProfileId, plan: plan,),));
  }
}

class RestResult extends StatelessWidget {
  final Restaurant eachRest;
  final double longitude;
  final double latitude;
  RestResult(this.eachRest, this.longitude, this.latitude);
  var distanceInMeters;

  @override
  Widget build(BuildContext context) {
    final lat1 = eachRest.latitude;
    final lon1 = eachRest.longitude;

    final lat2 = latitude;
    final lon2 = longitude;

    double calculateDistance(lat1, lon1, lat2, lon2){
      double R, s,d,a,b, af, c, metre;

      R = 6371e3; // metres
      s = lat1 * pi/180; // φ, λ in radians
      d = lat2 * pi/180;
      a = (lat2-lat1) * pi/180;
      b = (lon2-lon1) * pi/180;

      af = sin(a/2) * sin(a/2) +
          cos(s) * cos(d) *
              sin(b/2) * sin(b/2);
      c = 2 * atan2(sqrt(af), sqrt(1-af));

      metre = (R * c)/1000;
      return metre;//
    }

    double totalDistance = calculateDistance(lat1, lon1, lat2, lon2 );

    return Padding(
      padding: EdgeInsets.all(3.0),
      child: Container(
        color: Colors.white54,
        child: Column(
          children: <Widget> [
            GestureDetector(
              onTap: () => displayUserProfile(context, userProfileId: eachRest.id, restaurantName: eachRest.RestaurantName),
              child: ListTile(
                //leading: CircleAvatar(backgroundColor: Colors.black, backgroundImage: CachedNetworkImageProvider(eachRest.url),),
                title: Text(eachRest.RestaurantName, style: TextStyle(
                  color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold,
                ),),
                subtitle: Text(eachRest.cuisine + " Cuisine \n" + eachRest.postcode.toString()+" "+eachRest.city + " (" + totalDistance.round().toString() + " Km away)", style: TextStyle(
                  color: Colors.black, fontSize: 13.0,
                ),),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
            Divider(thickness: 0.5,),
          ],
        ),
      ),
    );
  }


  displayUserProfile(BuildContext context, {String userProfileId, String restaurantName}){
    Navigator.push(context, MaterialPageRoute(builder: (context) => restaurantProfile(userRestId :eachRest.id, restaurantName: restaurantName, restOnline: false),));
  }

}
