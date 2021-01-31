import 'package:flutter/material.dart';
import 'package:meally2/main/TrackerPage.dart';
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
      body: Container(
        //color: HexColor("#FF9900"),

        child: ListView(
          children: <Widget>[
            topBar(),
            //Divider(),
            ProgressData(),
            //
            //Divider(),
            displayProfilePost(),
          ],
        ),
      ),
      bottomSheet: UploadProgress(),
    );
  }

  topBar(){
    return Container(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      width: MediaQuery.of(context).size.width,
      height: 70,
      alignment: Alignment.bottomLeft,
      //margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        //color: Colors.blue
      ),
      child:
      Text("Weight Track",
        style: GoogleFonts.poppins(
            textStyle: TextStyle(color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 25)
        ),),
    );
  }

  ProgressData(){
    return FutureBuilder(
      future: userReference.document(widget.userProfileId).get(),
      builder: (context, dataSnapshot){
        if(!dataSnapshot.hasData){
          return circularProgress(Colors.orangeAccent);
        }
        User user = User.fromDocument(dataSnapshot.data);
        return Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10,bottom: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        alignment: Alignment(-1, 0),
                        image: AssetImage("assets/images/bg.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child:Container(
                      decoration: BoxDecoration(
                          color : HexColor("#690000").withOpacity(0.15)
                      ),
                      child: Container(
                        padding: EdgeInsets.only(top: 15, bottom: 15),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              child: createColumns("Start", user.initialWeight.round()),
                            ),
                            Container(
                              child: createColumns("Current", user.weight.round()),
                            ),
                            Container(
                              //color: Colors.black45,
                              child: createColumns("Change", (user.weight - user.initialWeight).round()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
        );
      },
    );
  }

  Column createColumns(String title, int Value  ){
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(Value.toString(), style: GoogleFonts.poppins(textStyle:
        TextStyle(fontSize: 18.0, color: title != "Change" ? Colors.white : Value >0 ? Colors.lightBlueAccent : HexColor("#690000"), fontWeight:FontWeight.w700),),),
        Container(
          margin: EdgeInsets.only(top: 5.0),
          child: Text(
              title,
              style: GoogleFonts.poppins(textStyle:
              TextStyle(fontSize: 15.0, color: Colors.white, fontWeight: FontWeight.w500),)
          ),
        )
      ],
    );
  }

  UploadProgress(){
      return Container(
        //padding: EdgeInsets.only(top: 1.0),
        child: FlatButton(
          onPressed: uploadPict,
          child: Container(

            width: double.infinity,
            height: 50.0,
            child: Text("Update Weight", style: GoogleFonts.poppins(textStyle: TextStyle(color:Colors.white , fontWeight: FontWeight.w600),)),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                alignment: Alignment(-1, 0),
                image: AssetImage("assets/images/bg.png"),
                fit: BoxFit.cover,
              ),
              color: Colors.orangeAccent,
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

  displayProfilePost(){
    if(loading){
      return circularProgress(Colors.orangeAccent);
    }else if(postlist.isEmpty){
      return Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 100),
              child: Icon(Icons.photo_library, color: Colors.grey, size: 100,),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text("no data", style: TextStyle(color: Colors.grey, fontSize: 30, fontWeight: FontWeight.bold),),
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
