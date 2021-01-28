import 'package:flutter/material.dart';
import 'package:meally2/HomePage.dart';
import 'package:meally2/restaurant/ReviewPage.dart';
import 'package:meally2/widgets/ProgressWidget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart' as intl;

class OrderDetailsPage extends StatefulWidget {
  final String userProfileId;
  final String orderId;
  OrderDetailsPage({this.userProfileId, this.orderId});
  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState(userProfileId: userProfileId, orderId:orderId);
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final String userProfileId;
  final String orderId;
  _OrderDetailsPageState({this.userProfileId, this.orderId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //Text(userProfileId),
          topBar(),
          Expanded(child: retrieveOrder())
        ],
      ),
    );
  }

  topBar(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 90,
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 30, left: 20, right: 20),
      margin: EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        color:Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0,5.0),
            blurRadius: 30,
            spreadRadius: -10,
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: Icon(Icons.clear_rounded),
          ),
          SizedBox(width: 20,),
          Text("Your order", style: GoogleFonts.poppins(textStyle:
          TextStyle(fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.w600),),),
        ],
      ),
    );
  }

  retrieveOrder(){
    return StreamBuilder(
      stream: custOrdersReference.document(userProfileId).collection("custOrder").where("orderId",isEqualTo: orderId).snapshots(),
      builder: (context, dataSnapshot){
        if(!dataSnapshot.hasData){
          return circularProgress(Colors.orangeAccent);
        }
        List<OrdersItem> ordersItem = [];
        dataSnapshot.data.documents.forEach((document){
          ordersItem.add(OrdersItem.fromDocument(document, userProfileId));
        });
        return ListView(
          children: ordersItem,
        );
      },
    );
  }
}

