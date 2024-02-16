import 'package:flutter/material.dart';

class ProductModel with ChangeNotifier {
  final int productId, storeId, views;
  final String productTitle,
      productPrice,
      productUnit,
      productcurrencyType,
      productDescription,
      productImage,
      productQuantity;

  ProductModel({
    required this.storeId,
    required this.productId,
    required this.views,
    required this.productTitle,
    required this.productPrice,
    required this.productUnit,
    required this.productcurrencyType,
    required this.productDescription,
    required this.productImage,
    required this.productQuantity,
  });

  factory ProductModel.fromJeson(Map<String, dynamic> jesondata) {
    return ProductModel(
      storeId: jesondata['store_id'],
      productId: jesondata['id'],
      views: jesondata['views'],
      productTitle: jesondata['name'],
      productUnit: jesondata['unit'],
      productPrice: jesondata['price'],
      productcurrencyType: jesondata['currencyType'],
      productDescription: jesondata['description'],
      productImage: jesondata['image'],
      productQuantity: jesondata['quantity'],
    );
  }
}
