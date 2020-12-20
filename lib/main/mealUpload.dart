import 'package:flutter/material.dart';
import 'package:meally2/models/restaurant.dart';
import 'package:meally2/main/RestaurantHome.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:hexcolor/hexcolor.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart' as ImD;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meally2/widgets/ProgressWidget.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class mealUpload extends StatefulWidget {
  final Restaurant gCurrentRest;
  final String userRestId;
  final String currentOnlineRestId;

  mealUpload({this.gCurrentRest, this.userRestId, this.currentOnlineRestId});
  @override
  _mealUploadState createState() => _mealUploadState();
}

class _mealUploadState extends State<mealUpload> {
  File file;
  double op = 0.0;
  bool uploading = false;
  String mealId = Uuid().v4();
  TextEditingController NameTextEditingController = TextEditingController();
  TextEditingController IngridientsTextEditingController = TextEditingController();
  TextEditingController priceTextEditingController = TextEditingController();
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
          title: Text("New meals", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),),
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
      backgroundColor: Hexcolor("#FF9900"),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 60),
            height: 350,
            width: MediaQuery.of(context).size.width,
            child: ClipRRect(
              child: Image(
                image: AssetImage("assets/images/healthy.png"),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Text("Add new meals", textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: Colors.white)
              )),
          Container(
            padding: EdgeInsets.only(left: 30, right: 30, top: 10),
            child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit", textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.white)
                )),
          ),
          Container(
            height: 100,
            alignment: Alignment.center,
            child: FlatButton(
              onPressed: (){
                showLoading();
                defaultImage();
              },
              child: Container(
                width: MediaQuery.of(context).size.width/2,
                height: 40.0,
                child: Text("Upload Meals",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Hexcolor("#FF9900"))
                  ),),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
            ),
          ),
          Opacity(
            opacity: op,
            child: circularProgress(Colors.white),
          ),
        ],
      ),
    );
  }

  showLoading(){
    setState(() {
      op = 1.0;
    });
  }

  clearPostInfo(){
    NameTextEditingController.clear();
    setState(() {
      file = null;
      op = 0.0;
    });
  }
  compressingPhoto() async{
    final tDirectory = await getTemporaryDirectory();
    final path = tDirectory.path;
    ImD.Image mImageFile = ImD.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$mealId.jpg')..writeAsBytesSync(ImD.encodeJpg(mImageFile, quality: 60));
    setState(() {
      file = compressedImageFile;
    });
  }
  Future<String> uploadPhoto(mImageFile) async{
    StorageUploadTask mStorageUploadTask = storageReference.child("post_$mealId.jpg").putFile(mImageFile);
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
    savePostInfoToFirestore(url: downloadUrl, name: NameTextEditingController.text, ingredients: IngridientsTextEditingController.text, price: double.tryParse(priceTextEditingController.text));
    NameTextEditingController.clear();
    IngridientsTextEditingController.clear();
    priceTextEditingController.clear();
    setState(() {
      file = null;
      uploading = false;
      mealId = Uuid().v4();
    });
    Navigator.push(context, MaterialPageRoute(builder: (context) => RestaurantHome()));
  }

  savePostInfoToFirestore({String url, String location, String name, String ingredients, double price}){
    mealsReference.document(widget.gCurrentRest.id).collection("mealList").document(mealId).setData({
      "mealId": mealId,
      "ownerId": widget.gCurrentRest.id,
      "timestamp": timestamp,
      "profileName": widget.gCurrentRest.RestaurantName,
      "order": {},
      "name": name,
      "ingredients": ingredients,
      "price": price+0.0,
      "url": url,
    });
  }
  displayUploadFormScreen(){
    return Scaffold(
      backgroundColor: Colors.white,
      /*
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black,),onPressed: clearPostInfo,),
        title: Text("New Post", style: TextStyle(fontSize: 24.0, color: Colors.black, fontWeight: FontWeight.bold),),
        actions: <Widget>[
          FlatButton(
              onPressed: uploading ? null : ()=> controlUploadAndSave(),
              child: Text("Share", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 16.0),)),
        ],
      ),
       */
      body: ListView(
        children: <Widget>[
          Container(
            height: 600,
            padding: EdgeInsets.only(top: 45, left: 30, right: 30),
            decoration: BoxDecoration(
              color: Hexcolor("#FF9900"),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
            ),
            child: ListView(
              children: <Widget>[
                Text("Upload new meals", textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white)
                    )),
                SizedBox(height: 10,),
                Stack(
                  children: <Widget>[
                    Container(
                      height: 220,
                      padding: EdgeInsets.only(top: 45, left: 30, right: 30),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: FileImage(file),
                            fit: BoxFit.cover,
                          ),
                        border: Border.all(color: Colors.white, width: 5)
                      ),
                    ),
                    Positioned(
                      left: 80,
                      right: 80,
                      bottom: 5,
                      child: RaisedButton.icon(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35.0)),
                          color: Colors.blue,
                          onPressed: () => takeImage(context),
                          icon: Icon(Icons.camera_alt, color: Colors.white,size: 13,),
                          label: Text("Upload a Photo", style: TextStyle(color: Colors.white, fontSize: 12),)),
                    ),
                  ],
                ),
                SizedBox(height: 15,),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Name", textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.white)
                          )),
                      Container(
                        child: TextField(
                          maxLength: 19,
                          maxLengthEnforced: true,
                          style: TextStyle(color: Colors.black),
                          controller: NameTextEditingController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: new EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            hintText: 'ex: Burger Special ...',
                          ),
                        ),
                      ),
                      Text("Ingredients", textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.white)
                          )),
                      Container(
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          minLines: 1,//Normal textInputField will be displayed
                          maxLines: null,
                          style: TextStyle(color: Colors.black),
                          controller: IngridientsTextEditingController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: new EdgeInsets.symmetric(vertical: 9.0, horizontal: 10.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            hintText: 'ex:\nBun\nSalad\nbeef',
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text("Price", textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.white)
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(" Rm.", textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 17, color: Colors.white)
                              )),
                          Container(
                            width: 260,
                            child: TextField(
                              style: TextStyle(color: Colors.black),
                              controller: priceTextEditingController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: new EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                hintText: 'ex: 15',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 40, right: 40, top: 20),
            child:
              FlatButton(
                onPressed: uploading ? null : ()=> controlUploadAndSave(),
                color: Hexcolor("#FF9900"),
                child: Container(
                  height: 40.0,
                  child: Text("Continue",textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)
                    ),),
                  alignment: Alignment.center,
                ),
              ),
          ),
          uploading ? linearProgress() : Text(""),
        ],
      ),
    );
  }
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return file == null ? displayUploadScreen() : displayUploadFormScreen();
  }
}
