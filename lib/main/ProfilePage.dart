import 'package:flutter/material.dart';
import 'package:meally2/EditProfilePage.dart';
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
  //int countPost = 0;
  //List<Post> postlist = [];
  //String postOrientation = "list";

  /*void initState(){
    getAllProfilePost();
  }
   */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              createProfileTopView(),
              menuOption(),
            ],
          )
        ),
    );
  }


  createProfileTopView(){
    return FutureBuilder(
      future: userReference.document(widget.userProfileId).get(),
      builder: (context, dataSnapshot){
        if(!dataSnapshot.hasData){
          return circularProgress();
        }
        User user = User.fromDocument(dataSnapshot.data);
        return Stack(
          children: <Widget>[
            Container(
              height: 200,
              color: Hexcolor("#FF9900"),
              width: MediaQuery.of(context).size.width,
            ),
            Padding(
              padding: EdgeInsets.only(top: 65, left: 30, right: 30, bottom: 1),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            //color : Colors.white,
                            //padding: EdgeInsets.only(top: 20.0),
                            child: Text(
                              user.profileName,
                              style: GoogleFonts.poppins(textStyle:
                              TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.w600),),
                            ),
                          ),
                          Container(
                            //color : Colors.white,
                            //padding: EdgeInsets.only(top: 3.0),
                            child: Text(
                              user.email,
                              style: GoogleFonts.poppins(textStyle:
                              TextStyle(fontSize: 14.0, color: Colors.white),),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child:ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image(
                                image: CachedNetworkImageProvider(user.url),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 40),
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0.0,3.0),
                          blurRadius: 37,
                          spreadRadius: -8,
                        ),
                      ],
                    ),
                    child:Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          child: createColumns("Weight", user.weight.toString()),
                        ),
                        Container(
                          child: createColumns("TDEE", user.tdee.toString()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  menuOption(){
    return Container(
      margin: EdgeInsets.only(top: 280, left: 30, right: 30),
      padding: EdgeInsets.only(top: 20, left: 10, right: 10),
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0,2.0),
            blurRadius: 23,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          createList("Update Weight","a"),
          createList("Edit Plans","a"),
          createList("Edit Profile","a"),
          createList("Log Out","a"),
        ],
      ),
    );
  }

  ListTile createList(String title, String function){
    return ListTile(
      leading: Icon(Icons.account_circle),
      title: GestureDetector(
        onTap: ()=>  print(function),
        child: Text(
          title,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300
          ),
        ),
      ),
    );
  }

  Row createRows(String title, Function function){
    return Row (

    );
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
  editUserProfile(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage(currentOnlineUserId: currentOnlineUserId)));
  }
  uploadPict(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => TrackerPage(gCurrentUser: currentUser, currentOnlineUserId: currentOnlineUserId)));
  }

}
