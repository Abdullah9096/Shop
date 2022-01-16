import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart ' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavourite = false});
  void statusFav(bool newStat) {
    isFavourite = newStat;
    notifyListeners();
  }

  Future<void> toggleFavouriteProduct(String token, String userId) async {
    final oldFavouriteVal = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();

    final url =
        'https://shop-712f9-default-rtdb.firebaseio.com/userFavourite/$userId/$id.json?auth=$token';

    try {
      final response = await http.put(
        url,
        body: json.encode(isFavourite),
      );
      if (response.statusCode >= 400) {
        statusFav(oldFavouriteVal);
      }
    } catch (error) {
      statusFav(oldFavouriteVal);
    }
  }
}
