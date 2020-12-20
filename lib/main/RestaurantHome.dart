import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meally2/CreateAccountPage.dart';
import 'package:meally2/main/CreateRestaurantAcc.dart';
import 'package:meally2/main/MainPage.dart';
import 'package:meally2/main/NotificationPage.dart';
import 'package:meally2/main/ProfilePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:meally2/models/restaurant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meally2/models/restaurantMenu.dart';
import 'package:meally2/models/restaurantProfile.dart';
import 'package:meally2/restaurant/restaurantMain.dart';
import 'package:meally2/widgets/bubble_bottom_bar.dart';

final GoogleSignIn gSignIn = GoogleSignIn();
final restReference = Firestore.instance.collection("restaurant");
final StorageReference storageReference = FirebaseStorage.instance.ref().child("mealList");
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
  int getPageIndex = 0;

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
      final input = await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateRestaurantAcc()));

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
      });
      documentSnapshot = await restReference.document(gCurrentRest.id).get();
    }
    currentRest = Restaurant.fromDocument(documentSnapshot);
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
          restaurantMain(),
          restaurantMenu(userRestId: currentRest.id, gCurrentRest: currentRest,),
          NotificationPage(),
          restaurantProfile(userRestId: currentRest.id, gCurrentRest: currentRest, restOnline: true),
          FlatButton(
            onPressed: (){
              logOutRest();
            },
            color: Hexcolor("#FF9900"),
            child: Container(
              width: MediaQuery.of(context).size.width/2,
              height: 40.0,
              child: Text("SignOut",textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)
                ),),
              alignment: Alignment.center,
            ),
          ),
          //OrderPage(gCurrentUser: currentUser,),
          //TrackerPage(gCurrentUser: currentUser,),
          //ProgressPage(userProfileId: currentUser.id, gCurrentUser: currentUser,),
          //ProfilePage(userProfileId: currentRest.id, gCurrentUser: currentRest,),
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
                Icons.chrome_reader_mode,
                color: Hexcolor("#FF9900"),
              ),
              activeIcon: Icon(
                Icons.chrome_reader_mode,
                color: Colors.white,
              ),
              title: Text("Menu")),
          BubbleBottomBarItem(
              backgroundColor: Colors.white,
              icon: Icon(
                Icons.notifications,
                color: Hexcolor("#FF9900"),
              ),
              activeIcon: Icon(
                Icons.notifications,
                color: Colors.white,
              ),
              title: Text("Notification")),
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
