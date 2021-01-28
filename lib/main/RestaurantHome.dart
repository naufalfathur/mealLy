import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meally2/CreateAccountPage.dart';
import 'package:meally2/main/CreateRestaurantAcc.dart';
import 'package:meally2/main/MainPage.dart';
import 'package:meally2/main/NotificationPage.dart';
import 'package:meally2/main/OrderPage.dart';
import 'package:meally2/main/ProfilePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:meally2/models/restaurant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meally2/models/restaurantMenu.dart';
import 'package:meally2/models/restaurantProfile.dart';
import 'package:meally2/restaurant/restaurantMain.dart';
import 'package:meally2/widgets/ProgressWidget.dart';
import 'package:meally2/widgets/bubble_bottom_bar.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

final GoogleSignIn gSignIn = GoogleSignIn();
final restReference = Firestore.instance.collection("restaurant");
final StorageReference storageReference = FirebaseStorage.instance.ref().child("mealList");
final StorageReference certReference = FirebaseStorage.instance.ref().child("certificate");
final mealsReference = Firestore.instance.collection("meals");
final activityFeedReference = Firestore.instance.collection("activity");
final DateTime timestamp = DateTime.now();
Restaurant currentRest;

class RestaurantHome extends StatefulWidget {
  @override
  _RestaurantHomeState createState() => _RestaurantHomeState();
}

class _RestaurantHomeState extends State<RestaurantHome> {
  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();
  bool isSignedIn = false;
  PageController pageController;
  int getPageIndex = 1;
  double height = 0.0;

  logInRest(){
    gSignIn.signIn();
  }
  logOutRest(){
    gSignIn.signOut();
  }
  controlSignIn(GoogleSignInAccount signInAccount) async {
    if(signInAccount != null){
      await saveRestInfoFirestore();
      setState(() {
        isSignedIn = true;
      });
    }else{
      setState(() {
        isSignedIn = false;
      });
    }
  }
  saveRestInfoFirestore() async {
    final GoogleSignInAccount gCurrentRest = gSignIn.currentUser;
    DocumentSnapshot documentSnapshot = await restReference.document(gCurrentRest.id).get();

    if(!documentSnapshot.exists){
      final input = await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateRestaurantAcc(userRestId: gCurrentRest.id,)));

