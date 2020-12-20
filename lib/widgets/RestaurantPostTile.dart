import 'package:flutter/material.dart';
import 'package:meally2/widgets/RestaurantPostWidget.dart';

class RestaurantPostTile extends StatelessWidget {
  final Post post;
  RestaurantPostTile(this.post);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Image.network(post.url),
    );
  }
}
