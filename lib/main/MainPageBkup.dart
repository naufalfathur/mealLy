import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:meally2/HomePage.dart';
import 'package:meally2/main/Planner.dart';
import 'package:meally2/main/myPlanPage.dart';
import 'package:meally2/models/meals.dart';
import 'package:meally2/models/user.dart';
import 'package:meally2/widgets/ProgressWidget.dart';import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart' as intl;

class MainPage extends StatefulWidget {
  final String userProfileId;
  final User gCurrentUser;
  MainPage({this.userProfileId, this.gCurrentUser});
  @override
  _MainPageState createState() => _MainPageState(userProfileId: userProfileId);
}

class _MainPageState extends State<MainPage> {
  final now = DateTime.now();
  final String userProfileId;
  double cal=0.0;
  double totCal = 0.0;
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
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      width: MediaQuery.of(context).size.width,
      height: 220,
      child: Stack(
        children: <Widget>[

          ClipPath(
            clipper: TopBarClipper(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Hexcolor("#FF9900"),
              ),
              /*
              child: ClipRRect(
                child: Align(
                  alignment: Alignment(2.0, 0),
                  child: Image(
                    image: AssetImage("assets/images/eating.png"),
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
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
              padding: EdgeInsets.only(left: 25, right: 45),
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
              padding: EdgeInsets.only(top: 30, bottom: 10, right: 10),
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
                      child: caloriesProgress(user)
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  caloriesProgress(User user){
    return StreamBuilder(
      stream: custOrdersReference.document(userProfileId).collection("custOrder").where("datetime", isGreaterThanOrEqualTo: DateTime(now.year, now.month, now.day), isLessThan: DateTime(now.year, now.month, now.day+ 1)).snapshots(),
      builder: (context, dataSnapshot){
        if(!dataSnapshot.hasData){
          return circularProgress(Colors.orangeAccent);
        }
        List<OrdersItem> comments = [];
        dataSnapshot.data.documents.forEach((document){
          comments.add(OrdersItem.fromDocument(document, userProfileId));
        });
        for (int i = 0; i < comments.length; i++) {
          print(comments[i].calories.toString() + "a");
          cal = cal + comments[i].calories;
        }

        if(comments.isEmpty){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Calories Consumed : "+user.tdee.toString()+"/"+user.tdee.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
              SizedBox(height: 5,),
              Container(
                width: 200,
                child:  LinearProgressIndicator(
                  value: user.tdee/user.tdee,
                  backgroundColor: Colors.black26,
                  valueColor: AlwaysStoppedAnimation(Colors.orangeAccent,),
                ),
              ),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Calories Consumed : 0/"+cal.round().toString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
            SizedBox(height: 5,),
            Container(
              width: 200,
              child:  LinearProgressIndicator(
                value: 0/cal.round(),
                backgroundColor: Colors.black26,
                valueColor: AlwaysStoppedAnimation(Colors.orangeAccent,),
              ),
            ),
          ],
        );
      },
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
      height: MediaQuery.of(context).size.height-380,
      width: MediaQuery.of(context).size.width,
      //color: Colors.blueAccent,
      padding: EdgeInsets.only(left: 25, right: 25,top: 15),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/eating.png"),
                    fit: BoxFit.scaleDown,
                  )
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Today's Menu",
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 13)
                ),),
              GestureDetector(
                onTap: (){myPlanPage(context);},
                child: Container(
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
              )
            ],
          ),
          SizedBox(height: 10,),
          Positioned(
            top: 35,
            child: Container(
              height: 170,
              width: MediaQuery.of(context).size.width-60,
              child: retrieveOrder(),
            ),
          ),
          Positioned(
            bottom: 40,
            child: Container(
              height: 100,
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0.0,10.0),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              width: MediaQuery.of(context).size.width-60,
              child: retrieveNextMeals(),
            ),
          )
        ],
      ),
    );
  }

  myPlanPage(context){
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyPlanPage(gCurrentUser: currentUser, userProfileId: currentUser.id)));
  }

  retrieveOrder(){
    return StreamBuilder(
      stream: custOrdersReference.document(userProfileId).collection("custOrder").where("datetime", isGreaterThanOrEqualTo: DateTime(now.year, now.month, now.day), isLessThan: DateTime(now.year, now.month, now.day+ 1)).snapshots(),
      builder: (context, dataSnapshot){
        if(!dataSnapshot.hasData){
          return circularProgress(Colors.orangeAccent);
        }
        List<OrdersItem> comments = [];
        dataSnapshot.data.documents.forEach((document){
          comments.add(OrdersItem.fromDocument(document, userProfileId));
        });
        if(comments.isEmpty){
          return noMeals();
        }
        return ListView(
          scrollDirection: Axis.horizontal,
          children: comments,
        );
      },
    );
  }
  retrieveNextMeals(){
    return StreamBuilder(
      stream: custOrdersReference.document(userProfileId).collection("custOrder")
          .where("datetime", isGreaterThanOrEqualTo: DateTime(now.year, now.month, now.day, now.hour, now.minute),
          isLessThan: DateTime(now.year, now.month, now.day+ 1)).limit(1).snapshots(),
      builder: (context, dataSnapshot){
        if(!dataSnapshot.hasData){
          return circularProgress(Colors.orangeAccent);
        }
        List<OrdersItem> comments = [];
        dataSnapshot.data.documents.forEach((document){
          comments.add(OrdersItem.fromDocument(document, userProfileId));
        });
        if(comments.isEmpty){
          return Center(
            child: Text(
                "No Meals Available"
            ),
          );
        }
        return ListView.builder(
          itemCount: comments.length,
          itemBuilder: (BuildContext context, int index){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Next meal delivery",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black)
                  ),
                ),
                SizedBox(width: 5,),
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(comments[index].url),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(comments[index].mealName,
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black)
                          ),
                        ),
                        Text(comments[index].datetime.toDate().toString()),
                      ],
                    ),
                  ],
                )
              ],
            );
          },
        );
      },
    );
  }

  noMeals(){
    return Container(
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
            spreadRadius: -18,
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

    path.lineTo(0, size.height-80);
    path.quadraticBezierTo(size.width/5, size.height, size.width, size.height-50);
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

class OrdersItem extends StatelessWidget {
  final datetime;
  final String location;
  final String mealName;
  final String mealId;
  final int status;
  final String custId;
  final String orderId;
  final String userProfileImg;
  final String url;
  final String userProfileId;
  final double calories;
  OrdersItem({
    this.url,
    this.status,
    this.userProfileImg,
    this.datetime,
    this.custId,
    this.location,
    this.mealName, this.mealId, this.userProfileId, this.orderId, this.calories});

  factory OrdersItem.fromDocument(DocumentSnapshot documentSnapshot, String userProfileId){
    return OrdersItem(
      custId: documentSnapshot["custId"],
      url: documentSnapshot["url"],
      userProfileImg: documentSnapshot["userProfileImg"],
      datetime: documentSnapshot["datetime"],
      status: documentSnapshot["status"],
      location: documentSnapshot["location"],
      mealName: documentSnapshot["mealName"],
      mealId: documentSnapshot["mealId"],
      orderId: documentSnapshot["orderId"],
      calories: documentSnapshot["calories"],
      userProfileId : userProfileId,
    );
  }


  @override
  Widget build(BuildContext context) {
    String stats;
    if(status==0){
      stats = "Unprepared";
    }else if(status==1){
      stats = "Preparing";
    }else if(status==2){
      stats = "Cooking";
    }else if(status==3){
      stats = "Delivering";
    }else {
      stats = "Delivered";
    }
    return Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: GestureDetector(
            onTap: (){print("a");},
            child: Container(
              //height: 20,
              padding: EdgeInsets.only(left: 5, right: 5, top: 8),
              width: 95,
              //color: Colors.blue,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0.0,3.0),
                    blurRadius: 15,
                    spreadRadius: -10,
                  ),
                ],
              ),
              child: ListView(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 80,
                    //width: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: NetworkImage(url),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 7,),
                  Text(mealName,textAlign: TextAlign.left,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 10)
                    ),),
                  Text(calories.toString() + "KCal",textAlign: TextAlign.left,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 10)
                    ),),
                  Text(intl.DateFormat.Hm().format(datetime.toDate()), style: GoogleFonts.poppins(textStyle:
                  TextStyle(fontSize: 13.0, color: Colors.orangeAccent, fontWeight: FontWeight.w600),),),
                ],
              ),
            )
        )
    );
  }
}