      restReference.document(gCurrentRest.id).setData({
        "id": gCurrentRest.id,
        "RestaurantName" : input[0],
        "url" : gCurrentRest.photoUrl,
        "email" : gCurrentRest.email,
        "postcode": input[1],
        "city": input[2],
        "accreditation" : input[3],
        "location": input[4],
        "PICName": input[5],
        "PICNo":input[6],
        "PICPosition": input[7],
        "cuisine": input[8],
        "certificate" : input[9],
        "earnings":0.0,
      });
      documentSnapshot = await restReference.document(gCurrentRest.id).get();
    }
    currentRest = Restaurant.fromDocument(documentSnapshot);
  }
  void initState(){
    super.initState();

    pageController =  PageController(initialPage: 1);

    gSignIn.onCurrentUserChanged.listen((gSignInAccount) {
      controlSignIn(gSignInAccount);
    }, onError: (gError){
      print("Error Message: " + gError);
    });

    gSignIn.signInSilently(suppressErrors: false).then((gSignInAccount) {
      controlSignIn(gSignInAccount);
    }).catchError((gError){
      print("Error Message: " + gError.toString());
    });
  }
  void dispose(){
    pageController.dispose();
    super.dispose();
  }
  onTapChangePage(int pageIndex){
    pageController.jumpToPage(pageIndex);
  }
  whenPageChanges(int pageIndex){
    setState(() {
      this.getPageIndex = pageIndex;
    });
  }


  Scaffold BuildHomeScreen(){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 80,
        automaticallyImplyLeading: false,
        /*
        leading: GestureDetector(
          onTap: (){
            seeOrders();
            print(orders);
          },
          child: Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                //border: Border.all(color: Colors.blue.withOpacity(0.5), width: 5),
                color: orders? Colors.grey : Colors.white,
                shape: BoxShape.circle
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today_rounded),
                Text("Orders",textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 10)
                  ),),
              ],
            ),
          ),
        ),

         */
        toolbarHeight: 80,
        //centerTitle: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("EatNEat",textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 13)
              ),),
            if (getPageIndex ==  0 ) Text("Restaurant Schedule",textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16)
              ),),
            if (getPageIndex ==  1 ) Text("Restaurant Home",textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16)
              ),),
            if (getPageIndex ==  2 ) Text("Restaurant Meals",textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16)
              ),),
            if (getPageIndex ==  3 ) Text("Restaurant Profile",textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16)
              ),),
          ],
        ),
        actions: [
          FlatButton(
            onPressed: (){
              _successModal(context);
            },
            child: Container(
              width: 60,
              margin: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Icon(Icons.notifications_none_outlined),
                  Container(
                    height: 25,
                    width: 25,
                    child : StreamBuilder(
                      stream: activityFeedReference.document(currentRest.id)
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
                          return  Transform.rotate(
                            angle: 25 * pi / 180,
                            child: Icon(
                              Icons.notifications_none_outlined,
                              color: Colors.black,
                            ),
                          );
                        }else{
                          return  Transform.rotate(
                            angle: 25 * pi / 180,
                            child: Icon(
                              Icons.notifications_active_outlined ,
                              color: Colors.red,
                            ),
                          );
                        }
                      },
                    )
                  ),
                  Text("Notification",textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 10)
                    ),),
                ],
              ),
            ),
          ),
          //SizedBox(width: 13,)
        ],

      ),
      body: Column(
        children: [
          /*
          Container(
            margin: EdgeInsets.only(bottom: 5),
            height: 30,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: getNewNotification(),
          ),

           */
          Expanded(
            child: PageView(
              children: <Widget>[
                OrderPage(userRestId: currentRest.id, gCurrentRest: currentRest,),
                restaurantMain(userRestId: currentRest.id, gCurrentRest: currentRest,),
                //NotificationPage(),
                restaurantMenu(userRestId: currentRest.id, gCurrentRest: currentRest,),
                restaurantProfile(userRestId: currentRest.id, gCurrentRest: currentRest, restOnline: true),
                //OrderPage(gCurrentUser: currentUser,),
                //TrackerPage(gCurrentUser: currentUser,),
                //ProgressPage(userProfileId: currentUser.id, gCurrentUser: currentUser,),
                //ProfilePage(userProfileId: currentRest.id, gCurrentUser: currentRest,),
              ],
              controller: pageController,
              onPageChanged: whenPageChanges,
              physics: NeverScrollableScrollPhysics(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(left: 25, right: 25),
        //color: Colors.black,
        child: SalomonBottomBar(
          currentIndex: getPageIndex,
          //backgroundColor: Colors.orangeAccent,
          onTap: onTapChangePage,
          items: [
            SalomonBottomBarItem(
                icon: Icon(
                  Icons.calendar_today_rounded,
                  color: getPageIndex == 0 ? Hexcolor("#FF9900") : Hexcolor("#3C3C3C"),
                ),
                //unselectedColor: Hexcolor("#3C3C3C"),
                selectedColor: Hexcolor("#FF9900"),
                title: Text("Schedule")),
            SalomonBottomBarItem(
                icon: Icon(
                  Icons.home,
                  color: getPageIndex == 1 ? Hexcolor("#FF9900") : Hexcolor("#3C3C3C"),
                ),
                selectedColor: Hexcolor("#FF9900"),
                title: Text("Home")),
            SalomonBottomBarItem(
                icon: Icon(
                  Icons.list_alt_rounded,
                  color: getPageIndex == 2 ? Hexcolor("#FF9900") : Hexcolor("#3C3C3C"),
                ),
                selectedColor: Hexcolor("#FF9900"),
                title: Text("Meals")),
            SalomonBottomBarItem(
                icon: Icon(
                  Icons.account_circle,
                  color: getPageIndex == 3 ? Hexcolor("#FF9900") : Hexcolor("#3C3C3C"),
                ),
                selectedColor: Hexcolor("#FF9900"),
                title: Text("Profile")),
          ],
        ),
      ),
    );
  }
  
  getNewNotification(){
    String notificationItemText;
    return StreamBuilder(
      stream: activityFeedReference.document(currentRest.id)
          .collection("activityItems").limit(1).orderBy("timestamp", descending: true).snapshots(),
      builder:  (context, dataSnapshot){
        if(!dataSnapshot.hasData){
          return circularProgress(Colors.orangeAccent);
        }
        List<NotificationsItem> notification = [];
        dataSnapshot.data.documents.forEach((document){
          notification.add(NotificationsItem.fromDocument(document));
        });
        if(notification.isEmpty){
          return Container(
            height: 30,
          );
        }else{
          return ListView.builder(
            itemCount: notification.length,
            itemBuilder: (BuildContext context, int index){
              if(notification[index].type == "comment"){
                return Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  alignment: Alignment.centerLeft,
                  height: 30,
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(notification[index].CustomerName + " just sent a review",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13)
                        ),),
                      /*
                      GestureDetector(
                          onTap: (){},
                          child: Icon(Icons.close_rounded, color: Colors.white, size: 20,)
                      ),

                       */
                    ],
                  ),
                );
              }else{
                return Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  alignment: Alignment.centerLeft,
                  height: 30,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/bg.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(notification[index].CustomerName + " just made some order", overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13)
                        ),),
                      /*
                      GestureDetector(
                          onTap: (){},
                          child: Icon(Icons.close_rounded, color: Colors.white, size: 20,)
                      ),

                       */
                    ],
                  ),
                );
              }

            },
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
                    height: MediaQuery.of(context).size.height-170,
                    alignment: Alignment.center,
                    //padding: EdgeInsets.only(left: 30, right: 30, top: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      //borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    ),
                    child: Scaffold(
                        body: PageView(
                          children: [
                            NotificationPage(),
                          ],
                        )
                    )
                );
              });
        });
  }

  Scaffold BuildSignInScreen(){
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 80),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Text("Sign In Resto!",textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 25)
              ),),
            Container(
              margin: EdgeInsets.only(top: 10),
              height: 5,
              color: Hexcolor("#FF9900"),
              width: 120,
            ),
            Container(
              margin: EdgeInsets.only(top: 120),
              //height: (MediaQuery.of(context).size.height/2),
              //color: Hexcolor("#FF9900"),
              width: (MediaQuery.of(context).size.width/2)+80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Welcome to MealLy",textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 20)
                    ),),
                  Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit",textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12)
                    ),),
                ],
              ),
            ),
            SizedBox(height: 40,),
            GestureDetector(
              onTap: logInRest,
              child: Container(
                height: 60,
                width: 270.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0.0,3.0),
                      blurRadius: 30,
                      spreadRadius: -8,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                //color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 30,
                      padding: EdgeInsets.only(right: 10),
                      child: Image(
                        image: AssetImage("assets/images/google.png"),
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    Text("Sign in with Google",
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black)
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: ()=> print("aa"),
              child: Container(
                height: 60,
                width: 270.0,
                decoration: BoxDecoration(
                  color: Hexcolor("#FF9900"),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0.0,3.0),
                      blurRadius: 30,
                      spreadRadius: -8,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                //color: Colors.black,
                child: Container(
                    alignment: Alignment.center,
                    child: Text("Sign as Restaurant",
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.white)
                      ),
                    )
                ),
              ),
            ),
            SizedBox(height: 100,),
            Text("m.",textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.w700, fontSize: 22)
              ),),

          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    if(isSignedIn){
      return BuildHomeScreen();
    }else{
      return BuildSignInScreen();//BuildSignInScreen();
    }
  }
}
