import 'package:flutter/material.dart';
import 'package:meally2/HomePage.dart';
import 'package:meally2/main/MyOrderPage.dart';
import 'package:meally2/main/OrderDetailsPage.dart';
import 'package:meally2/main/Planner.dart';
import 'package:meally2/models/user.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meally2/widgets/ProgressWidget.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class MyPlanPage extends StatefulWidget {
  final String userProfileId;
  final User gCurrentUser;
  MyPlanPage({this.userProfileId, this.gCurrentUser});
  @override
  _MyPlanPageState createState() => _MyPlanPageState(gCurrentUser:gCurrentUser, userProfileId:userProfileId);
}

class _MyPlanPageState extends State<MyPlanPage> {
  var now = DateTime.now();
  //final today = DateTime(now.year, now.month, now.day);
  //final yesterday = DateTime(now.year, now.month, now.day - 1);
  //final tomorrow = DateTime(now.year, now.month, now.day + 1);
  //String formatted = intl.DateFormat.Hm().format(now);
  final User gCurrentUser;
  final String userProfileId;
  DatePickerController _controller = DatePickerController();
  int pageChanged = 0;
  DateTime _selectedValue = DateTime.now();
  DateTime _selectedValue2 ;
  PageController pageController = PageController();
  List<OrdersItem> meals;


  _MyPlanPageState({this.userProfileId, this.gCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
          child: Column(
            children: [
              topBar(),
              SizedBox(height: 10,),
              Container(
                color: Colors.white,
                child: DatePicker(
                  DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                  width: 60,
                  height: 80,
                  controller: _controller,
                  initialSelectedDate: DateTime.now(),
                  selectionColor: Colors.grey,
                  selectedTextColor: Colors.white,
                  onDateChange: (date) {
                    // New date selected
                    print(date);
                    setState(() {
                      now = date;
                    });
                  },
                ),
              ),
              SizedBox(height: 10,),
              Expanded(child: retrieveOrder(now),)
            ],
          ),
        ),
      bottomSheet:  Padding(
        padding: const EdgeInsets.all(10.0),
        child: FlatButton(
          onPressed: (){
            planMeal();
          },
          //color: Hexcolor("#FF9900"),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 45.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: AssetImage("assets/images/bg.png"),
                fit: BoxFit.fitWidth,
              ),

            ),
            child: Text("Create new plan",textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)
              ),),
            alignment: Alignment.center,
          ),
        ),
      ),

      /*
        body: Container(
          //color: Colors.blueGrey[100],
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Stack(
            children: [
              ListView(
                children: <Widget>[
                  topBar(),
                  SizedBox(height: 10,),
                  Container(
                    color: Colors.white,
                    child: DatePicker(
                      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                      width: 60,
                      height: 80,
                      controller: _controller,
                      initialSelectedDate: DateTime.now(),
                      selectionColor: Colors.grey,
                      selectedTextColor: Colors.white,
                      onDateChange: (date) {
                        // New date selected
                        print(date);
                        setState(() {
                          now = date;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 10,),
                  Expanded(child: retrieveOrder(now),)
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FlatButton(
                    onPressed: (){
                      planMeal();
                    },
                    //color: Hexcolor("#FF9900"),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 45.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          image: AssetImage("assets/images/bg.png"),
                          fit: BoxFit.fitWidth,
                        ),

                      ),
                      child: Text("Create new plan",textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)
                        ),),
                      alignment: Alignment.center,
                    ),
                  ),
                ),
              ),
            ],
          ),

        )

       */
    );
  }

  topBar(){
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 70,
        alignment: Alignment.bottomLeft,
        //margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          //color: Colors.blue
        ),
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Meal Plan",
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 25)
              ),),
            GestureDetector(
              onTap: (){viewOrder();},
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color:Colors.black,
                ),
                padding: EdgeInsets.only(left: 5, right: 5,top: 2, bottom: 2),
                child: Row(
                  children: [
                    Icon(Icons.shopping_bag_outlined, color: Colors.white,),
                    Text("Orders",
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12)
                      ),),
                  ],
                ),
              ),
            ),
          ],
        ),
    );
  }

  viewOrder(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyOrderPage(gCurrentUser: currentUser, userProfileId: currentUser.id)));
  }

  mealPage(){
    if(meals == null){
      return circularProgress(Colors.orangeAccent);
    }else if(meals.isEmpty){
      return Container(height: 400, alignment: Alignment.center,child: Text("no meals available"));
    }else{
      return mealList();
    }
  }

  retrieveOrder(DateTime date){
    /*
    QuerySnapshot querySnapshot =  await custOrdersReference.document(userProfileId)
        .collection("custOrder").where("datetime", isGreaterThanOrEqualTo: DateTime(date.year, date.month, date.day)
        , isLessThan: DateTime(date.year, date.month, date.day+ 1)).getDocuments();
    setState(() {
      meals = querySnapshot.documents.map((document) => OrdersItem.fromDocument(document, userProfileId)).toList();
    });
     */
    return StreamBuilder(
      stream: custOrdersReference.document(userProfileId) .collection("custOrder").where("datetime", isGreaterThanOrEqualTo: DateTime(date.year, date.month, date.day)
          , isLessThan: DateTime(date.year, date.month, date.day+ 1)).snapshots(),
      builder: (context, dataSnapshot){
        print("b");
        if(!dataSnapshot.hasData){
          print("c");
          return circularProgress(Colors.orangeAccent);
        }
        print("d");
        List<OrdersItem> comments = [];
        dataSnapshot.data.documents.forEach((document){
          comments.add(OrdersItem.fromDocument(document, userProfileId));
        });
        if(comments.isEmpty){
          return Container(height: 400, alignment: Alignment.center,child: Text("no meals available"));
        }
        return ListView(
          children: comments,
        );
      },
    );
  }

  mealList(){
    return Container(
      height: 500,
      child: ListView.builder(
        itemCount: meals.length,
        itemBuilder: (BuildContext context, int index){
          return Container(
            margin: EdgeInsets.only(top: 5, bottom: 5),
            height: 140,
            width: 130,
            //color: Colors.blue,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0,3.0),
                  blurRadius: 30,
                  spreadRadius: -8,
                ),
              ],
              image: DecorationImage(
                image: CachedNetworkImageProvider(meals[index].url),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10),
              //border: Border.all(color: Colors.black12),
            ),
            child: Container(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/2-10, right: 10, bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors:[
                      Hexcolor("#616161").withOpacity(0.2),
                      Hexcolor("#000000").withOpacity(0.4)
                    ],
                    stops: [0.2, 0.7],
                    begin: Alignment.bottomLeft,
                  )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(meals[index].mealName,textAlign: TextAlign.left,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)
                    ),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.flash_on_rounded, color: Colors.white,size: 14,),
                      Text(meals[index].calories.toString(),textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14)
                        ),),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 3, right: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue, width: 2),
                    ),
                    child: Text(intl.DateFormat.Hm().format(meals[index].datetime.toDate()), style: GoogleFonts.poppins(textStyle:
                    TextStyle(fontSize: 10.0, color: Colors.white, fontWeight: FontWeight.w500),),),
                  ),
                ],
              ),
            ),
          );
        },

      ),
    );
  }

  planMeal(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => Planner(userProfileId: userProfileId)));
  }

}

