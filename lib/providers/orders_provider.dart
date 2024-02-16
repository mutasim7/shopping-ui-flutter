// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/consts/my_validators.dart';
import 'package:shopping_app/models/orders_model.dart';
import 'package:shopping_app/providers/auth_provider.dart';
import 'package:shopping_app/providers/cart_provider.dart';
import 'package:shopping_app/providers/product_provider.dart';
import 'package:shopping_app/services/auth_services.dart';

class OrdersProvider with ChangeNotifier {
  bool isloading = false;
  List<OrdersModel> get getOrders {
    return _orders;
  }

  String? _name;

  Future<String> getName({required String id}) async {
    final response =
        await http.get(Uri.parse('${AuthServices.linkgetName}/$id'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      _name = jsonData['Name'];
    } else {
      isloading = false;
      notifyListeners();
      print('Unexpected error: ${response.statusCode}');
    }
    return _name!;
  }

  Future<void> sendCartItemsToServer({
    required BuildContext context,
    required CartProvider cartProvider,
    required ProductProvider productProvider,
    required AuthProvider authProvider,
    required String address,
    required String name,
    required String number,
  }) async {
    try {
      // final cartProvider = Provider.of<CartProvider>(context);

      isloading = true;
      notifyListeners();
      List<Map<String, dynamic>> cartItems = [];
      int? userid = await authProvider.getUserId();

      for (var entry in cartProvider.getCartItems.entries) {
        String? storeName = await getName(id: entry.value.storeid);
        final getCurrProduct =
            productProvider.findByProdId(entry.value.productId);

        if (getCurrProduct != null) {
          cartItems.add({
            'user_id': userid,
            'storeId': getCurrProduct.storeId,
            'productId': entry.value.productId,
            'productTitle': getCurrProduct.productTitle,
            'unit': getCurrProduct.productUnit,
            'price': double.parse(getCurrProduct.productPrice) *
                entry.value.quantity,
            'quantity': entry.value.quantity,
            'currencyType': getCurrProduct.productcurrencyType,
            'imageUrl': getCurrProduct.productImage,
            'address': address,
            'name': name,
            'number': number,
            'storeName': storeName,
          });
        }
      }

      final cartItemsJson = json.encode({"cartItems": cartItems});

      print(cartItemsJson);
      final response = await http.post(
        Uri.parse(AuthServices.linkSendAllOrders),
        headers: {'Content-Type': 'application/json'},
        body: cartItemsJson,
      );

      if (response.statusCode == 200) {
        cartProvider.clearLocalCart(userid: userid!);
        getAllProducts(userId: userid.toString());
        isloading = false;
        Navigator.pop(context);
        MyValidators.showSnackBar(
            context: context,
            backgroundColor: Colors.blueAccent,
            fontSize: 25,
            text: "تم أرسال الطلب بنجاح");
        var jsonData = json.decode(response.body);
        print('تم إرسال البيانات بنجاح.');
      } else {
        isloading = false;

        MyValidators.showSnackBar(
            context: context,
            backgroundColor: Colors.redAccent,
            fontSize: 25,
            text: "لم يتم إرسال الطلب");

        print('حدث خطأ: ${response.statusCode}');
      }
    } catch (e) {
      isloading = false;

      MyValidators.showSnackBar(
          context: context,
          backgroundColor: Colors.redAccent,
          fontSize: 25,
          text: "لم يتم إرسال الطلب");
      print(e.toString());
    }
    notifyListeners();
  }

  final List<OrdersModel> _orders = [];

  Future<List<OrdersModel>> getAllProducts({required String userId}) async {
    try {
      final response =
          await http.get(Uri.parse('${AuthServices.linkgetAllOrders}/$userId'));

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        _orders.clear();
        for (var item in jsonData['orders']) {
          _orders.add(OrdersModel.fromjson(item));
        }
        return _orders;
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }

    notifyListeners();
    return [];
  }

  OrdersModel? findByorderId(String orderId) {
    if (_orders
        .where((element) => element.orderId == int.parse(orderId))
        .isEmpty) {
      return null;
    }
    return _orders
        .firstWhere((element) => element.orderId == int.parse(orderId));
  }

  Future<void> removeOneOrder({required String orderId}) async {
    try {
      final response = await http
          .delete(Uri.parse('${AuthServices.linkdeleteOrder}/$orderId'));

      if (response.statusCode == 200) {
        _orders.removeWhere((order) => order.orderId == int.parse(orderId));
        print('تم حذف البيانات بنجاح');
        print(orderId);
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

  Future<void> removeAllOrders({required int userid}) async {
    try {
      final response = await http
          .delete(Uri.parse('${AuthServices.linkdeleteAllOrders}/$userid'));

      if (response.statusCode == 200) {
        _orders.clear();
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

  Future<void> updateQuantityforOrder(
      BuildContext context, int id, double quantity) async {
    try {
      print(id);
      print(quantity);
      // isLoading = true;
      final response = await http.put(
        Uri.parse('${AuthServices.linkupdateQuantityforOrder}/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'quantity': quantity}),
      );

      if (response.statusCode == 200) {
        MyValidators.showSnackBar(
            context: context,
            backgroundColor: const Color.fromARGB(255, 0, 193, 100),
            fontSize: 25,
            text: 'تم تحديث الطلب');
      } else if (response.statusCode == 404) {
        MyValidators.showSnackBar(
            context: context,
            backgroundColor: Colors.redAccent,
            fontSize: 25,
            text: "لم يتم تحديث الطلب");

        print('Error: لايوجد اتصال');

        // isLoading = false;
      } else {
        // isLoading = false;
        MyValidators.showSnackBar(
            context: context,
            backgroundColor: Colors.redAccent,
            fontSize: 25,
            text: "لم يتم تحديث الطلب");
        print('Unexpected error: ${response.statusCode.toString()}');
      }
    } catch (e) {
      // // isLoading = false;
      // MyValidators.showSnackBar(
      //     context: context,
      //     backgroundColor: Colors.redAccent,
      //     fontSize: 25,
      //     text: "لم يتم تحديث الطلب");

      print(e.toString());
    }
    notifyListeners();
  }
}
