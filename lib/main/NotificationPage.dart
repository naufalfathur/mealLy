import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meally2/HomePage.dart';
import 'package:meally2/main/RestaurantHome.dart';
import 'package:meally2/widgets/ProgressWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as tAgo;
import 'package:smooth_star_rating/smooth_star_rating.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<bool> isSelected = [false, false];
  String types = "order";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: header(context, strTitle: "Notifications",),
      body: Column(
        children: <Widget>[
          topBar(),
          tabBar(),
          Expanded(
            child: notification(types),
          )
        ],
      ),
    );
  }
  topBar(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Notification",
            style: GoogleFonts.poppins(
                textStyle: TextStyle(color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 23)
            ),),
          Transform.rotate(
            angle: 25 * pi / 180,
            child: Icon(
              Icons.notifications_none_outlined,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  tabBar(){
    return Container(
      padding: EdgeInsets.only(left: 3, right: 3),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Hexcolor("#F6F6F6"),
        //border: Border.all(color: Colors.black, width: 1.0),
        //borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child:
      ToggleButtons(
        fillColor: Colors.orangeAccent,
        splashColor: Colors.blue,
        selectedBorderColor: Colors.white,
        borderColor: Colors.white,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width/2-5,
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Text("Orders", style: GoogleFonts.poppins(textStyle: TextStyle(color:Colors.black , fontWeight: FontWeight.w600),)),
          ),
          Container(
            width: MediaQuery.of(context).size.width/2-5,
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Text("Reviews", style: GoogleFonts.poppins(textStyle: TextStyle(color:Colors.black , fontWeight: FontWeight.w600),)),
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
              print(index);
              setState(() {
                types = "order";
              });
            }else {
              print(index);
              types = "comment";
            }
          });
        },
        isSelected: isSelected,
      ),
    );
  }

  notification(String types){
    return StreamBuilder(
      stream: activityFeedReference.document(currentRest.id)
          .collection("activityItems")
          .where("type",isEqualTo: types).snapshots(),
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
}

String notificationItemText;
Widget mediaPreview;
class NotificationsItem extends StatelessWidget {
  final String CustomerName;
  final String type;
  final String commentData;
  final datetime;
  final String location;
  final String mealName;
  final String mealId;
  final int status;
  final String userId;
  final rating;
  final String userProfileImg;
  final String url;
  final Timestamp timestamp;
  NotificationsItem({
    this.timestamp,
    this.url,
    this.CustomerName,
    this.mealId, this.userId,
    this.commentData, this.type,
    this.userProfileImg,
    this.status,
    this.rating, this.datetime,
  this.location, this.mealName});

  factory NotificationsItem.fromDocument(DocumentSnapshot documentSnapshot){
    return NotificationsItem(
      CustomerName: documentSnapshot["CustomerName"],
      type: documentSnapshot["type"],
      commentData: documentSnapshot["commentData"],
      mealId: documentSnapshot["mealId"],
      userId: documentSnapshot["userId"],
      rating: documentSnapshot["rating"],
      userProfileImg: documentSnapshot["userProfileImg"],
      url: documentSnapshot["url"],
      timestamp: documentSnapshot["timestamp"],
      datetime: documentSnapshot["datetime"],
      location: documentSnapshot["location"],
      mealName: documentSnapshot["mealName"],
      status: documentSnapshot["status"],
    );
  }

  @override
  Widget build(BuildContext context) {
    configureMediaPreview(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: whatNotif(context)
    );
  }

  whatNotif(BuildContext context){
    if(type == "comment"){
      return comment(context);
    }else if(type == "order"){
      return order(context);
    }else{
      return Container(
        child: Text("a"),
      );
    }
  }

  comment(BuildContext context){
    return Container(
      color: Colors.white54,
      child: ListTile(
        title: GestureDetector(
          onTap: ()=>displayUserProfile(context, userProfileId: userId),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(CustomerName + ": " , style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),),
                  SmoothStarRating(
                    rating: rating,
                    isReadOnly: true,
                    size: 12,
                    filledIconData: Icons.star,
                    halfFilledIconData: Icons.star_half,
                    defaultIconData: Icons.star_border,
                    color: Colors.orangeAccent,
                    starCount: 5,
                    allowHalfRating: true,
                    spacing: 2.0,
                  ),
                ],
              ),
              //Text(CustomerName + rating.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)),
              Text("$notificationItemText", style: TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),

          /*
            RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  children: [
                    TextSpan(text: CustomerName + rating.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
                    //TextSpan(text: " $notificationItemText", ),
                  ]
              ),
            ),
             */
        ),
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(userProfileImg),
        ),
        subtitle: Text(tAgo.format(timestamp.toDate()),style:  TextStyle(color: Colors.grey, fontSize: 12), overflow: TextOverflow.ellipsis,),
        trailing: mediaPreview,
      ),
    );
  }
  order(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
      padding: EdgeInsets.only(left: 20),
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0,3.0),
            blurRadius: 30,
            spreadRadius: -10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15,),
              Text(mealName,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.black45)
                  )),
              SizedBox(height: 15,),
              Text(CustomerName,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black)
                  )),
              Text("$notificationItemText",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black)
                  )),
              SizedBox(height: 10,),
              Text(datetime.toDate().toString(),
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 11, color: Colors.black45)
                  )),
              Text("Seri Kembangan, Selangor",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 11, color: Colors.black45)
                  )),
            ],
          ),
          Container(
            //height: 180,
            width: MediaQuery.of(context).size.width/3+20,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), topRight: Radius.circular(20)),
              image: DecorationImage(
                image: NetworkImage(url),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      )
    );
  }

  configureMediaPreview(context){
    if(type == "comment" || type == "order"){
      mediaPreview = GestureDetector(
        onTap: ()=> displayFullPost(context),
        child: Container(
          height: 50,
          width: 50,
          child: AspectRatio(
            aspectRatio: 16/9,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(fit: BoxFit.cover, image: CachedNetworkImageProvider(url)),
              ),
            ),
          ),
        ),
      );
    }else{
      mediaPreview = Text("");
    }
    if(type == "like"){
      notificationItemText = "Liked your post.";
    }else if(type == "comment"){
      notificationItemText = "Sent a review : $commentData";
    }else if(type == "order"){
      notificationItemText = "sent an order";
    } else{
      notificationItemText = "Error, UnknownType = $type";
    }
  }

  displayFullPost(context){
    print("ok");
    //Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreenPage(postId: postId, userId: userId,)));
  }

  displayUserProfile(BuildContext context, {String userProfileId}){
    print("ok");
    //Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(userProfileId : userProfileId)));
  }
}

