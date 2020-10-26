import 'package:flutter/material.dart';
import 'package:meally2/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meally2/HomePage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:meally2/widgets/HeaderPage.dart';
import 'package:meally2/widgets/PostTileWidget.dart';
import 'package:meally2/widgets/PostWidget.dart';
import 'package:meally2/widgets/ProgressWidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProgressPage extends StatefulWidget {
  final String userProfileId;
  final User gCurrentUser;

  ProgressPage({this.userProfileId, this.gCurrentUser});
  @override
  _ProgressPageState createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  final String currentOnlineUserId = currentUser.id;
  bool loading = false;
  int countPost = 0;
  List<Post> postlist = [];
  String postOrientation = "list";

  void initState(){
    getAllProfilePost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: "Progress Page",),
      body: Container(
        //color: Hexcolor("#FF9900"),
        child: ListView(
          children: <Widget>[
            Divider(),
            displayProfilePost(),
          ],
        ),
      ),
    );
  }


  displayProfilePost(){
    if(loading){
      return circularProgress();
    }else if(postlist.isEmpty){
      return Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(30),
              child: Icon(Icons.photo_library, color: Colors.grey, size: 200,),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text("No Post", style: TextStyle(color: Colors.redAccent, fontSize: 40, fontWeight: FontWeight.bold),),
            )
          ],
        ),
      );
    }else if(postOrientation == "grid"){
      List<GridTile> gridTilesList = [];
      postlist.forEach((eachPost) {
        gridTilesList.add(GridTile(child: PostTile(eachPost)));
      });
      return Container(
          color: Colors.white,
          child:GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            mainAxisSpacing: 1.5,
            crossAxisSpacing: 1.5,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: gridTilesList,
          )
      );
    }
    else if(postOrientation == "list"){
      return Container(
        color: Colors.white,
        child:
        Column(
          children: postlist,
        ),
      );
    }
  }

  getAllProfilePost() async{
    setState(() {
      loading = true;
    });

    QuerySnapshot querySnapshot = await TrackerReference.document(widget.userProfileId).collection("userTrack").orderBy("timestamp", descending: true).getDocuments();

    setState(() {
      loading = false;
      countPost = querySnapshot.documents.length;
      postlist = querySnapshot.documents.map((documentSnapshot) => Post.fromDocument(documentSnapshot)).toList();
    });
  }

  setOrientation(String orientation){
    setState(() {
      this.postOrientation = orientation;
    });
  }
}
