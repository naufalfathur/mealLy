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
import 'package:geolocator/geolocator.dart';
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
  TextEditingController name = TextEditingController();
  TextEditingController no = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController postcode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: userReference.document(widget.userProfileId).get(),
      builder: (context, dataSnapshot){
        if(!dataSnapshot.hasData){
          return circularProgress(Colors.orangeAccent);
        }
        User user = User.fromDocument(dataSnapshot.data);
        return Scaffold(
          body: Container(
              padding: EdgeInsets.only(left: 40, right: 40),
              //width: MediaQuery.of(context).size.width,
              //height: MediaQuery.of(context).size.height,
              child: ListView(
                children: <Widget>[
                  logo(),
                  accountDetails(user),
                  menu(user),
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
      },
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


  accountDetails(User user){
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
                Text(user.phoneNo.toString(), textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Colors.black)
                    )),
                Text(user.postcode.toString() + ", " + user.city,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Colors.black)
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  menu(User user){
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(left: 10, right: 10),
      height: 300,
      //color: Colors.blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          GestureDetector(
            onTap: (){
              editProfile(context, user);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.edit, size: 18,),
                    SizedBox(width: 20,),
                    Text(
                      "Edit Profile",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 10,),
                Icon(Icons.arrow_forward_ios_rounded, size: 10,),
              ],
            ),
          ),
          //createList(Icons.edit, "Edit Profile",(){editProfile(context, user);}),
          createList(Icons.shopping_bag_outlined,"Orders",viewOrder),
          //createList(Icons.system_update_alt_rounded,"Update TDEE",editUserProfile),
          createList(Icons.person,"Update Weight",updateWeight),
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

  updateWeight(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => TrackerPage(gCurrentUser: currentUser, currentOnlineUserId: currentOnlineUserId)));
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

  updateProfile(){
    userReference.document(widget.userProfileId).updateData({
      "profileName" : name.text,
      "phoneNo" : int.tryParse(no.text),
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

  void editProfile(context, User user){
    showModalBottomSheet(
        context: context, isScrollControlled:true,
        backgroundColor: Colors.white,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (BuildContext bc){
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState){
                name.text = user.profileName;
                no.text = user.phoneNo.toString();
                location.text = user.location;
                city.text = user.city;
                postcode.text = user.postcode.toString();
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
                                        controller: name,
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
