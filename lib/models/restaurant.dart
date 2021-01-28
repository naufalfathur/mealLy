import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  final String id;
  final String RestaurantName;
  final String url;
  final String email;
  final int postcode;
  final String city;
  final String cuisine;
  final String accreditation;
  final String location;
  final String PICName;
  final int PICNo;
  final String PICPosition;
  final String certificate;
  final double earnings;

  Restaurant({
    this.id,
    this.RestaurantName,
    this.url,
    this.email,
    this.postcode,
    this.cuisine,
    this.city,
    this.accreditation,
    this.location,
    this.PICName,
    this.PICNo,
    this.PICPosition,
    this.certificate,
    this.earnings
  });

  factory Restaurant.fromDocument(DocumentSnapshot doc) {
    return Restaurant(
        id: doc.documentID,
        email: doc['email'],
        url: doc['url'],
        RestaurantName: doc['RestaurantName'],
        postcode: doc['postcode'],
        cuisine: doc['cuisine'],
        city: doc['city'],
        accreditation: doc['accreditation'],
        location: doc['location'],
        PICName: doc['PICName'],
        PICNo: doc['PICNo'],
        PICPosition: doc["PICPosition"],
        certificate: doc["certificate"],
        earnings: doc["earnings"]
    );
  }
}