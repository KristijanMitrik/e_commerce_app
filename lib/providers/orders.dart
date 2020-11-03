import 'package:flutter/foundation.dart';
import '../providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
    this.id,
    this.amount,
    this.products,
    this.dateTime,
  );
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = new List<OrderItem>();
  final String authToken;
  final String userId;
  List<OrderItem> get orders {
    return _orders;
  }

  Orders(this.authToken,this._orders,this.userId);

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = 'https://flutter-project-b70e3.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price
                  })
              .toList(),
        }));
    _orders.insert(
        0,
        OrderItem(
          json.decode(response.body)['name'],
          total,
          cartProducts,
          timestamp,
        ));
    notifyListeners();
  }

  Future<void> fetchAndset() async {
    final url = 'https://flutter-project-b70e3.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
   
      if(extractedData==null)
      {
        return;
      }
    extractedData.forEach((orderId, orderData) {
      print('building');
      List<CartItem> list = [];
      print(orderData['products']);
      List<dynamic> list1 = orderData['products'];
      list1.forEach((item) {
       list.add(new  CartItem(item['id'], item['title'], item['quantity'], item['price']));
      });
       
      
      loadedOrders.add(OrderItem(
          orderId,
          orderData['amount'],
          list,
          DateTime.parse(
            orderData['dateTime'],
          )));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
}
