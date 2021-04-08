import 'package:flutter/material.dart';
import 'package:meally2/HomePage.dart';
import 'package:meally2/models/restaurant.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meally2/widgets/ProgressWidget.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:intl/intl.dart' as intl;
class OrderListsPage extends StatefulWidget {
  final String userRestId;
  final Restaurant gCurrentRest;

  OrderListsPage({this.userRestId, this.gCurrentRest});
  @override
  _OrderListsPageState createState() => _OrderListsPageState(userRestId: userRestId);
}

class _OrderListsPageState extends State<OrderListsPage> {
  final String userRestId;
  _OrderListsPageState({this.userRestId});

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
              color: Colors.black,
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
        padding: EdgeInsets.only(top: 40, left: 20, right: 20),
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
                onTap: (){Navigator.pop(context);},
                child: Icon(Icons.arrow_back_ios_rounded, color: Colors.black,)),
            SizedBox(height: 5,),
            Text("Orders",
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: Colors.black,
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
          //color: HexColor("#FF9900"),
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
      stream: ordersReference.document(userRestId).collection("order").where("status", isLessThan: 4).orderBy("status", descending: false).snapshots(),
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

  retrievePastOrder(){
    return StreamBuilder(
      stream: ordersReference.document(userRestId).collection("order").where("status", isEqualTo: 4).snapshots(),
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
                    Text(intl.DateFormat('EEEE').format(DateTime.parse(datetime.toDate().toString())) + " " + intl.DateFormat.Hm().format(datetime.toDate()), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,color: Colors.black54),),
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