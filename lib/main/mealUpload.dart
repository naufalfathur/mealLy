import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meally2/models/nutritionsInfo.dart';
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
import 'package:flutter_native_image/flutter_native_image.dart';
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
  double abcaaa = 0.0;
  double calories = 0.0 ;
  String ing;
  double fat = 0.0;
  double carbs = 0.0;
  double sodium = 0.0;
  double protein = 0.0;
  TextEditingController NameTextEditingController = TextEditingController();
  TextEditingController IngridientsTextEditingController = TextEditingController();
  TextEditingController priceTextEditingController = TextEditingController();
  PageController pageController = PageController();
  int pageChanged = 0;
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
      backgroundColor: HexColor("#FF9900"),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                alignment: Alignment(-1, 0),
                image: AssetImage("assets/images/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: PageView(
              //physics:new NeverScrollableScrollPhysics(),
              pageSnapping: true,
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  pageChanged = index;
                });
                print(pageChanged);
              },
              children: [
                //page0(),
                page1(),
                page2(),
                page3(),
                page4(),
                page5()
              ],
            ),
          ),
        ],
      ),
    );
  }

  page1(){
    return Container(
      height: 500,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(40),
      //color: Colors.redAccent,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 340,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Chef.png"),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          SizedBox(height: 10,),
          Text("Adding your meals in MealLy! its really simple", textAlign: TextAlign.center, style: GoogleFonts.poppins(textStyle:
          TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white)
          ),),
          SizedBox(height: 10,),
          Text("Swipe to see how this works", style: GoogleFonts.poppins(textStyle:
          TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.white)
          ),),
          SizedBox(height: 10,),
          GestureDetector(
              onTap: (){
                pageController.animateToPage(++pageChanged, duration: Duration(milliseconds: 250), curve: Curves.bounceInOut);
              },
              child: Container(
                decoration: const ShapeDecoration(
                  color: Colors.white,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_forward),
                  color: Colors.orangeAccent,
                  onPressed: (){

                  },
                ),
              )
          ),
        ],
      ),
    );
  }
  page2(){
    return Container(
      padding: EdgeInsets.all(40),
      height: 500,
      width: MediaQuery.of(context).size.width,
      //color: Colors.black,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 500,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/upload2.png"),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          SizedBox(height: 10,),
          Text("Just fill in the name and price and upload some fancy photo", textAlign: TextAlign.center, style: GoogleFonts.poppins(textStyle:
          TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white)
          ),),
          SizedBox(height: 10,),
          Text("remember, Customer will see through the meals, attract them by your picts", textAlign: TextAlign.center, style: GoogleFonts.poppins(textStyle:
          TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Colors.white)
          ),),
        ],
      ),
    );
  }
  page3(){
    return Container(
      height: 500,
      padding: EdgeInsets.all(40),
      width: MediaQuery.of(context).size.width,
      //color: Colors.blue,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 500,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/upload3.png"),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          SizedBox(height: 10,),
          Text("MealLy will automatically calculate your meals nutrition. Thus, for the best result state your ingredients like in the example!", textAlign: TextAlign.center, style: GoogleFonts.poppins(textStyle:
          TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white)
          ),),
        ],
      ),
    );
  }
  page4(){
    return Container(
      height: 500,
      padding: EdgeInsets.all(40),
      width: MediaQuery.of(context).size.width,
      //color: Colors.blue,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 500,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/upload5.png"),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          SizedBox(height: 10,),
          Text("Lastly, Hit submit \n and the meals are set!", textAlign: TextAlign.center, style: GoogleFonts.poppins(textStyle:
          TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white)
          ),),
        ],
      ),
    );
  }
  page5(){
    return Container(
      height: 500,
      padding: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      //color: Colors.blue,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Its very simple\nLets get started!", textAlign: TextAlign.center, style: GoogleFonts.poppins(textStyle:
          TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white)
          ),),
          SizedBox(height: 15,),
          GestureDetector(
            onTap: (){
              showLoading();
              defaultImage();
            },
            child: Container(
              height: 50,
              width: 160,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text("Continue", textAlign: TextAlign.center, style: GoogleFonts.poppins(textStyle:
              TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.orangeAccent)
              ),),
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
    File compressedFile = await FlutterNativeImage.compressImage(file.path,
      quality: 25,);
    setState(() {
      file = compressedFile;
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
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    //Navigator.push(context, MaterialPageRoute(builder: (context) => RestaurantHome()));
  }
  Future<Welcome> getRec2(String text) async{
    var client = http.Client();
    var welcome;
    String ups = text;
    try{
      var response = await client.post(
        'https://api.spoonacular.com/recipes/parseIngredients?apiKey=8d294ea254074f929f33000a4ed329ea',
        body: "includeNutrition=true&servings=1&ingredientList=$ups",);
      print(response.body);
      print(response.statusCode);
      if(response.statusCode == 200){
        var jsonString = response.body;
        var jsonMap = jsonDecode(jsonString);
        List<dynamic> posts = List<Welcome>.from(jsonMap.map((model)=> Welcome.fromJson(model)));
        int a = posts.length;
        String aa = Welcome.fromJson(jsonMap[1]).nutrition.nutrients.first.amount.toString();
        welcome = Welcome.fromJson(jsonMap[0]);

        print(posts.length.toString() + "s");
        for(int i = 0; i< posts.length; i++){
          abcaaa += Welcome.fromJson(jsonMap[i]).nutrition.nutrients.first.amount;
        }
        print(abcaaa.toString() + "adadbb");
        print(welcome);
        setState(() {
          abcaaa = abcaaa;
        });

      }
    }catch(Exception){
      print(Exception);
      return welcome;
    }

    print("bb");
    return welcome;
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
      "price": price+0.01,
      "url": url,
      "calories": calories+0.01,
      "fat" : fat+0.01,
      "carbs" : carbs+0.01,
      "sodium" : sodium+0.01,
      "protein" : protein+0.01,

    });
  }
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Counting nutrition for the meals..'),
          content: SingleChildScrollView(
            child: Container(
              height: 180,
              //width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                child: Image(
                  image: AssetImage('assets/images/chemist.gif'),
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ),
        );
      },
    );
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
          SizedBox(height: 15,),
          Container(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
                            hintText: "ex. Homemade Pasta",
                            hintStyle: TextStyle(color: Colors.grey),
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
                            hintText: "ex. 15",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Text("Ingredients :", style: GoogleFonts.poppins(textStyle:
                TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),

                  height: 120,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    textAlign: TextAlign.start,
                    minLines: 1,//Normal textInputField will be displayed
                    maxLines: null,
                    style: TextStyle(color: Colors.black),
                    controller: IngridientsTextEditingController,
                    decoration: InputDecoration(
                        hintText: 'ex:\n0.5 cup of rice\n1 tablespoon garlic\n20 grams of chicken',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("disclaimer : \nmealLy will not store the exact info about your ingredients, only the name and its nutrition", style: GoogleFonts.poppins(textStyle:
                  TextStyle(fontSize: 11.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 40, right: 40, top: 10),
            child:
              GestureDetector(

                onTap: uploading ? null : () async {
                  _showMyDialog();
                  print(IngridientsTextEditingController.text);
                  ing = await API_Manager().getIng(IngridientsTextEditingController.text);
                  calories = (await API_Manager().getRec(IngridientsTextEditingController.text, "Calories")+0.1);
                  fat = await API_Manager().getRec(IngridientsTextEditingController.text, "Fat")+0.1;
                  carbs = await API_Manager().getRec(IngridientsTextEditingController.text, "Carbohydrates")+0.1;
                  sodium = await API_Manager().getRec(IngridientsTextEditingController.text, "Sodium")+0.1;
                  protein = await API_Manager().getRec(IngridientsTextEditingController.text, "Protein")+0.1;
                  print("$calories, $fat, $carbs, $sodium, $protein");
                  print("$ing");
                  _successModal(context);
                },
                //onPressed: uploading ? null : ()=> controlUploadAndSave(),
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
                  child: Text("Submit",textAlign: TextAlign.center,
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
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState){
                return Scaffold(
                  appBar: AppBar(
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.white,
                    leading: GestureDetector(
                      onTap: (){Navigator.pop(context);},
                        child: Icon(Icons.arrow_back_ios_rounded,size: 14, color: Colors.black,)),
                    title: Text("Meals summary", style: GoogleFonts.poppins(textStyle:
                    TextStyle(fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.w600),),),
                    actions: <Widget>[
                      IconButton(icon: Icon(Icons.check, color: Colors.black,), onPressed: uploading ? true : ()=> controlUploadAndSave(),)
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
                          uploading ? linearProgress() : Text(""),
                          Container(
                            height: (MediaQuery.of(context).size.height/2)-100,
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
                          Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 25, right: 25, top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(NameTextEditingController.text,
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 30)
                                  ),),
                                SizedBox(height: 6,),
                                Text("Calories",
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 15)
                                  ),),
                                Text("$calories kcal",
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(color: HexColor("#FF9900"), fontWeight: FontWeight.w600, fontSize: 27)
                                  ),),
                                SizedBox(height: 10,),
                                Text("Ingredients",
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 15)
                                  ),),
                                Text(ing, style: GoogleFonts.poppins(
                                    textStyle: TextStyle(color: Colors.black26, fontWeight: FontWeight.w600, fontSize: 15)
                                ),),
                                SizedBox(height: 10,),
                                Text("Nutritions",
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 15)
                                  ),),
                                SizedBox(height: 3,),
                                Container(
                                  height: 85.0,
                                  child: ListView.builder(
                                      itemCount: 1,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (BuildContext context, int i) {
                                        return  Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              height: 80,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.orangeAccent.withOpacity(0.5), width: 5),
                                                  color: Colors.white,
                                                  shape: BoxShape.circle
                                              ),
                                              child: Center(
                                                child: Text("fat\n"+fat.toStringAsFixed(2),textAlign: TextAlign.center, style: GoogleFonts.poppins(textStyle:
                                                TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                                              ),
                                            ),
                                            SizedBox(width: 10,),
                                            Container(
                                              height: 80,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.blue.withOpacity(0.5), width: 5),
                                                  color: Colors.white,
                                                  shape: BoxShape.circle
                                              ),
                                              child: Center(
                                                child: Text("carbs\n"+carbs.toStringAsFixed(2),textAlign: TextAlign.center, style: GoogleFonts.poppins(textStyle:
                                                TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                                              ),
                                            ),
                                            SizedBox(width: 10,),
                                            Container(
                                              height: 80,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.red.withOpacity(0.5), width: 5),
                                                  color: Colors.white,
                                                  shape: BoxShape.circle
                                              ),
                                              child: Center(
                                                child: Text("sodium\n"+sodium.toStringAsFixed(2),textAlign: TextAlign.center, style: GoogleFonts.poppins(textStyle:
                                                TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                                              ),
                                            ),
                                            SizedBox(width: 10,),
                                            Container(
                                              height: 80,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.green.withOpacity(0.5), width: 5),
                                                  color: Colors.white,
                                                  shape: BoxShape.circle
                                              ),
                                              child: Center(
                                                child: Text("protein\n"+protein.toStringAsFixed(2), textAlign: TextAlign.center,style: GoogleFonts.poppins(textStyle:
                                                TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.w500),),),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Text("Price",
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 15)
                                  ),),
                                Text("rm" + priceTextEditingController.text,
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(color: HexColor("#FF9900"), fontWeight: FontWeight.w600, fontSize: 27)
                                  ),),
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

}

