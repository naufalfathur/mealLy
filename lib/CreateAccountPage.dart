import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meally2/HomePage.dart';
import 'package:meally2/main/paymentPage.dart';
import 'package:meally2/models/user.dart';
import 'package:meally2/widgets/ProgressWidget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:geolocator/geolocator.dart';

class Item {
  const Item(this.name,this.icon, this.value);
  final String name;
  final Icon icon;
  final String value;
}

class CreateAccountPage extends StatefulWidget {
  final GoogleSignInAccount userProfileId;
  CreateAccountPage({this.userProfileId});
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState(userProfileId: userProfileId);
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final GoogleSignInAccount userProfileId;
  _CreateAccountPageState({this.userProfileId});
  final _scaffoldkey =  GlobalKey<ScaffoldState>();
  //final _formkey = GlobalKey<FormState>();
  final _formkey2 = GlobalKey<FormState>();
  final _formkey3 = GlobalKey<FormState>();
  final _formkey4 = GlobalKey<FormState>();
  final _formkey5 = GlobalKey<FormState>();
  TextEditingController ZIPTextEditingController = TextEditingController();
  TextEditingController cityTextEditingController = TextEditingController();
  TextEditingController locationTextEditingController = TextEditingController();
  TextEditingController phoneNo = TextEditingController();
  String gender;
  int age;
  double weight;
  double height;
  double bodyfat = 0.0;
  double lbm;
  int tdee;
  String program = "maintain";
  Item item;
  double activity = 1.2;
  int page = 0;
  int pageChanged = 0;
  Color _color = Colors.white;
  double rating = 0;
  int error = 0;
  bool locationAsk = true;

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

