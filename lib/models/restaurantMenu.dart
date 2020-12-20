import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meally2/main/RestaurantHome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meally2/main/mealUpload.dart';
import 'package:meally2/models/restaurant.dart';
import 'package:meally2/widgets/RestaurantPostTile.dart';
import 'package:meally2/widgets/RestaurantPostWidget.dart';
import 'package:meally2/widgets/ProgressWidget.dart';
import 'package:meally2/widgets/RestaurantPostWidget.dart';

class restaurantMenu extends StatefulWidget {
  final String userRestId;
  final Restaurant gCurrentRest;

  restaurantMenu({this.userRestId, this.gCurrentRest});
  @override
  _restaurantMenuState createState() => _restaurantMenuState();
}

class _restaurantMenuState extends State<restaurantMenu> {
  final String currentOnlineRestId = currentRest.id;
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
      body: ListView(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: Hexcolor("#FF9900"),
            ),
            child: Text("Menu", textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 25)
              ),),
          ),
          uploadMeal(),
          Divider(),
          displayProfilePost(),
        ],
      ),
    );
  }

  uploadMeal(){
    return Container(
      child: FlatButton(
        onPressed: uploadPict,
        child: Container(
          width: double.infinity,
          height: 50.0,
          margin: EdgeInsets.only(top: 30),
          child: Text("Upload meals", style: GoogleFonts.poppins(textStyle: TextStyle(color:Colors.white , fontWeight: FontWeight.w600),)),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Hexcolor("#FF9900"),
            //borderRadius: BorderRadius.circular(6.0),
          ),
        ),
      ),
    );
  }

  uploadPict(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => mealUpload(gCurrentRest: currentRest, currentOnlineRestId: currentOnlineRestId)));
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
        gridTilesList.add(GridTile(child: RestaurantPostTile(eachPost)));
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

    QuerySnapshot querySnapshot = await mealsReference.document(widget.userRestId).collection("mealList").getDocuments();

    setState(() {
      loading = false;
      countPost = querySnapshot.documents.length;
      postlist = querySnapshot.documents.map((documentSnapshot) => Post.fromDocument(documentSnapshot, true)).toList();
    });
  }

  setOrientation(String orientation){
    setState(() {
      this.postOrientation = orientation;
    });
  }


}
