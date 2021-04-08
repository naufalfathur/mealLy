import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meally2/main/WelcomeScreen.dart';
import 'HomePage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MealLy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData
        (
        scaffoldBackgroundColor: Colors.white,
        dialogBackgroundColor: Colors.white,
        primarySwatch: Colors.grey,
        cardColor: Colors.white70,
        accentColor: Colors.orangeAccent,

      ),
      home: WelcomeScreen(),
    );
  }



}