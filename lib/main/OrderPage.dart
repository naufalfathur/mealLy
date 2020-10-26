import 'package:flutter/material.dart';
import 'package:meally2/HomePage.dart';
import 'package:meally2/main/TrackerPage.dart';
import 'package:meally2/models/user.dart';

class OrderPage extends StatefulWidget {
  final User gCurrentUser;

  OrderPage({this.gCurrentUser});
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: 300,
        color: Colors.orangeAccent,
        child: PageView(
          children: <Widget>[
            TrackerPage(gCurrentUser: currentUser)
          ],
        ),
      ),
    );
  }
}
