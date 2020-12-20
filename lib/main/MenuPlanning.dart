import 'dart:math';

import 'package:flutter/material.dart';
//import 'package:meally2/models/user.dart';
import 'package:meally2/widgets/RestaurantPostTile.dart';
import 'package:meally2/widgets/RestaurantPostWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meally2/HomePage.dart';
import 'package:meally2/models/restaurant.dart';
import 'package:meally2/widgets/ProgressWidget.dart';

class MenuPlanning extends StatefulWidget {
  final userProfileId;
  //final User gCurrentUser;
  MenuPlanning({this.userProfileId});
  @override
  _MenuPlanningState createState() => _MenuPlanningState(userProfileId: userProfileId,);
}

class _MenuPlanningState extends State<MenuPlanning> {
  final userProfileId;
  //final User gCurrentUser;
  var lst = [200, 900, 600, 400, 312, 453, 577, 321, 213, 494, 121,113, 104, 599];
  var nums = new List(3);
  int sum = 0;
  int total = 1100;
  int randomNum;
  int min;
  int max;
  Random rnd;

  _MenuPlanningState({this.userProfileId});
  List<Post> posts;
  List<String> followingsList = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  retrieveTimeLine() async{
    print(userProfileId);
    QuerySnapshot querySnapshot =  await timelineReference.document(userProfileId)
        .collection("timelinePosts").orderBy("price", descending: true).where("price",isGreaterThan: 20).getDocuments();
    print(querySnapshot.toString());
    List<Post> allPosts = querySnapshot.documents.map((document) => Post.fromDocument(document, false)).toList();
    List<dynamic> list = querySnapshot.documents.map((DocumentSnapshot doc){return doc['RestaurantName'];}).toList();
    print("a" + allPosts.toString());
    //print("v" + list.toString());
    setState(() {
      this.posts = allPosts;
    });
    setState(() {
      min = total~/6;
      max = total~/5;
    });
    do{
      for (int i = 0; i < nums.length-1; i++) {
        rnd = new Random();
        randomNum = min + rnd.nextInt(max - min);
        do {
         lst.shuffle();
        }while(lst[0]<=randomNum);
        nums[i] = lst[0];
        total -= nums[i];
      }
      total = 1100;
      print(nums.toList());
      do {
        lst.shuffle();
      }while(lst[0]>total~/3);
      nums[nums.length-1] = lst[0];
      print(nums.toList());
      setState(() {
       sum = nums.reduce((a, b) => a + b);
      });
      print(sum);
    }while(sum>(total+100)||sum<(total-100));
  }

  retrieveFollowings() async{
    QuerySnapshot querySnapshot =  await followingReference.document(currentUser.id)
        .collection("userFollowing").getDocuments();

    setState(() {
      followingsList = querySnapshot.documents.map((document) => document.documentID).toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveTimeLine();
    retrieveFollowings();
  }

  createUserTimeLine(){
    if(posts == null){
      return circularProgress(Colors.orangeAccent);
    }else{
      return ListView(children: posts,);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      //appBar: header(context, isAppTitle: true, ),
      body: RefreshIndicator(
        child: createUserTimeLine(),
        onRefresh: ()=> retrieveTimeLine(),
      ),
    );
  }
}
