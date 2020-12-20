import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String profileName;
  final String url;
  final String email;
  final String gender;
  final int age;
  final double weight;
  final double initialWeight;
  final double height;
  final double bodyfat;
  final double lbm;
  final int tdee;

  User({
    this.id,
    this.profileName,
    this.url,
    this.email,
    this.gender,
    this.age,
    this.weight,
    this.initialWeight,
    this.height,
    this.bodyfat,
    this.lbm,
    this.tdee,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc.documentID,
      email: doc['email'],
      url: doc['url'],
      profileName: doc['profileName'],
      gender: doc['gender'],
      age: doc['age'],
      weight: doc['weight'],
      initialWeight: doc['initialWeight'],
      height: doc['height'],
      bodyfat: doc['bodyfat'],
      lbm: doc["lbm"],
      tdee: doc["tdee"],
    );
  }
}