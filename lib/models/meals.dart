import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String mealId;
  final String ownerId;
  //final String timestamp;
  final String name;
  final String ingredients;
  final double price;
  final String url;
  final double calories ;
  final double fat;
  final double carbs;
  final double sodium ;
  final double protein;

  Post({
    this.mealId,
    this.ownerId,
    //this.timestamp,
    this.name,
    this.ingredients,
    this.price,
    this.url,
    this.fat,
    this.sodium,
    this.carbs,
    this.calories,
    this.protein
  });

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      mealId: doc['mealId'],
      ownerId: doc['ownerId'],
      name: doc['name'],
      ingredients: doc['ingredients'],
      price: doc['price'],
      url: doc['url'],
      calories: doc["calories"],
      protein: doc["protein"],
      carbs: doc["carbs"],
      sodium: doc["sodium"],
      fat: doc["fat"],
    );
  }
}