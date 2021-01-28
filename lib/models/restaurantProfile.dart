import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meally2/HomePage.dart' as homePage;
import 'package:meally2/main/RestaurantHome.dart';
import 'package:meally2/models/restaurant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meally2/HomePage.dart' as homePage;
import 'package:meally2/widgets/ProgressWidget.dart';
import 'package:meally2/widgets/RestaurantPostTile.dart';
import 'package:meally2/widgets/RestaurantPostWidget.dart';

class restaurantProfile extends StatefulWidget {
  final String userRestId;
  final Restaurant gCurrentRest;
  final String restaurantName;
  final bool restOnline;

  restaurantProfile({this.userRestId, this.gCurrentRest, this.restaurantName, this.restOnline});
  @override
  _restaurantProfileState createState() => _restaurantProfileState(restOnline);
}

class _restaurantProfileState extends State<restaurantProfile> {
  final bool restOnline;

  _restaurantProfileState(this.restOnline);
  //final String currentOnlineUserId = homePage.currentUser.profileName;
  String currentOnlineId;
  bool loading = false;
  int countPost = 0;
  bool block;
  List<Post> postlist = [];
  String postOrientation = "list";

  void initState(){
    getAllProfilePost();
    checkWhoseOnline2();
    CheckIfAlreadyFollowing();
  }

  checkWhoseOnline2(){
    if(restOnline){
      setState(() {
        currentOnlineId = currentRest.id;
        print(currentOnlineId);
      });
      //print("this is rest");
    }else{
      setState(() {
        currentOnlineId = homePage.currentUser.id;
        print(currentOnlineId);
      });
      //print("this is not rest");
    }
  }

  CheckIfAlreadyFollowing() async{
    DocumentSnapshot documentSnapshot = await homePage.followersReference
        .document(widget.userRestId).collection("userFollowers")
        .document(currentOnlineId).get();
    setState(() {
      block = !documentSnapshot.exists;
    });
  }


