import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/models/cart_model.dart';
import 'package:shopping_app/services/auth_services.dart';

import '../models/product_model.dart';
import 'product_provider.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartModel> _cartItems = {};

  Map<String, CartModel> get getCartItems {
    return _cartItems;
  }

  bool isProductInCart({required String productId}) {
    return _cartItems.containsKey(productId);
  }

  Future<int> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int userid = prefs.getInt("id") ?? 0;
    print(userid);
    return userid;
  }

  Future<void> addProductToCart(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(AuthServices.linkProductsInCart),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        int userid = await getUserId();
        fetchCart(userid.toString());
        final jsonData = json.decode(response.body);
        var cart = jsonData['ProductsInCart'];
        print(cart);
      } else if (response.statusCode == 404) {
        print('Error: لايوجد اتصال');
      } else {
        print('Unexpected error: ${response.statusCode}');
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future<void> fetchCart(String userId) async {
    try {
      final response = await http
          .get(Uri.parse('${AuthServices.linkfetchAllProductsInCart}/$userId'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        var productsInCart = jsonData['ProductsInCart'];

        for (var cartData in productsInCart) {
          var cartModel = CartModel.fromjson(cartData);
          var productId = cartModel.productId;
          _cartItems[productId] = cartModel;
        }

        print('تم استلام البيانات من السلة بنجاح');
      } else if (response.statusCode == 404) {
        print('خطأ في الطلب: ${response.statusCode}');
      } else {
        print('Unexpected error: ${response.statusCode}');
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  void updateQuantity({required String productId, required double quantity}) {
    _cartItems.update(
      productId,
      (item) => CartModel(
        cartId: item.cartId,
        productId: productId,
        quantity: quantity,
        storeid: item.storeid,
        userid: item.userid,
      ),
    );
    notifyListeners();
  }

  int getTotalQuantity(
      {required ProductProvider productProvider, required String productID}) {
    int totalQuantity = 0;

    final ProductModel? getCurrProduct =
        productProvider.findByProdId(productID);
    if (getCurrProduct != null) {
      totalQuantity = int.parse(getCurrProduct.productQuantity);
    }

    return totalQuantity;
  }

  double getTotalTL({required ProductProvider productProvider}) {
    double totalTL = 0.0;

    _cartItems.forEach((key, value) {
      final ProductModel? getCurrProduct =
          productProvider.findByProdId(value.productId);
      if (getCurrProduct == null) {
        totalTL += 0;
      } else if (getCurrProduct.productcurrencyType == "TL") {
        totalTL += double.parse(getCurrProduct.productPrice) * value.quantity;
      }
    });
    return totalTL;
  }

  double getTotalUSD({required ProductProvider productProvider}) {
    double totalUSD = 0.0;

    _cartItems.forEach((key, value) {
      final ProductModel? getCurrProduct =
          productProvider.findByProdId(value.productId);
      if (getCurrProduct == null) {
        totalUSD += 0;
      } else if (getCurrProduct.productcurrencyType == "\$") {
        totalUSD += double.parse(getCurrProduct.productPrice) * value.quantity;
      }
    });
    return totalUSD;
  }

  double getQty() {
    double total = 0;
    _cartItems.forEach((key, value) {
      total += value.quantity;
    });
    return total;
  }

  Future<void> removeOneItem(
      {required String cartId, required String productId}) async {
    try {
      final response = await http
          .delete(Uri.parse('${AuthServices.linkdeleteProductInCart}/$cartId'));

      if (response.statusCode == 200) {
        _cartItems.remove(productId);
        int userid = await getUserId();
        fetchCart(userid.toString());
        print('تم حذف البيانات بنجاح');
        print(cartId);
      } else if (response.statusCode == 404) {
        print('خطأ في الطلب: ${response.statusCode}');
      } else {
        print('Unexpected error: ${response.statusCode}');
      }
    } catch (e) {
      print(e.toString());
    }

    notifyListeners();
  }

  Future<void> clearLocalCart({required int userid}) async {
    try {
      final response = await http.delete(
          Uri.parse('${AuthServices.linkdeleteAllProductsInCart}/$userid'));

      if (response.statusCode == 200) {
        _cartItems.clear();
        int userid = await getUserId();
        fetchCart(userid.toString());
        print('تم حذف البيانات بنجاح');
        print(userid);
      } else if (response.statusCode == 404) {
        print('خطأ في الطلب: ${response.statusCode}');
      } else {
        print('Unexpected error: ${response.statusCode}');
      }
    } catch (e) {
      print(e.toString());
    }

    notifyListeners();
  }
}
