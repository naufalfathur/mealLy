import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meally2/main/RestaurantHome.dart';
import 'package:meally2/main/paymentPage.dart';
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
import 'package:flutter_swiper/flutter_swiper.dart';

class MealPlanning extends StatefulWidget {
  final int plan;
  final userProfileId;
  MealPlanning({this.userProfileId, this.plan});

  @override
  _MealPlanningState createState() => _MealPlanningState(userProfileId: userProfileId, plan : plan);
}

class _MealPlanningState extends State<MealPlanning> {
  final int plan;
  final userProfileId;
  _MealPlanningState({this.userProfileId, this.plan});
  var nums;
  double sum = 0;
  String name;
  double tdee;
  double total,randomNum,min,max,a;
  Random rnd;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  var i;
  String day ;
  static final now = DateTime.now();
  final dropdownDatePicker = DropdownDatePicker(
    initialDate: ValidDate(year: now.year, month: now.month+1, day: 2),//2021-1-8
    firstDate: ValidDate(year: now.year, month: 1, day: 1),//2021-1-1
    lastDate: ValidDate(year: now.year+2, month: 12, day: 31),//2023-1-8
    textStyle: TextStyle(fontWeight: FontWeight.bold),
    dropdownColor: Colors.blue[200],
    dateHint: DateHint(year: 'year', month: 'month', day: 'day'),
    ascending: false,
  );
  final dropdownDatePicker2 = DropdownDatePicker(
    initialDate: ValidDate(year: now.year, month: now.month+1, day: 3),//2021-1-8
    firstDate: ValidDate(year: now.year, month: 1, day: 1),
    lastDate: ValidDate(year: now.year+2, month: 12, day: 31),
    textStyle: TextStyle(fontWeight: FontWeight.bold),
    dropdownColor: Colors.blue[200],
    dateHint: DateHint(year: 'year', month: 'month', day: 'day'),
    ascending: false,
  );
  final dropdownDatePicker3 = DropdownDatePicker(
    initialDate: ValidDate(year: now.year, month: now.month+1, day: 4),//2021-1-8
    firstDate: ValidDate(year: now.year-2, month: 1, day: 1),
    lastDate: ValidDate(year: now.year+2, month: 12, day: 31),
    textStyle: TextStyle(fontWeight: FontWeight.bold),
    dropdownColor: Colors.blue[200],
    dateHint: DateHint(year: 'year', month: 'month', day: 'day'),
    ascending: false,
  );
  final dropdownDatePicker4 = DropdownDatePicker(
    initialDate: ValidDate(year: now.year, month: now.month+1, day: 5),//2021-1-8
    firstDate: ValidDate(year: now.year-2, month: 1, day: 1),
    lastDate: ValidDate(year: now.year+2, month: 12, day: 31),
    textStyle: TextStyle(fontWeight: FontWeight.bold),
    dropdownColor: Colors.blue[200],
    dateHint: DateHint(year: 'year', month: 'month', day: 'day'),
    ascending: false,
  );
  final dropdownDatePicker5 = DropdownDatePicker(
    initialDate: ValidDate(year: now.year, month: now.month+1, day: 6),//2021-1-8
    firstDate: ValidDate(year: now.year-2, month: 1, day: 1),
    lastDate: ValidDate(year: now.year+2, month: 12, day: 31),
    textStyle: TextStyle(fontWeight: FontWeight.bold),
    dropdownColor: Colors.blue[200],
    dateHint: DateHint(year: 'year', month: 'month', day: 'day'),
    ascending: false,
  );
  final dropdownDatePicker6 = DropdownDatePicker(
    initialDate: ValidDate(year: now.year, month: now.month+1, day: 7),//2021-1-8
    firstDate: ValidDate(year: now.year-2, month: 1, day: 1),
    lastDate: ValidDate(year: now.year+2, month: 12, day: 31),
    textStyle: TextStyle(fontWeight: FontWeight.bold),
    dropdownColor: Colors.blue[200],
    dateHint: DateHint(year: 'year', month: 'month', day: 'day'),
    ascending: false,
  );
  final dropdownDatePicker7 = DropdownDatePicker(
    initialDate: ValidDate(year: now.year, month: now.month+1, day: 8),//2021-1-8
    firstDate: ValidDate(year: now.year-2, month: 1, day: 1),
    lastDate: ValidDate(year: now.year+2, month: 12, day: 31),
    textStyle: TextStyle(fontWeight: FontWeight.bold),
    dropdownColor: Colors.blue[200],
    dateHint: DateHint(year: 'year', month: 'month', day: 'day'),
    ascending: false,
  );