  logOutUser() async {
    await gSignIn.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context)=> RestaurantHome()));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: restReference.document(widget.userRestId).get(),
        builder: (context, dataSnapshot) {
          if (!dataSnapshot.hasData) {
            return circularProgress(Colors.orangeAccent);
          }
          Restaurant restaurant = Restaurant.fromDocument(dataSnapshot.data);
          return Scaffold(
            body: ListView(
              children: <Widget>[
                profilePage(restaurant),
              ],
            ),
          );
        }
    );
  }

  Future<void> _showCert(Restaurant restaurant){
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Halal Certification'),
          content: SingleChildScrollView(
            child: Container(
             // height: MediaQuery.of(context).size.height/2,
              //width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                child: Image(
                  image: NetworkImage(restaurant.certificate),
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  profilePage(Restaurant restaurant){
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          alignment: Alignment.center,
          //margin: EdgeInsets.only( top: 60),
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/restaurant.jpg"),
                fit: BoxFit.cover,
              )
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors:[
                    Hexcolor("#616161").withOpacity(0.6),
                    Hexcolor("#000000").withOpacity(0.5)
                  ],
                  stops: [0.2, 1],
                  begin: Alignment.topRight,
                )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(restaurant.RestaurantName,textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 30)
                  ),),
                Text("★★★★★",textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)
                  ),),
              ],
            ),
          ),
        ),
        /*
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              alignment: Alignment.center,
              padding: EdgeInsets.only( top: 10),
              decoration: BoxDecoration(
                color: Hexcolor("#FF9900"),
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(35)),
              ),
              child: Text("Profile",textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 25)
                ),),
            ),

             */
        displayWidget(restaurant),
      ],
    );
  }

  displayWidget(Restaurant restaurant){
    if(restOnline){
      //print("this is rest");
      return menuBar(restaurant);
    }else{
      //print("this is not rest");
      return displayProfilePost();
    }
  }

  menuBar(Restaurant restaurant){
    return Container(
      //width: MediaQuery.of(context).size.width-50,
      height: 250,
      alignment: Alignment.center,
      margin: EdgeInsets.only( left: 30, right: 30, top: 20),
      padding: EdgeInsets.only(left: 30, right: 30),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            onTap: (){
              _showCert(restaurant);
            },
            child: Row(
              children: [
                Icon(Icons.upload_file),
                SizedBox(width: 10,),
                Text("Halal Certification",textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)
                  ),),
                SizedBox(width: 10,),
                //Icon(Icons.error_outline,color: Colors.red,),
              ],
            ),
          ),
          Row(
            children: [
              Icon(Icons.history),
              SizedBox(width: 10,),
              Text("Order History",textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)
                ),),
            ],
          ),
          Row(
            children: [
              Icon(Icons.mode_edit),
              SizedBox(width: 10,),
              Text("Edit Profile",textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)
                ),),
            ],
          ),
          GestureDetector(
            onTap: logOutUser,
            child:
            Row(
              children: [
                Icon(Icons.logout),
                SizedBox(width: 10,),
                Text("Log Out",textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)
                  ),),
              ],
            ),
          ),
        ],
      ),
    );
  }

  blockButton(){
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: FlatButton(
        onPressed: (){
          if(block){
            setState(() {
              block = false;
            });
            homePage.followersReference.document(widget.userRestId)
                .collection("userFollowers")
                .document(currentOnlineId)
                .setData({});
            homePage.followingReference.document(currentOnlineId)
                .collection("userFollowing")
                .document(widget.userRestId)
                .setData({});
          }else{
            setState(() {
              block = true;
            });
            homePage.followersReference.document(widget.userRestId)
                .collection("userFollowers")
                .document(currentOnlineId).get()
                .then((document){
              if(document.exists){
                document.reference.delete();
              }
            });
            homePage.followingReference.document(currentOnlineId)
                .collection("userFollowing")
                .document(widget.userRestId).get()
                .then((document){
              if(document.exists){
                document.reference.delete();
              }
            });
          }
        },
        child: Container(
          width: 100.0,
          height: 30.0,
          child: Text(block? "unblock" : "block", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.red,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
      ),
    );
  }

  displayProfilePost(){
    if(loading){
      return circularProgress(Colors.orangeAccent);
    }else if(postlist.isEmpty){
      return Container(
        alignment: Alignment.center,
        //margin: EdgeInsets.only(top: 225),
        padding: EdgeInsets.only(top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //blockButton(),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Icon(Icons.photo_library, color: Colors.grey, size: 100,),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text("no meals", style: TextStyle(color: Colors.grey, fontSize: 30, fontWeight: FontWeight.bold),),
            )
          ],
        ),
      );
    }else if(block){
      return Container(
        alignment: Alignment.center,
        //margin: EdgeInsets.only(top: 225),
        padding: EdgeInsets.only(top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            blockButton(),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Icon(Icons.block, color: Colors.grey, size: 100,),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text("blocked", style: TextStyle(color: Colors.grey, fontSize: 30, fontWeight: FontWeight.bold),),
            )
          ],
        ),
      );
    }else if(!block){
      return Container(
        alignment: Alignment.center,
        //margin: EdgeInsets.only(top: 225),
        padding: EdgeInsets.only(top: 20),
        child:
        Column(
          children: [
            blockButton(),
            Column(children: postlist,)
          ],
        ),
      );
    }
  }

  getAllProfilePost() async{
    setState(() {
      loading = true;
    });

    QuerySnapshot querySnapshot = await mealsReference.document(widget.userRestId).collection("mealList").getDocuments();

    setState(() {
      loading = false;
      countPost = querySnapshot.documents.length;
      postlist = querySnapshot.documents.map((documentSnapshot) => Post.fromDocument(documentSnapshot, restOnline)).toList();
    });
  }

  setOrientation(String orientation){
    setState(() {
      this.postOrientation = orientation;
    });
  }
}
