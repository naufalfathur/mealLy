import 'package:flutter/material.dart';
import 'package:meally2/EditProfilePage.dart';
import 'package:meally2/main/MyOrderPage.dart';
import 'package:meally2/main/TrackerPage.dart';
import 'package:meally2/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meally2/HomePage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:meally2/widgets/PostTileWidget.dart';
import 'package:meally2/widgets/PostWidget.dart';
import 'package:meally2/widgets/ProgressWidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfilePage extends StatefulWidget {
  final String userProfileId;
  final User gCurrentUser;

  ProfilePage({this.userProfileId, this.gCurrentUser});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String currentOnlineUserId = currentUser.id;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.only(left: 40, right: 40),
          //width: MediaQuery.of(context).size.width,
          //height: MediaQuery.of(context).size.height,
          child: ListView(
            children: <Widget>[
              logo(),
              accountDetails(),
              menu(),
            ],
          )
        ),
      bottomSheet: Container(
        height: 150,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: ClipPath(
          clipper: TopBarClipper(),
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.all(20),
            alignment: Alignment.bottomLeft,
            width: MediaQuery.of(context).size.width,
            child: Text("MealLy 1.0", textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.white)
                )),
          ),
        ),
      ),
    );
  }

  logo(){
    return Container(
      height: 100,
      alignment: Alignment.bottomLeft,
      child: Text("mealLy", textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
              textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 30, color: Colors.black)
          )),
    );
  }


  accountDetails(){
    return FutureBuilder(
      future: userReference.document(widget.userProfileId).get(),
      builder: (context, dataSnapshot){
        if(!dataSnapshot.hasData){
          return circularProgress(Colors.orangeAccent);
        }
        User user = User.fromDocument(dataSnapshot.data);
        return Container(
          height: 120,
          //color: Colors.blue,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(backgroundImage: NetworkImage(user.url),radius: 30,),
              SizedBox(width: 20,),
              Container(
                width: MediaQuery.of(context).size.width/2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(user.profileName, overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black)
                        )),
                    Text("012030101", textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Colors.black)
                        )),
                    Text(user.postcode + ", " + user.city,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Colors.black)
                        )),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  menu(){
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(left: 10, right: 10),
      height: 300,
      //color: Colors.blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          createList(Icons.edit, "Edit Profile",editUserProfile),
          createList(Icons.shopping_bag_outlined,"Orders",viewOrder),
          createList(Icons.system_update_alt_rounded,"Update TDEE",editUserProfile),
          createList(Icons.person,"Update Weight",editUserProfile),
          createList(Icons.logout, "Log Out",logoutUser),
        ],
      ),
    );
  }

  createList(IconData icon, String title, Function function){
    return GestureDetector(
      onTap: function,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 18,),
              SizedBox(width: 20,),
              Text(
                title,
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15
                ),
              ),
            ],
          ),
          SizedBox(width: 10,),
          Icon(Icons.arrow_forward_ios_rounded, size: 10,),
        ],
      ),
    );
  }

  logoutUser() async {
    await gSignIn.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
  }
  editUserProfile(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage(currentOnlineUserId: currentOnlineUserId)));
  }
  viewOrder(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyOrderPage(gCurrentUser: currentUser, userProfileId: currentUser.id)));
  }


  Column createColumns(String title, String Value  ){
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(Value.toString(), style: GoogleFonts.poppins(textStyle:
        TextStyle(fontSize: 20.0, color: Colors.orangeAccent, fontWeight: FontWeight.bold),),),
        Container(
          margin: EdgeInsets.only(top: 5.0),
          child: Text(
            title,
            style: GoogleFonts.poppins(textStyle:
            TextStyle(fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.w600),)
          ),
        )
      ],
    );
  }

  createButtonTitleAndFunction({String title, Function performFunction}){
    return Container(
      //padding: EdgeInsets.only(top: 1.0),
      child: FlatButton(
        onPressed: performFunction,
        child: Container(
          width: double.infinity,
          height: 50.0,
          child: Text(title, style: GoogleFonts.poppins(textStyle: TextStyle(color: title == "Update Weight" ? Colors.white : Colors.orangeAccent, fontWeight: FontWeight.w600),)),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: title == "Update Weight" ? Colors.orangeAccent : Colors.white,
            border: Border.all(color: Colors.orangeAccent),
            //borderRadius: BorderRadius.circular(6.0),
          ),
        ),
      ),
    );
  }
  uploadPict(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => TrackerPage(gCurrentUser: currentUser, currentOnlineUserId: currentOnlineUserId)));
  }
}

class TopBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.moveTo(size.width, 0);
    path.quadraticBezierTo(size.width-50, size.height+20, 0, size.height-90);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
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
