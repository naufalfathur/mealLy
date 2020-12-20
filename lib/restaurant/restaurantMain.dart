import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';

class restaurantMain extends StatefulWidget {
  @override
  _restaurantMainState createState() => _restaurantMainState();
}

class _restaurantMainState extends State<restaurantMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 20, right: 20, top: 10),
            decoration: BoxDecoration(
              color: Hexcolor("#FF9900"),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(Icons.menu_rounded, color: Colors.white, size: 30,),
                Text("Welcome!",textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 25)
                  ),),
                Text("m.",textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 25)
                  ),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
