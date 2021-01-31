import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meally2/HomePage.dart';
import 'package:meally2/main/NotificationPage.dart';
import 'package:meally2/main/OrderListsPage.dart';
import 'package:meally2/main/OrderPage.dart';
import 'package:meally2/main/RestaurantHome.dart';
import 'package:meally2/models/restaurant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meally2/restaurant/ReviewPage.dart';
import 'package:meally2/widgets/ProgressWidget.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:intl/intl.dart' as intl;

class restaurantMain extends StatefulWidget {
  final String userRestId;
  final Restaurant gCurrentRest;

  restaurantMain({this.userRestId, this.gCurrentRest});
  @override
  _restaurantMainState createState() => _restaurantMainState(userRestId:userRestId);
}

class _restaurantMainState extends State<restaurantMain> {
  final String userRestId;
  _restaurantMainState({this.userRestId});
  double earn= 0.0;
  double rateTot;
  double rate;
  final now = DateTime.now();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    // TODO: implement initState
    getEarnings();
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: getEarnings,
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            //topBar()
            earnings(),
            widgets(),
            SizedBox(height: 15,),
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: HexColor("#FF9900"),
                //color: HexColor("#181716"),
                //color: Colors.white,
                image: DecorationImage(
                  alignment: Alignment(-1, 0),
                  image: AssetImage("assets/images/bg.png"),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.2),
                    offset: Offset(-2.0,3.0),
                    blurRadius: 20,
                    spreadRadius: -8,
                  ),
                ],
                //border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(15),
              ),
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 25, right: 25),
              padding: EdgeInsets.only(left: 15, right: 10,top: 10, bottom: 10),
              width: MediaQuery.of(context).size.width,
              child: retrieveNextMeals(),
            ),
            SizedBox(height: 15,),
            Container(
              height: 220,
              margin: EdgeInsets.only(left: 15, right: 15),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black12, width: 2.5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    height: 30,
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Active orders",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600, fontSize: 14)
                          ),),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => OrderListsPage(userRestId: currentRest.id, gCurrentRest: currentRest,)));
                          },
                          child: Text("see all",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600, fontSize: 14)
                            ),),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: activeOrder(),
                  )
                ],
              ),
            ),
            SizedBox(height: 15,),
            Divider(thickness: 1,),
            Padding(
              padding: const EdgeInsets.only(left: 15, bottom: 10),
              child: Text("Customers Reviews",
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black)
                ),),
            ),

            Container(
              height: 200,
              child: notification(),
            )
            //activeOrders()
          ],
        ),
      ),
    );
  }


  activeOrder(){
    return StreamBuilder(
      stream: ordersReference.document(userRestId).collection("order").orderBy("datetime", descending: false).snapshots(),
      builder: (context, dataSnapshot){
        if(!dataSnapshot.hasData){
          return circularProgress(Colors.orangeAccent);
        }
        List<OrdersItem> comments = [];
        dataSnapshot.data.documents.forEach((document){
          comments.add(OrdersItem.fromDocument(document, userRestId));
        });
        if(comments.isEmpty){
          return Center(child: Text("No Data Available"));
        }
        return ListView(
          children: comments,
        );
      },
    );
  }

  notification(){
    return StreamBuilder(
      stream: activityFeedReference.document(currentRest.id)
          .collection("activityItems")
          .where("type",isEqualTo: "comment").snapshots(),
      builder:  (context, dataSnapshot){
        if(!dataSnapshot.hasData){
          return circularProgress(Colors.orangeAccent);
        }
        List<NotificationsItem> notification = [];
        dataSnapshot.data.documents.forEach((document){
          notification.add(NotificationsItem.fromDocument(document));
        });
        return ListView(children: notification);
      },
    );
  }

  retrieveNextMeals(){
    return StreamBuilder(
      stream: ordersReference.document(userRestId).collection("order")
          .where("datetime", isGreaterThanOrEqualTo: DateTime(now.year, now.month, now.day, now.hour, now.minute),
          isLessThan: DateTime(now.year, now.month, now.day+ 1))
          .limit(1).snapshots(),

      builder: (context, dataSnapshot){
        if(!dataSnapshot.hasData){
          return circularProgress(Colors.orangeAccent);
        }
        List<OrdersItem> comments = [];
        dataSnapshot.data.documents.forEach((document){
          comments.add(OrdersItem.fromDocument(document, userRestId));
        });
        if(comments.isEmpty){
          return Center(
            child: Text(
              "No Delivery in this time", style: TextStyle(color: Colors.white),
            ),
          );
        }
        return ListView.builder(
          itemCount: comments.length,
          itemBuilder: (BuildContext context, int index){
            return Container(
              height: 120,
              //color: Colors.blue,
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Next Delivery",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Colors.white)
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(13),
                          image: DecorationImage(
                            image: NetworkImage(comments[index].url),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Text("Next Delivery:\n"+comments[index].mealName,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Colors.white)
                        ),
                      ),
                      SizedBox(width: 100,),
                      Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 15,)
                    ],
                  ),
                  SizedBox(height: 3,),
                  Divider(color: Colors.white,),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.white, size: 12,),
                      SizedBox(width: 5,),
                      Text(intl.DateFormat.Hm().format(comments[index].datetime.toDate()), style: GoogleFonts.poppins(textStyle:
                      TextStyle(fontSize: 11.0, color: Colors.white, fontWeight: FontWeight.w500),),)
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<double> getEarnings() async{
    DocumentReference documentReference =  restReference.document(userRestId);
    await documentReference.get().then((snapshot) {
      setState(() {
        earn = double.tryParse(snapshot.data['earnings'].toStringAsFixed(2));
      });
    });
    print("earn = "+earn.toString());
  }

  retrieveOrder(DateTime date) {
    return StreamBuilder(
      stream: ordersReference.document(userRestId).collection("order").where("datetime", isGreaterThanOrEqualTo:
      DateTime(date.year, date.month, date.day), isLessThan: DateTime(date.year, date.month, date.day+ 1
      )).snapshots(),
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
          return Container(
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("You have",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)
                  ),),
                Row(
                  children: [
                    Text("0",
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500, fontSize: 65, height: 1.3,)
                      ),),
                    Text(" meals",
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18, height: 4.5,)
                      ),),
                  ],
                ),
                Text("sold today, Steady!",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 11, height: 0.8 )
                  ),),
              ],
            ),
          );
        }
        return Container(
          height: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("You have",
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)
                ),),
              Row(
                children: [
                  Text(comments.length.toString(),
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500, fontSize: 65, height: 1.3,)
                    ),),
                  Text(" meals",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18, height: 4.5,)
                    ),),
                ],
              ),
              Text("sold today, nice !",
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 11, height: 0.8 )
                ),),
            ],
          ),
        );
      },
    );

  }

  retrieveRating() {
    return StreamBuilder(
      stream: activityFeedReference.document(currentRest.id)
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
          return Container(
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Your\nRating",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)
                  ),),
                Text("0.0",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 45, height: 1.2 )
                  ),),
                SmoothStarRating(
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
              ],
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

        return Container(
          height: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Your\nRating",
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)
                ),),
              Text(rate.toStringAsFixed(2),
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 45, height: 1.2 )
                ),),
              SmoothStarRating(
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
            ],
          ),
        );
      },
    );

  }

  getSold(){

  }

  topBar(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 20, right: 20, top: 10),
      decoration: BoxDecoration(
        color: HexColor("#FF9900"),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(Icons.menu_rounded, color: Colors.white, size: 30,),
          Text("Welcome!",textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 25)
            ),),
          Text("m.",textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 25)
            ),),
        ],
      ),
    );
  }

  earnings(){
    return Container(
      margin: EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 15),
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      height: 90,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color : Colors.black)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Earnings",textAlign: TextAlign.left,
            style: GoogleFonts.poppins(
                textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)
            ),),
          Text("RM $earn",textAlign: TextAlign.left,
            style: GoogleFonts.poppins(
                textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 30)
            ),),
        ],
      ),
    );
  }
  widgets(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: (){
            //Navigator.push(context, MaterialPageRoute(builder: (context) => ProgressPage(userProfileId: currentUser.id, gCurrentUser: currentUser,)));
          },
          child: Container(
            height: 160,
            width: 150,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: HexColor("#575757"),
              borderRadius: BorderRadius.circular(15),
            ),
            child: retrieveOrder(DateTime.now()),
          ),
        ),
        SizedBox(width: 10,),
        Container(
          height: 160,
          padding: EdgeInsets.all(15),
          width: 150,
          decoration: BoxDecoration(
            color: HexColor("#FF4747"),
            borderRadius: BorderRadius.circular(15),
          ),
          child: retrieveRating(),
        )
      ],
    );
  }
}

