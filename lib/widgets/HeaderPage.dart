import 'package:flutter/material.dart';

AppBar header(context, {bool isAppTitle = false, String strTitle, disappearedBackButton=false}) {
  return AppBar(
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    automaticallyImplyLeading: disappearedBackButton ? false : true,
    title:
    Container(
      padding: EdgeInsets.only(top: 25, left: 10, right: 10),
      alignment: isAppTitle ? Alignment.centerLeft : Alignment.center,
      child:
      Text(
        isAppTitle ? "MealLy" : strTitle,
        style: TextStyle(
          color: Colors.orangeAccent,
          fontFamily: isAppTitle ? "Signatra" : "",
          fontSize: isAppTitle ? 45.0 : 22.00,
        ),
        overflow: TextOverflow.ellipsis,
      ),

    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
    elevation: 0,

  );
}
