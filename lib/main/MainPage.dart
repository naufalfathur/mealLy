import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:meally2/HomePage.dart';
import 'package:meally2/main/NotificationPage.dart';
import 'package:meally2/main/OrderDetailsPage.dart';
import 'package:meally2/main/Planner.dart';
import 'package:meally2/main/ProgressPage.dart';
import 'package:meally2/main/myPlanPage.dart';
import 'package:meally2/models/meals.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:meally2/models/user.dart';
import 'package:meally2/widgets/ProgressWidget.dart';import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_swiper/flutter_swiper.dart';

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
  double calories = 0.0;
  double totCal = 0.0;

  _MainPageState({this.userProfileId});
  @override
  Widget build(BuildContext context) {
    double pageHeight = MediaQuery.of(context).size.height*1.4;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
          return <Widget>[
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height/2+30,
              floating: false,
              elevation: 0,
              collapsedHeight: 70,
              backgroundColor: Colors.orangeAccent,
              automaticallyImplyLeading: false,
              pinned: true,
              snap: false,
              flexibleSpace:  Stack(
                children: <Widget>[
                  Positioned.fill(
                    child:  Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          alignment: Alignment(-1, 0),
                          image: AssetImage("assets/images/bg.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child:
                      Container(
                      decoration: BoxDecoration(
                          color: Hexcolor("#000000").withOpacity(0.1)
                      ),
                     ),
                    ),
                  ),
                  Positioned(
                    top: 1,
                    child: Container(
                      width: MediaQuery.of(context).size.width+90,
                      height: 600,
                      decoration: BoxDecoration(
                        //color: Colors.orangeAccent,
                      ),
                      child: Swiper(
                        itemCount: 3,
                        itemBuilder: (BuildContext context, int index){
                          if(index == 0){
                            return message1();
                          }else if(index == 1){
                            return message1();
                          }else if(index == 2){
                            return message1();
                          }else{
                            return Container(color: Colors.red,child: Text("Error, Please try again"));
                          }
                        },
                        //layout: SwiperLayout.TINDER,
                        itemHeight: (MediaQuery.of(context).size.height/3)+300,
                        //loop: false,
                        //itemWidth: MediaQuery.of(context).size.height,
                        control: SwiperControl(),
                        pagination: SwiperPagination(),
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text("mealLy",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white)
                          ),),
                      ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 15,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topRight:  Radius.circular(15), topLeft:  Radius.circular(15)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        body: FutureBuilder(
            future: userReference.document(widget.userProfileId).get(),
            builder: (context, dataSnapshot) {
              if (!dataSnapshot.hasData) {
                return circularProgress(Colors.orangeAccent);
              }
              User user = User.fromDocument(dataSnapshot.data);
              return Container(
                width: MediaQuery.of(context).size.width,
                //height: pageHeight-(pageHeight/2.4),
                color: Colors.white,
                padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                child: inside(pageHeight, user),
              );
            }
        ),
      )
    );
  }

  message1(){
    return Container(
        padding: EdgeInsets.only(left: 50, top: 60),
        decoration: BoxDecoration(
          image: DecorationImage(
            alignment: Alignment(0, -0.3),
            image: AssetImage("assets/images/diet.png"),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: RotationTransition(
          turns: new AlwaysStoppedAnimation(-5 / 360),
          child: Text("Build your desired\nbody without\nwasting\ntime ", style: GoogleFonts.architectsDaughter(textStyle:
          TextStyle(fontWeight: FontWeight.w600, fontSize: 28, color: Hexcolor("#69320A").withOpacity(0.8))
          ),),
        )
    );
  }

  ListView inside(double pageHeight, User user){
    return ListView(
      children: [
        Container(
          //height: pageHeight,
          width: MediaQuery.of(context).size.width,
          //padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          color: Colors.white,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 10, right: 10,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){_showProfile(context, user);},
                        child: CircleAvatar(backgroundColor: Colors.black, backgroundImage: CachedNetworkImageProvider(user.url),maxRadius: 15,)),
                    Container(
                      height:25,
                      alignment: Alignment.centerRight,
                      width: 25,
                      //color: Colors.black,
                      child: getNotification(),),
                  ],
                ),
              ),
              SizedBox(height: 15,),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 10, right: 10, top: 5),
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Good Morning", style: GoogleFonts.poppins(textStyle:
                    TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.black)
                    ),),
                    Text(user.profileName, style: GoogleFonts.poppins(textStyle:
                    TextStyle(fontWeight: FontWeight.w700, fontSize: 23, color: Colors.orangeAccent)
                    ),),
                  ],
                ),
              ),
              SizedBox(height: 5,),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                width: MediaQuery.of(context).size.width,
                height: 110,
                padding: EdgeInsets.only(top: 10, bottom: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Hexcolor("#FF9900"),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orangeAccent.withOpacity(0.9),
                      offset: Offset(-2.0,3.0),
                      blurRadius: 20,
                      spreadRadius: -8,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 70,
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          //alignment: Alignment(0, -3),
                          image: AssetImage("assets/images/healthy.png"),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (calories == 0.0 ) Text("Welcome to \nMealLy",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white)
                          ),),
                        if (calories != 0.0 ) Text("$calories kcal\nRemaining",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white)
                          ),),
                        if (calories == 0.0 ) Text("Start make your plan now!",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Colors.white)
                          ),),
                        if (calories != 0.0 ) Text("800/2000 of Calories Consumed",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Colors.white)
                          ),),
                        Container(
                          margin: EdgeInsets.only(top: 3),
                          width: 160,
                          height: 8,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: LinearProgressIndicator(
                              value: 0.7,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                              backgroundColor: Color(0xffD6D6D6),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15,),
              todaysPlan(),
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Hexcolor("#FF9900"),
                  //color: Hexcolor("#181716"),
                  //color: Colors.white,
                  image: DecorationImage(
                    alignment: Alignment(-1, 0),
                    image: AssetImage("assets/images/bg.png"),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.2),
                      offset: Offset(-2.0,3.0),
                      blurRadius: 20,
                      spreadRadius: -8,
                    ),
                  ],
                  //border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 15, right: 15),
                padding: EdgeInsets.only(left: 15, right: 10,top: 10, bottom: 10),
                width: MediaQuery.of(context).size.width,
                child: retrieveNextMeals(),
              ),
              SizedBox(height: 15,),
              /*
              Container(
                height: 120,
                margin: EdgeInsets.only(left: 15, right: 15),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Hexcolor("#181716"),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              SizedBox(height: 15,),
               */
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  weightTrackWidget(user),
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
                        Text(user.tdee.toString(),
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
              ),
              SizedBox(height: 15,),
              Container(
                height: 220,
                margin: EdgeInsets.only(left: 15, right: 15),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black12, width: 2.5),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      height: 30,
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Active orders",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600, fontSize: 14)
                            ),),
                          Text("see all",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600, fontSize: 14)
                            ),),
                        ],
                      ),
                    ),
                    Expanded(
                      child: activeOrder(),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  weightTrackWidget(User user){
    int weightProg = (user.weight - user.initialWeight).round();
    int weight;
    if(weightProg<0){
      weight = weightProg*-1;
    }
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProgressPage(userProfileId: currentUser.id, gCurrentUser: currentUser,)));
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
                if (weightProg>0) Icon(Icons.arrow_upward_rounded, color: Colors.blue,),
                if (weightProg<0) Icon(Icons.arrow_downward_rounded, color: Colors.red,),
                Text(weight.toString(),
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 55, height: 1.3,)
                  ),),
                Text(" Kg",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15, height: 4.1,)
                  ),),
              ],
            ),
            Text("From " + user.initialWeight.toString() + "kg to " +   user.weight.toString() + "kg",
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 11, height: 0.8 )
              ),),
          ],
        ),
      ),
    );
  }

  getNotification(){
    return StreamBuilder(
      stream: CustActivityFeedReference.document(widget.userProfileId)
          .collection("activityItems").orderBy("timestamp", descending: true).snapshots(),
      builder:  (context, dataSnapshot){
        if(!dataSnapshot.hasData){
          return circularProgress(Colors.orangeAccent);
        }
        List<NotificationsItem> notification = [];
        dataSnapshot.data.documents.forEach((document){
          notification.add(NotificationsItem.fromDocument(document));
        });
        if(notification.isEmpty){
          return GestureDetector(
            onTap: (){_successModal(context);},
            child: Transform.rotate(
              angle: 25 * pi / 180,
              child: Icon(
                Icons.notifications_none_outlined, size: 25,
                color: Colors.black,
              ),
            ),
          );
        }else{
          return GestureDetector(
            onTap: (){_successModal(context);},
            child: Transform.rotate(
              angle: 25 * pi / 180,
              child: Icon(
                Icons.notification_important_outlined, size: 25,
                color: Colors.red,
              ),
            )
          );
        }
      },
    );
  }

  void _successModal(context){
    List<bool> isSelected = [false, false, false];
    showModalBottomSheet(
        context: context, isScrollControlled:true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (BuildContext bc){
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState){
                return Container(
                    height: MediaQuery.of(context).size.height/2,
                    alignment: Alignment.center,
                    //padding: EdgeInsets.only(left: 30, right: 30, top: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      //borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    ),
                    child: Scaffold(
                        body: Container(
                          height: MediaQuery.of(context).size.height/2,
                          width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 100,
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Notification",
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 23)
                                      ),),
                                    Transform.rotate(
                                      angle: 25 * pi / 180,
                                      child: Icon(
                                        Icons.notifications_none_outlined,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: StreamBuilder(
                                  stream: CustActivityFeedReference.document(widget.userProfileId)
                                      .collection("activityItems").orderBy("timestamp", descending: true).snapshots(),
                                  builder:  (context, dataSnapshot){
                                    if(!dataSnapshot.hasData){
                                      return circularProgress(Colors.orangeAccent);
                                    }
                                    String stats;
                                    List<NotificationsItem> notification = [];
                                    dataSnapshot.data.documents.forEach((document){
                                      notification.add(NotificationsItem.fromDocument(document));
                                    });
                                    if(notification.isEmpty){
                                      return Center(
                                        child: Text("No notification"),
                                      );
                                    }else{
                                      return ListView.builder(
                                        itemCount: notification.length,
                                        itemBuilder: (BuildContext context, int index){
                                          if(notification[index].status==0){
                                            stats = "Unprepared";
                                          }else if(notification[index].status==1){
                                            stats = "Preparing";
                                          }else if(notification[index].status==2){
                                            stats = "Cooking";
                                          }else if(notification[index].status==3){
                                            stats = "Delivering";
                                          }else {
                                            stats = "Delivered";
                                          }
                                          return Container(
                                            padding: EdgeInsets.only(top: 5, right: 5),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(notification[index].mealName + " status changed to "+ stats,
                                                  style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600, fontSize: 12)
                                                  ),),
                                                Divider(thickness: 1,)
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          )
                        )
                    )
                );
              });
        });
  }

  void _showProfile(context, User user){
    List<bool> isSelected = [false, false, false];
    showModalBottomSheet(
        context: context, isScrollControlled:true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (BuildContext bc){
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState){
                return Container(
                    height: MediaQuery.of(context).size.height-170,
                    alignment: Alignment.center,
                    //padding: EdgeInsets.only(left: 30, right: 30, top: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      //borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    ),
                    child: Scaffold(
                        body: Stack(
                          children: [
                            Container(
                              height: 140,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  //alignment: Alignment(-1, 0),
                                  image: AssetImage("assets/images/bg.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height-340,
                              margin: EdgeInsets.only(top: 110),
                              padding: EdgeInsets.only(left: 25, right: 25, top: 80),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: Colors.white
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(user.profileName,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600, fontSize: 18)
                                    ),),
                                  Text(user.email,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600, fontSize: 12)
                                    ),),
                                  Container(
                                    height: 80,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30.0),
                                        color: Colors.blue
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(user.weight.toString(),
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 24)
                                              ),),
                                            Text("weight",
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12)
                                              ),),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(user.tdee.toString(),
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 24)
                                              ),),
                                            Text("TDEE",
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12)
                                              ),),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("age", style: GoogleFonts.poppins(textStyle:
                                      TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                                      Text(user.age.toString(), style: GoogleFonts.poppins(textStyle:
                                      TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w600),),),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("bodyfat", style: GoogleFonts.poppins(textStyle:
                                      TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                                      Text(user.bodyfat.toString(), style: GoogleFonts.poppins(textStyle:
                                      TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w600),),),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("lbm", style: GoogleFonts.poppins(textStyle:
                                      TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                                      Text(user.lbm.toString(), style: GoogleFonts.poppins(textStyle:
                                      TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w600),),),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("phone no.", style: GoogleFonts.poppins(textStyle:
                                      TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                                      Text(user.phoneNo.toString(), style: GoogleFonts.poppins(textStyle:
                                      TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w600),),),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("address", style: GoogleFonts.poppins(textStyle:
                                      TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                                      Container(
                                        width: MediaQuery.of(context).size.width-160,
                                        height: 90,
                                        child: Text(user.location.toString(), textAlign: TextAlign.right, style: GoogleFonts.poppins(textStyle:
                                        TextStyle(fontSize: 11.0, color: Colors.black, fontWeight: FontWeight.w600),),),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 70),
                                height: 85,
                                alignment: Alignment.center,
                                child: CircleAvatar(backgroundColor: Colors.black, backgroundImage: CachedNetworkImageProvider(user.url),maxRadius: 35,)),
                          ],
                        ),
                      bottomSheet: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child:
                        FlatButton(
                          onPressed: (){
                          },
                          //color: Hexcolor("#FF9900"),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 45.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              image: DecorationImage(
                                image: AssetImage("assets/images/bg.png"),
                                fit: BoxFit.fitWidth,
                              ),

                            ),
                            child:
                            Text("Edit Profile" ,textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)
                              ),),
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                    )
                );
              });
        });
  }

  todaysPlan(){
    return Container(
      //color: Colors.blue,
      //padding: EdgeInsets.only(left: 25, right: 25,top: 15),
      height: 200,
      width: MediaQuery.of(context).size.width,
      //color: Colors.blue,
      child: Stack(
        children: [
          Container(
            height: 190,
            margin: EdgeInsets.only(left: 18, right: 18),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.black12, width: 1.5),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 40, right: 40,top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Today's Menu",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 15)
                  ),),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MyPlanPage(gCurrentUser: currentUser, userProfileId: currentUser.id)));
                    },
                  child: Container(
                    width: 70,
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
          ),
          Positioned(
            top: 55,
            child: Container(
              height: 110,
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width-20,
              //color: Colors.red,
              child: retrieveOrder(),
            ),
          )
        ],
      )
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCalories();

  }

  getCalories() async{
    QuerySnapshot querySnapshot =  await custOrdersReference.document(userProfileId).collection("custOrder")
        .where("datetime", isGreaterThanOrEqualTo: DateTime(now.year, now.month, now.day),
        isLessThan: DateTime(now.year, now.month, now.day+ 1)).getDocuments();
    var newList = querySnapshot.documents.map((document) => OrdersItem.fromDocument(document, userProfileId)).toList();
    for (int i = 0; i < newList.length; i++) {
      calories += newList[i].calories;
    }
    return calories;
  }
