import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exceptions.dart';

import 'product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _items = [
    /*Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
        id: 'p2',
        title: 'Trousers',
        description: 'A nice pair of trousers.',
        price: 59.99,
        imageUrl:
            'https://img.shein.com/images/sheinside.com/201505/1432021574017436926_thumbnail_600x799.webp'),
    Product(
      id: 'p3',
      title: 'Red Shirt2',
      description: 'A red shirt2 - it is pretty red2!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
        id: 'p4',
        title: 'Trousers2',
        description: 'A nice pair of trousers2.',
        price: 59.99,
        imageUrl:
            'https://img.shein.com/images/sheinside.com/201505/1432021574017436926_thumbnail_600x799.webp'),*/
  ];
  String _authToken;
  String _userId;
  set authntToken(String tok) {
    _authToken = tok;
  }

  set userId(String id) {
    _userId = id;
  }

  /* ProductProvider(this.token, this._items);*/

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((productItem) => productItem.isFavourite).toList();
  }

  Product findById(String id) {
    return items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final creator =
        filterByUser ? 'orderBy="creatorId"&equalTo="$_userId"' : '';
    var url =
        'https://shop-712f9-default-rtdb.firebaseio.com/products.json?auth=$_authToken&$creator';
    try {
      final response = await http.get(url);

      final extractData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProduct = [];
      if (extractData == null) {
        return;
      }
      url =
          'https://shop-712f9-default-rtdb.firebaseio.com/userFavourite/$_userId.json?auth=$_authToken';
      final responseFavourite = await http.get(url);
      final favouriteData = json.decode(responseFavourite.body);
      extractData.forEach((prodId, prodData) {
        loadedProduct.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavourite:
                favouriteData == null ? false : favouriteData[prodId] ?? false,
          ),
        );
      });
      _items = loadedProduct;
      notifyListeners();
    } catch (error) {
      print('the error is $error');

      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://shop-712f9-default-rtdb.firebaseio.com/products.json?auth=$_authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'creatorId': _userId
        }),
      );

      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      final url =
          'https://shop-712f9-default-rtdb.firebaseio.com/products/$id.json?auth=$_authToken';

      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          }));
      _items[productIndex] = newProduct;
    }
    notifyListeners();
  }

  Future<void> removeProduct(String id) async {
    final url =
        'https://shop-712f9-default-rtdb.firebaseio.com/products/$id.json?auth=$_authToken';
    final productIndex = _items.indexWhere((product) => product.id == id);
    var product = _items[productIndex];
    _items.removeAt(productIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(productIndex, product);
      notifyListeners();
      throw HttpException('Server response error!! status code more than 400');
    }
    product = null;
  }
}
