import 'package:flutter/material.dart';

class StoreModel with ChangeNotifier {
  final int storeid, status;
  final String? storeImage;
  final String storename, storectg, storeaddress, storearea;

  StoreModel(
      {required this.storectg,
      required this.storeaddress,
      required this.storeid,
      required this.status,
      required this.storename,
      required this.storeImage,
      required this.storearea});

  factory StoreModel.fromjson(Map<String, dynamic> json) {
    return StoreModel(
        storectg: json['category'],
        storeaddress: json['address'],
        storeid: json['id'],
        status: json['status'],
        storename: json['name'],
        storeImage: json['image'],
        storearea: json['area']);
  }
}
