import 'package:flutter/material.dart';
import 'package:meally2/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meally2/models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:meally2/widgets/ProgressWidget.dart';
import 'package:google_fonts/google_fonts.dart';

class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  //final String timestamp;
  final String name;
  final String description;
  final String url;

  Post({
    this.postId,
    this.ownerId,
    //this.timestamp,
    this.name,
    this.description,
    this.url,
  });

  factory Post.fromDocument(DocumentSnapshot documentSnapshot){
    return Post(
      postId: documentSnapshot["postId"],
      ownerId: documentSnapshot["ownerId"],
      //timestamp: documentSnapshot["timestamp"],
      name: documentSnapshot["profileName"],
      description: documentSnapshot["description"],
      url: documentSnapshot["url"],
    );
  }

  @override
  _PostState createState() => _PostState(
    postId : this.postId,
    ownerId : this.ownerId,
    //timestamp : this.timestamp,
    name : this.name,
    description : this.description,
    url : this.url,
  );
}

class _PostState extends State<Post> {
  final String postId;
  final String ownerId;

  //final String timestamp;
  final String name;
  final String description;
  final String url;
  final String currentOnlineUserId = currentUser?.id;

  _PostState({
    this.postId,
    this.ownerId,
    //this.timestamp,
    this.name,
    this.description,
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          createPostHead(),
          //createPostPicture(),
          //createPostFooter(),
        ],
      ),
    );
  }
  createPostHead(){
    return FutureBuilder(
      future: userReference.document(ownerId).get(),
      builder: (context, dataSnapshot){
        if(!dataSnapshot.hasData){
          return circularProgress(Colors.orangeAccent);
        }
        User user = User.fromDocument(dataSnapshot.data);
        bool isPostOwner = currentOnlineUserId == ownerId;

        return ListTile(
          //leading: CircleAvatar(backgroundImage: CachedNetworkImageProvider(user.url), backgroundColor: Colors.grey,),
          title: GestureDetector(
            onTap: ()=> print("show profile"),
            child: Text("$description Kg", style: GoogleFonts.poppins(textStyle: TextStyle(color:Colors.black , fontWeight: FontWeight.w600),)),
          ),
          subtitle: Text("timestamp", style: GoogleFonts.poppins(textStyle: TextStyle(color:Colors.black , fontWeight: FontWeight.w400, fontSize: 12),)),
          trailing: CircleAvatar(backgroundImage: CachedNetworkImageProvider(url), backgroundColor: Colors.grey,),
        );
      },
    );
  }

  createPostPicture(){
    return GestureDetector(
      onDoubleTap: ()=> print("postLiked"),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.network(url),
        ],
      ),
    );
  }

  createPostFooter(){
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 40.0, left: 20.0)),
            GestureDetector(
              onTap: ()=> print("Liked post"),
              child: Icon(
                Icons.favorite, color: Colors.grey,
                /*isLiked ? Icons.favorite : Icons.favorite_border,
                size: 28.0,
                color: Colors.pink,
                 */
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 20.0)),
            GestureDetector(
              onTap: ()=> print("show comment"),
              child: Icon( Icons.chat_bubble_outline,
                size: 28.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                "$name ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(child: Text(
              description, style: TextStyle(color: Colors.black),
            ),),
          ],
        ),
      ],
    );
  }


}
