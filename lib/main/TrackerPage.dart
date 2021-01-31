import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart' as ImD;
import 'package:meally2/HomePage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meally2/models/user.dart';
import 'package:meally2/widgets/ProgressWidget.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TrackerPage extends StatefulWidget {

  final User gCurrentUser;
  final String userProfileId;
  final String currentOnlineUserId;

  TrackerPage({this.gCurrentUser, this.userProfileId, this.currentOnlineUserId});

  @override
  _TrackerPageState createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> with AutomaticKeepAliveClientMixin<TrackerPage> {

  File file;
  bool uploading = false;
  String postId = Uuid().v4();
  TextEditingController descriptionTextEditingController = TextEditingController();
  //final snackBar = SnackBar(content: Text('Yay! A SnackBar!'));

  captureImageWithCamera() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 680,
      maxWidth: 680,
    );
    setState(() {
      this.file =  imageFile;
    });
  }
  pickImageFromGallery() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      this.file =  imageFile;
    });
  }
  defaultImage() async {
    File imageFile = await urlToFile("https://i.ibb.co/NFfysyq/No-Image-Available.png");
    setState(() {
      this.file =  imageFile;
    });
  }
  Future<File> urlToFile(String imageUrl) async {
    // generate random number.
    var rng = new Random();
    // get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
    // get temporary path from temporary directory.
    String tempPath = tempDir.path;
    // create a new file in temporary path with random file name.
    File file = new File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');
    // call http.get method and pass imageUrl into it to get response.
    http.Response response = await http.get(imageUrl);
    // write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
    // now return the file which is created with random name in
    // temporary directory and image bytes from response is written to // that file.
    return file;
  }

  takeImage(mContext){
    return showDialog(
      context: mContext,
      builder: (context){
        return SimpleDialog(
          title: Text("New Post", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),),
          children: <Widget>[
            SimpleDialogOption(
              child: Text("Capture Image with Camera", style: TextStyle(color: Colors.black54),),
              onPressed: captureImageWithCamera,
            ),
            SimpleDialogOption(
              child: Text("Select Image from Gallery", style: TextStyle(color: Colors.black54),),
              onPressed: pickImageFromGallery,
            ),
            SimpleDialogOption(
              child: Text("Cancel", style: TextStyle(color: Colors.black54),),
              onPressed:() =>Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  displayUploadScreen(){
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            height: 500,
            width: MediaQuery.of(context).size.width,
            child: ClipRRect(
              child: Image(
                image: AssetImage("assets/images/train.png"),
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 50, right: 50),
            child: Text("Update your weight regularly to see your progress!", textAlign: TextAlign.center, style: GoogleFonts.poppins(textStyle:
            TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.w500),),),
          ),
          Container(
            //color: Colors.black26,
            height: 100,
            alignment: Alignment.center,
            child: FlatButton(
              onPressed: defaultImage,
              child: Container(
                width: MediaQuery.of(context).size.width/2,
                height: 40.0,
                child: Text("Update Weight",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.white)
                  ),),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: HexColor("#FF9900"),
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  clearPostInfo(){
    descriptionTextEditingController.clear();
    setState(() {
      file = null;
    });
  }
  compressingPhoto() async{
    final tDirectory = await getTemporaryDirectory();
    final path = tDirectory.path;
    ImD.Image mImageFile = ImD.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')..writeAsBytesSync(ImD.encodeJpg(mImageFile, quality: 60));
    setState(() {
      file = compressedImageFile;
    });
  }

  Future<String> uploadPhoto(mImageFile) async{
    StorageUploadTask mStorageUploadTask = storageReference.child("post_$postId.jpg").putFile(mImageFile);
    StorageTaskSnapshot storageTaskSnapshot =  await mStorageUploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;

  }
  controlUploadAndSave() async{
    setState(() {
      uploading = true;
    });
    await compressingPhoto();

    String downloadUrl = await uploadPhoto(file);
    savePostInfoToFirestore(url: downloadUrl, description: descriptionTextEditingController.text);
    descriptionTextEditingController.clear();
    setState(() {
      file = null;
      uploading = false;
      postId = Uuid().v4();
    });
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
  }
  savePostInfoToFirestore({String url, String location, String description}){
    TrackerReference.document(widget.gCurrentUser.id).collection("userTrack").document(postId).setData({
      "postId": postId,
      "ownerId": widget.gCurrentUser.id,
      "timestamp": DateTime.now(),
      "profileName": widget.gCurrentUser.profileName,
      "description": description,
      "url": url,
    });
    userReference.document(widget.currentOnlineUserId).updateData({
      "weight" : double.tryParse(descriptionTextEditingController.text),
    });
  }
  displayUploadFormScreen(){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.close, color: Colors.black,),onPressed: clearPostInfo,),
        centerTitle: true,
        title: Text("Add Weight", style: GoogleFonts.poppins(textStyle:
        TextStyle(fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.w600),),),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.check, color: Colors.black,), onPressed: uploading ? null : ()=> controlUploadAndSave(),)
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: ListView(
          children: <Widget>[
            uploading ? linearProgress() : Text(""),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Weight", style: GoogleFonts.poppins(textStyle:
                TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                Container(
                  //color: Colors.blue,
                  width: MediaQuery.of(context).size.width-150,
                  child: TextField(
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.end,
                    controller: descriptionTextEditingController,
                    decoration: InputDecoration(
                        hintText: "Put your Weight now",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none
                    ),
                  ),
                ),
                Text("Kg", style: GoogleFonts.poppins(textStyle:
                TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.w500),),),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Date", style: GoogleFonts.poppins(textStyle:
                TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                Text(DateTime.now().day.toString()+ "/" + DateTime.now().month.toString() + "/" + DateTime.now().year.toString(), style: GoogleFonts.poppins(textStyle:
                TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.w500),),),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Progress Photo", style: GoogleFonts.poppins(textStyle:
                TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                Container(
                  alignment: Alignment.center,
                  child: RaisedButton.icon(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35.0)),
                      color: Colors.orangeAccent,
                      onPressed: () => takeImage(context),
                      icon: Icon(Icons.camera_alt, color: Colors.white,),
                      label: Text("Upload Photo", style: TextStyle(color: Colors.white),)),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Container(
              height: 230.0,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 16/9,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(file),
                          fit: BoxFit.cover,
                        )
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return file == null ? displayUploadScreen() : displayUploadFormScreen();
  }
}
