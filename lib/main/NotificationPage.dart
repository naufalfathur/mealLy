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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: header(context, strTitle: "Notifications",),
      body: Column(
        children: <Widget>[
          topBar(),
          Expanded(
            child:notification(),
          )
        ],
      ),
    );
  }
  topBar(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Hexcolor("#FF9900"),
      ),
      child: Text("Notification", textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
            textStyle: TextStyle(color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 25)
        ),),
    );
  }

  notification(){
    return Container(
      child: FutureBuilder(
        future: retrieveNotification(),
        builder: (context, dataSnapshot){
          if(!dataSnapshot.hasData){
            return circularProgress(Colors.orangeAccent);
          }
          return ListView(children: dataSnapshot.data,);
;       },
      ),
    );
  }

  retrieveNotification() async{
    print("a");
    QuerySnapshot querySnapshot = await activityFeedReference.document(currentRest.id)
        .collection("activityItems").orderBy("timestamp", descending: true)
        .limit(60).getDocuments();
    List<NotificationsItem> notificationItem = [];
    querySnapshot.documents.forEach((document) {
      notificationItem.add(NotificationsItem.fromDocument(document));
    });
    print(notificationItem.length);
    return notificationItem;
  }
}

String notificationItemText;
Widget mediaPreview;
class NotificationsItem extends StatelessWidget {
  final String CustomerName;
  final String type;
  final String commentData;
  final String mealId;
  final String userId;
  final rating;
  final String userProfileImg;
  final String url;
  final Timestamp timestamp;
  NotificationsItem({this.timestamp, this.url, this.CustomerName, this.mealId, this.userId, this.commentData, this.type, this.userProfileImg, this.rating});

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
    );
  }

  @override
  Widget build(BuildContext context) {
    configureMediaPreview(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Container(
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
      ),
    );
  }

  configureMediaPreview(context){
    if(type == "comment" || type == "like"){
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
    }else if(type == "follow"){
      notificationItemText = "started following you.";
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