class OrdersItem extends StatelessWidget {
  final datetime;
  final String location;
  final String mealName;
  final String mealId;
  final int status;
  final double calories;
  final String custId;
  final String orderId;
  final String userProfileImg;
  final String url;
  final price;
  final String userRestId;
  OrdersItem({
    this.url,
    this.status,
    this.userProfileImg,
    this.datetime,
    this.calories,
    this.custId,
    this.location,
    this.price,
    this.mealName, this.mealId, this.userRestId, this.orderId});

  factory OrdersItem.fromDocument(DocumentSnapshot documentSnapshot, String userRestId){
    return OrdersItem(
      custId: documentSnapshot["custId"],
      url: documentSnapshot["url"],
      userProfileImg: documentSnapshot["userProfileImg"],
      datetime: documentSnapshot["datetime"],
      status: documentSnapshot["status"],
      location: documentSnapshot["location"],
      mealName: documentSnapshot["mealName"],
      calories: documentSnapshot["calories"],
      mealId: documentSnapshot["mealId"],
      orderId: documentSnapshot["orderId"],
      price: documentSnapshot["price"],
      userRestId : userRestId,
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
    return Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: GestureDetector(
            onTap: (){},
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  //top: BorderSide(width: 2.0, color: HexColor("#9D9D9D")),
                  bottom: BorderSide(width: 1.0, color: HexColor("#E8E8E8")),
                ),
                color: Colors.white,
              ),
              child: ListTile(
                //leading: CircleAvatar(backgroundImage: CachedNetworkImageProvider(userProfileImg)),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(datetime.toDate().toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,color: Colors.black54),),
                      Text(mealName , style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400,color: Colors.black54),),
                      Text("Status : $stats", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400,
                          color: status == 0 ? Colors.red:Colors.black54),),
                    ],
                  ),
                  trailing: Text("+ rm" + price.toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,color: Colors.blue),),
              ),
            )
        )
    );
  }

}

