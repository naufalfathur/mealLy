import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meally2/main/RestaurantHome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meally2/main/mealUpload.dart';
import 'package:meally2/models/restaurant.dart';
import 'package:meally2/restaurant/ReviewPage.dart';
import 'package:meally2/widgets/RestaurantPostTile.dart';
import 'package:meally2/widgets/RestaurantPostWidget.dart';
import 'package:meally2/widgets/ProgressWidget.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as ImD;
import 'package:meally2/widgets/RestaurantPostWidget.dart';
import 'package:meally2/widgets/ProgressWidget.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
class restaurantMenu extends StatefulWidget {
  final String userRestId;
  final Restaurant gCurrentRest;

  restaurantMenu({this.userRestId, this.gCurrentRest});
  @override
  _restaurantMenuState createState() => _restaurantMenuState();
}

class _restaurantMenuState extends State<restaurantMenu> {
  final String currentOnlineRestId = currentRest.id;
  bool loading = false;
  File file;
  int countPost = 0;
  List<Post> postlist = [];
  String postOrientation = "list";
  TextEditingController NameTextEditingController = TextEditingController();
  TextEditingController IngridientsTextEditingController = TextEditingController();
  TextEditingController priceTextEditingController = TextEditingController();


  @override
  void initState(){
    super.initState();
    defaultImage("https://i.ibb.co/NFfysyq/No-Image-Available.png");
    //getAllProfilePost();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 50, right: 50, top: 10),
            child:  Column(
              children: [
                Text("Upload your meals here\n"
                    "to delete, just swipe the meals",textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 11)
                  ),),
              ],
            ),
          ),
          Divider(),
          Expanded(child: retrieveMeals())
          //displayProfilePost(),
        ],
      ),
      bottomSheet:  uploadMeal(),
    );
  }

  uploadMeal(){
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
      child: Container(
        child: GestureDetector(
          onTap: uploadPict,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: AssetImage("assets/images/bg.png"),
                fit: BoxFit.fitWidth,
              ),

            ),
            width: double.infinity,
            height: 50.0,
            //margin: EdgeInsets.only(top: 10),
            child: Text("Upload meals", style: GoogleFonts.poppins(textStyle: TextStyle(color:Colors.white , fontWeight: FontWeight.w600),)),
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }

  uploadPict(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => mealUpload(gCurrentRest: currentRest, currentOnlineRestId: currentOnlineRestId)));
  }

  retrieveMeals(){
    return StreamBuilder(
      stream: mealsReference.document(widget.userRestId).collection("mealList").orderBy("timestamp", descending: true).snapshots(),
      builder: (context, dataSnapshot){
        print("b");
        if(!dataSnapshot.hasData){
          print("c");
          return circularProgress(Colors.orangeAccent);
        }
        print("d");
        List<Post> meals = [];
        dataSnapshot.data.documents.forEach((document){
          meals.add(Post.fromDocument(document, true));
        });
        if(meals.isEmpty){
          return Container(height: 400, alignment: Alignment.center,child: Text("no meals available"));
        }
        return ListView.builder(
          itemCount: meals.length,
          itemBuilder: (BuildContext context, int index){
            final items = List<String>.generate(meals.length, (i) => "Item ${i + 1}");
            return Dismissible(
              background: Container(color: Colors.red),
              key: UniqueKey(),
              onDismissed: (direction) {
                mealsReference.document(meals[index].ownerId).collection("mealList").document(meals[index].mealId).delete();
                setState(() {
                  items.removeAt(index);
                });
                Scaffold.of(context).showSnackBar(SnackBar(content: Text(meals[index].name + "removed")));
              },
              child: Container(
                child:  GestureDetector(
                  onTap: ()=> displayComment(context, mealId: meals[index].mealId, ownerId: meals[index].ownerId, url: meals[index].url),
                  child: ListTile(
                    minVerticalPadding: 10,
                    leading: Container(
                      height: 100,
                      width: 100,
                      //margin: EdgeInsets.only(left: 20, right: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(meals[index].url),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(meals[index].name, textAlign: TextAlign.start,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black)
                            )),
                        Text("rm " + meals[index].price.toString(),
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.black)
                            )),
                        Text(meals[index].calories.toString() + " kcal",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Colors.black)
                            )),
                      ],
                    ),
                    trailing:GestureDetector(
                        onTap: () async {
                          bool opt = await defaultImage(meals[index].url);
                          if (opt){
                            editMeals(context,meals[index].mealId, meals[index].name,  meals[index].price);
                          }else{
                          }
                        },
                        child: Icon(Icons.edit, color: Colors.black54, size: 20,)),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  displayComment(BuildContext context, {String mealId, String ownerId, String url}){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return ReviewPage(mealId: mealId, mealOwnerId: ownerId, mealImageUrl: url, restOnline: true);
    }
    ));
  }

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
  defaultImage(String url) async {
    File imageFile = await urlToFile(url);
    setState(() {
      this.file =  imageFile;
    });
    if(file==null){
      return false;
    }else{
      return true;
    }

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
  compressingPhoto(String mealId) async{
    File compressedFile = await FlutterNativeImage.compressImage(file.path,
      quality: 25,);
    setState(() {
      file = compressedFile;
    });
  }
  Future<String> uploadPhoto(mImageFile, String mealId) async{
    StorageUploadTask mStorageUploadTask = storageReference.child("post_$mealId.jpg").putFile(mImageFile);
    StorageTaskSnapshot storageTaskSnapshot =  await mStorageUploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
  controlUploadAndSave(String mealId) async{
    await compressingPhoto(mealId);

    String downloadUrl = await uploadPhoto(file, mealId);
    //savePostInfoToFirestore(url: downloadUrl, name: NameTextEditingController.text, ingredients: IngridientsTextEditingController.text, price: double.tryParse(priceTextEditingController.text));
    mealsReference.document(widget.gCurrentRest.id).collection("mealList").document(mealId).updateData({
      "name": NameTextEditingController.text,
      "price": double.tryParse(priceTextEditingController.text)+0.01,
      "url": downloadUrl,
    });
    NameTextEditingController.clear();
    priceTextEditingController.clear();
    Navigator.pop(context);
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

  void editMeals(context, String id, String name, double price){
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
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState){
                NameTextEditingController.text = name;
                priceTextEditingController.text = price.toString();
                return Scaffold(
                  appBar: AppBar(
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.white,
                    leading: GestureDetector(
                        onTap: (){Navigator.pop(context);},
                        child: Icon(Icons.arrow_back_ios_rounded,size: 14, color: Colors.black,)),
                    title: Text("Edit Meals", style: GoogleFonts.poppins(textStyle:
                    TextStyle(fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.w600),),),
                    actions: <Widget>[
                      IconButton(icon: Icon(Icons.check, color: Colors.black,), onPressed:  ()=> controlUploadAndSave(id),)
                    ],
                  ),
                  body: Container(
                      height: MediaQuery.of(context).size.height,
                      alignment: Alignment.center,
                      //padding: EdgeInsets.only(left: 30, right: 30, top: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        //borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                      ),
                      child: ListView(
                        children: [
                          Stack(
                            children: <Widget>[
                              Container(
                                height: (MediaQuery.of(context).size.height/2)-80,
                                width: MediaQuery.of(context).size.width,
                                //margin: EdgeInsets.only(left: 20, right: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: FileImage(file),
                                    fit: BoxFit.cover,
                                  ),
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
                          Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 25, right: 25, top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Meal", style: GoogleFonts.poppins(textStyle:
                                    TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                                    Container(
                                      //color: Colors.blue,
                                      width: MediaQuery.of(context).size.width-150,
                                      child: TextField(
                                        textAlign: TextAlign.end,
                                        style: TextStyle(color: Colors.black),
                                        controller: NameTextEditingController,
                                        decoration: InputDecoration(
                                            border: InputBorder.none
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Price (rm)", style: GoogleFonts.poppins(textStyle:
                                    TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                                    Container(
                                      //color: Colors.blue,
                                      width: MediaQuery.of(context).size.width-150,
                                      child: TextField(
                                        textAlign: TextAlign.end,
                                        style: TextStyle(color: Colors.black),
                                        controller: priceTextEditingController,
                                        decoration: InputDecoration(
                                            border: InputBorder.none
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                  ),
                );
              });
        });
  }

  displayProfilePost(){
    if(loading){
      return circularProgress(Colors.orangeAccent);
    }else if(postlist.isEmpty){
      return Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 100),
              child: Icon(Icons.photo_library, color: Colors.grey, size: 100,),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text("no data", style: TextStyle(color: Colors.grey, fontSize: 30, fontWeight: FontWeight.bold),),
            )
          ],
        ),
      );
    }else if(postOrientation == "grid"){
      List<GridTile> gridTilesList = [];
      postlist.forEach((eachPost) {
        gridTilesList.add(GridTile(child: RestaurantPostTile(eachPost)));
      });
      return Container(
          color: Colors.white,
          child:GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            mainAxisSpacing: 1.5,
            crossAxisSpacing: 1.5,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: gridTilesList,
          )
      );
    }
    else if(postOrientation == "list"){
      return Container(
        color: Colors.white,
        child:
        Column(
          children: postlist,
        ),
      );
    }
  }

  getAllProfilePost() async{
    setState(() {
      loading = true;
    });

    QuerySnapshot querySnapshot = await mealsReference.document(widget.userRestId).collection("mealList").orderBy("timestamp", descending: true).getDocuments();

    setState(() {
      loading = false;
      countPost = querySnapshot.documents.length;
      postlist = querySnapshot.documents.map((documentSnapshot) => Post.fromDocument(documentSnapshot, true)).toList();
    });
  }


}
