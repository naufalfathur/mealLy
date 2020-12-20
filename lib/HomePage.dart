//import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meally2/CreateAccountPage.dart';
import 'package:meally2/main/MainPage.dart';
import 'package:meally2/main/NotificationPage.dart';
import 'package:meally2/main/ProfilePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:meally2/main/ProgressPage.dart';
import 'package:meally2/main/restaurantList.dart';
import 'package:meally2/models/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meally2/widgets/bubble_bottom_bar.dart';
import 'package:meally2/main/MenuPlanning.dart';

final GoogleSignIn gSignIn = GoogleSignIn();
final userReference = Firestore.instance.collection("users");
final StorageReference storageReference= FirebaseStorage.instance.ref().child("WeightTrack");
final TrackerReference = Firestore.instance.collection("tracker");
final followingReference = Firestore.instance.collection("following");
final followersReference = Firestore.instance.collection("followers");
final reviewsReference = Firestore.instance.collection("reviews");
final timelineReference = Firestore.instance.collection("timeline");
final DateTime timestamp = DateTime.now();
User currentUser;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();
  bool isSignedIn = false;
  PageController pageController;
  int getPageIndex = 0;

  logInUser(){
    gSignIn.signIn();
  }
  logOutUser(){
    gSignIn.signOut();
  }
  controlSignIn(GoogleSignInAccount signInAccount) async {
    if(signInAccount != null){
      await saveUserInfoFirestore();
      setState(() {
        isSignedIn = true;
      });
    }else{
      setState(() {
        isSignedIn = false;
      });
    }
  }
  saveUserInfoFirestore() async {
    final GoogleSignInAccount gCurrentUser = gSignIn.currentUser;
    DocumentSnapshot documentSnapshot = await userReference.document(gCurrentUser.id).get();

    if(!documentSnapshot.exists){
      final input = await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccountPage()));

      userReference.document(gCurrentUser.id).setData({
        "id": gCurrentUser.id,
        "profileName" : gCurrentUser.displayName,
        "url" : gCurrentUser.photoUrl,
        "email" : gCurrentUser.email,
        "gender": input[0],
        "age": input[1],
        "weight": input[2],
        "initialWeight" : input[2],
        "height": input[3],
        "bodyfat": input[4],
        "lbm":input[5],
        "tdee": input[6],
        "timestamp" : timestamp,
      });
      documentSnapshot = await userReference.document(gCurrentUser.id).get();
    }
    currentUser = User.fromDocument(documentSnapshot);
  }
  void initState(){
    super.initState();

    pageController =  PageController();

    gSignIn.onCurrentUserChanged.listen((gSignInAccount) {
      controlSignIn(gSignInAccount);
    }, onError: (gError){
      print("Error Message: " + gError);
    });

    gSignIn.signInSilently(suppressErrors: false).then((gSignInAccount) {
      controlSignIn(gSignInAccount);
    }).catchError((gError){
      print("Error Message: " + gError);
    });
  }
  void dispose(){
    pageController.dispose();
    super.dispose();
  }
  onTapChangePage(int pageIndex){
    pageController.animateToPage(pageIndex, duration: Duration(milliseconds: 400), curve: Curves.easeInSine);
  }
  whenPageChanges(int pageIndex){
    setState(() {
      this.getPageIndex = pageIndex;
    });
  }

  Scaffold BuildHomeScreen(){
    return Scaffold(
      body: PageView(
        children: <Widget>[
          //TimeLinePage(),
          MainPage(userProfileId: currentUser.id, gCurrentUser: currentUser,),
          MenuPlanning( userProfileId: currentUser.id),
          //OrderPage(gCurrentUser: currentUser,),
          //TrackerPage(gCurrentUser: currentUser,),
          //restaurantList(),
          ProgressPage(userProfileId: currentUser.id, gCurrentUser: currentUser,),
          //Container(child: Text("a"),),
          //NotificationPage(),
          ProfilePage(userProfileId: currentUser.id, gCurrentUser: currentUser,),
        ],
        controller: pageController,
        onPageChanged: whenPageChanges,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BubbleBottomBar(
        hasNotch: false,
        opacity: .15,
        currentIndex: getPageIndex,
        //backgroundColor: Colors.orangeAccent,
        onTap: onTapChangePage,
        borderRadius: BorderRadius.vertical(
          //top: Radius.circular(30),
          //bottom: Radius.circular(30),
        ),
        elevation: 8,
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: Colors.white,
              icon: Icon(
                Icons.dashboard,
                color: Hexcolor("#FF9900"),
              ),
              activeIcon: Icon(
                Icons.dashboard,
                color: Colors.white,
              ),
              title: Text("Home")),
          BubbleBottomBarItem(
              backgroundColor: Colors.white,
              icon: Icon(
                Icons.dashboard,
                color: Hexcolor("#FF9900"),
              ),
              activeIcon: Icon(
                Icons.dashboard,
                color: Colors.white,
              ),
              title: Text("Home")),
          BubbleBottomBarItem(
              backgroundColor: Colors.white,
              icon: Icon(
                Icons.access_time,
                color: Hexcolor("#FF9900"),
              ),
              activeIcon: Icon(
                Icons.access_time,
                color: Colors.white,
              ),
              title: Text("Order")),
          BubbleBottomBarItem(
              backgroundColor: Colors.white,
              icon: Icon(
                Icons.account_circle,
                color: Hexcolor("#FF9900"),
              ),
              activeIcon: Icon(
                Icons.account_circle,
                color: Colors.white,
              ),
              title: Text("Profile")),
        ],
      ),
    );
  }
  Scaffold BuildSignInScreen(){
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 80),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Text("Sign In",textAlign: TextAlign.center,
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
              onTap: logInUser,
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
