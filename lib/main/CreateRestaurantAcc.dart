import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meally2/main/RestaurantHome.dart';
import 'package:geolocator/geolocator.dart';

class Item {
  const Item(this.name,this.icon, this.value);
  final String name;
  final Icon icon;
  final String value;
}

class CreateRestaurantAcc extends StatefulWidget {
  @override
  _CreateRestaurantAccState createState() => _CreateRestaurantAccState();
}

class _CreateRestaurantAccState extends State<CreateRestaurantAcc> {
  TextEditingController ZIPTextEditingController = TextEditingController();
  TextEditingController cityTextEditingController = TextEditingController();
  TextEditingController locationTextEditingController = TextEditingController();
  final _scaffoldkey =  GlobalKey<ScaffoldState>();
  final _formName = GlobalKey<FormState>();
  final _formAcc = GlobalKey<FormState>();
  final _formCuis = GlobalKey<FormState>();
  final _formZIP = GlobalKey<FormState>();
  final _formCity = GlobalKey<FormState>();
  final _formLoc = GlobalKey<FormState>();
  final _formPICName = GlobalKey<FormState>();
  final _formPICNo = GlobalKey<FormState>();
  final _formPICPos = GlobalKey<FormState>();

  String RestaurantName;
  int postcode = 123;
  String city = "empty";
  String accreditation;
  String cuisine;
  String location = "empty";
  String PICName = "john";
  int PICNo = 0122;
  String PICPosition = "owner";

  int page = 0;
  int pageChanged = 0;
  Color _color = Colors.white;
  double rating = 0;
  int error = 0;

  List<bool> isSelected = [true, false, false,false, false];
  List<bool> isSelected2 = [true, false, false];

  getLocation() async{
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark mPlacemark = placemark[0];
    String completeAddressInfo = '${mPlacemark.subThoroughfare} ${mPlacemark.thoroughfare}, ${mPlacemark.subLocality} ${mPlacemark.locality}, ${mPlacemark.subAdministrativeArea} ${mPlacemark.administrativeArea}, ${mPlacemark.postalCode} ${mPlacemark.country}, ';
    String cityAddress = '${mPlacemark.locality}';
    String postcodeAddress = '${mPlacemark.postalCode}';
    ZIPTextEditingController.text = postcodeAddress;
    cityTextEditingController.text = cityAddress;
    locationTextEditingController.text = completeAddressInfo;
  }


  submitForm1(){
    final form = _formName.currentState;
    final form2 = _formAcc.currentState;
    final form3 = _formCuis.currentState;
    if(form2.validate()&&form3.validate()){
      form.save();
      form2.save();
      form3.save();
    }
  }
  submitForm2(){
    final form4 = _formZIP.currentState;
    final form5 = _formCity.currentState;
    final form6 = _formLoc.currentState;
    if(form4.validate()){
      form4.save();
      form5.save();
      form6.save();
    }
  }
  submitForm3(){
    final form7 = _formPICName.currentState;
    final form8 = _formPICNo.currentState;
    final form9 = _formPICPos.currentState;
    if(form7.validate()){
      form7.save();
      form8.save();
      form9.save();
      Navigator.pop(context, [RestaurantName, postcode, city, accreditation, location, PICName, PICNo, PICPosition, cuisine]);
      Navigator.push(context, MaterialPageRoute(builder: (context) => RestaurantHome()));
    }
  }

  List<Item> items = <Item>[
    const Item('Male',Icon(Icons.android,color:  const Color(0xFF167F67),),"male"),
    const Item('Female',Icon(Icons.flag,color:  const Color(0xFF167F67),),"female"),
  ];

  @override
  Widget build(BuildContext context) {
    return CreateAccount();
  }

