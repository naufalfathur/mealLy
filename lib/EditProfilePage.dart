import 'package:flutter/material.dart';
import 'package:meally2/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meally2/models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:meally2/widgets/ProgressWidget.dart';
class EditProfilePage extends StatefulWidget {
  final String currentOnlineUserId;
  EditProfilePage({this.currentOnlineUserId});
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController profileNameTextEditingController = TextEditingController();
  final _scaffoldkey =  GlobalKey<ScaffoldState>();
  bool loading = false;
  User user;
  bool _profileNameValid =  true;
  int tdee;

  void initState(){
    super.initState();
    getAndDisplayUserInformation();
  }
  getAndDisplayUserInformation() async{
    setState(() {
      loading = true;
    });
    DocumentSnapshot documentSnapshot =  await userReference.document(widget.currentOnlineUserId).get();
    user = User.fromDocument(documentSnapshot);

    profileNameTextEditingController.text = user.profileName;
    setState(() {
      loading = false;
    });
  }


  Column createProfileNameTextFormField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 13.0),
          child: Text(
            "Profile Name", style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          style: TextStyle(color: Colors.black),
          controller: profileNameTextEditingController,
          decoration: InputDecoration(
              hintText: "Write profile name here....",
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)
              ),
              hintStyle: TextStyle(color: Colors.grey),
              errorText: _profileNameValid ? null : "Profile name is very short"
          ),
        )
      ],
    );
  }

  updateUserData(){
    setState(() {
      profileNameTextEditingController.text.trim().length<3 || profileNameTextEditingController.text.isEmpty ? _profileNameValid = false : _profileNameValid = true;
    });
    if(_profileNameValid){
      userReference.document(widget.currentOnlineUserId).updateData({
        "profileName" : profileNameTextEditingController.text,
      });
      SnackBar successSnackbar =  SnackBar(content: Text("Profile has been updated successfully."));
      _scaffoldkey.currentState.showSnackBar(successSnackbar);
    }
  }

  logoutUser() async {
    await gSignIn.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Edit Profile", style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.done, color: Colors.white, size: 30.0,), onPressed:()=>Navigator.pop(context),),
        ],
      ),
      body: loading ? circularProgress() : ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 7.0),
                  child: CircleAvatar(
                    radius: 52.0,
                    backgroundImage: CachedNetworkImageProvider(user.url),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      createProfileNameTextFormField(),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 50.0, right: 50.0),
                  child: RaisedButton(
                    onPressed: updateUserData,
                    child: Text("Update",
                      style: TextStyle(color: Colors.black, fontSize: 16.0),),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 50.0, right: 50.0),
                  child: RaisedButton(
                    color: Colors.red,
                    onPressed: logoutUser,
                    child: Text("Logout",
                      style: TextStyle(color: Colors.black, fontSize: 16.0),),
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
