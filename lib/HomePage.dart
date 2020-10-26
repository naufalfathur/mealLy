import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meally2/CreateAccountPage.dart';
import 'package:meally2/main/MainPage.dart';
import 'package:meally2/main/OrderPage.dart';
import 'package:meally2/main/ProfilePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:meally2/main/ProgressPage.dart';
import 'package:meally2/main/TrackerPage.dart';
import 'package:meally2/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meally2/widgets/bubble_bottom_bar.dart';

final GoogleSignIn gSignIn = GoogleSignIn();
final userReference = Firestore.instance.collection("users");
final StorageReference storageReference= FirebaseStorage.instance.ref().child("WeightTrack");
final TrackerReference = Firestore.instance.collection("tracker");
final DateTime timestamp = DateTime.now();
User currentUser;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          MainPage(),
          //OrderPage(gCurrentUser: currentUser,),
          //TrackerPage(gCurrentUser: currentUser,),
          ProgressPage(userProfileId: currentUser.id, gCurrentUser: currentUser,),
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
                Icons.history,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "MealLy",
              style: TextStyle(fontSize: 92.0, color: Colors.black45, fontFamily: "Signatra"),
            ),
            Text(
              "Personalized Meal Planning and Ordering Service",
              style: TextStyle(fontSize: 12.0, color: Colors.black45),
            ),
            GestureDetector(
              onTap: logInUser,
              child: Container(
                width: 270.0,
                height: 65.0,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/google_signin_button.png"),
                      fit: BoxFit.cover,
                    )
                ),
              ),
            )
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
      return BuildSignInScreen();
    }
  }
}
