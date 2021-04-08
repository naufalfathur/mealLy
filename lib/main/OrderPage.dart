import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meally2/HomePage.dart';
import 'package:meally2/main/RestaurantHome.dart';
import 'package:meally2/models/restaurant.dart';
import 'package:meally2/widgets/ProgressWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as tAgo;
import 'package:intl/intl.dart' as intl;
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:maps_launcher/maps_launcher.dart';


class OrderPage extends StatefulWidget {
  final String userRestId;
  final Restaurant gCurrentRest;

  OrderPage({this.userRestId, this.gCurrentRest});
  @override
  _OrderPageState createState() => _OrderPageState(userRestId:userRestId);
}

class _OrderPageState extends State<OrderPage> {
  var now = DateTime.now();
  final String userRestId;
  PageController pageController = PageController();
  DatePickerController _controller = DatePickerController();
  List<OrdersItem> meals;
  _OrderPageState({this.userRestId});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //topBar(),
          //Expanded(child: retrieveOrder())
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
      )
    );
  }





  retrieveOrder(DateTime date) {
    /*
    QuerySnapshot querySnapshot =  await ordersReference.document(userRestId)
        .collection("order").where("datetime", isGreaterThanOrEqualTo: DateTime(date.year, date.month, date.day)
        , isLessThan: DateTime(date.year, date.month, date.day+ 1)).getDocuments();
    setState(() {
      meals = querySnapshot.documents.map((document) => OrdersItem.fromDocument(document, userRestId)).toList();
    });
      */
    print("a");
    return StreamBuilder(
      stream: ordersReference.document(userRestId).collection("order").where("datetime", isGreaterThanOrEqualTo:
      DateTime(date.year, date.month, date.day), isLessThan: DateTime(date.year, date.month, date.day+ 1)).snapshots(),
      builder: (context, dataSnapshot){
        print("b");
        if(!dataSnapshot.hasData){
          print("c");
          return circularProgress(Colors.orangeAccent);
        }
        print("d");
        List<OrdersItem> comments = [];
        dataSnapshot.data.documents.forEach((document){
          comments.add(OrdersItem.fromDocument(document, userRestId));
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
}



class OrdersItem extends StatelessWidget {
  final String CustomerName;
  final String commentData;
  final datetime;
  final String location;
  final String mealName;
  final String userRestId;
  final String mealId;
  final int status;
  final String orderId;
  final String custId;
  final String userProfileImg;
  final String url;
  final price;
  int changedStatus;
  OrdersItem({
    this.url,
    this.CustomerName,
    this.commentData,
    this.status,
    this.userProfileImg,
    this.price,
    this.datetime,
    this.custId,
    this.location,
    this.mealName, this.mealId, this.userRestId, this.orderId});

  factory OrdersItem.fromDocument(DocumentSnapshot documentSnapshot, String userRestId){
    return OrdersItem(
      CustomerName: documentSnapshot["CustomerName"],
      commentData: documentSnapshot["commentData"],
      custId: documentSnapshot["custId"],
      url: documentSnapshot["url"],
      userProfileImg: documentSnapshot["userProfileImg"],
      datetime: documentSnapshot["datetime"],
      status: documentSnapshot["status"],
      location: documentSnapshot["location"],
      mealName: documentSnapshot["mealName"],
      mealId: documentSnapshot["mealId"],
      price: documentSnapshot["price"],
      orderId: documentSnapshot["orderId"],
      userRestId : userRestId,
    );
  }


  @override
  Widget build(BuildContext context) {
    String stats;
    Color color;
    if(status==0){
      stats = "Unprepared";
      color = Colors.redAccent;
    }else if(status==1){
      stats = "Preparing";
      color = Colors.orangeAccent;
    }else if(status==2){
      stats = "Cooking";
      color = Colors.blueAccent;
    }else if(status==3){
      stats = "Delivering";
      color = Colors.green;
    }else {
      stats = "Delivered";
      color = Colors.green;
    }
    return GestureDetector(
      onTap: (){
        _successModal(context);
      },
      child: Container(
        margin: EdgeInsets.only(top: 5, bottom: 10),
        height: 140,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 10,),
            Container(
              width: 40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(height: 50, width: 3, color: Colors.black38,),
                  Text(intl.DateFormat.Hm().format(datetime.toDate()), style: GoogleFonts.poppins(textStyle:
                  TextStyle(fontSize: 10.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                  Container(height: 50, width: 3, color: Colors.black38,),
                ],
              ),
            ),
            SizedBox(width: 10,),
            Container(
              height: 140,
              width: 140,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(url),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
                //border: Border.all(color: Colors.black12),
              ),
            ),
            SizedBox(width: 15,),
            Container(
              //color: Colors.blue,
              width: MediaQuery.of(context).size.width/3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 3, right: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue, width: 2),
                    ),
                    child: Text("+ rm" + price.toString(), style: GoogleFonts.poppins(textStyle:
                    TextStyle(fontSize: 10.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                  ),
                  Text(mealName,textAlign: TextAlign.left,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 19)
                    ),),
                  Text(CustomerName,textAlign: TextAlign.left, overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12)
                    ),),
                  Text(location,textAlign: TextAlign.left, overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12)
                    ),),
                  Container(
                    height: 25,
                    width: MediaQuery.of(context).size.width/3-20,
                    color: color,
                    alignment: Alignment.center,
                    child: Text(stats,textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 10)
                      ),),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _successModal(context){
    List<bool> isSelected = [false, false, false];
    showModalBottomSheet(
        context: context, isScrollControlled:true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (BuildContext bc){
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState){
                return Container(
                    height: MediaQuery.of(context).size.height-130,
                    alignment: Alignment.center,
                    //padding: EdgeInsets.only(left: 30, right: 30, top: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      //borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    ),
                    child: Scaffold(
                        body:  Stack(
                          children: [
                            Container(
                              height: 310,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                //borderRadius: BorderRadius.circular(5.0),
                                image: DecorationImage(
                                  image: NetworkImage(url),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Container(
                                height: 350,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: HexColor("#000000").withOpacity(0.3)//HexColor("#690000").withOpacity(0.35)
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: GestureDetector(
                                onTap: (){Navigator.pop(context);},
                                child: Container(
                                  padding: EdgeInsets.only(left: 20, right: 20, top: 5),
                                  height: 55,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(Icons.arrow_back_ios_rounded,size: 14, color: Colors.black,),
                                      Text("Order details", style: GoogleFonts.poppins(textStyle:
                                      TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 390,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                ),
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 80,
                                        width: MediaQuery.of(context).size.width,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15.0),
                                          image: DecorationImage(
                                            image: AssetImage("assets/images/bg.png"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("Delivery for " + intl.DateFormat('EEEE').format(DateTime.parse(datetime.toDate().toString())) + " " + intl.DateFormat.Hm().format(datetime.toDate()), style: GoogleFonts.poppins(textStyle:
                                            TextStyle(fontSize: 15.0, color: Colors.white, fontWeight: FontWeight.w600),),),
                                            Text(mealName, style: GoogleFonts.poppins(textStyle:
                                            TextStyle(fontSize: 15.0, color: Colors.white, fontWeight: FontWeight.w700),),),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 15,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Ordered by ", style: GoogleFonts.poppins(textStyle:
                                          TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w600),),),
                                          Container(
                                            height: 20,
                                            width: MediaQuery.of(context).size.width-150,
                                            child: Text(CustomerName,textAlign: TextAlign.right, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(textStyle:
                                            TextStyle(fontSize: 14.0, color: Colors.black45, fontWeight: FontWeight.w500),),),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15,),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Order Id", style: GoogleFonts.poppins(textStyle:
                                          TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w600),),),
                                          Container(
                                            height: 40,
                                            width: MediaQuery.of(context).size.width-150,
                                            child: Text(orderId, textAlign: TextAlign.right,
                                              style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 12.0, color: Colors.black45, fontWeight: FontWeight.w500),),),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5,),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Address", style: GoogleFonts.poppins(textStyle:
                                          TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w600),),),
                                          Container(
                                            height: 60,
                                            width: MediaQuery.of(context).size.width-150,
                                            child: Text(location, textAlign: TextAlign.right,
                                              style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 12.0, color: Colors.black45, fontWeight: FontWeight.w500),),),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15,),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: HexColor("#F6F6F6"),
                                          ),
                                          child:
                                          ToggleButtons(
                                            fillColor: Colors.orangeAccent,
                                            splashColor: Colors.blue,
                                            borderColor: Colors.white,
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(left: 15, right: 15),
                                                child: Text("Preparing", style: GoogleFonts.poppins(textStyle: TextStyle(color:Colors.black , fontWeight: FontWeight.w600),)),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(left: 15, right: 15),
                                                child: Text("Cooking", style: GoogleFonts.poppins(textStyle: TextStyle(color:Colors.black , fontWeight: FontWeight.w600),)),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(left: 15, right: 15),
                                                child: Text("Delivering", style: GoogleFonts.poppins(textStyle: TextStyle(color:Colors.black , fontWeight: FontWeight.w600),)),
                                              ),
                                            ],
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
                                                  changedStatus = 1;
                                                  print(changedStatus);
                                                  updateStatus(custId, userRestId, orderId);
                                                }else if(index == 1){
                                                  changedStatus = 2;
                                                  print(changedStatus);
                                                  updateStatus(custId, userRestId, orderId);
                                                }else if(index == 2){
                                                  changedStatus = 3;
                                                  print(changedStatus);
                                                  updateStatus(custId, userRestId, orderId);
                                                }
                                              });
                                            },
                                            isSelected: isSelected,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      bottomSheet:  Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: FlatButton(
                          onPressed: () => MapsLauncher.launchQuery(
                              location),
                          //color: HexColor("#FF9900"),
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
                            child: Text("Open Maps",textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)
                              ),),
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                    )
                );
              });
    });
  }
/*
  updateStatus(custId, userRestId, mealId){
    custOrdersReference.document(custId).collection("custOrder").document().updateData({
      "status": changedStatus,
    });
    ordersReference.document(userRestId).collection("order").document().updateData({
      "status": changedStatus,
    });
  }

 */
  updateStatus(custId, userRestId, orderId){
    print(custId);
    print(userRestId);
    print(orderId);
    custOrdersReference.document(custId).collection("custOrder").document(orderId).updateData({
      "status": changedStatus,
    });
    ordersReference.document(userRestId).collection("order").document(orderId).updateData({
      "status": changedStatus,
    });
    CustActivityFeedReference.document(custId).collection("activityItems").add({
      "type" : "CustOrder",
      "orderId" : orderId,
      "custId": custId,
      "CustomerName" : CustomerName,
      "mealUrl": url,
      "mealName" : mealName,
      "status": changedStatus,
      "mealId": mealId,
      "timestamp" : DateTime.now(),
    });

  }

}
