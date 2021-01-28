import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meally2/widgets/ProgressWidget.dart';
import 'package:meally2/widgets/RestaurantPostWidget.dart';

class PaymentPage extends StatefulWidget {
  final List<Post> allMeals;
  PaymentPage({this.allMeals});


  @override
  _PaymentPageState createState() => _PaymentPageState(allMeals: allMeals);
}

class _PaymentPageState extends State<PaymentPage> {
  final List<Post> allMeals;
  _PaymentPageState({this.allMeals});
  double total;



  @override
  Widget build(BuildContext context) {
    countTotal();
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        //padding: EdgeInsets.all(15),
        //color: Colors.red,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: (){
                  Navigator.pop(context, [false]);
                },
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 40, bottom: 50, top: 40),
                    child: Icon(Icons.arrow_back_ios_rounded))),

            Text("Checkout",textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 20)
              ),),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Text("Thank you for choosing mealLy, after this step the meals designed only "
                  "for you is on your doorstep",textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(color: Colors.black45, fontWeight: FontWeight.w600, fontSize: 12)
                ),),
            ),
            SizedBox(height: 15,),
            Container(
              height: MediaQuery.of(context).size.height/2,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(15),
              child: ListView.builder(
                itemCount: allMeals.length,
                itemBuilder: (BuildContext context, int index){
                  return Container(
                    height: 60,
                   child: ListTile(
                     leading: CircleAvatar(
                       radius: 15.0,
                       backgroundImage:
                       NetworkImage(allMeals[index].url),
                     ),
                     isThreeLine: true,
                     title:
                     Text(allMeals[index].name,
                       style: GoogleFonts.poppins(
                           textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black)
                       ),),
                     subtitle:
                     Text("id : " + allMeals[index].mealId, overflow: TextOverflow.ellipsis,
                       style: GoogleFonts.poppins(
                           textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 10, color: Colors.black45)
                       ),),
                     minLeadingWidth: 20,
                     trailing: Container(
                       width: 60,
                       child: Row(
                         children: [
                           Icon(Icons.money_sharp, color: Colors.lightGreen, size: 15,),
                           Text(" "+ allMeals[index].price.toString()),
                         ],
                       ),
                     ),
                   ),
                  );
                },
              ),
            ),
            /*
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                height: 180,
                width: MediaQuery.of(context).size.width-40,
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  //border: Border.all(color: Colors.blue),
                  color: Colors.blue
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                    ),
                    SizedBox(height: 45,),
                    Text("     Debit/Credit Card",textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)
                      ),),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15,),
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                height: 180,
                //width: MediaQuery.of(context).size.width-40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: Colors.black26, width: 2),
                    image: DecorationImage(
                      //alignment: Alignment(-1, 0),
                      scale: 2,
                      image: NetworkImage("https://cdn.hsbc.com.my/content/dam/hsbc/my/images/ways-to-bank/fpx-logo.jpg"),
                      fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            ),

             */
            Padding(
              padding: EdgeInsets.only(top: 10, left: 25, right: 25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Subtotal", style: GoogleFonts.poppins(textStyle:
                      TextStyle(fontSize: 12.0, color: Colors.black45, fontWeight: FontWeight.w600),),),
                      Text("rm " + total.round().toString(), style: GoogleFonts.poppins(textStyle:
                      TextStyle(fontSize: 12.0, color: Colors.black45, fontWeight: FontWeight.w600),),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Weekly Program plan fee", style: GoogleFonts.poppins(textStyle:
                      TextStyle(fontSize: 12.0, color: Colors.black45, fontWeight: FontWeight.w600),),),
                      Text("rm 1", style: GoogleFonts.poppins(textStyle:
                      TextStyle(fontSize: 12.0, color: Colors.black45, fontWeight: FontWeight.w600),),),
                    ],
                  ),
                  Divider(thickness: 1,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total ", style: GoogleFonts.poppins(textStyle:
                      TextStyle(fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.w600),),),
                      Text("rm " + (total.round()+1).toString(), style: GoogleFonts.poppins(textStyle:
                      TextStyle(fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.w600),),),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FlatButton(
          onPressed: (){
            //Navigator.pop(context);
            _successModal(context);
            //Navigator.pop(context, [true]);
          },
          //color: Hexcolor("#FF9900"),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 45.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: AssetImage("assets/images/bg.png"),
                fit: BoxFit.fitWidth,
              ),

            ),
            child: Text("Pay rm " + (total.round()+1).toString(),textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)
              ),),
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }

  countTotal(){
    total = 0.0;
    print("aaa");
    print("bbb");
    print(allMeals.length);
    for (int i = 0; i < allMeals.length; i++){
      total += allMeals[i].price;
    }
    print(allMeals[1].price);
    print(total);
  }

  void _successModal(context){
    List<bool> isSelected = [false, false, false];
    showModalBottomSheet(
        context: context, isScrollControlled:true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (BuildContext bc){
          Timer(Duration(seconds: 3), (){
            Navigator.pop(context);
            Navigator.pop(context, [true]);
          });
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState){
                return Container(
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.center,
                    //padding: EdgeInsets.only(left: 30, right: 30, top: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      //borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    ),
                    child: Scaffold(
                        body: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height/2,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.blue,
                              child: ClipRRect(
                                child: Image(
                                  image: AssetImage("assets/images/pay.gif"),
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 25, right: 25),
                              child: Text("Payment Successful",textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 20)
                                ),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 25, right: 25, bottom: 10),
                              child: Text("Thank you, you can access the plan on the homescreen ",textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(color: Colors.black45, fontWeight: FontWeight.w600, fontSize: 12)
                                ),),
                            ),
                            circularProgress(Colors.orangeAccent.withOpacity(0.5)),
                          ],
                        ),
                    )
                );
              });
        });
  }
}
