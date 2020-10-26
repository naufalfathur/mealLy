import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
            children: <Widget>[
              ClipPath(
                clipper: TopBarClipper(),
                child: Container(
                  height: 270,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Hexcolor("#FF9900")
                  ),child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Image(
                    image: AssetImage("assets/images/background.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                ),
              ),
              Positioned(
                bottom: -30,
                child: Container(
                  padding: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/eating.png"),
                        fit: BoxFit.scaleDown,
                      )
                  ),
                ),
              ),

              Positioned(
                top: 50,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  padding: EdgeInsets.only(top: 10.0, left: 25, right: 25, bottom: 10),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Hi Jane,",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 28, color: Colors.white)
                                ),),
                              Text("Welcome to MealLy !",
                                style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),)),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.account_circle, color: Colors.white, size: 40,),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 120,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  padding: EdgeInsets.only(top: 30, bottom: 10),
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 18, bottom: 18),
                        decoration: BoxDecoration(
                          color: Hexcolor("#FF9900"),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0.0,3.0),
                                blurRadius: 37,
                                spreadRadius: -8,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: <Widget>[
                            Text("56.0",
                              style: GoogleFonts.poppins(textStyle:TextStyle(fontWeight: FontWeight.w400, fontSize: 17, color: Colors.white), )),
                            Text("Weight",
                              style: GoogleFonts.poppins(textStyle:TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.white),),),
                          ],
                        ),
                      ),
                      Container(
                        width: 230,
                        padding: const EdgeInsets.only(left:10 , top: 28, bottom: 28),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0.0,3.0),
                                blurRadius: 37,
                                spreadRadius: -8,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Calories Remaining : 2000/2000",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                            SizedBox(height: 5,),
                            Container(
                              width: 200,
                              child:  LinearProgressIndicator(
                                value: 20,
                                backgroundColor: Colors.black26,
                                valueColor: AlwaysStoppedAnimation(Colors.orangeAccent,),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
               Positioned(
                 top: 250,
                 child: Container(
                   height: 300,
                   //color: Colors.blueAccent,
                   padding: EdgeInsets.only(left: 20, right: 20,top: 20),
                   width: MediaQuery.of(context).size.width,
                   child: Column(
                     children: <Widget>[
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: <Widget>[
                           Text("Today's Menu",
                             style: GoogleFonts.poppins(
                                 textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 15)
                             ),),
                           Container(
                             width: 80,
                             decoration: BoxDecoration(
                               color: Hexcolor("#FF9900"),
                               borderRadius: BorderRadius.circular(30),
                             ),
                             child: Text("See All",textAlign: TextAlign.center,
                               style: GoogleFonts.poppins(
                                   textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)
                               ),),
                           ),
                         ],
                       ),
                       SizedBox(height: 20,),
                       Container(
                         width: MediaQuery.of(context).size.width,
                         height: 200,
                         alignment: Alignment.center,
                         //color: Colors.black12,
                         decoration: BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.circular(20),
                           boxShadow: [
                             BoxShadow(
                               color: Colors.black26,
                               offset: Offset(0.0,3.0),
                               blurRadius: 37,
                               spreadRadius: -8,
                             ),
                           ],
                         ),
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
                             Text("You haven't create any Meal Plan",textAlign: TextAlign.center,
                               style: GoogleFonts.poppins(
                                   textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 13)
                               ),),
                             FlatButton(
                                 color: Hexcolor("#FF9900"),
                                 child: Container(
                                   width: MediaQuery.of(context).size.width/2,
                                   height: 40.0,
                                   child: Text("Create Now",textAlign: TextAlign.center,
                                     style: GoogleFonts.poppins(
                                         textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)
                                     ),),
                                   alignment: Alignment.center,
                                   decoration: BoxDecoration(
                                     color: Colors.orangeAccent,
                                     border: Border.all(color: Colors.orangeAccent),
                                     borderRadius: BorderRadius.circular(6.0),
                                   ),
                                 ),
                             ),
                           ],
                         ),
                       ),
                     ],
                   ),
                 ),
               ),
            ],
          ),
      ),
    );
  }
}

class TopBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height-100);
    path.quadraticBezierTo(size.width/5, size.height, size.width, size.height-150);
    //path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    // TODO: implement getClip
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
    throw UnimplementedError();
  }
}
