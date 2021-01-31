import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meally2/HomePage.dart';
import 'package:meally2/main/RestaurantHome.dart';
import 'package:meally2/models/meals.dart';
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

  retrieveComments(bool recent){
    if(recent){
      return StreamBuilder(
        stream: reviewsReference.document(mealId).collection("reviews").orderBy("timestamp", descending: true).limit(1).snapshots(),
        builder: (context, dataSnapshot){
          if(!dataSnapshot.hasData){
            return circularProgress(Colors.orangeAccent);
          }
          List<Comment> comments = [];
          dataSnapshot.data.documents.forEach((document){
            comments.add(Comment.fromDocument(document));
          });
          if(comments.isEmpty){
            return Text("no reviews yet, Be the first!");
          }
          return ListView(
            children: comments,
          );
        },
      );
    }else{
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
          if(comments.isEmpty){
            return Text("no reviews yet, Be the first!");
          }
          return ListView(
            children: comments,
          );
        },
      );
    }
  }

  saveComment(){
    reviewsReference.document(mealId).collection("reviews").add({
      "CustomerName" : currentUser.profileName,
      "comment": commentTextEditingController.text,
      "rating" : rating,
      "timestamp": DateTime.now(),
      "url": currentUser.url,
      "custId": currentUser.id,
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
    print(mealOwnerId);print(mealId);
    return FutureBuilder(
        future: mealsReference.document(mealOwnerId).collection('mealList').document(mealId).get(),
        builder: (context, dataSnapshot) {
          if (!dataSnapshot.hasData) {
            return circularProgress(Colors.orangeAccent);
          }
          Post meals = Post.fromDocument(dataSnapshot.data);
          return Scaffold(
           //appBar: header(context, strTitle: "Review"),
          body: Stack(
            children: [
              ListView(
                children: <Widget>[
                  mealPhoto(meals),
                  //Expanded(child: mealDetails(),),
                  mealDetails(meals),
                ],
              ),
              bottomBar(meals)
            ],
          )
        );
        }
    );
    /*
    return Scaffold(
      //appBar: header(context, strTitle: "Review"),
      body: Stack(
        children: [
          ListView(
            children: <Widget>[
              mealPhoto(),
              //Expanded(child: mealDetails(),),
              mealDetails(),
              /*
          SizedBox(height: 40,),
          Text("Reviews",textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 23)
            ),),
          Container(
            margin: EdgeInsets.only(left: 50),
            height: 5,
            color: HexColor("#FF9900"),
            width: MediaQuery.of(context).size.width/7,
          ),
          SizedBox(height: 10,),
          Expanded(child: retrieveComments()),
          Divider(),
          checkWhoseOnline(),
           */

            ],
          ),
          bottomBar()
        ],
      )
    );
     */
  }


  bottomBar(Post meals){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 70,
        padding: EdgeInsets.only(left: 20, right: 20),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(thickness: 1.2,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("RM" + meals.price.toString(),
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: HexColor("#FF9900"), fontWeight: FontWeight.w700, fontSize: 30)
                  ),),
                Container(
                    width: 80,
                    child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 40.0,
                      child: Text("Back", style: GoogleFonts.poppins(textStyle: TextStyle(color:Colors.white , fontWeight: FontWeight.w600),)),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: HexColor("#FF9900"),
                        //borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
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

  mealPhoto(Post meals){
    return Container(
      height: (MediaQuery.of(context).size.height/2)-80,
      width: MediaQuery.of(context).size.width,
      //margin: EdgeInsets.only(left: 20, right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: NetworkImage(meals.url),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  mealDetails(Post meals){
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 25, right: 25, top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Italian Cuisine",
            style: GoogleFonts.poppins(
                textStyle: TextStyle(color: HexColor("#FF9900"), fontWeight: FontWeight.w600, fontSize: 15)
            ),),
          Text(meals.name,
            style: GoogleFonts.poppins(
                textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 30)
            ),),
          SizedBox(height: 6,),
          Text("Calories",
            style: GoogleFonts.poppins(
                textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 15)
            ),),
          Text(meals.calories.toString() + " Kcal",
            style: GoogleFonts.poppins(
                textStyle: TextStyle(color: HexColor("#FF9900"), fontWeight: FontWeight.w600, fontSize: 27)
            ),),
          SizedBox(height: 10,),
          Text("Main Ingredients",
            style: GoogleFonts.poppins(
                textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 15)
            ),),
          Text(meals.ingredients, style: GoogleFonts.poppins(
                textStyle: TextStyle(color: Colors.black26, fontWeight: FontWeight.w600, fontSize: 15)
            ),),
          SizedBox(height: 10,),
          Text("Nutritions",
            style: GoogleFonts.poppins(
                textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 15)
            ),),
          SizedBox(height: 3,),
          Container(
            height: 85.0,
            child: ListView.builder(
              itemCount: 1,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int i) {
                return  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.orangeAccent.withOpacity(0.5), width: 5),
                          color: Colors.white,
                          shape: BoxShape.circle
                      ),
                      child: Center(
                        child: Text("fat\n"+meals.fat.toStringAsFixed(2),textAlign: TextAlign.center, style: GoogleFonts.poppins(textStyle:
                        TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue.withOpacity(0.5), width: 5),
                          color: Colors.white,
                          shape: BoxShape.circle
                      ),
                      child: Center(
                        child: Text("carbs\n"+meals.carbs.toStringAsFixed(2),textAlign: TextAlign.center, style: GoogleFonts.poppins(textStyle:
                        TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.red.withOpacity(0.5), width: 5),
                          color: Colors.white,
                          shape: BoxShape.circle
                      ),
                      child: Center(
                        child: Text("sodium\n"+meals.sodium.toStringAsFixed(2),textAlign: TextAlign.center, style: GoogleFonts.poppins(textStyle:
                        TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.green.withOpacity(0.5), width: 5),
                          color: Colors.white,
                          shape: BoxShape.circle
                      ),
                      child: Center(
                        child: Text("protein\n"+meals.protein.toStringAsFixed(2), textAlign: TextAlign.center,style: GoogleFonts.poppins(textStyle:
                        TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                      ),
                    ),
                  ],
                );
              }
            ),
          ),
          SizedBox(height: 10,),
          Divider(thickness: 1.2,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Recent Review",
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 15)
                ),),
              GestureDetector(
                onTap: ()=>_successModal(context),
                child: Text("view all",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 15)
                  ),),
              ),
            ],
          ),
          Container(
            height: 80,
            child: retrieveComments(true),
          ),
          SizedBox(height: 120,),
        ],
      ),
    );
  }

  customerReview(){
    return Container(
      child: Column(
          children: [
            Container(
              //color: Colors.black,
              width: MediaQuery.of(context).size.width,
              child: TextField(
                keyboardType: TextInputType.multiline,
                minLines: 1,//Normal textInputField will be displayed
                maxLines: null,
                style: TextStyle(color: Colors.black45, fontWeight: FontWeight.w700, fontSize: 16),
                controller: commentTextEditingController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: HexColor("#EFEFEF"),
                  contentPadding: new EdgeInsets.symmetric(vertical: 9.0, horizontal: 10.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  hintText: 'Write your review here...',
                ),
              ),
            ),
            SizedBox(height: 10,),
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
            Container(
              child: FlatButton(
                onPressed: saveComment,
                child: Container(
                  width: double.infinity,
                  height: 50.0,
                  margin: EdgeInsets.only(top: 10, bottom: 20),
                  child: Text("Upload meals", style: GoogleFonts.poppins(textStyle: TextStyle(color:Colors.white , fontWeight: FontWeight.w600),)),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: HexColor("#FF9900"),
                    borderRadius: BorderRadius.circular(10),
                    //borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
              ),
            )
          ],
        ),
    );
  }
  backButton(){
    return GestureDetector(
      onTap: (){
        Navigator.of(context).pop();
      },
      child: Container(
        alignment: Alignment.center,
        height: 50,
        margin: EdgeInsets.only(bottom: 20),
        color: HexColor("#FF9900"),
        child: Text("Back", style: GoogleFonts.poppins(textStyle:
        TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.w600),),),
      ),
    );
  }

  void _successModal(context){
    showModalBottomSheet(context: context, isScrollControlled:true, backgroundColor: Colors.transparent,builder: (BuildContext bc){
      return Container(
        height: MediaQuery.of(context).size.height-70,
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 30, right: 30, top: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Scaffold(
          body:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.arrow_drop_down_circle_rounded, color: Colors.black38,size: 30,),
              ),
              SizedBox(height: 40,),
              Text("Homemade \nPasta",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 30, color: Colors.black)
                  )),
              Divider(thickness: 1.2,),
              SizedBox(height: 5,),
              Text("Reviews",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black)
                  )),
              Expanded(
                child: retrieveComments(false),
              ),
              checkWhoseOnline(),
            ],
          ),
        )
      );
    });
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
      padding: EdgeInsets.only(bottom: 6.0, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              CircleAvatar(backgroundImage: CachedNetworkImageProvider(url),),
              SizedBox(width: 15,),
              Column(
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
                  Text(tAgo.format(timestamp.toDate()), style: TextStyle(color: Colors.black),),
                ],
              ),
            ]
          ),
          Divider(),
        ],
      ),
    );
  }
}
