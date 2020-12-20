import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meally2/main/RestaurantHome.dart';
import 'package:meally2/models/restaurant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:meally2/restaurant/ReviewPage.dart';
import 'package:meally2/widgets/ProgressWidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meally2/HomePage.dart';
class Post extends StatefulWidget {
  final String mealId;
  final String ownerId;
  //final String timestamp;
  final bool restOnline;
  final dynamic order;
  final String name;
  final String ingredients;
  final double price;
  final String url;

  Post({
    this.mealId,
    this.ownerId,
    //this.timestamp,
    this.order,
    this.name,
    this.ingredients,
    this.price,
    this.url,
    this.restOnline,
  });

  factory Post.fromDocument(DocumentSnapshot documentSnapshot, bool restOnline){
    return Post(
      mealId: documentSnapshot["mealId"],
      ownerId: documentSnapshot["ownerId"],
      //timestamp: documentSnapshot["timestamp"],
      order: documentSnapshot["order"],
      name: documentSnapshot["name"],
      ingredients: documentSnapshot["ingredients"],
      price: documentSnapshot["price"],
      url: documentSnapshot["url"],
      restOnline: restOnline,
    );
  }

  int getTotalNumberOfOrder(order){
    if(order == null){
      return 0;
    }
    int counter = 0;
    order.values.forEach((eachValue){
      if(eachValue == true){
        counter = counter + 1;
      }
    });
    return counter;
  }

  @override
  _PostState createState() => _PostState(
    mealId : this.mealId,
    ownerId : this.ownerId,
    //timestamp : this.timestamp,
    order : this.order,
    restOnline: restOnline,
    name : this.name,
    ingredients : this.ingredients,
    price : this.price,
    url : this.url,
    orderCount: getTotalNumberOfOrder(this.order),
  );
}

class _PostState extends State<Post> {
  final String mealId;
  final String ownerId;
  Map order;
  //final String timestamp;
  final bool restOnline;
  final String name;
  final String ingredients;
  final double price;
  final String url;
  int orderCount;
  bool isOrdered;
  bool showHeart = false;
  final String currentOnlineRestId = currentRest?.id;

  _PostState({
    this.mealId,
    this.ownerId,
    //this.timestamp,
    this.order,
    this.restOnline,
    this.name,
    this.ingredients,
    this.orderCount,
    this.price,
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    print(restOnline);
    isOrdered = (order[currentOnlineRestId] == true);
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          createPostHead(),
          //createPostPicture(),
          createPostFooter(),
        ],
      ),
    );
  }
  createPostHead(){
    return FutureBuilder(
      future: restReference.document(ownerId).get(),
      builder: (context, dataSnapshot){
        if(!dataSnapshot.hasData){
          return circularProgress(Colors.orangeAccent);
        }
        Restaurant restaurant = Restaurant.fromDocument(dataSnapshot.data);
        bool isPostOwner = currentOnlineRestId == ownerId;

        return Column(
          children: <Widget>[
            Row(
              children: [
                Container(
                  height: 150,
                  width: 150,
                  margin: EdgeInsets.only(left: 20, right: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(url),
                        fit: BoxFit.cover,
                      ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0.0,5.0),
                        blurRadius: 30,
                        spreadRadius: -8,
                      ),
                    ],
                  ),
                ),
                //CircleAvatar(backgroundImage: CachedNetworkImageProvider(url), backgroundColor: Colors.grey,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("$name", textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black)
                        )),
                    Container(
                      height: 100,
                      //color: Colors.blue,
                      child: Text("$ingredients",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 11, color: Colors.black)
                          )),
                    ),
                    Text("Calories : 5000",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Colors.black)
                        )),
                    Text("RM $price",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Colors.black)
                        )),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
/*
  removeLike(){
    bool isNotPostOwner = currentOnlineRestId != ownerId;
    if(isNotPostOwner){
      activityFeedReference.document(ownerId).collection("activityItems").document(mealId).get().then((document) {
        if(document.exists){
          document.reference.delete();
        }
      });
    }
  }
  addLike(){
    bool isNotPostOwner = currentOnlineRestId != ownerId;
    if(isNotPostOwner){
      activityFeedReference.document(ownerId).collection("activityItems").document(mealId).setData({
        "type": "like",
        "name": currentRest.RestaurantName,
        "restId": currentRest.id,
        "timestamp" : DateTime.now(),
        "url" : url,
        "mealId" : mealId,
        "restProfileImg": currentRest.url,
      });
    }
  }
  controlUserLikePost(){
    bool _ordered = order[currentOnlineRestId] == true;
    if(_ordered){
      mealsReference.document(ownerId).collection("mealList").document(mealId).updateData({"order.$currentOnlineRestId": false});
      removeLike();
      setState(() {
        orderCount = orderCount -1;
        isOrdered = false;
        order[currentOnlineRestId] = false;
      });
    } else if(!_ordered){
      mealsReference.document(ownerId).collection("mealList").document(mealId).updateData({"order.$currentOnlineRestId": true});
      addLike();
      setState(() {
        orderCount = orderCount + 1;
        isOrdered = true;
        order[currentOnlineRestId] = true;
        showHeart = true;
      });
      Timer(Duration(milliseconds: 800), (){
        setState(() {
          showHeart = false;
        });
      });
    }
  }


  createPostPicture(){
    return GestureDetector(
      onDoubleTap: ()=> controlUserLikePost,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.network(url),
          showHeart ? Icon(Icons.favorite, size: 140, color: Colors.pink,) : Text("")
        ],
      ),
    );
  }
   */

  createPostFooter(){
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 40.0, left: 20.0)),
            /*
            GestureDetector(
              onTap: ()=> controlUserLikePost(),
              child: Icon(
                isOrdered ? Icons.favorite : Icons.favorite_border,
                size: 28.0,
                color: Colors.pink,
              ),
            ),
             */
            Padding(padding: EdgeInsets.only(right: 20.0)),
            GestureDetector(
              onTap: ()=> displayComment(context, mealId: mealId, ownerId: ownerId, url: url),
              child: Icon( Icons.chat_bubble_outline,
                size: 28.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }

  displayComment(BuildContext context, {String mealId, String ownerId, String url}){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return ReviewPage(mealId: mealId, mealOwnerId: ownerId, mealImageUrl: url, restOnline: restOnline);
    }
    ));
  }
}