  PageController pageController = PageController();
  Scaffold CreateAccount(){
    return Scaffold(
      key: _scaffoldkey,
      body: ListView(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 50),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Text("Set up your account",textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20)
                  ),),
                Container(
                  margin: EdgeInsets.only(left: 90),
                  height: 5,
                  color: Hexcolor("#FF9900"),
                  width: MediaQuery.of(context).size.width/4,
                ),
                SizedBox(height: 30,),
                Text("Hi Jane Doe, ",textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 20)
                  ),),
                Container(
                  padding: EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 20),
                  child:  Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua",textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 10)
                    ),),
                ),
                Container(
                  width: 200,
                  height: 5,
                  child:  LinearProgressIndicator(
                    value: ((pageChanged+1)*33)/100,
                    backgroundColor: Colors.black12,
                    valueColor: AlwaysStoppedAnimation(Colors.orangeAccent,),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: (MediaQuery.of(context).size.height/3)+100,
                  width: MediaQuery.of(context).size.width,
                  child: PageView(
                    //physics:new NeverScrollableScrollPhysics(),
                    pageSnapping: true,
                    controller: pageController,
                    onPageChanged: (index) {
                      setState(() {
                        pageChanged = index;
                      });
                      print(pageChanged);
                    },
                    children: [
                      page1(),
                      page2(),
                      page3(),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                FlatButton(
                  onPressed: (){
                    if (pageChanged == 0){
                      submitForm1();
                      pageController.animateToPage(++pageChanged, duration: Duration(milliseconds: 250), curve: Curves.bounceInOut);
                    }else if (pageChanged == 1){
                      submitForm2();
                      pageController.animateToPage(++pageChanged, duration: Duration(milliseconds: 250), curve: Curves.bounceInOut);
                    }else if (pageChanged == 2){
                      submitForm3();
                    }
                  },
                  color: Hexcolor("#FF9900"),
                  child: Container(
                    width: MediaQuery.of(context).size.width/2,
                    height: 40.0,
                    child: Text("Continue",textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)
                      ),),
                    alignment: Alignment.center,
                  ),
                ),
                SizedBox(height: 5,),
                Text((pageChanged+1).toString() + "/3",textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.w700, fontSize: 12)
                  ),),
                SizedBox(height: 5,),

              ],
            ),
          ),
        ],
      ),
    );
  }

  page1(){
    return Container(
        padding: EdgeInsets.only(left: 40, right: 40),
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Restaurant Name", textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black)
                        )),
                    Container(
                      height: 60,
                      child: Form(
                        key: _formName,
                        autovalidate: true,
                        child: TextFormField(
                          //initialValue: '60',
                          maxLength: 20,
                          //keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.black),
                          validator: (val){
                            if(val.isEmpty) {
                              return "name";
                            }else{
                              return null;
                            }
                          },
                          onSaved: (val) => RestaurantName = val,
                          decoration: InputDecoration(
                            contentPadding: new EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(7.0)),
                            hintText: '...',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Accreditation", textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black)
                        )),
                    Container(
                      height: 60,
                      //width: 120,
                      margin: EdgeInsets.only(top: 10),
                      child: Form(
                        key: _formAcc,
                        autovalidate: true,
                        child: TextFormField(
                          //initialValue: '21',
                          maxLength: 1,
                          //keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.black),
                          validator: (val){
                            if(val.isEmpty){
                              return "Accreditation";
                            }else{
                              return null;
                            }
                          },
                          onSaved: (val) => accreditation = val,
                          decoration: InputDecoration(
                            contentPadding: new EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(7.0)),
                            hintText: '...',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Cuisine Type", textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black)
                        )),
                    Container(
                      height: 60,
                      //width: 120,
                      margin: EdgeInsets.only(top: 10),
                      child: Form(
                        key: _formCuis,
                        autovalidate: true,
                        child: TextFormField(
                          //initialValue: '21',
                          maxLength: 10,
                          //keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.black),
                          validator: (val){
                            if(val.isEmpty){
                              return "cuisine";
                            }else{
                              return null;
                            }
                          },
                          onSaved: (val) => cuisine = val,
                          decoration: InputDecoration(
                            contentPadding: new EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(7.0)),
                            hintText: '...',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        )
    );
  }
  page2(){
    return Container(
        padding: EdgeInsets.only(left: 40, right: 40),
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
                SizedBox(height: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("ZIP Code", textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black)
                        )),
                    Container(
                      height: 60,
                      child: Form(
                        key: _formZIP,
                        autovalidate: true,
                        child: TextFormField(
                          controller: ZIPTextEditingController,
                          maxLength: 20,
                          //keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.black),
                          validator: (val){
                            if(val.isEmpty) {
                              return "postcode";
                            }else{
                              return null;
                            }
                          },
                          onSaved: (val) => postcode = int.tryParse(val),
                          decoration: InputDecoration(
                            contentPadding: new EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(7.0)),
                            hintText: '...',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("City/Town", textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black)
                        )),
                    Container(
                      height: 60,
                      //width: 120,
                      margin: EdgeInsets.only(top: 10),
                      child: Form(
                        key: _formCity,
                        autovalidate: true,
                        child: TextFormField(
                          controller: cityTextEditingController,
                          style: TextStyle(color: Colors.black),
                          validator: (val){
                            if(val.isEmpty){
                              return "City";
                            }else{
                              return null;
                            }
                          },
                          onSaved: (val) => city = val,
                          decoration: InputDecoration(
                            contentPadding: new EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(7.0)),
                            hintText: '...',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Full Address", textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black)
                        )),
                    Container(
                      height: 60,
                      //width: 120,
                      margin: EdgeInsets.only(top: 10),
                      child: Form(
                        key: _formLoc,
                        autovalidate: true,
                        child: TextFormField(
                          controller: locationTextEditingController,
                          style: TextStyle(color: Colors.black),
                          validator: (val){
                            if(val.isEmpty){
                              return "Address";
                            }else{
                              return null;
                            }
                          },
                          onSaved: (val) => location = val,
                          decoration: InputDecoration(
                            contentPadding: new EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(7.0)),
                            hintText: '...',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        )
    );
  }
  page3(){
    return Container(
        padding: EdgeInsets.only(left: 40, right: 40),
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("PIC Name", textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black)
                        )),
                    Container(
                      height: 60,
                      child: Form(
                        key: _formPICName,
                        autovalidate: true,
                        child: TextFormField(
                          //initialValue: '60',
                          maxLength: 20,
                          //keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.black),
                          validator: (val){
                            if(val.isEmpty) {
                              return "PICName";
                            }else{
                              return null;
                            }
                          },
                          onSaved: (val) => PICName = val,
                          decoration: InputDecoration(
                            contentPadding: new EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(7.0)),
                            hintText: '...',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("PIC No.", textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black)
                        )),
                    Container(
                      height: 60,
                      //width: 120,
                      margin: EdgeInsets.only(top: 10),
                      child: Form(
                        key: _formPICNo,
                        autovalidate: true,
                        child: TextFormField(
                          //initialValue: '21',
                          //keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.black),
                          validator: (val){
                            if(val.isEmpty){
                              return "picNo";
                            }else{
                              return null;
                            }
                          },
                          onSaved: (val) => PICNo = int.tryParse(val),
                          decoration: InputDecoration(
                            contentPadding: new EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(7.0)),
                            hintText: '...',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("PIC Position", textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black)
                        )),
                    Container(
                      height: 60,
                      //width: 120,
                      margin: EdgeInsets.only(top: 10),
                      child: Form(
                        key: _formPICPos,
                        autovalidate: true,
                        child: TextFormField(
                          //initialValue: '21',
                          //keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.black),
                          validator: (val){
                            if(val.isEmpty){
                              return "PICPosition";
                            }else{
                              return null;
                            }
                          },
                          onSaved: (val) => PICPosition = val,
                          decoration: InputDecoration(
                            contentPadding: new EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(7.0)),
                            hintText: '...',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        )
    );
  }

  void  _successModal(context){
    showModalBottomSheet(context: context, builder: (BuildContext bc){
      return Container(
        height: MediaQuery.of(context).size.height/2+100,
        alignment: Alignment.center,
        padding: EdgeInsets.all(40),
        color: Hexcolor("#FF9900"),
        child: Column(
          children: <Widget>[
            Text("Congrats!", textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 30, color: Colors.white)
                )),
            SizedBox(height: 5,),
            Text("Your account has been successfully created", textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white)
                )),
            SizedBox(height: 10,),
            Icon(Icons.check_circle_outline, color: Colors.white,size: 80,),
            SizedBox(height: 10,),
            SizedBox(height: 10,),
            FlatButton(
              onPressed: (){
               print("a");
              },
              color: Colors.white,
              child: Container(
                width: MediaQuery.of(context).size.width/2,
                height: 40.0,
                child: Text("Great! Thank you",textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Hexcolor("#FF9900"), fontWeight: FontWeight.w600, fontSize: 13)
                  ),),
                alignment: Alignment.center,
              ),
            ),
          ],
        ),
      );
    });
  }
}
