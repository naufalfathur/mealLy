import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meally2/main/RestaurantHome.dart';
//import 'package:meally2/models/user.dart';
import 'package:meally2/widgets/RestaurantPostTile.dart';
import 'package:meally2/widgets/RestaurantPostWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meally2/HomePage.dart';
import 'package:meally2/models/restaurant.dart';
import 'package:intl/intl.dart' as intl;
import 'package:google_fonts/google_fonts.dart';
import 'package:day_night_time_picker/lib/constants.dart';
import 'package:meally2/widgets/ProgressWidget.dart';
import 'package:dropdown_date_picker/dropdown_date_picker.dart';
import 'package:date_time_picker_widget/date_time_picker_widget.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:uuid/uuid.dart';

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
  //var lst = [200.2, 900.5, 600.2, 400.4, 312.4, 453.5, 577.3, 321.1, 213.2, 494.4, 121.2,113.3, 104.5, 599.2];
  var nums = new List(3);
  double sum = 0;
  double total = 1100;
  double randomNum;
  double min;
  double max;
  double a;
  Random rnd;

  var i;
  String day ;
  static final now = DateTime.now();

  final dropdownDatePicker = DropdownDatePicker(
    initialDate: ValidDate(year: now.year, month: now.month, day: now.day),
    firstDate: ValidDate(year: now.year, month: 1, day: 1),
    lastDate: ValidDate(year: now.year+2, month: now.month, day: now.day),
    textStyle: TextStyle(fontWeight: FontWeight.bold),
    dropdownColor: Colors.blue[200],
    dateHint: DateHint(year: 'year', month: 'month', day: 'day'),
    ascending: false,
  );

  _MenuPlanningState({this.userProfileId});
  List<dynamic> list;
  List<Post> posts;
  List<Post> posts2;
  List<Post> posts3;
  List<Post> meals;
  List<String> followingsList = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Color _color = Colors.blue;
  String _d1, _d2;
  String _t1, _t2;

  //TimeOfDay _time = TimeOfDay.now().replacing(minute: 30);
  bool iosStyle = true;


  List<TimeOfDay> _time = [
    TimeOfDay(hour: 08, minute: 30),
    TimeOfDay(hour: 13, minute: 30),
    TimeOfDay(hour: 19, minute: 00),
  ];

  List<DateTime> mealsTime = [
    DateTime.parse("2020-01-02 08:30:00"),
    DateTime.parse("2020-01-02 13:30:00"),
    DateTime.parse("2020-01-02 19:00:00"),
  ];


  void onTimeChanged(TimeOfDay newTime) {
    print(i.toString()+"b");
    setState(() {
      _time[i] = newTime;
    });
  }


  retrieveTimeLine() async{
    print(userProfileId);
    DateTime todayDate = DateTime.parse("2020-01-02 03:04:05");
    print(todayDate);
    QuerySnapshot querySnapshot =  await timelineReference.document(userProfileId)
        .collection("timelinePosts").getDocuments();
    print(querySnapshot.toString());
    List<dynamic> list = querySnapshot.documents.map((DocumentSnapshot doc){return doc['price'];}).toList();
    setState(() {
      this.list = list;
    });
    print("v" + list.toString());
    setState(() {
      min = total/6;
      max = total/5;
    });
    do{
      for (int i = 0; i < nums.length-1; i++) {
        rnd = new Random();
        randomNum = min + rnd.nextInt(max.toInt() - min.toInt());
        do {
          list.shuffle();
        }while(list[0]<=randomNum);
        nums[i] = list[0];
        total -= nums[i];
      }
      total = 1100;
      print(nums.toList());
      do {
        list.shuffle();
      }while(list[0]>total~/3);
      nums[nums.length-1] = list[0];
      print(nums.toList());
      setState(() {
       sum = nums.reduce((a, b) => a + b);
      });
      print(sum);
    }while(sum>(total+100)||sum<(total-100));
    setState(() {
      a = list[0]+10;
    });
    QuerySnapshot querySnapshot2 =  await timelineReference.document(userProfileId)
        .collection("timelinePosts").where("name",isEqualTo: "Homemade Pasta").getDocuments();
    //List<Post> allPosts = querySnapshot2.documents.map((document) => Post.fromDocument(document, false)).toList();
    QuerySnapshot querySnapshot3 =  await timelineReference.document(userProfileId)
        .collection("timelinePosts").where("price",isEqualTo: nums[1]).getDocuments();
    //List<Post> allPosts2 = querySnapshot3.documents.map((document) => Post.fromDocument(document, false)).toList();
   QuerySnapshot querySnapshot4 =  await timelineReference.document(userProfileId)
       .collection("timelinePosts").where("price",isEqualTo: nums[2]).getDocuments();
    //List<Post> allPosts3 = querySnapshot4.documents.map((document) => Post.fromDocument(document, false)).toList();
    var newList = querySnapshot2.documents.map((document) => Post.fromDocument(document, false)).toList()
        + querySnapshot3.documents.map((document) => Post.fromDocument(document, false)).toList()
        + querySnapshot4.documents.map((document) => Post.fromDocument(document, false)).toList();
    setState(() {
      this.posts = newList;
      //this.posts2 = allPosts2;
      //this.posts3 = allPosts3;
      //this.meals.add(posts)
    });
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
      return test();
    }
  }

  test(){
    //day = intl.DateFormat('EEEE').format(DateTime.parse(dropdownDatePicker.getDate()));
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              Container(
                height: MediaQuery.of(context).size.height*2,
                width:  MediaQuery.of(context).size.width,
                //color: Colors.blue,
                padding: EdgeInsets.only(top: 80, left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Today",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 25, color: HexColor("#FF9900"))
                          ),),
                        dropdownDatePicker,
                      ],
                    ),
                    Container(
                      height: 600,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          //Expanded(child: ListView(children: posts,),),
                          Expanded(
                            child: ListView.builder(
                              itemCount: posts.length,
                              itemBuilder: (BuildContext context, int index){
                                return Card(
                                  color: Colors.white70,
                                  child: Column(
                                    children: [
                                      posts[index],
                                      FlatButton(
                                        color: Colors.orangeAccent,
                                        onPressed: () {
                                          i = index;
                                          print(i.toString()+"aa");
                                          Navigator.of(context).push(
                                            showPicker(
                                              context: context,
                                              value: _time[index],
                                              onChange: onTimeChanged,
                                              minuteInterval: MinuteInterval.FIVE,
                                              disableHour: false,
                                              disableMinute: false,
                                              minMinute: 7,
                                              maxMinute: 56,
                                              // Optional onChange to receive value as DateTime
                                              onChangeDateTime: (DateTime dateTime) {
                                                setState(() {
                                                  DateTime time = DateTime.parse(dropdownDatePicker.getDate() + " " + intl.DateFormat.Hm().format(dateTime)+":00");
                                                  mealsTime[index] = time;
                                                });
                                                print(mealsTime[index]);
                                              },
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context).size.width,
                                          child: Text(
                                            intl.DateFormat.Hm().format(mealsTime[index]),
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        )
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    //Expanded(child: _timePicker(),),
                    /*
                    FlatButton(
                      color: Colors.orangeAccent,
                      onPressed: () {
                        Navigator.of(context).push(
                          showPicker(
                            context: context,
                            value: _time,
                            onChange: onTimeChanged,
                            minuteInterval: MinuteInterval.FIVE,
                            disableHour: false,
                            disableMinute: false,
                            minMinute: 7,
                            maxMinute: 56,
                            // Optional onChange to receive value as DateTime
                            onChangeDateTime: (DateTime dateTime) {
                              setState(() {
                                DateTime time = DateTime.parse(widget.dropdownDatePicker.getDate() + " " + intl.DateFormat.Hm().format(dateTime)+":00");
                                mealsTime1 = time;
                              });
                              print(mealsTime1);
                            },
                          ),
                        );
                      },
                      child: Text(
                        mealsTime1.toString(),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    FlatButton(
                      color: Colors.orangeAccent,
                      onPressed: () {
                        Navigator.of(context).push(
                          showPicker(
                            context: context,
                            value: _time,
                            onChange: onTimeChanged,
                            minuteInterval: MinuteInterval.FIVE,
                            disableHour: false,
                            disableMinute: false,
                            minMinute: 7,
                            maxMinute: 56,
                            // Optional onChange to receive value as DateTime
                            onChangeDateTime: (DateTime dateTime) {
                              setState(() {
                                DateTime time = DateTime.parse(widget.dropdownDatePicker.getDate() + " " + intl.DateFormat.Hm().format(dateTime)+":00");
                                mealsTime2 = time;
                              });
                              print(mealsTime2);
                            },
                          ),
                        );
                      },
                      child: Text(
                        mealsTime2.toString(),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    FlatButton(
                      color: Colors.orangeAccent,
                      onPressed: () {
                        Navigator.of(context).push(
                          showPicker(
                            context: context,
                            value: _time,
                            onChange: onTimeChanged,
                            minuteInterval: MinuteInterval.FIVE,
                            disableHour: false,
                            disableMinute: false,
                            minMinute: 7,
                            maxMinute: 56,
                            // Optional onChange to receive value as DateTime
                            onChangeDateTime: (DateTime dateTime) {
                              setState(() {
                                DateTime time = DateTime.parse(widget.dropdownDatePicker.getDate() + " " + intl.DateFormat.Hm().format(dateTime)+":00");
                                mealsTime3 = time;
                              });
                              print(mealsTime3);
                            },
                          ),
                        );
                      },
                      child: Text(
                        mealsTime3.toString(),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                     */
                  ],
                ),
              )
            ],
          ),
          bottomBar(),
        ],
      )
    );
  }

  bottomBar(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        padding: EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("refresh",
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 25, color: Colors.white)
              ),),
            Text("next",
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 25, color: Colors.white)
              ),),
          ],
        ),
      ),
    );
  }


  makeOrder(){
    for (int i = 0; i < 3; i++){
      var orderId = Uuid().v4();
      custOrdersReference.document(currentUser.id).collection("custOrder").document(orderId).setData({
        "custId": currentUser.id,
        "restId" : posts[i].ownerId,
        "orderId" : orderId,
        "datetime": mealsTime[i],
        "mealName" : posts[i].name,
        "location": "aa",
        "status": 0,
        "timestamp": DateTime.now(),
        "mealId": posts[i].mealId,
        "userProfileImg": currentUser.url,
        "url": posts[i].url,
      });
      ordersReference.document(posts[i].ownerId).collection("order").document(orderId).setData({
        "CustomerName" : currentUser.profileName,
        "custId": currentUser.id,
        "restId" : posts[i].ownerId,
        "datetime": mealsTime[i],
        "mealName" : posts[i].name,
        "orderId" : orderId,
        "location": "aa",
        "status": 0,
        "timestamp": DateTime.now(),
        "mealId": posts[i].mealId,
        "userProfileImg": currentUser.url,
        "url": posts[i].url,
      });
      activityFeedReference.document(posts[i].ownerId).collection("activityItems").add({
        "type" : "order",
        "custId": currentUser.id,
        "CustomerName" : currentUser.profileName,
        "userProfileImg": currentUser.url,
        "url": posts[i].url,
        "datetime":mealsTime[i],
        "mealName" : posts[i].name,
        "location": "aa",
        "mealId": posts[i].mealId,
        "timestamp" : DateTime.now(),
      });
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
