import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  toggleFavouriteStatus(String token, String userId) async {
    final oldstatus = isFavourite;
    isFavourite = !isFavourite;
    final url =
        'https://flutter-project-b70e3.firebaseio.com/userFavourites/$userId/$id.json?auth=$token';
    notifyListeners();
    try {
      final response = await http.put(url,
          body: json.encode(
            isFavourite,
          ));
      if (response.statusCode >= 400) {
        isFavourite = oldstatus;
        notifyListeners();
      }
    } catch (error) {
      isFavourite = oldstatus;
      notifyListeners();
    }
  }
}