  submitForm(){
    final form2 = _formkey2.currentState;
    final form3 = _formkey3.currentState;
    final form4 = _formkey4.currentState;
    final form5 = _formkey5.currentState;
    if(form2.validate()&&form3.validate()&&form4.validate()){
      form2.save();
      form3.save();
      form4.save();
      form5.save();
      if(bodyfat == 0.0){
        lbm = weight;
        print(bodyfat);
      }else{
        lbm = weight - (weight * (bodyfat/100));
        print(bodyfat);
      }
      tdee = ((370 + (21.6 * lbm))*activity).round();
      print(tdee);
      pageController.animateToPage(++pageChanged, duration: Duration(milliseconds: 250), curve: Curves.bounceInOut);

    //final form = _formkey.currentState;

      /*
      Timer(Duration(seconds: 2), (){
        Navigator.pop(context, [gender, age, weight, height, bodyfat, lbm, tdee]);
      });
       */
      //_successModal(context);
      //Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  List<Item> items = <Item>[
    const Item('Male',Icon(Icons.android,color:  const Color(0xFF167F67),),"male"),
    const Item('Female',Icon(Icons.flag,color:  const Color(0xFF167F67),),"female"),
  ];



  @override
  Widget build(BuildContext parentContext) {
    if(locationAsk){
      return page0();
    }else{
      return CreateAccount();
    }

  }
  PageController pageController = PageController();


  Scaffold CreateAccount(){
    return Scaffold(
      key: _scaffoldkey,
      body: ListView(
        children: [
          Container(

            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 50, left: 40, right: 40),
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
                Text("Hi " +  userProfileId.displayName,textAlign: TextAlign.center,
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
                  height: MediaQuery.of(context).size.height/3+80,
                  //color: Hexcolor("#FF9900"),
                  //padding: EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width,
                  child: PageView(
                    physics:new NeverScrollableScrollPhysics(),
                    pageSnapping: true,
                    controller: pageController,
                    onPageChanged: (index) {
                      setState(() {
                        pageChanged = index;
                      });
                      print(pageChanged);
                    },
                    children: [
                      //page0(),
                      page1(),
                      page2(),
                      page3(),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                FlatButton(
                  onPressed: () {
                    if(pageChanged == 0){
                      submitForm();
                      //pageController.animateToPage(++pageChanged, duration: Duration(milliseconds: 250), curve: Curves.bounceInOut);
                    }else if (pageChanged == 1){
                      pageController.animateToPage(++pageChanged, duration: Duration(milliseconds: 250), curve: Curves.bounceInOut);
                    }else if (pageChanged == 2){
                      print("a");
                      //await Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentPage()));
                      _successModal(context);
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
                if(pageChanged != 0) Text((pageChanged).toString() + "/3",textAlign: TextAlign.center,
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
  Scaffold page0(){
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        //color: Colors.blue,
          padding: EdgeInsets.only(left: 40, right: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //SizedBox(height: 60,),
              CircleAvatar(backgroundImage: NetworkImage(userProfileId.photoUrl),radius: 50,),
              SizedBox(height: 20,),
              Text("Hi " +  userProfileId.displayName.toString(),textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 15)
                ),),
              Container(
                padding: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 20),
                child:  Text("Thank you for registering to mealLy, before you set up your account"
                    " \nin order to MealLy be able to works, we needs your phone number and location to continue",textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12)
                  ),),
              ),
              SizedBox(height: 15,),
              Text("Phone No : ",textAlign: TextAlign.left,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 12)
                ),),
              Container(
                width: 90,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: phoneNo,
                ),
              ),
              SizedBox(height: 20,),
              FlatButton(
                onPressed: (){
                  if(phoneNo.text.isEmpty){
                    print("error");
                  }else{
                    getLocation();
                    setState(() {
                      locationAsk = false;
                    });
                  }
                },
                //color: Hexcolor("#FF9900"),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/bg.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Text("Get my location",textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)
                    ),),
                  alignment: Alignment.center,
                ),
              ),
            ],
          ),
      ),
    );
  }
  page1(){
    return Container(
      //padding: EdgeInsets.only(left: 40, right: 40),
      child: ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Weight (Kg)", textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black)
                          )),
                      Container(
                        height: 60,
                        width: 120,
                        //padding: EdgeInsets.only(left: 10, right: 10),
                        margin: EdgeInsets.only(top: 10),
                        child: Form(
                          key: _formkey3,
                          autovalidate: true,
                          child: TextFormField(
                            //initialValue: '60',
                            maxLength: 3,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.black),
                            validator: (val){
                              if(val.isEmpty) {
                                return "weight";
                              }else{
                                return null;
                              }
                            },
                            onSaved: (val) => weight = double.tryParse(val),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Height (Cm)", textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black)
                          )),
                      Container(
                        height: 60,
                        width: 120,
                        //padding: EdgeInsets.only(left: 10, right: 10),
                        margin: EdgeInsets.only(top: 10),
                        child: Form(
                          key: _formkey4,
                          autovalidate: true,
                          child: TextFormField(
                            //initialValue: '160',
                            maxLength: 3,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.black),
                            validator: (val){
                              if(val.isEmpty) {
                                return "height";
                              }else{
                                return null;
                              }
                            },
                            onSaved: (val) => height = double.tryParse(val),
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
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: [
                      Text("Body Fat % (Optional)", textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black)
                          )),
                      Container(
                        height: 60,
                        width: 120,
                        //padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        margin: EdgeInsets.only(top: 10),
                        child: Form(
                          key: _formkey5,
                          autovalidate: true,
                          child: TextFormField(
                            initialValue: '0.0',
                            maxLength: 3,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.black),
                            validator: (val){
                              if(val.isEmpty){
                                return "body fat";
                              }else{
                                return null;
                              }
                            },
                            onSaved: (val) => bodyfat = double.tryParse(val),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Age", textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black)
                          )),
                      Container(
                        height: 60,
                        width: 120,
                        //padding: EdgeInsets.only(left: 10, right: 10),
                        margin: EdgeInsets.only(top: 10),
                        child: Form(
                          key: _formkey2,
                          autovalidate: true,
                          child: TextFormField(
                            //initialValue: '21',
                            maxLength: 3,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            style: TextStyle(color: Colors.black),
                            validator: (val){
                              if(val.isEmpty){
                                return "pls put age";
                              }else{
                                return null;
                              }
                            },
                            onSaved: (val) => age = int.tryParse(val),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Gender", textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black)
                      )),
                  Container(
                    height: 40,
                    padding: EdgeInsets.only(left: 10, right: 10),
                    margin: EdgeInsets.only(top: 10),
                    //width: 270,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<Item>(
                      hint:  Text("Select gender", style: TextStyle( fontSize: 12),),
                      value: item,
                      onChanged: (Item Value) {
                        setState(() {
                          item = Value;
                          gender = item.value;
                          print(gender);
                        });
                      },
                      items: items.map((Item items) {
                        return  DropdownMenuItem<Item>(
                          value: items,
                          child: Row(
                            children: <Widget>[
                              items.icon,
                              SizedBox(width: 15),
                              Text(
                                items.name,
                                style:  TextStyle(color: Colors.black, fontSize: 12),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width/2-25),
                            ],
                          ),
                        );
                      }).toList(),
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
      //padding: EdgeInsets.only(left: 15, right: 15),
      child: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          pageController.animateToPage(--pageChanged, duration: Duration(milliseconds: 250), curve: Curves.bounceInOut);
                        },
                        child: Icon(Icons.arrow_back_ios, size: 20, color: Hexcolor("#FF9900"),)
                      ),
                      Container(
                        //padding: EdgeInsets.only(bottom: 20),
                        child: Text("Exercising?",textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 12)
                          ),),
                      ),
                      GestureDetector(
                        onTap: (){
                          pageController.animateToPage(++pageChanged, duration: Duration(milliseconds: 250), curve: Curves.bounceInOut);
                        },
                          child: Icon(Icons.arrow_forward_ios, size: 20, color: Hexcolor("#FF9900"),)
                      ),
                    ],
                  ),
              ),
              SizedBox(height: 20,),
              RotatedBox(
                quarterTurns: 1,
                child:
                  ToggleButtons(
                    children: <Widget>[
                      RotatedBox(quarterTurns: 3, child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Sedentary\n(little or no exercise)", textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black)
                            )),
                      ),),
                      RotatedBox(quarterTurns: 3, child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Light activity\n(1-2 days/week)", textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black)
                            )),
                      ),),
                      RotatedBox(quarterTurns: 3, child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Moderate activity\n(3-5 days/week)", textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black)
                            )),
                      ),),
                      RotatedBox(quarterTurns: 3, child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("very active (6-7 days/week)", textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black)
                            )),
                      ),),
                      RotatedBox(quarterTurns: 3, child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("extra active (2x/day)", textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black)
                            )),
                      ),),
                    ],
                    isSelected: isSelected,
                    onPressed: (int index) {
                      setState(() {
                        for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                          if (buttonIndex == index) {
                            isSelected[buttonIndex] = true;
                          } else {
                            isSelected[buttonIndex] = false;
                          }
                        }
                        if(index == 0){
                          activity = 1.2;
                          print(activity);
                        }else if(index == 1){
                          activity = 1.375;
                          print(activity);
                        }else if(index == 2){
                          activity = 1.55;
                          print(activity);
                        }else if(index == 3){
                          activity = 1.725;
                          print(activity);
                        }else if(index == 4){
                          activity = 1.9;
                          print(activity);
                        }
                      });
                    },
                  ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  page3(){
    return Container(
      //padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                    onTap: (){
                      pageController.animateToPage(--pageChanged, duration: Duration(milliseconds: 250), curve: Curves.bounceInOut);
                    },
                    child: Icon(Icons.arrow_back_ios, size: 20, color: Hexcolor("#FF9900"),)
                ),
                Container(
                  //padding: EdgeInsets.only(bottom: 20),
                  child: Text("Set Target",textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 12)
                    ),),
                ),
                GestureDetector(
                    onTap: (){
                      pageController.animateToPage(++pageChanged, duration: Duration(milliseconds: 250), curve: Curves.bounceInOut);
                    },
                    child: Icon(Icons.check_circle, size: 20, color: Hexcolor("#FF9900"),)
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),
          RotatedBox(
            quarterTurns: 1,
            child:
            ToggleButtons(
              children: <Widget>[
                RotatedBox(quarterTurns: 3, child: Padding(
                  padding: const EdgeInsets.only(left: 60, right: 60),
                  child: Text("Maintain", textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black)
                      )),
                ),),
                RotatedBox(quarterTurns: 3, child: Padding(
                  padding: const EdgeInsets.only(left: 60, right: 60),
                  child: Text("Cutting\n(Decrease Weight)", textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black)
                      )),
                ),),
                RotatedBox(quarterTurns: 3, child: Padding(
                  padding: const EdgeInsets.only(left: 60, right: 60),
                  child: Text("Bulking\n(Increase Weight)", textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black)
                      )),
                ),),
              ],
              isSelected: isSelected2,
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0; buttonIndex < isSelected2.length; buttonIndex++) {
                    if (buttonIndex == index) {
                      isSelected2[buttonIndex] = true;
                    } else {
                      isSelected2[buttonIndex] = false;
                    }
                  }
                  if(index == 0){
                    program = "maintain";
                    print(program);
                  }else if(index == 1){
                    program = "Cutting";
                    print(program);
                  }else if(index == 2){
                    program = "Bulking";
                    print(program);
                  }
                });
              },
            ),
          ),
          SizedBox(height: 20,),
        ],
      ),
    );
  }

  void _successModal(context){
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context) =>
        GestureDetector(
          //onVerticalDragStart: (_) {},
          child: Container(
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
                Text("Your data has ben updated", textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white)
                    )),
                SizedBox(height: 10,),
                Container(
                  height: 80,
                  //width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    child: Image(
                      image: AssetImage("assets/images/loadOr.gif"),
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Text("Using Katch-McArdle Formula, the calories intake that your body needs for your " + program + " program is " + tdee.toString() + " calories per day", textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Colors.white)
                    )),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Program ", style: GoogleFonts.poppins(textStyle:
                    TextStyle(fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.w600),),),
                    Text(program, style: GoogleFonts.poppins(textStyle:
                    TextStyle(fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.w500),),),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Gender ", style: GoogleFonts.poppins(textStyle:
                    TextStyle(fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.w600),),),
                    Text(gender, style: GoogleFonts.poppins(textStyle:
                    TextStyle(fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.w500),),),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("age ", style: GoogleFonts.poppins(textStyle:
                    TextStyle(fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.w600),),),
                    Text(age.toString(), style: GoogleFonts.poppins(textStyle:
                    TextStyle(fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.w500),),),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("bodyfat ", style: GoogleFonts.poppins(textStyle:
                    TextStyle(fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.w600),),),
                    Text(bodyfat.toString() + " %", style: GoogleFonts.poppins(textStyle:
                    TextStyle(fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.w500),),),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("weight ", style: GoogleFonts.poppins(textStyle:
                    TextStyle(fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.w600),),),
                    Text(weight.toString(), style: GoogleFonts.poppins(textStyle:
                    TextStyle(fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.w500),),),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Calories intake ", style: GoogleFonts.poppins(textStyle:
                    TextStyle(fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.w600),),),
                    Text(tdee.toString(), style: GoogleFonts.poppins(textStyle:
                    TextStyle(fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.w500),),),
                  ],
                ),

                SizedBox(height: 10,),

                FlatButton(
                  onPressed: (){
                    Navigator.pop(context, [gender, age, weight, height, bodyfat, lbm, tdee, ZIPTextEditingController.text,cityTextEditingController.text,locationTextEditingController.text, phoneNo.text, program]);
                    Navigator.pop(context, [gender, age, weight, height, bodyfat, lbm, tdee, ZIPTextEditingController.text,cityTextEditingController.text,locationTextEditingController.text, phoneNo.text, program]);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
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
          )
        ),
        isDismissible: false,
        isScrollControlled: true,
    );
  }

}
