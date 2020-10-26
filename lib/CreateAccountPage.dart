import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:meally2/widgets/HeaderPage.dart';

class Item {
  const Item(this.name,this.icon, this.value);
  final String name;
  final Icon icon;
  final double value;
}

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _scaffoldkey =  GlobalKey<ScaffoldState>();
  final _formkey = GlobalKey<FormState>();
  final _formkey2 = GlobalKey<FormState>();
  final _formkey3 = GlobalKey<FormState>();
  final _formkey4 = GlobalKey<FormState>();
  final _formkey5 = GlobalKey<FormState>();
  String gender;
  int age;
  double weight;
  double height;
  double bodyfat;
  double lbm;
  int tdee;
  Item item;
  double activity = 1.2;

  submitUsername(){
    final form = _formkey.currentState;
    final form2 = _formkey2.currentState;
    final form3 = _formkey3.currentState;
    final form4 = _formkey4.currentState;
    final form5 = _formkey5.currentState;
    if(form.validate()){
      form.save();
      form2.save();
      form3.save();
      form4.save();
      form5.save();
      lbm = weight - (weight * (bodyfat/100));
      tdee = ((370 + (21.6 * lbm))*activity).round();
      SnackBar snackBar = SnackBar(content: Text("Welcome"));
      _scaffoldkey.currentState.showSnackBar(snackBar);
      Timer(Duration(seconds: 2), (){
        Navigator.pop(context, [gender, age, weight, height, bodyfat, lbm, tdee]);
      });
    }
  }

  List<Item> items = <Item>[
    const Item('sedentary (little or no exercise)',Icon(Icons.android,color:  const Color(0xFF167F67),),1.2),
    const Item('light activity (1-2 days/week)',Icon(Icons.flag,color:  const Color(0xFF167F67),),1.375),
    const Item('moderate activity (3-5 days/week)',Icon(Icons.format_indent_decrease,color:  const Color(0xFF167F67),),1.55),
    const Item('very active (6-7 days/week)',Icon(Icons.mobile_screen_share,color:  const Color(0xFF167F67),),1.725),
    const Item('extra active (2x/day)',Icon(Icons.mobile_screen_share,color:  const Color(0xFF167F67),),1.9),
  ];

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: header(context, strTitle: "Settings", disappearedBackButton: true),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 26.0),
                  child: Center(
                    child: Text("Set up your details", style: TextStyle(fontSize: 26.0),),
                  ),
                ),
                Padding(//gender
                  padding: EdgeInsets.all(17.0),
                  child: Container(
                    child: Form(
                      key: _formkey,
                      autovalidate: true,
                      child: TextFormField(
                        style: TextStyle(color: Colors.black54),
                        validator: (val){
                          if(val.isEmpty){
                            return "gender should be male or female";
                          }else{
                            return null;
                          }
                        },
                        onSaved: (val) => gender = val,
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black54),
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Gender (male/female)",
                            labelStyle: TextStyle(fontSize: 16.0),
                            hintText: "must be male/female",
                            hintStyle: TextStyle(color: Colors.grey)
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(//age
                  padding: EdgeInsets.all(17.0),
                  child: Container(
                    child: Form(
                      key: _formkey2,
                      autovalidate: true,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: TextStyle(color: Colors.black54),
                        validator: (val){
                          if(val.isEmpty){
                            return "pls put age";
                          }else{
                            return null;
                          }
                        },
                        onSaved: (val) => age = int.tryParse(val),
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black54),
                            ),
                            border: OutlineInputBorder(),
                            labelText: "age",
                            labelStyle: TextStyle(fontSize: 16.0),
                            hintText: "age",
                            hintStyle: TextStyle(color: Colors.grey)
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(//weight
                  padding: EdgeInsets.all(17.0),
                  child: Container(
                    child: Form(
                      key: _formkey3,
                      autovalidate: true,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.black54),
                        validator: (val){
                          if(val.isEmpty) {
                            return "weight";
                          }else{
                            return null;
                          }
                        },
                        onSaved: (val) => weight = double.tryParse(val),
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black54),
                            ),
                            border: OutlineInputBorder(),
                            labelText: "weight",
                            labelStyle: TextStyle(fontSize: 16.0),
                            hintText: "in Kg",
                            hintStyle: TextStyle(color: Colors.grey)
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(//height
                  padding: EdgeInsets.all(17.0),
                  child: Container(
                    child: Form(
                      key: _formkey4,
                      autovalidate: true,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.black54),
                        validator: (val){
                          if(val.isEmpty) {
                            return "height";
                          }else{
                            return null;
                          }
                        },
                        onSaved: (val) => height = double.tryParse(val),
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black54),
                            ),
                            border: OutlineInputBorder(),
                            labelText: "height",
                            labelStyle: TextStyle(fontSize: 16.0),
                            hintText: "in cm",
                            hintStyle: TextStyle(color: Colors.grey)
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(//bodyfat
                  padding: EdgeInsets.all(17.0),
                  child: Container(
                    child: Form(
                      key: _formkey5,
                      autovalidate: true,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.black54),
                        validator: (val){
                          if(val.isEmpty){
                            return "body fat";
                          }else{
                            return null;
                          }
                        },
                        onSaved: (val) => bodyfat = double.tryParse(val),
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black54),
                            ),
                            border: OutlineInputBorder(),
                            labelText: "bodyfat",
                            labelStyle: TextStyle(fontSize: 16.0),
                            hintText: "percentage",
                            hintStyle: TextStyle(color: Colors.grey)
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(17.0),
                  child: DropdownButton<Item>(
                    hint:  Text("Select item"),
                    value: item,
                    onChanged: (Item Value) {
                      setState(() {
                        item = Value;
                        activity = item.value;
                        print(activity);
                      });
                    },
                    items: items.map((Item items) {
                      return  DropdownMenuItem<Item>(
                        value: items,
                        child: Row(
                          children: <Widget>[
                            items.icon,
                            SizedBox(width: 17,),
                            Text(
                              items.name,
                              style:  TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                /*Padding(
                  padding: EdgeInsets.all(20.0),
                  child: DropdownButton(
                      value: activity,
                      items: [
                        DropdownMenuItem(
                          child: Text("sedentary (little or no exercise)"),
                          value: 1.2,
                        ),
                        DropdownMenuItem(
                          child: Text("light activity (1-2 days/week)"),
                          value: 1.375,
                        ),
                        DropdownMenuItem(
                          child: Text("moderate activity (3-5 days/week)"),
                          value: 1.55,
                        ),
                        DropdownMenuItem(
                            child: Text("very active (6-7 days/week)"),
                            value: 1.725,
                        ),
                        DropdownMenuItem(
                            child: Text("extra active (2x/day)"),
                            value: 1.9,
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          activity = double.tryParse(value);
                        });
                      }),
                ),
                 */
                GestureDetector(
                  onTap: submitUsername,
                  child: Container(
                    height: 55.0,
                    width: 320.0,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        "Proceed",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),

    );
  }
}