/*
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


 */

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
          return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("No Meals Available", textAlign: TextAlign.center,),
                  SizedBox(height: 20,),
                  Container(
                    height: 40,
                    width:180,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/bg.png"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: Text("Create New Plan",textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)
                      ),),
                  )
                ],
              )
          );
        }
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: comments.length,
          itemBuilder: (BuildContext context, int index){
            print(comments.length);
            if(index < comments.length -1 ){
              return Container(
                margin: EdgeInsets.only(left: 5, right: 5),
                //height: 140,
                width: 130,
                //color: Colors.blue,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0.0,3.0),
                      blurRadius: 30,
                      spreadRadius: -8,
                    ),
                  ],
                  image: DecorationImage(
                    image: NetworkImage(comments[index].url),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  //border: Border.all(color: Colors.black12),
                ),
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors:[
                          Hexcolor("#616161").withOpacity(0.2),
                          Hexcolor("#000000").withOpacity(0.4)
                        ],
                        stops: [0.2, 1],
                        begin: Alignment.topRight,
                      )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(comments[index].mealName,textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 11)
                        ),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.flash_on_rounded, color: Colors.white,size: 10,),
                          Text("600",textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 10)
                            ),),
                          SizedBox(width: 42),
                          Container(
                            padding: EdgeInsets.only(left: 3, right: 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.blue, width: 2),
                            ),
                            child: Text(intl.DateFormat.Hm().format(comments[index].datetime.toDate()), style: GoogleFonts.poppins(textStyle:
                            TextStyle(fontSize: 10.0, color: Colors.white, fontWeight: FontWeight.w500),),),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }else{
              return Container(
                margin: EdgeInsets.only(left: 5, right: 35),
                //height: 140,
                width: 130,
                //color: Colors.blue,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0.0,3.0),
                      blurRadius: 30,
                      spreadRadius: -8,
                    ),
                  ],
                  image: DecorationImage(
                    image: NetworkImage(comments[index].url),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  //border: Border.all(color: Colors.black12),
                ),
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors:[
                          Hexcolor("#616161").withOpacity(0.2),
                          Hexcolor("#000000").withOpacity(0.4)
                        ],
                        stops: [0.2, 1],
                        begin: Alignment.topRight,
                      )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(comments[index].mealName,textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 11)
                        ),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.flash_on_rounded, color: Colors.white,size: 10,),
                          Text("600",textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 10)
                            ),),
                          SizedBox(width: 42),
                          Container(
                            padding: EdgeInsets.only(left: 3, right: 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.blue, width: 2),
                            ),
                            child: Text(intl.DateFormat.Hm().format(comments[index].datetime.toDate()), style: GoogleFonts.poppins(textStyle:
                            TextStyle(fontSize: 10.0, color: Colors.white, fontWeight: FontWeight.w500),),),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  retrieveNextMeals(){
    return StreamBuilder(
      stream: custOrdersReference.document(userProfileId).collection("custOrder")
     .where("datetime", isGreaterThanOrEqualTo: DateTime(now.year, now.month, now.day, now.hour, now.minute),
          isLessThan: DateTime(now.year, now.month, now.day+ 1))
          .limit(1).snapshots(),

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
                "No Delivery in this time", style: TextStyle(color: Colors.white),
            ),
          );
        }
        return ListView.builder(
          itemCount: comments.length,
          itemBuilder: (BuildContext context, int index){
            return Container(
              height: 120,
              //color: Colors.blue,
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Next Delivery",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Colors.white)
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(13),
                          image: DecorationImage(
                            image: NetworkImage(comments[index].url),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Text("Next Delivery:\n"+comments[index].mealName,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Colors.white)
                        ),
                      ),
                      SizedBox(width: 130,),
                      Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 15,)
                    ],
                  ),
                  SizedBox(height: 3,),
                  Divider(color: Colors.white,),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.white, size: 12,),
                      SizedBox(width: 5,),
                      Text(intl.DateFormat.Hm().format(comments[index].datetime.toDate()), style: GoogleFonts.poppins(textStyle:
                      TextStyle(fontSize: 11.0, color: Colors.white, fontWeight: FontWeight.w500),),)
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  activeOrder(){
    return StreamBuilder(
      stream: custOrdersReference.document(userProfileId).collection("custOrder").where("status", isLessThan: 4).orderBy("status", descending: false).snapshots(),
      builder: (context, dataSnapshot){
        if(!dataSnapshot.hasData){
          return circularProgress(Colors.orangeAccent);
        }
        List<OrdersItem> comments = [];
        dataSnapshot.data.documents.forEach((document){
          comments.add(OrdersItem.fromDocument(document, userProfileId));
        });
        if(comments.isEmpty){
          return Center(child: Text("No Data Available"));
        }
        return ListView(
          children: comments,
        );
      },
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
  final double calories;
  final String custId;
  final String orderId;
  final String userProfileImg;
  final String url;
  final String userProfileId;
  OrdersItem({
    this.url,
    this.status,
    this.userProfileImg,
    this.datetime,
    this.calories,
    this.custId,
    this.location,
    this.mealName, this.mealId, this.userProfileId, this.orderId});

  factory OrdersItem.fromDocument(DocumentSnapshot documentSnapshot, String userProfileId){
    return OrdersItem(
      custId: documentSnapshot["custId"],
      url: documentSnapshot["url"],
      userProfileImg: documentSnapshot["userProfileImg"],
      datetime: documentSnapshot["datetime"],
      status: documentSnapshot["status"],
      location: documentSnapshot["location"],
      mealName: documentSnapshot["mealName"],
      calories: documentSnapshot["calories"],
      mealId: documentSnapshot["mealId"],
      orderId: documentSnapshot["orderId"],
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
            onTap: (){displayDetails(context, userProfileId);},
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  //top: BorderSide(width: 2.0, color: Hexcolor("#9D9D9D")),
                  bottom: BorderSide(width: 1.0, color: Hexcolor("#E8E8E8")),
                ),
                color: Colors.white,
              ),
              child: ListTile(
                //leading: CircleAvatar(backgroundImage: CachedNetworkImageProvider(userProfileImg)),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(datetime.toDate().toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,color: Colors.black54),),
                      Text(mealName , style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400,color: Colors.black54),),
                      Text("Status : $stats", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400,
                          color: status == 0 ? Colors.red:Colors.black54),),
                    ],
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_rounded, size: 15,)
              ),
            )
        )
    );
  }

  displayDetails(context, userProfileId){
    Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailsPage(userProfileId: userProfileId, orderId: orderId)));
  }

}
/*
class NotificationsItem extends StatelessWidget {
  final String CustomerName;
  final String type;
  final String commentData;
  final datetime;
  final String location;
  final String mealName;
  final String mealId;
  final String userId;
  final rating;
  final String userProfileImg;
  final String url;
  final Timestamp timestamp;
  NotificationsItem({
    this.timestamp,
    this.url,
    this.CustomerName,
    this.mealId, this.userId,
    this.commentData, this.type,
    this.userProfileImg,
    this.rating, this.datetime,
    this.location, this.mealName});

  factory NotificationsItem.fromDocument(DocumentSnapshot documentSnapshot){
    return NotificationsItem(
      CustomerName: documentSnapshot["CustomerName"],
      type: documentSnapshot["type"],
      commentData: documentSnapshot["commentData"],
      mealId: documentSnapshot["mealId"],
      userId: documentSnapshot["userId"],
      rating: documentSnapshot["rating"],
      userProfileImg: documentSnapshot["userProfileImg"],
      url: documentSnapshot["url"],
      timestamp: documentSnapshot["timestamp"],
      datetime: documentSnapshot["datetime"],
      location: documentSnapshot["location"],
      mealName: documentSnapshot["mealName"],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text("");
  }

}

 */