class OrdersItem extends StatelessWidget {
  final datetime;
  final String location;
  final String mealName;
  final String mealId;
  final int status;
  final String custId;
  final double calories;
  final String orderId;
  final String userProfileImg;
  final String url;
  final String userProfileId;
  OrdersItem({
    this.url,
    this.status,
    this.userProfileImg,
    this.datetime,
    this.calories,
    this.custId,
    this.location,
    this.mealName, this.mealId, this.userProfileId, this.orderId});

  factory OrdersItem.fromDocument(DocumentSnapshot documentSnapshot, String userProfileId){
    return OrdersItem(
      custId: documentSnapshot["custId"],
      url: documentSnapshot["url"],
      userProfileImg: documentSnapshot["userProfileImg"],
      datetime: documentSnapshot["datetime"],
      status: documentSnapshot["status"],
      location: documentSnapshot["location"],
      mealName: documentSnapshot["mealName"],
      mealId: documentSnapshot["mealId"],
      orderId: documentSnapshot["orderId"],
      calories: documentSnapshot["calories"],
      userProfileId : userProfileId,
    );
  }


  @override
  Widget build(BuildContext context) {
    String stats;
    if(status==0){
      stats = "Unprepared";
    }else if(status==1){
      stats = "Preparing";
    }else if(status==2){
      stats = "Cooking";
    }else if(status==3){
      stats = "Delivering";
    }else {
      stats = "Delivered";
    }
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5),
      height: 140,
      width: 130,
      //color: Colors.blue,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0,3.0),
            blurRadius: 30,
            spreadRadius: -8,
          ),
        ],
        image: DecorationImage(
          image: CachedNetworkImageProvider(url),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(10),
        //border: Border.all(color: Colors.black12),
      ),
      child: Container(
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/2-10, right: 10, bottom: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors:[
                Hexcolor("#616161").withOpacity(0.2),
                Hexcolor("#000000").withOpacity(0.4)
              ],
              stops: [0.2, 0.7],
              begin: Alignment.bottomLeft,
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(mealName,textAlign: TextAlign.left,
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)
              ),),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.flash_on_rounded, color: Colors.white,size: 14,),
                Text(calories.toString(),textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14)
                  ),),
              ],
            ),
            Container(
              padding: EdgeInsets.only(left: 3, right: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue, width: 2),
              ),
              child: Text(intl.DateFormat.Hm().format(datetime.toDate()), style: GoogleFonts.poppins(textStyle:
              TextStyle(fontSize: 10.0, color: Colors.white, fontWeight: FontWeight.w500),),),
            ),
          ],
        ),
      ),
    );
  }

  displayDetails(context, userProfileId){
    Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailsPage(userProfileId: userProfileId, orderId: orderId)));
  }

}

