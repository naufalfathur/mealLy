import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:meally2/HomePage.dart';
import 'package:meally2/main/Planner.dart';
import 'package:meally2/models/user.dart';
import 'package:meally2/widgets/ProgressWidget.dart';

class MainPage extends StatefulWidget {
  final String userProfileId;
  final User gCurrentUser;
  MainPage({this.userProfileId, this.gCurrentUser});
  @override
  _MainPageState createState() => _MainPageState(userProfileId: userProfileId);
}

class _MainPageState extends State<MainPage> {
  final String userProfileId;
  _MainPageState({this.userProfileId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: userReference.document(widget.userProfileId).get(),
          builder: (context, dataSnapshot) {
            if (!dataSnapshot.hasData) {
              return circularProgress(Colors.orangeAccent);
            }
            User user = User.fromDocument(dataSnapshot.data);
            return ListView(
              children: <Widget>[
                Top(user),
                promo(),
                menu(),
              ],
            );
          }
      ),
    );
  }

  Top(User user){
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 220,
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: TopBarClipper(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Hexcolor("#FF9900"),
              ),
              /*
                  child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Image(
                    image: AssetImage("assets/images/background.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                   */
            ),
          ),
          /*Positioned(
            bottom: -30,
            child: Container(
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              height: 300,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/eating.png"),
                    fit: BoxFit.scaleDown,
                  )
              ),
            ),
          ),
           */
          Positioned(
            top: 20,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.only(left: 25, right: 25),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.menu, color: Colors.white, size: 30,),
                    Text("m.",
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 25, color: Colors.white)
                      ),
                    ),
                  ],
                ),
            ),


          ),
          Positioned(
            top: 50,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.only(top: 10.0, left: 28, right: 25, bottom: 10),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Hi " + user.profileName,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white)
                            ),),
                          Text("Welcome to MealLy! 😎",
                              style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),)),
                        ],
                      ),
                      /*
                          Row(
                            children: <Widget>[
                              Icon(Icons.account_circle, color: Colors.white, size: 40,),
                            ],
                          ),
                           */
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 105,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.only(top: 30, bottom: 10, left: 8, right: 10),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: Hexcolor("#FF9900"),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0.0,3.0),
                          blurRadius: 37,
                          spreadRadius: -8,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(user.initialWeight.toString(),
                            style: GoogleFonts.poppins(textStyle:TextStyle(fontWeight: FontWeight.w400, fontSize: 17, color: Colors.white), )),
                        Text("Weight",
                          style: GoogleFonts.poppins(textStyle:TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.white),),),
                      ],
                    ),
                  ),
                  Container(
                    width: 230,
                    padding: EdgeInsets.only(left:10 , top: 20, bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0.0,3.0),
                          blurRadius: 37,
                          spreadRadius: -8,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Calories Consumed : 2000/"+user.tdee.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                        SizedBox(height: 5,),
                        Container(
                          width: 200,
                          child:  LinearProgressIndicator(
                            value: 2000/user.tdee,
                            backgroundColor: Colors.black26,
                            valueColor: AlwaysStoppedAnimation(Colors.orangeAccent,),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  promo(){
    return Column(
      children: <Widget>[
        Container(
          height: 100,
          width: MediaQuery.of(context).size.width - 45,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Hexcolor("#FF9900"),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Get your",
                      style: GoogleFonts.poppins(textStyle:TextStyle(fontWeight: FontWeight.w700, fontSize: 17, color: Colors.white), )),
                  Text("40% off code !",
                    style: GoogleFonts.poppins(textStyle:TextStyle(fontWeight: FontWeight.w700, fontSize: 17, color: Colors.white),),),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  menu(){
    return Container(
      //color: Colors.blueAccent,
      padding: EdgeInsets.only(left: 25, right: 25,top: 15),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Today's Menu",
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 13)
                ),),
              Container(
                width: 80,
                decoration: BoxDecoration(
                  color: Hexcolor("#FF9900"),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text("See All",textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)
                  ),),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            width: MediaQuery.of(context).size.width,
            height: 150,
            alignment: Alignment.center,
            //color: Colors.black12,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0.0,3.0),
                  blurRadius: 37,
                  spreadRadius: -8,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("You haven't create any Meal Plan",textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 13)
                  ),),
                FlatButton(
                  onPressed: PlanMeal,
                  color: Hexcolor("#FF9900"),
                  child: Container(
                    width: MediaQuery.of(context).size.width/2,
                    height: 40.0,
                    child: Text("Create Now",textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)
                      ),),
                    alignment: Alignment.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  PlanMeal(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => Planner(userProfileId: userProfileId)));
  }
}



class TopBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height-100);
    path.quadraticBezierTo(size.width/5, size.height, size.width, size.height-130);
    //path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    // TODO: implement getClip
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
    throw UnimplementedError();
  }
}