class API_Manager {
  //Future<Welcome> get abcaaa => null;

  /*
  var client = http.Client();
  Future<Welcome> createAlbum() async {
    var welcome;
    Map<String, String> data = {
      "servings": "1",
      "ingredientList": "1 apple\n2 cups of coffee\n1.4 liters almond milk\n2 1/2 salmon fillets\nkale"
    };
    final response = await client.post(
      Strings.url,
      body: Strings.data
    );
    //final response2 = await client.send( Strings.data);
    print(response.body);
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      var jsonString = response.body;
      var jsonMap = jsonDecode(jsonString);
      welcome = Welcome.fromJson(jsonMap);
      print(jsonString);
      print("aa");
      return Welcome.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      print("bb");
      throw Exception('Failed to load album');
    }
  }
*/

  Future<double> createOrderMessage(String text, String type) async{
    double order = await getRec(text, "calories");
    //print(order.toString());
    return order;
  }

  Future<double> getRec(String text, String type) async{
    var client = http.Client();
    var welcome;
    double result = 0.0;
    String ups = text;

    try{
      var response = await client.post(
        'https://api.spoonacular.com/recipes/parseIngredients?apiKey=871cc9ddc1ea4733830dd2c30e3d691a',
        body: "includeNutrition=true&servings=1&ingredientList=$ups",);
      //print(response.body);
      //print(response.statusCode);
      if(response.statusCode == 200){
        var jsonString = response.body;
        var jsonMap = jsonDecode(jsonString);
        List<dynamic> posts = List<Welcome>.from(jsonMap.map((model)=> Welcome.fromJson(model)));
        List<Welcome> posts2 = List<Welcome>.from(jsonMap.map((model)=> Welcome.fromJson(model)));
        int a = posts.length;
        String aa = Welcome.fromJson(jsonMap[1]).nutrition.nutrients.first.amount.toString();
        welcome = Welcome.fromJson(jsonMap[0]);

        //print(posts.length.toString() + "s");
        /*
        if(type == "calories"){
          for(int i = 0; i< posts.length; i++){
            result += Welcome.fromJson(jsonMap[i]).nutrition.nutrients[25].amount;
          }
        }else if(type == "fat"){
          for(int i = 0; i< posts.length; i++){
            result += Welcome.fromJson(jsonMap[i]).nutrition.nutrients[1].amount;
          }
        }else if(type == "carbs"){
          for(int i = 0; i< posts.length; i++){
            result += Welcome.fromJson(jsonMap[i]).nutrition.nutrients[3].amount;
          }
        }else if(type == "sodium"){
          for(int i = 0; i< posts.length; i++){
            result += Welcome.fromJson(jsonMap[i]).nutrition.nutrients[7].amount;
          }
        }else if(type == "protein"){
          for(int i = 0; i< posts.length; i++){
            result += Welcome.fromJson(jsonMap[i]).nutrition.nutrients[9].amount;
          }
        }
         */

        double value = 0.0;
        for(int i = 0; i< posts2.length; i++){
          print("a" + i.toString());
          //print("ingName" + posts2[i].name);
          print("a2" +  posts2[i].nutrition.nutrients.length.toString());
          for(int j = 0; j< posts2[i].nutrition.nutrients.length; j++){
            if(posts2[i].nutrition.nutrients[j].name == type){
              print("name : " + posts2[i].nutrition.nutrients[j].name);
              value +=  posts2[i].nutrition.nutrients[j].amount;
              print("value : " + value.toString());
            }
          }
        }
        result = value.round().truncateToDouble();
        print("total Value" + result.toString());

        //print(abcaaa.toString() + "adadbb");
        //print(jsonString);

      }
    }catch(Exception){
      print(Exception);
      return result;
    }

    //print("bb");
    return result;
  }

  Future<String> getIng(String text) async{
    var client = http.Client();
    String result;
    String ups = text;

    try{
      var response = await client.post(
        'https://api.spoonacular.com/recipes/parseIngredients?apiKey=871cc9ddc1ea4733830dd2c30e3d691a',
        body: "includeNutrition=true&servings=1&ingredientList=$ups",);
      //print(response.body);
      //print(response.statusCode);
      if(response.statusCode == 200){
        var jsonString = response.body;
        var jsonMap = jsonDecode(jsonString);
        List<Welcome> posts2 = List<Welcome>.from(jsonMap.map((model)=> Welcome.fromJson(model)));

        String ing = "";
        for(int i = 0; i< posts2.length; i++){
          //print("a" + i.toString());
          //print("ingName" + posts2[i].name);
          String ing2 = posts2[i].name + "\n";
          ing = ing + ing2;
        }
        //print (ing);
        result = ing;

      }
    }catch(Exception){
      print(Exception);
      return result;
    }

    //print("bb");
    return result;
  }
}
