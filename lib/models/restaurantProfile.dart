import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meally2/HomePage.dart' as homePage;
import 'package:meally2/main/NotificationPage.dart';
import 'package:meally2/main/OrderListsPage.dart';
import 'package:meally2/main/RestaurantHome.dart';
import 'package:meally2/models/restaurant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meally2/HomePage.dart' as homePage;
import 'package:meally2/widgets/ProgressWidget.dart';
import 'package:meally2/widgets/RestaurantPostTile.dart';
import 'package:meally2/widgets/RestaurantPostWidget.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:geolocator/geolocator.dart';


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
  double rateTot;
  double rate;

  TextEditingController rName = TextEditingController();
  TextEditingController no = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController postcode = TextEditingController();


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
                    HexColor("#616161").withOpacity(0.6),
                    HexColor("#000000").withOpacity(0.5)
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
                Container(
                  child: retrieveRating(),),
                GestureDetector(
                  onTap: (){
                    _showCert(restaurant);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 30,
                    width: 130,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text("Halal Certification",textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600, fontSize: 12)
                      ),),
                  ),
                )
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
                color: HexColor("#FF9900"),
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

  retrieveRating() {
    return StreamBuilder(
      stream: activityFeedReference.document(widget.userRestId)
          .collection("activityItems").where("type", isEqualTo: "comment").snapshots(),
      builder: (context, dataSnapshot){
        if(!dataSnapshot.hasData){
          return circularProgress(Colors.orangeAccent);
        }
        List<NotificationsItem> comments = [];
        dataSnapshot.data.documents.forEach((document){
          comments.add(NotificationsItem.fromDocument(document));
        });
        if(comments.isEmpty){
          return Center(
            child: SmoothStarRating(
              rating: 0,
              isReadOnly: true,
              size: 20,
              filledIconData: Icons.star,
              halfFilledIconData: Icons.star_half_rounded,
              defaultIconData: Icons.star_border,
              color: Colors.white,
              starCount: 5,
              allowHalfRating: true,
              spacing: 2.0,
            ),
          );
        }
        rate = 0.0;
        rateTot = 0.0;
        for (int i = 0; i < comments.length; i++) {
          rateTot += comments[i].rating;
          print("tot $i" + rateTot.toString());
        }

        print("tot" + rateTot.toString());
        rate = rateTot/comments.length;
        print("rate" + rate.toString());

        return Center(
          child: SmoothStarRating(
            rating: rate,
            isReadOnly: true,
            size: 20,
            filledIconData: Icons.star,
            halfFilledIconData: Icons.star_half_rounded,
            defaultIconData: Icons.star_border,
            color: Colors.white,
            starCount: 5,
            allowHalfRating: true,
            spacing: 2.0,
          ),
        );
      },
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
      height: 350,
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
          Text(restaurant.email,textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                textStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600, fontSize: 12)
            ),),
          Text(restaurant.PICNo.toString(),textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                textStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600, fontSize: 12)
            ),),
          Text(restaurant.location,textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                textStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600, fontSize: 12)
            ),),
          Divider(thickness: 1,),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => OrderListsPage(userRestId: currentRest.id, gCurrentRest: currentRest,)));
            },
            child: Row(
              children: [
                Icon(Icons.history),
                SizedBox(width: 10,),
                Text("Order Lists",textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12)
                  ),),
              ],
            ),
          ),
          GestureDetector(
            onTap: (){
              editProfile(context, restaurant);
            },
            child: Row(
              children: [
                Icon(Icons.mode_edit),
                SizedBox(width: 10,),
                Text("Edit Profile",textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12)
                  ),),
              ],
            ),
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
                      textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12)
                  ),),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("MealLy 1.0", textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black)
                  )),
              Text("by JAT \nNaufal Fathur, Ikhwanul Muslim, Petra Praysia", textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 8, color: Colors.black)
                  )),
            ],
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

  updateProfile(){
    restReference.document(widget.userRestId).updateData({
      "RestaurantName" : rName.text,
      "PICNo" : int.tryParse(no.text),
      "location" : location.text,
      "city" : city.text,
      "postcode" : int.tryParse(postcode.text),
    });
    Navigator.pop(context);
  }
  getLocation() async{
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark mPlacemark = placemark[0];
    String completeAddressInfo = '${mPlacemark.subThoroughfare} ${mPlacemark.thoroughfare}, ${mPlacemark.subLocality} ${mPlacemark.locality}, ${mPlacemark.subAdministrativeArea} ${mPlacemark.administrativeArea}, ${mPlacemark.postalCode} ${mPlacemark.country}, ';
    String cityAddress = '${mPlacemark.locality}';
    String postcodeAddress = '${mPlacemark.postalCode}';
    postcode.text = postcodeAddress;
    city.text = cityAddress;
    location.text = completeAddressInfo;
  }

  void editProfile(context, Restaurant rest){
    List<bool> isSelected = [false, false, false];
    showModalBottomSheet(
        context: context, isScrollControlled:true,
        backgroundColor: Colors.white,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (BuildContext bc){
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState){
                rName.text = rest.RestaurantName;
                no.text = rest.PICNo.toString();
                location.text = rest.location;
                city.text = rest.city;
                postcode.text = rest.postcode.toString();
                return Scaffold(
                  appBar: AppBar(
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.white,
                    leading: GestureDetector(
                        onTap: (){Navigator.pop(context);},
                        child: Icon(Icons.arrow_back_ios_rounded,size: 14, color: Colors.black,)),
                    title: Text("Edit Profile", style: GoogleFonts.poppins(textStyle:
                    TextStyle(fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.w600),),),
                    actions: <Widget>[
                      IconButton(icon: Icon(Icons.check, color: Colors.black,), onPressed:  ()=> updateProfile(),)
                    ],
                  ),
                  body: Container(
                      height: MediaQuery.of(context).size.height,
                      alignment: Alignment.center,
                      //padding: EdgeInsets.only(left: 30, right: 30, top: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        //borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                      ),
                      child: ListView(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 25, right: 25, top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Info", style: GoogleFonts.poppins(textStyle:
                                TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.w700),),),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Restaurant Name", style: GoogleFonts.poppins(textStyle:
                                    TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                                    Container(
                                      //color: Colors.blue,
                                      width: MediaQuery.of(context).size.width-200,
                                      child: TextField(
                                        textAlign: TextAlign.end,
                                        style: TextStyle(color: Colors.black),
                                        controller: rName,
                                        decoration: InputDecoration(
                                            border: InputBorder.none
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Phone No", style: GoogleFonts.poppins(textStyle:
                                    TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                                    Container(
                                      //color: Colors.blue,
                                      width: MediaQuery.of(context).size.width-150,
                                      child: TextField(
                                        textAlign: TextAlign.end,
                                        style: TextStyle(color: Colors.black),
                                        controller: no,
                                        decoration: InputDecoration(
                                            border: InputBorder.none
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(thickness: 1,),
                                Text("Address", style: GoogleFonts.poppins(textStyle:
                                TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.w700),),),
                                SizedBox(height: 10,),
                                Container(
                                  //width: 220.0,
                                  //height: 110.0,
                                  alignment: Alignment.center,
                                  child: RaisedButton.icon(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35.0)),
                                      color: Colors.green,
                                      onPressed: getLocation,
                                      icon: Icon(Icons.location_on, color: Colors.white,),
                                      label: Text("Get my current Location", style: TextStyle(color: Colors.white),)),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("ZIP Code", style: GoogleFonts.poppins(textStyle:
                                    TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                                    Container(
                                      //color: Colors.blue,
                                      width: MediaQuery.of(context).size.width-150,
                                      child: TextField(
                                        textAlign: TextAlign.end,
                                        style: TextStyle(color: Colors.black),
                                        controller: postcode,
                                        decoration: InputDecoration(
                                            border: InputBorder.none
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("City", style: GoogleFonts.poppins(textStyle:
                                    TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                                    Container(
                                      //color: Colors.blue,
                                      width: MediaQuery.of(context).size.width-150,
                                      child: TextField(
                                        textAlign: TextAlign.end,
                                        style: TextStyle(color: Colors.black),
                                        controller: city,
                                        decoration: InputDecoration(
                                            border: InputBorder.none
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text("Full Address", style: GoogleFonts.poppins(textStyle:
                                TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                                Container(
                                  //color: Colors.blue,
                                  width: MediaQuery.of(context).size.width-40,
                                  child: TextField(
                                    keyboardType: TextInputType.multiline,
                                    textAlign: TextAlign.start,
                                    minLines: 1,//Normal textInputField will be displayed
                                    maxLines: null,
                                    style: TextStyle(color: Colors.black),
                                    controller: location,
                                    decoration: InputDecoration(
                                        border: InputBorder.none
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                  ),
                );
              });
        });
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