  List<dynamic> list;
  List<Post> posts, posts2, posts3, posts4, posts5, posts6, posts7;
  //List<List<Post>> meals;
  List<String> followingsList = [];
  List<TimeOfDay> _time = [
    TimeOfDay(hour: 08, minute: 30),
    TimeOfDay(hour: 12, minute: 30),
    TimeOfDay(hour: 15, minute: 00),
    TimeOfDay(hour: 19, minute: 00),
    TimeOfDay(hour: 22, minute: 00),
  ];
  List<TimeOfDay> _time2 = [
    TimeOfDay(hour: 08, minute: 30),
    TimeOfDay(hour: 12, minute: 30),
    TimeOfDay(hour: 15, minute: 00),
    TimeOfDay(hour: 19, minute: 00),
    TimeOfDay(hour: 22, minute: 00),
  ];
  List<TimeOfDay> _time3 = [
    TimeOfDay(hour: 08, minute: 30),
    TimeOfDay(hour: 12, minute: 30),
    TimeOfDay(hour: 15, minute: 00),
    TimeOfDay(hour: 19, minute: 00),
    TimeOfDay(hour: 22, minute: 00),
  ];
  List<TimeOfDay> _time4 = [
    TimeOfDay(hour: 08, minute: 30),
    TimeOfDay(hour: 12, minute: 30),
    TimeOfDay(hour: 15, minute: 00),
    TimeOfDay(hour: 19, minute: 00),
    TimeOfDay(hour: 22, minute: 00),
  ];
  List<TimeOfDay> _time5 = [
    TimeOfDay(hour: 08, minute: 30),
    TimeOfDay(hour: 12, minute: 30),
    TimeOfDay(hour: 15, minute: 00),
    TimeOfDay(hour: 19, minute: 00),
    TimeOfDay(hour: 22, minute: 00),
  ];
  List<TimeOfDay> _time6 = [
    TimeOfDay(hour: 08, minute: 30),
    TimeOfDay(hour: 12, minute: 30),
    TimeOfDay(hour: 15, minute: 00),
    TimeOfDay(hour: 19, minute: 00),
    TimeOfDay(hour: 22, minute: 00),
  ];
  List<TimeOfDay> _time7 = [
    TimeOfDay(hour: 08, minute: 30),
    TimeOfDay(hour: 12, minute: 30),
    TimeOfDay(hour: 15, minute: 00),
    TimeOfDay(hour: 19, minute: 00),
    TimeOfDay(hour: 22, minute: 00),
  ];
  List<DateTime> mealsTime = [
    DateTime.parse(now.year.toString()+"-0"+now.month.toString()+"-"+now.day.toString()+" 08:30:00"),
    DateTime.parse(now.year.toString()+"-0"+now.month.toString()+"-"+now.day.toString()+" 12:30:00"),
    DateTime.parse(now.year.toString()+"-0"+now.month.toString()+"-"+now.day.toString()+" 15:00:00"),
    DateTime.parse(now.year.toString()+"-0"+now.month.toString()+"-"+now.day.toString()+" 19:00:00"),
    DateTime.parse(now.year.toString()+"-0"+now.month.toString()+"-"+now.day.toString()+" 22:00:00"),
  ];
  List<DateTime> mealsTime2 = [
    DateTime.parse(now.year.toString()+"-0"+now.month.toString()+"-"+(now.day+1).toString()+" 08:30:00"),
    DateTime.parse(now.year.toString()+"-0"+now.month.toString()+"-"+(now.day+1).toString()+" 12:30:00"),
    DateTime.parse(now.year.toString()+"-0"+now.month.toString()+"-"+(now.day+1).toString()+" 15:00:00"),
    DateTime.parse(now.year.toString()+"-0"+now.month.toString()+"-"+(now.day+1).toString()+" 19:00:00"),
    DateTime.parse(now.year.toString()+"-0"+now.month.toString()+"-"+(now.day+1).toString()+" 22:00:00"),
  ];
  List<DateTime> mealsTime3 = [
    DateTime.parse(now.year.toString()+"-0"+now.month.toString()+"-"+(now.day+2).toString()+" 08:30:00"),
    DateTime.parse(now.year.toString()+"-0"+now.month.toString()+"-"+(now.day+2).toString()+" 12:30:00"),
    DateTime.parse(now.year.toString()+"-0"+now.month.toString()+"-"+(now.day+2).toString()+" 15:00:00"),
    DateTime.parse(now.year.toString()+"-0"+now.month.toString()+"-"+(now.day+2).toString()+" 19:00:00"),
    DateTime.parse(now.year.toString()+"-0"+now.month.toString()+"-"+(now.day+2).toString()+" 22:00:00"),
  ];
  List<DateTime> mealsTime4 = [
    DateTime.parse(now.year.toString()+"-0"+now.month.toString()+"-"+(now.day+3).toString()+" 08:30:00"),
    DateTime.parse(now.year.toString()+"-0"+now.month.toString()+"-"+(now.day+3).toString()+" 12:30:00"),
    DateTime.parse(now.year.toString()+"-0"+now.month.toString()+"-"+(now.day+3).toString()+" 15:00:00"),
    DateTime.parse(now.year.toString()+"-0"+now.month.toString()+"-"+(now.day+3).toString()+" 19:00:00"),
    DateTime.parse(now.year.toString()+"-0"+now.month.toString()+"-"+(now.day+3).toString()+" 22:00:00"),
  ];
  List<DateTime> mealsTime5 = [
    DateTime.parse(now.year.toString()+"-0"+now.month.toString()+"-"+(now.day+4).toString()+" 08:30:00"),
    DateTime.parse(now.year.toString()+"-0"+now.month.toString()+"-"+(now.day+4).toString()+" 12:30:00"),
    DateTime.parse(now.year.toString()+"-0"+now.month.toString()+"-"+(now.day+4).toString()+" 15:00:00"),
    DateTime.parse(now.year.toString()+"-0"+now.month.toString()+"-"+(now.day+4).toString()+" 19:00:00"),
    DateTime.parse(now.year.toString()+"-0"+now.month.toString()+"-"+(now.day+4).toString()+" 22:00:00"),
  ];
  List<DateTime> mealsTime6 = [
    DateTime.parse(now.year.toString()+"-0"+now.month.toString()+"-"+(now.day+5).toString()+" 08:30:00"),
    DateTime.parse(now.year.toString()+"-0"+now.month.toString()+"-"+(now.day+5).toString()+" 12:30:00"),
    DateTime.parse(now.year.toString()+"-0"+now.month.toString()+"-"+(now.day+5).toString()+" 15:00:00"),
    DateTime.parse(now.year.toString()+"-0"+now.month.toString()+"-"+(now.day+5).toString()+" 19:00:00"),
    DateTime.parse(now.year.toString()+"-0"+now.month.toString()+"-"+(now.day+5).toString()+" 22:00:00"),
  ];
  List<DateTime> mealsTime7 = [
    DateTime.parse(now.year.toString()+"-0"+now.month.toString()+"-"+(now.day+6).toString()+" 08:30:00"),
    DateTime.parse(now.year.toString()+"-0"+now.month.toString()+"-"+(now.day+6).toString()+" 12:30:00"),
    DateTime.parse(now.year.toString()+"-0"+now.month.toString()+"-"+(now.day+6).toString()+" 15:00:00"),
    DateTime.parse(now.year.toString()+"-0"+now.month.toString()+"-"+(now.day+6).toString()+" 19:00:00"),
    DateTime.parse(now.year.toString()+"-0"+now.month.toString()+"-"+(now.day+6).toString()+" 22:00:00"),
  ];

  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _time[i] = newTime;
    });
  }
  void onTimeChanged2(TimeOfDay newTime) {
    setState(() {
      _time2[i] = newTime;
    });
  }
  void onTimeChanged3(TimeOfDay newTime) {
    setState(() {
      _time3[i] = newTime;
    });
  }
  void onTimeChanged4(TimeOfDay newTime) {
    setState(() {
      _time4[i] = newTime;
    });
  }
  void onTimeChanged5(TimeOfDay newTime) {
    setState(() {
      _time5[i] = newTime;
    });
  }
  void onTimeChanged6(TimeOfDay newTime) {
    setState(() {
      _time6[i] = newTime;
    });
  }
  void onTimeChanged7(TimeOfDay newTime) {
    setState(() {
      _time7[i] = newTime;
    });
  }

  Future<String> getCustTDEE() async{
    DocumentReference documentReference =  userReference.document(userProfileId);
    await documentReference.get().then((snapshot) {
      tdee = double.tryParse(snapshot.data['tdee'].toString());
      name = snapshot.data['profileName'].toString();
    });
    print("TDEE = "+tdee.toString());
    setState(() {
      total = tdee;
    });
    print("total = "+total.toString());
  }

  Future <Null> retrieveTimeLine() async{
    print("plan" + plan.toString());
    await getCustTDEE();
    setState(() {
      posts = null;
      posts2 = null;
      posts3 = null;
      posts4 = null;
      posts5 = null;
      posts6 = null;
      posts7 = null;
    });
    QuerySnapshot querySnapshot =  await timelineReference.document(userProfileId)
        .collection("timelinePosts").getDocuments();
    List<dynamic> list = querySnapshot.documents.map((DocumentSnapshot doc){return doc['calories'];}).toList();
    setState(() {
      this.list = list;
    });
    int p;
    if (plan==1){
      p= 1;
    }else if (plan ==7){
      p= 7;
    }
    for (int k = 0; k < p; k++) {
      generateRandom(k);
    }
    //generateRandom2();
    //generateRandom3();
    //getMealsFromRandom();
  }

  generateRandom(int k) async{
    int trial = 0;
    int amm = 2;
    nums = new List(2);
    min = total/6;
    max = total/5;
    //print("asas" + min.toString());
    //print("as9s" + max.toString());
    do{
      if(trial == 5){
        amm = amm +1;
        nums = new List(amm);
        trial = 0;
        print("212 " + amm.toString());
        for (int i = 0; i < nums.length-1; i++) {
          rnd = new Random();
          randomNum = min + rnd.nextInt(max.toInt() - min.toInt());
          do {
            list.shuffle();
          }while(list[0]<=randomNum);
          nums[i] = list[0];
          total -= nums[i];
          print("213 " + nums[i].toString());
        }
        total = tdee;
        do {
          list.shuffle();
        }while(list[0]>total~/3);
        nums[nums.length-1] = list[0];
        print("214 " + nums[nums.length-1].toString());
        sum = nums.reduce((a, b) => a + b);
        print("215 " + sum.toString());
        trial = trial +1;
        print("trial " + trial.toString());
      }else {
        for (int i = 0; i < nums.length-1; i++) {
          rnd = new Random();
          randomNum = min + rnd.nextInt(max.toInt() - min.toInt());
          do {
            list.shuffle();
          }while(list[0]<=randomNum);
          nums[i] = list[0];
          total -= nums[i];
          print("213 " + nums[i].toString());
        }
        total = tdee;
        do {
          list.shuffle();
        }while(list[0]>total~/3);
        nums[nums.length-1] = list[0];
        print("214 " + nums[nums.length-1].toString());
        sum = nums.reduce((a, b) => a + b);
        print("215 " + sum.toString());
        trial = trial +1;
        print("trial " + trial.toString());
      }
    }while(sum>(total+200)||sum<(total-100));
    print(nums.toString() + "1a $k");
    print(sum.toString() + "1 $k");
    sum = 0;
    total = tdee;

    var newList;
    QuerySnapshot querySnapshot;
    for (int i = 0; i < nums.length; i++) {
      querySnapshot =  await timelineReference.document(userProfileId)
          .collection("timelinePosts").where("calories",isEqualTo: nums[i]).limit(1).getDocuments();
      if(i == 0) {
        newList = querySnapshot.documents.map((document) => Post.fromDocument(document, false)).toList();
      }else{
        newList += querySnapshot.documents.map((document) => Post.fromDocument(document, false)).toList();
      }
    }
    setState(() {
      if(k==0){
        this.posts = newList;
      }else if(k==1){
        this.posts2 = newList;
      }else if(k==2){
        this.posts3 = newList;
      }else if(k==3){
        this.posts4 = newList;
      }else if(k==4){
        this.posts5 = newList;
      }else if(k==5){
        this.posts6 = newList;
      }else if(k==6){
        this.posts7 = newList;
      }
    });
  }

  getMealsFromRandom() async{
    var newList;
    QuerySnapshot querySnapshot;
    for (int i = 0; i < nums.length; i++) {
      querySnapshot =  await timelineReference.document(userProfileId)
          .collection("timelinePosts").where("calories",isEqualTo: nums[i]).limit(1).getDocuments();
      if(i == 0) {
        newList = querySnapshot.documents.map((document) => Post.fromDocument(document, false)).toList();
      }else{
        newList += querySnapshot.documents.map((document) => Post.fromDocument(document, false)).toList();
      }
    }
    /*
    QuerySnapshot querySnapshot2 =  await timelineReference.document(userProfileId)
        .collection("timelinePosts").where("calories",isEqualTo: nums[0]).limit(1).getDocuments();
    QuerySnapshot querySnapshot3 =  await timelineReference.document(userProfileId)
        .collection("timelinePosts").where("calories",isEqualTo: nums[1]).limit(1).getDocuments();
    QuerySnapshot querySnapshot4 =  await timelineReference.document(userProfileId)
        .collection("timelinePosts").where("calories",isEqualTo: nums[2]).limit(1).getDocuments();


    QuerySnapshot querySnapshot2a =  await timelineReference.document(userProfileId)
        .collection("timelinePosts").where("calories",isEqualTo: nums2[0]).limit(1).getDocuments();
    QuerySnapshot querySnapshot3a =  await timelineReference.document(userProfileId)
        .collection("timelinePosts").where("calories",isEqualTo: nums2[1]).limit(1).getDocuments();
    QuerySnapshot querySnapshot4a =  await timelineReference.document(userProfileId)
        .collection("timelinePosts").where("calories",isEqualTo: nums2[2]).limit(1).getDocuments();

    QuerySnapshot querySnapshot2b =  await timelineReference.document(userProfileId)
        .collection("timelinePosts").where("calories",isEqualTo: nums3[0]).limit(1).getDocuments();
    QuerySnapshot querySnapshot3b =  await timelineReference.document(userProfileId)
        .collection("timelinePosts").where("calories",isEqualTo: nums3[1]).limit(1).getDocuments();
    QuerySnapshot querySnapshot4b =  await timelineReference.document(userProfileId)
        .collection("timelinePosts").where("calories",isEqualTo: nums3[2]).limit(1).getDocuments();

    var newList = querySnapshot2.documents.map((document) => Post.fromDocument(document, false)).toList()
        + querySnapshot3.documents.map((document) => Post.fromDocument(document, false)).toList()
        + querySnapshot4.documents.map((document) => Post.fromDocument(document, false)).toList();
    var newList2 = querySnapshot2a.documents.map((document) => Post.fromDocument(document, false)).toList()
        + querySnapshot3a.documents.map((document) => Post.fromDocument(document, false)).toList()
        + querySnapshot4a.documents.map((document) => Post.fromDocument(document, false)).toList();
    var newList3 = querySnapshot2b.documents.map((document) => Post.fromDocument(document, false)).toList()
        + querySnapshot3b.documents.map((document) => Post.fromDocument(document, false)).toList()
        + querySnapshot4b.documents.map((document) => Post.fromDocument(document, false)).toList();
     */
    setState(() {
      //this.posts = newList;
      //this.posts2 = newList2;
      //this.posts3 = newList3;
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
    retrieveFollowings();
    retrieveTimeLine();

  }

  test(List whichPosts){
    DropdownDatePicker pickDate;
    List<TimeOfDay> setTime;
    List<DateTime> setMealsTime;
    if(whichPosts == posts){
      pickDate = dropdownDatePicker;
      setTime = _time;
      setMealsTime = mealsTime;
    }else if(whichPosts == posts2){
      pickDate = dropdownDatePicker2;
      setTime = _time2;
      setMealsTime = mealsTime2;
    }else if(whichPosts == posts3){
      pickDate = dropdownDatePicker3;
      setTime = _time3;
      setMealsTime = mealsTime3;
    }else if(whichPosts == posts4){
      pickDate = dropdownDatePicker4;
      setTime = _time4;
      setMealsTime = mealsTime4;
    }else if(whichPosts == posts5){
      pickDate = dropdownDatePicker5;
      setTime = _time5;
      setMealsTime = mealsTime5;
    }else if(whichPosts == posts6){
      pickDate = dropdownDatePicker6;
      setTime = _time6;
      setMealsTime = mealsTime6;
    }else if(whichPosts == posts7){
      pickDate = dropdownDatePicker7;
      setTime = _time7;
      setMealsTime = mealsTime7;
    }
    return Scaffold(
        body: Stack(
          children: [
            ListView(
              children: [
                Container(
                  width:  MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(intl.DateFormat('EEEE').format(DateTime.parse(pickDate.getDate())),
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Hexcolor("#FF9900"))
                            ),),
                          pickDate,
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
                                itemCount: whichPosts.length,
                                itemBuilder: (BuildContext context, int index){
                                  print(whichPosts.length);
                                  return Card(
                                    color: Colors.white70,
                                    child: Column(
                                      children: [
                                        whichPosts[index],
                                        FlatButton(
                                            color: Colors.orangeAccent,
                                            onPressed: () {
                                              i = index;
                                              Navigator.of(context).push(
                                                showPicker(
                                                  context: context,
                                                  value: setTime[index],
                                                  onChange:
                                                  whichPosts == posts ? onTimeChanged :
                                                  whichPosts == posts2 ? onTimeChanged2 :
                                                  whichPosts == posts3 ? onTimeChanged3 :
                                                  whichPosts == posts4 ? onTimeChanged4 :
                                                  whichPosts == posts5 ? onTimeChanged5 :
                                                  whichPosts == posts6 ? onTimeChanged6 :
                                                  onTimeChanged7,
                                                  minuteInterval: MinuteInterval.FIVE,
                                                  disableHour: false,
                                                  disableMinute: false,
                                                  minMinute: 7,
                                                  maxMinute: 56,
                                                  // Optional onChange to receive value as DateTime
                                                  onChangeDateTime: (DateTime dateTime) {
                                                    setState(() {
                                                      DateTime time = DateTime.parse(dropdownDatePicker.getDate() + " " + intl.DateFormat.Hm().format(dateTime)+":00");
                                                      setMealsTime[index] = time;
                                                    });
                                                  },
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context).size.width,
                                              child: Text(
                                                intl.DateFormat.Hm().format(setMealsTime[index]),
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
                    ],
                  ),
                )
              ],
            ),
          ],
        )
    );
  }
  /*
  test2(){
    return Scaffold(
        body: Stack(
          children: [
            ListView(
              children: [
                Container(
                  width:  MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(intl.DateFormat('EEEE').format(DateTime.parse(dropdownDatePicker2.getDate())),
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Hexcolor("#FF9900"))
                            ),),
                          dropdownDatePicker2,
                        ],
                      ),
                      Container(
                        height: 600,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: posts2.length,
                                itemBuilder: (BuildContext context, int index){
                                  return Card(
                                    color: Colors.white70,
                                    child: Column(
                                      children: [
                                        posts2[index],
                                        FlatButton(
                                            color: Colors.orangeAccent,
                                            onPressed: () {
                                              i = index;
                                              Navigator.of(context).push(
                                                showPicker(
                                                  context: context,
                                                  value: _time2[index],
                                                  onChange: onTimeChanged2,
                                                  minuteInterval: MinuteInterval.FIVE,
                                                  disableHour: false,
                                                  disableMinute: false,
                                                  minMinute: 7,
                                                  maxMinute: 56,
                                                  // Optional onChange to receive value as DateTime
                                                  onChangeDateTime: (DateTime dateTime) {
                                                    setState(() {
                                                      DateTime time = DateTime.parse(dropdownDatePicker2.getDate() + " " + intl.DateFormat.Hm().format(dateTime)+":00");
                                                      mealsTime2[index] = time;
                                                    });
                                                  },
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context).size.width,
                                              child: Text(
                                                intl.DateFormat.Hm().format(mealsTime2[index]),
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
                    ],
                  ),
                )
              ],
            ),
          ],
        )
    );
  }
  test3(){
    return Scaffold(
        body: Stack(
          children: [
            ListView(
              children: [
                Container(
                  //height: MediaQuery.of(context).size.height,
                  width:  MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(intl.DateFormat('EEEE').format(DateTime.parse(dropdownDatePicker3.getDate())),
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Hexcolor("#FF9900"))
                            ),),
                          dropdownDatePicker3,
                        ],
                      ),
                      Container(
                        height: 600,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: posts3.length,
                                itemBuilder: (BuildContext context, int index){
                                  return Card(
                                    color: Colors.white70,
                                    child: Column(
                                      children: [
                                        posts3[index],
                                        FlatButton(
                                            color: Colors.orangeAccent,
                                            onPressed: () {
                                              i = index;
                                              Navigator.of(context).push(
                                                showPicker(
                                                  context: context,
                                                  value: _time3[index],
                                                  onChange: onTimeChanged3,
                                                  minuteInterval: MinuteInterval.FIVE,
                                                  disableHour: false,
                                                  disableMinute: false,
                                                  minMinute: 7,
                                                  maxMinute: 56,
                                                  // Optional onChange to receive value as DateTime
                                                  onChangeDateTime: (DateTime dateTime) {
                                                    setState(() {
                                                      DateTime time = DateTime.parse(dropdownDatePicker3.getDate() + " " + intl.DateFormat.Hm().format(dateTime)+":00");
                                                      mealsTime3[index] = time;
                                                    });
                                                  },
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context).size.width,
                                              child: Text(
                                                intl.DateFormat.Hm().format(mealsTime3[index]),
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
                    ],
                  ),
                )
              ],
            ),
          ],
        )
    );
  }

   */


  makeOrder(List whichPosts){
    List<DateTime> setMealsTime;
    if(whichPosts == posts){
      setMealsTime = mealsTime;
    }else if(whichPosts == posts2){
      setMealsTime = mealsTime2;
    }else if(whichPosts == posts3){
      setMealsTime = mealsTime3;
    }else if(whichPosts == posts4){
      setMealsTime = mealsTime4;
    }else if(whichPosts == posts5){
      setMealsTime = mealsTime5;
    }else if(whichPosts == posts6){
      setMealsTime = mealsTime6;
    }else if(whichPosts == posts7){
      setMealsTime = mealsTime7;
    }
    for (int i = 0; i < 3; i++){
      var orderId = Uuid().v4();
      custOrdersReference.document(currentUser.id).collection("custOrder").document(orderId).setData({
        "custId": currentUser.id,
        "restId" : whichPosts[i].ownerId,
        "orderId" : orderId,
        "datetime": setMealsTime[i],
        "mealName" : whichPosts[i].name,
        "location": currentUser.location,
        "status": 0,
        "calories" : whichPosts[i].calories,
        "timestamp": DateTime.now(),
        "mealId": whichPosts[i].mealId,
        "userProfileImg": currentUser.url,
        "url": whichPosts[i].url,
        "calories": whichPosts[i].calories,
      });
      ordersReference.document(whichPosts[i].ownerId).collection("order").document(orderId).setData({
        "CustomerName" : currentUser.profileName,
        "custId": currentUser.id,
        "restId" : whichPosts[i].ownerId,
        "datetime": setMealsTime[i],
        "mealName" : whichPosts[i].name,
        "orderId" : orderId,
        "location": currentUser.location,
        "status": 0,
        "timestamp": DateTime.now(),
        "mealId": whichPosts[i].mealId,
        "userProfileImg": currentUser.url,
        "url": whichPosts[i].url,
        "calories": whichPosts[i].calories,
      });
      activityFeedReference.document(whichPosts[i].ownerId).collection("activityItems").add({
        "type" : "order",
        "custId": currentUser.id,
        "CustomerName" : currentUser.profileName,
        "userProfileImg": currentUser.url,
        "url": whichPosts[i].url,
        "datetime":setMealsTime[i],
        "mealName" : whichPosts[i].name,
        "location": currentUser.location,
        "mealId": whichPosts[i].mealId,
        "timestamp" : DateTime.now(),
      });
      /*
      restReference.document(whichPosts[i].ownerId).updateData({
        //"earnings": FieldValue.increment
      });
       */
    }

  }
  /*
  makeOrder2(){
    for (int i = 0; i < 3; i++){
      var orderId = Uuid().v4();
      custOrdersReference.document(currentUser.id).collection("custOrder").document(orderId).setData({
        "custId": currentUser.id,
        "restId" : posts2[i].ownerId,
        "orderId" : orderId,
        "datetime": mealsTime2[i],
        "mealName" : posts2[i].name,
        "location": currentUser.location,
        "calories" : posts2[i].calories,
        "status": 0,
        "timestamp": DateTime.now(),
        "mealId": posts2[i].mealId,
        "userProfileImg": currentUser.url,
        "url": posts2[i].url,
      });
      ordersReference.document(posts2[i].ownerId).collection("order").document(orderId).setData({
        "CustomerName" : currentUser.profileName,
        "custId": currentUser.id,
        "restId" : posts2[i].ownerId,
        "datetime": mealsTime2[i],
        "mealName" : posts2[i].name,
        "orderId" : orderId,
        "location": currentUser.location,
        "status": 0,
        "timestamp": DateTime.now(),
        "mealId": posts2[i].mealId,
        "userProfileImg": currentUser.url,
        "url": posts2[i].url,
      });
      activityFeedReference.document(posts2[i].ownerId).collection("activityItems").add({
        "type" : "order",
        "custId": currentUser.id,
        "CustomerName" : currentUser.profileName,
        "userProfileImg": currentUser.url,
        "url": posts2[i].url,
        "datetime":mealsTime2[i],
        "mealName" : posts2[i].name,
        "location": currentUser.location,
        "mealId": posts2[i].mealId,
        "timestamp" : DateTime.now(),
      });
    }

  }

  makeOrder3(){
    for (int i = 0; i < 3; i++){
      var orderId = Uuid().v4();
      custOrdersReference.document(currentUser.id).collection("custOrder").document(orderId).setData({
        "custId": currentUser.id,
        "restId" : posts3[i].ownerId,
        "orderId" : orderId,
        "datetime": mealsTime3[i],
        "mealName" : posts3[i].name,
        "location": currentUser.location,
        "status": 0,
        "timestamp": DateTime.now(),
        "calories" : posts3[i].calories,
        "mealId": posts3[i].mealId,
        "userProfileImg": currentUser.url,
        "url": posts3[i].url,
      });
      ordersReference.document(posts3[i].ownerId).collection("order").document(orderId).setData({
        "CustomerName" : currentUser.profileName,
        "custId": currentUser.id,
        "restId" : posts3[i].ownerId,
        "datetime": mealsTime3[i],
        "mealName" : posts3[i].name,
        "orderId" : orderId,
        "location": currentUser.location,
        "status": 0,
        "timestamp": DateTime.now(),
        "mealId": posts3[i].mealId,
        "userProfileImg": currentUser.url,
        "url": posts3[i].url,
      });
      activityFeedReference.document(posts3[i].ownerId).collection("activityItems").add({
        "type" : "order",
        "custId": currentUser.id,
        "CustomerName" : currentUser.profileName,
        "userProfileImg": currentUser.url,
        "url": posts3[i].url,
        "datetime":mealsTime3[i],
        "mealName" : posts3[i].name,
        "location": currentUser.location,
        "mealId": posts3[i].mealId,
        "timestamp" : DateTime.now(),
      });
    }

  }
   */

  back(){
    var nav = Navigator.of(context);
    nav.pop();
    nav.pop();
    nav.pop();
    nav.pop();
    nav.pop();
    print("vack");
  }
  @override
  Widget build(BuildContext context) {
    if(plan==1){
      if(posts == null){
        return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
              height: MediaQuery.of(context).size.height,
              //color: Colors.blue,
              padding: EdgeInsets.all(20),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/thinking.gif"),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  Text("please wait we are\npreparing your plan 😊 ...",textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 13)
                    ),),
                  SizedBox(height: 20,),
                  CircularProgressIndicator()
                ],
              )
          ),
        );
      }else {
        return Scaffold(
          body: CreateAccount(),
        );
      }
    }else{
      if(posts == null || posts2 == null || posts3 == null || posts4 == null || posts5 == null || posts6 == null || posts7 == null ){
        return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
              height: MediaQuery.of(context).size.height,
              //color: Colors.blue,
              padding: EdgeInsets.all(20),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/thinking.gif"),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  Text("please wait we are\npreparing your plan 😊 ...",textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 13)
                    ),),
                  SizedBox(height: 20,),
                  CircularProgressIndicator()
                ],
              )
          ),
        );
      }else {
        return Scaffold(
          body: CreateAccount(),
        );
      }
    }

  }
  CreateAccount(){
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: retrieveTimeLine,
      child: ListView(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 50),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Text("Plan your meals",textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20)
                  ),),
                Container(
                  margin: EdgeInsets.only(left: 90),
                  height: 5,
                  color: Hexcolor("#FF9900"),
                  width: MediaQuery.of(context).size.width/4,
                ),
                SizedBox(height: 10,),
                Text("Hi $name",textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 20)
                  ),),
                Container(
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child:  Column(
                    children: [
                      Text("We just generate the best meal plan for you\n"
                          "if you think you dont like it you can swipe down to refresh the plan",textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 11)
                        ),),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  height: (MediaQuery.of(context).size.height/3)+250,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.topCenter,
                  color: Colors.white,
                  child: Swiper(
                    itemCount: plan,
                    itemBuilder: (BuildContext context, int index){

                      if(index == 0){
                        return test(posts);
                      }else if(index == 1){
                        return test(posts2);
                      }else if(index == 2){
                        return test(posts3);
                      }else if(index == 3){
                        return test(posts4);
                      }else if(index == 4){
                        return test(posts5);
                      }else if(index == 5){
                        return test(posts6);
                      }else if(index == 6){
                        return test(posts7);
                      }else{
                        return Container(color: Colors.red,child: Text("Error, Please try again"));
                      }
                    },
                    layout: SwiperLayout.TINDER,
                    itemHeight: (MediaQuery.of(context).size.height/3)+300,
                    //loop: false,
                    itemWidth: 500,
                    control: SwiperControl(),
                    pagination: SwiperPagination(),
                  ),
                ),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: () async {
                    var allMeals;
                    if(plan == 1){
                      allMeals = posts;
                    }else{
                      allMeals = posts + posts2 + posts3 + posts4 + posts5 + posts6 + posts7;
                    }

                    final paySuccess = await Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentPage(allMeals : allMeals)));
                    if(paySuccess[0]) {
                      if(plan == 1){
                        makeOrder(posts);
                      }else{
                        makeOrder(posts);
                        makeOrder(posts2);
                        makeOrder(posts3);
                        makeOrder(posts4);
                        makeOrder(posts5);
                        makeOrder(posts6);
                        makeOrder(posts7);
                      }
                      back();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: AssetImage("assets/images/bg.png"),
                        fit: BoxFit.cover,
                      ),

                    ),
                    width: MediaQuery.of(context).size.width-100,
                    height: 40.0,
                    child: Text("Submit",textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)
                      ),),
                    alignment: Alignment.center,
                  ),
                ),
                SizedBox(height: 5,),
                SizedBox(height: 5,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
