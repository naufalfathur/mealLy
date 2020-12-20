import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meally2/HomePage.dart';
import 'package:meally2/main/RestaurantHome.dart';
import 'package:meally2/widgets/ProgressWidget.dart';
import 'package:timeago/timeago.dart' as tAgo;
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ReviewPage extends StatefulWidget {
  final String mealId;
  final String mealOwnerId;
  final String mealImageUrl;
  final bool restOnline;
  ReviewPage({this.mealId, this.mealOwnerId, this.mealImageUrl, this.restOnline});
  @override
  _ReviewPageState createState() => _ReviewPageState(mealId: mealId, mealOwnerId: mealOwnerId, mealImageUrl: mealImageUrl, restOnline: restOnline);
}

class _ReviewPageState extends State<ReviewPage> {
  final String mealId;
  final String mealOwnerId;
  final String mealImageUrl;
  final bool restOnline;

  var rating = 3.0;

  TextEditingController commentTextEditingController = TextEditingController();
  _ReviewPageState({this.mealId, this.mealOwnerId, this.mealImageUrl, this.restOnline});

  retrieveComments(){
    return StreamBuilder(
      stream: reviewsReference.document(mealId).collection("reviews").orderBy("timestamp", descending: false).snapshots(),
      builder: (context, dataSnapshot){
        if(!dataSnapshot.hasData){
          return circularProgress(Colors.orangeAccent);
        }
        List<Comment> comments = [];
        dataSnapshot.data.documents.forEach((document){
          comments.add(Comment.fromDocument(document));
        });
        return ListView(
          children: comments,
        );
      },
    );
  }

  saveComment(){
    reviewsReference.document(mealId).collection("reviews").add({
      "CustomerName" : currentUser.profileName,
      "comment": commentTextEditingController.text,
      "rating" : rating,
      "timestamp": DateTime.now(),
      "url": currentUser.url,
      "restId": currentUser.id,
    });
    //print(mealOwnerId);
    //print(currentRest.id);
    //bool isNotMealOwner = mealOwnerId != currentRest.id;
    //print("meal" + isNotMealOwner.toString());
    activityFeedReference.document(mealOwnerId).collection("activityItems").add({
      "type" : "comment",
      "commentData": commentTextEditingController.text,
      "mealId": mealId,
      "custId": currentUser.id,
      "rating" : rating,
      "CustomerName" : currentUser.profileName,
      "userProfileImg": currentUser.url,
      "url": mealImageUrl,
      "timestamp" : DateTime.now(),
    });
    commentTextEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: header(context, strTitle: "Review"),
      body: Column(
        children: <Widget>[
          SizedBox(height: 40,),
          Text("Reviews",textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 23)
            ),),
          Container(
            margin: EdgeInsets.only(left: 50),
            height: 5,
            color: Hexcolor("#FF9900"),
            width: MediaQuery.of(context).size.width/7,
          ),
          SizedBox(height: 10,),
          Expanded(child: retrieveComments()),
          Divider(),
          checkWhoseOnline(),
        ],
      ),
    );
  }
  checkWhoseOnline(){
    //print(restOnline);
    if(!restOnline){
      print("this isnt rest");
      return customerReview();
    }else{
      print("this is rest");
      return backButton();
    }

  }

  customerReview(){
    return Container(
      child:
        Column(
          children: [
            Row(
              children: [
                SizedBox(width: 10,),
                CircleAvatar(backgroundImage: CachedNetworkImageProvider(mealImageUrl),),
                Container(
                  width: MediaQuery.of(context).size.width - 50,
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    minLines: 1,//Normal textInputField will be displayed
                    maxLines: null,
                    style: TextStyle(color: Colors.black),
                    controller: commentTextEditingController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: new EdgeInsets.symmetric(vertical: 9.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      hintText: 'Write your review here...',
                    ),
                  ),
                ),
              ],
            ),
            SmoothStarRating(
              rating: rating,
              isReadOnly: false,
              size: 30,
              filledIconData: Icons.star,
              halfFilledIconData: Icons.star_half,
              defaultIconData: Icons.star_border,
              starCount: 5,
              allowHalfRating: true,
              spacing: 2.0,
              onRated: (value) {
                rating = value;
                print(rating);
                // print("rating value dd -> ${value.truncate()}");
              },
            ),
            OutlineButton(
              onPressed: saveComment,
              borderSide: BorderSide.none,
              child: Text("publish", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
            ),
          ],
        ),
    );
  }

  backButton(){
    return Container(
      alignment: Alignment.center,
      height: 80,
      color: Hexcolor("#FF9900"),
      child: Text("Back", style: GoogleFonts.poppins(textStyle:
      TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.w600),),),
    );
  }
}

class Comment extends StatelessWidget {
  final String CustomerName;
  final String custId;
  final String url;
  final rating;
  final String comment;
  final Timestamp timestamp;

  Comment({this.CustomerName, this.custId, this.timestamp, this.url, this.comment, this.rating});

  factory Comment.fromDocument(DocumentSnapshot doc){
    return Comment(
      CustomerName: doc['CustomerName'],
      custId: doc['custId'],
      rating: doc['rating'],
      url: doc['url'],
      comment: doc['comment'],
      timestamp: doc['timestamp'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.0),
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(CustomerName + ": " , style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700,color: Colors.black),),
                          SmoothStarRating(
                            rating: rating,
                            isReadOnly: true,
                            size: 20,
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
                      Text(comment, style: TextStyle(fontSize: 15, color: Colors.black),),
                    ],
                  ),
                  leading: CircleAvatar(backgroundImage: CachedNetworkImageProvider(url),),
                  subtitle: Text(tAgo.format(timestamp.toDate()), style: TextStyle(color: Colors.black),),
                  isThreeLine: true,
                ),
                Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
