import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../providers/cart.dart';
//import 'package:provider/provider.dart';

class OrderItem {
  final String oid;
  final double oamount;
  final List<CartItem> oproducts;
  final DateTime odate;
  OrderItem({
    @required this.oid,
    @required this.oamount,
    @required this.oproducts,
    @required this.odate,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  String token;
  set authToken(String autok) {
    token = autok;
  }

  String _userId;
  set userId(String id) {
    _userId = id;
  }

  Future<void> addOrders(List<CartItem> products, double total) async {
    //final cartId=Provider.of<cart>(context);
    final url =
        'https://shop-712f9-default-rtdb.firebaseio.com/Orders/$_userId.json?auth=$token';
    //final cartIemIndex=products.indexWhere((cartItemid) => cartItemid.cId==);
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'oproducts': products
            .map((cp) => {
                  'cTitle': cp.cTitle,
                  'cPrice': cp.cPrice,
                  'cQuantity': cp.cQuantity,
                })
            .toList(),
        'odate': DateTime.now().toIso8601String(),
      }),
    );

    _orders.insert(
      0,
      OrderItem(
        oid: json.decode(response.body)['name'],
        oamount: total,
        oproducts: products,
        odate: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  Future<void> fetchOrders() async {
    final url =
        'https://shop-712f9-default-rtdb.firebaseio.com/Orders/$_userId.json?auth=$token&';
    final List<OrderItem> loadedOrders = [];
    final response = await http.get(url);
    print(response.body);
    final extractData = json.decode(response.body) as Map<String, dynamic>;
    if (extractData == null) {
      return;
    }
    extractData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
        oid: orderId,
        oamount: orderData['amount'],
        oproducts: (orderData['oproducts'] as List<dynamic>)
            .map(
              (item) => CartItem(
                cId: item['cId'],
                cTitle: item['cTitle'],
                cPrice: item['cPrice'],
                cQuantity: item['cQuantity'],
              ),
            )
            .toList(),
        odate: DateTime.parse((orderData['odate'])),
      ));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
}
