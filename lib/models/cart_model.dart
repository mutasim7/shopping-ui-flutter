import 'package:flutter/material.dart';

class CartModel with ChangeNotifier {
  final int cartId;
  final String productId;
  final double quantity;
  final int userid;
  final String storeid;
  String address;

  CartModel({
    required this.userid,
    required this.storeid,
    required this.cartId,
    required this.productId,
    required this.quantity,
    this.address = "",
  });

  factory CartModel.fromjson(Map<String, dynamic> json) {
    return CartModel(
        userid: json['user_id'],
        storeid: json['storeId'],
        cartId: json['id'],
        productId: json['productId'],
        quantity: double.parse(json['quantity'].toString()));
  }

  Map<String, dynamic> toJson() => {
        'user_id': userid,
        'storeId': storeid,
        'productId': productId,
        'quantity': quantity,
        'address': address,
      };
}
