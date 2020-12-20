import 'package:flutter/material.dart';
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

class restaurantList extends StatefulWidget {
  final String userProfileId;
  restaurantList({this.userProfileId});
  @override
  _restaurantListState createState() => _restaurantListState(userProfileId: userProfileId);
}

class _restaurantListState extends State<restaurantList> {
  final String userProfileId;
  _restaurantListState({this.userProfileId});
  displayUsersFoundScreen(){
    return FutureBuilder(
      future: restReference.getDocuments(),
      builder: (context, dataSnapshot){
        if(!dataSnapshot.hasData){
          return circularProgress(Colors.blue);
        }
        List<RestResult> restList = [];
        dataSnapshot.data.documents.forEach((document){
          Restaurant eachRest = Restaurant.fromDocument(document);
          RestResult restResult = RestResult(eachRest);
          restList.add(restResult);
        });

        return ListView(children: restList);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          padding: EdgeInsets.only(top:50),
          child: Column(
            children: [
              Expanded(child: displayUsersFoundScreen(),),
              saveButton(),
            ],
          )
      ),
    );
  }

  saveButton(){
    return GestureDetector(
      onTap: ()=>displayMenuPlanning(),
      child: Container(
        alignment: Alignment.center,
        height: 80,
        color: Hexcolor("#FF9900"),
        child: Text("Save", style: GoogleFonts.poppins(textStyle:
        TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.w600),),),
      ),
    );
  }
  displayMenuPlanning(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => MenuPlanning(userProfileId: userProfileId),));
  }
}

class RestResult extends StatelessWidget {
  final Restaurant eachRest;
  RestResult(this.eachRest);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3.0),
      child: Container(
        color: Colors.white54,
        child: Column(
          children: <Widget> [
            GestureDetector(
              onTap: () => displayUserProfile(context, userProfileId: eachRest.id, restaurantName: eachRest.RestaurantName),
              child: ListTile(
                leading: CircleAvatar(backgroundColor: Colors.black, backgroundImage: CachedNetworkImageProvider(eachRest.url),),
                title: Text(eachRest.RestaurantName, style: TextStyle(
                  color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold,
                ),),
                subtitle: Text(eachRest.cuisine + " Cuisine \n" + eachRest.postcode.toString()+" "+eachRest.city , style: TextStyle(
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
    Navigator.push(context, MaterialPageRoute(builder: (context) => restaurantProfile(userRestId : userProfileId, restaurantName: restaurantName, restOnline: false),));
  }

}
