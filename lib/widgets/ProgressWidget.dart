import 'package:flutter/material.dart';

circularProgress(Color color) {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12.0),
    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(color),),
  );
}

linearProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12.0),
    child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white),),
  );
}