class OrdersItem extends StatelessWidget {
  final datetime;
  final String location;
  final String mealName;
  final String mealId;
  final int status;
  final String custId;
  final String userProfileImg;
  final String url;
  final String restId;
  final String orderId;
  final String userProfileId;
  OrdersItem({
    this.url,
    this.status,
    this.userProfileImg,
    this.datetime,
    this.custId,
    this.location,
    this.mealName, this.mealId, this.userProfileId, this.restId,this.orderId});

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
      restId: documentSnapshot["restId"],
      orderId: documentSnapshot["orderId"],
      userProfileId : userProfileId,
    );
  }


  @override
  Widget build(BuildContext context) {
    String gifUrl;
    String stats;
    double width = MediaQuery.of(context).size.width-80;
    double prog1 = 0;
    double prog2 = 0;
    double prog3 = 0;
    double prog4 = 0;
    if(status==0){
      gifUrl = "https://i.ibb.co/P94vs90/31454-food-prepared-food-app.gif";
      prog1 = 0;
      prog2 = 0;
      prog3 = 0;
      prog4 = 0;
      stats = "Unprepared";
    }else if(status==1){
      gifUrl = "https://i.ibb.co/mtGS1bw/6519-cooking.gif";
      prog1 = null;
      prog2 = 0;
      prog3 = 0;
      prog4 = 0;
      stats = "Preparing";
    }else if(status==2){
      gifUrl = "https://i.ibb.co/y65w54J/cooking.gif";
      prog1 = 1;
      prog2 = null;
      prog3 = 0;
      prog4 = 0;
      stats = "Cooking";
    }else if(status==3){
      gifUrl = "https://i.ibb.co/tzdDLtC/21653-delivery-guy-out-for-delivery.gif";
      prog1 = 1;
      prog2 = 1;
      prog3 = null;
      prog4 = 0;
      stats = "Delivering";
    }else {
      gifUrl = "https://i.ibb.co/4Nw32xB/29278-courier.gif";
      prog1 = 1;
      prog2 = 1;
      prog3 = 1;
      prog4 = 1;
      stats = "Delivered";
    }
    return Container(
        height: MediaQuery.of(context).size.height-115,
        alignment: Alignment.center,
        //padding: EdgeInsets.only(left: 30, right: 30, top: 20),
        decoration: BoxDecoration(
          //color: Hexcolor("#F8F8F8"),
          //borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Scaffold(
            body: Container(
              alignment: Alignment.center,
              child: ListView(
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (status==0) Text("Please wait", textAlign: TextAlign.center, style: GoogleFonts.poppins(textStyle:
                  TextStyle(fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.w500),),),

                  if (status==4) Text("Enjoy your food!", textAlign: TextAlign.center, style: GoogleFonts.poppins(textStyle:
                  TextStyle(fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                  Container(
                    height: 180,
                    margin: EdgeInsets.only(bottom: 20, top: 20),
                    //width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      child: Image(
                        image: NetworkImage(gifUrl),
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                    padding: EdgeInsets.only(left: 15, right: 15),
                    height: 80,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11.0),
                      color:Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0.0,0.0),
                          blurRadius: 30,
                          spreadRadius: -10,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(intl.DateFormat.Hm().format(datetime.toDate()), style: GoogleFonts.poppins(textStyle:
                            TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                            Text(stats, style: GoogleFonts.poppins(textStyle:
                            TextStyle(fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 6, bottom: 20),
                              width: width/4-20,
                              height: 8,
                              child:  ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                child: LinearProgressIndicator(
                                  value: prog1,
                                  backgroundColor: Colors.black12,
                                  valueColor: AlwaysStoppedAnimation(Colors.orangeAccent,),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 6, bottom: 20),
                              width: width/4+15,
                              height: 8,
                              child:  ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                child: LinearProgressIndicator(
                                  value: prog2,
                                  backgroundColor: Colors.black12,
                                  valueColor: AlwaysStoppedAnimation(Colors.orangeAccent,),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 6, bottom: 20),
                              width: width/4+30,
                              height: 8,
                              child:  ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                child: LinearProgressIndicator(
                                  value:prog3,
                                  backgroundColor: Colors.black12,
                                  valueColor: AlwaysStoppedAnimation(Colors.orangeAccent,),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 6, bottom: 20),
                              width: width/4-30,
                              height: 8,
                              child:  ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                child: LinearProgressIndicator(
                                  value: prog4,
                                  backgroundColor: Colors.black12,
                                  valueColor: AlwaysStoppedAnimation(Colors.orangeAccent,),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                    padding: EdgeInsets.only(left: 15, right: 15),
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11.0),
                      color:Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0.0,0.0),
                          blurRadius: 30,
                          spreadRadius: -10,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          //color: Colors.blue,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("order details", style: GoogleFonts.poppins(textStyle:
                              TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                              Divider(thickness: 1,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("order id", style: GoogleFonts.poppins(textStyle:
                                  TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                                  Container(
                                    width:  MediaQuery.of(context).size.width-150,
                                    child: Text(orderId, textAlign: TextAlign.right, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(textStyle:
                                    TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w600),),),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("meal name", style: GoogleFonts.poppins(textStyle:
                                  TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                                  Text(mealName, style: GoogleFonts.poppins(textStyle:
                                  TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w600),),),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("price", style: GoogleFonts.poppins(textStyle:
                                  TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                                  Text(mealName, style: GoogleFonts.poppins(textStyle:
                                  TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w600),),),
                                ],
                              ),
                              /*
                              GestureDetector(
                                onTap: ()=> displayComment(context, mealId: mealId, ownerId: restId, url: url),
                                child: Text(mealName, style: GoogleFonts.poppins(textStyle:
                                TextStyle(fontSize: 19.0, color: Colors.black, fontWeight: FontWeight.w600),),),
                              ),

                               */
                            ],
                          ),
                        ),
                        if (status==3) GestureDetector(
                            onTap: (){updateStatus(userProfileId, restId, orderId);},
                            child: Text("Delivered")),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    padding: EdgeInsets.only(left: 15, right: 15),
                    height: 80,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11.0),
                      color:Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0.0,0.0),
                          blurRadius: 30,
                          spreadRadius: -10,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          //color: Colors.blue,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.location_pin, color: Colors.redAccent, size: 18,),
                                  Container(
                                    width:  MediaQuery.of(context).size.width-100,
                                    child: Text(location, textAlign: TextAlign.left, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(textStyle:
                                    TextStyle(fontSize: 13.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.location_pin, color: Colors.blue, size: 18,),
                                  Container(
                                    width:  MediaQuery.of(context).size.width-100,
                                    child: Text(location, textAlign: TextAlign.left, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(textStyle:
                                    TextStyle(fontSize: 13.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          bottomSheet: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child:
            FlatButton(
              onPressed: (){
                if (status==3){
                  updateStatus(userProfileId, restId, orderId);
                }else if (status==4) {
                  displayComment(context, mealId: mealId, ownerId: restId, url: url);
                }else{
                  Navigator.pop(context);
                }
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
                child:
                Text(status<3 ? "back" : status==3 ? "Meal Delivered" : "Leave Review" ,textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)
                  ),),
                alignment: Alignment.center,
              ),
            ),
          ),
        )
    );
  }

  displayComment(BuildContext context, {String mealId, String ownerId, String url}){
    Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewPage(mealId: mealId, mealOwnerId: ownerId, mealImageUrl: url, restOnline: false)));
  }
  updateStatus(userProfileId, restId, orderId){
    custOrdersReference.document(userProfileId).collection("custOrder").document(orderId).updateData({
      "status": 4,
    });
    ordersReference.document(restId).collection("order").document(orderId).updateData({
      "status": 4,
    });
  }

}
