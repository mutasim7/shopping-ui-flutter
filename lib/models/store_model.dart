import 'package:flutter/material.dart';

class StoreModel with ChangeNotifier {
  final String storeimg, storename, ctgstore, areastor;

  StoreModel(
      {required this.ctgstore,
      required this.storeimg,
      required this.storename,
      required this.areastor});
}
