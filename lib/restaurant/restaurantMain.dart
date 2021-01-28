import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meally2/main/RestaurantHome.dart';
import 'package:meally2/models/restaurant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class restaurantMain extends StatefulWidget {
  final String userRestId;
  final Restaurant gCurrentRest;

  restaurantMain({this.userRestId, this.gCurrentRest});
  @override
  _restaurantMainState createState() => _restaurantMainState(userRestId:userRestId);
}

class _restaurantMainState extends State<restaurantMain> {
  final String userRestId;
  _restaurantMainState({this.userRestId});
  double earn;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEarnings();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          //topBar()
          earnings(),
          widgets(),
          //activeOrders()
        ],
      ),
    );
  }

  Future<double> getEarnings() async{
    DocumentReference documentReference =  restReference.document(userRestId);
    await documentReference.get().then((snapshot) {
      earn = double.tryParse(snapshot.data['earnings'].toString());
    });
    print("earn = "+earn.toString());
  }

  getRating(){

  }

  getSold(){

  }

  topBar(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 20, right: 20, top: 10),
      decoration: BoxDecoration(
        color: Hexcolor("#FF9900"),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(Icons.menu_rounded, color: Colors.white, size: 30,),
          Text("Welcome!",textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 25)
            ),),
          Text("m.",textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 25)
            ),),
        ],
      ),
    );
  }

  earnings(){
    return Container(
      margin: EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 15),
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      height: 90,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color : Colors.black)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Earnings",textAlign: TextAlign.left,
            style: GoogleFonts.poppins(
                textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)
            ),),
          Text("RM $earn",textAlign: TextAlign.left,
            style: GoogleFonts.poppins(
                textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 30)
            ),),
        ],
      ),
    );
  }
  widgets(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: (){
            //Navigator.push(context, MaterialPageRoute(builder: (context) => ProgressPage(userProfileId: currentUser.id, gCurrentUser: currentUser,)));
          },
          child: Container(
            height: 160,
            width: 150,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Hexcolor("#575757"),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Weight\nTrack",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)
                  ),),
                Row(
                  children: [
                    Icon(Icons.arrow_upward_rounded, color: Colors.blue,),
                    Text("10",
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 55, height: 1.3,)
                      ),),
                    Text(" Kg",
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15, height: 4.1,)
                      ),),
                  ],
                ),
                Text("From 60kg to 70kg",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 11, height: 0.8 )
                  ),),
              ],
            ),
          ),
        ),
        SizedBox(width: 10,),
        Container(
          height: 160,
          padding: EdgeInsets.all(15),
          width: 150,
          decoration: BoxDecoration(
            color: Hexcolor("#FF4747"),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Calories\nIntake",
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)
                ),),
              Text("2000",
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 45, height: 1.2 )
                ),),
              Text("Based on Kath-McArdie formula",
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 8, )
                ),),
            ],
          ),
        )
      ],
    );
  }
}
