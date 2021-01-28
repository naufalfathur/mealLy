import 'package:flutter/material.dart';
import 'package:meally2/HomePage.dart';
import 'package:meally2/main/OrderDetailsPage.dart';
import 'package:meally2/models/user.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meally2/widgets/ProgressWidget.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class MyOrderPage extends StatefulWidget {
  final String userProfileId;
  final User gCurrentUser;
  MyOrderPage({this.userProfileId, this.gCurrentUser});
  @override
  _MyOrderPageState createState() => _MyOrderPageState(gCurrentUser:gCurrentUser, userProfileId:userProfileId);
}

class _MyOrderPageState extends State<MyOrderPage> {
  final User gCurrentUser;
  final String userProfileId;
  _MyOrderPageState({this.userProfileId, this.gCurrentUser});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: topBar(),
          toolbarHeight: 180,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          bottom: TabBar(
            indicatorColor: Colors.orangeAccent,
            tabs: [
              Tab(text: 'Current'),
              Tab(text: 'Past'),
            ],
            labelColor: Colors.black,
            indicator: MaterialIndicator(
              height: 5,
              topLeftRadius: 8,
              topRightRadius: 8,
              color: Colors.orangeAccent,
              horizontalPadding: 50,
              tabPosition: TabPosition.bottom,
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Container(child: retrieveOrder()),
            Container(child: retrievePastOrder()),
          ],
        ),
      ),
    );
  }

  topBar(){
    return Container(
      width: MediaQuery.of(context).size.width,
      //color: Colors.blue,
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.only(top: 60, left: 20, right: 20),
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: (){Navigator.pop(context);},
              child: Icon(Icons.arrow_back_ios_rounded, color: Colors.orangeAccent,)),
          SizedBox(height: 5,),
          Text("Orders",
            style: GoogleFonts.poppins(
                textStyle: TextStyle(color: Colors.orangeAccent,
                    fontWeight: FontWeight.w600,
                    fontSize: 27)
            ),),
        ],
      )
    );
  }
  /*
  pastOrder(){
    return Container(
        width: MediaQuery.of(context).size.width,
        //height: 210,
        alignment: Alignment.bottomLeft,
        padding: EdgeInsets.only(top: 10, left: 20, right: 20),
        //margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          //color: Hexcolor("#FF9900"),
        ),
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("past",
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18)
              ),),
            Divider(thickness: 2,color: Colors.black,)
          ],
        )
    );
  }
  
   */
  retrieveOrder(){
    return StreamBuilder(
      stream: custOrdersReference.document(userProfileId).collection("custOrder").where("status", isLessThan: 4).orderBy("status", descending: false).snapshots(),
      builder: (context, dataSnapshot){
        if(!dataSnapshot.hasData){
          return circularProgress(Colors.orangeAccent);
        }
        List<OrdersItem> comments = [];
        dataSnapshot.data.documents.forEach((document){
          comments.add(OrdersItem.fromDocument(document, userProfileId));
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

  retrievePastOrder(){
    return StreamBuilder(
      stream: custOrdersReference.document(userProfileId).collection("custOrder").where("status", isEqualTo: 4).snapshots(),
      builder: (context, dataSnapshot){
        if(!dataSnapshot.hasData){
          return circularProgress(Colors.orangeAccent);
        }
        List<OrdersItem> comments = [];
        dataSnapshot.data.documents.forEach((document){
          comments.add(OrdersItem.fromDocument(document, userProfileId));
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
}

class OrdersItem extends StatelessWidget {
  final datetime;
  final String location;
  final String mealName;
  final String mealId;
  final int status;
  final String custId;
  final String orderId;
  final String userProfileImg;
  final String url;
  final String userProfileId;
  OrdersItem({
    this.url,
    this.status,
    this.userProfileImg,
    this.datetime,
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
    return Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: GestureDetector(
            onTap: (){displayDetails(context, userProfileId);},
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  //top: BorderSide(width: 2.0, color: Hexcolor("#9D9D9D")),
                  bottom: BorderSide(width: 1.0, color: Hexcolor("#E8E8E8")),
                ),
                color: Colors.white,
              ),
              child: ListTile(
                //leading: CircleAvatar(backgroundImage: CachedNetworkImageProvider(userProfileImg)),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(datetime.toDate().toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700,color: Colors.black),),
                    Text(mealName , style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,color: Colors.black),),
                  ],
                ),
                subtitle: Text("Status : $stats", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,
                    color: status == 0 ? Colors.red:Colors.black),),
                trailing: Icon(Icons.arrow_forward_ios_rounded, size: 15,)
              ),
            )
        )
    );
  }

  displayDetails(context, userProfileId){
    Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailsPage(userProfileId: userProfileId, orderId: orderId)));
  }

}
