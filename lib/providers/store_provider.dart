// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:shopping_app/models/store_model.dart';
import 'package:shopping_app/services/assets_manager.dart';

class StoreProvider with ChangeNotifier {
  List<StoreModel> get getStores {
    return _Stores;
  }

  List<StoreModel> areList = [];
  List<StoreModel> findByArea({required String areName}) {
    areList = _Stores.where((element) =>
            element.areastor.toLowerCase().contains(areName.toLowerCase()))
        .toList();
    return areList;
  }

  List<StoreModel> findByCategory({required String stoName}) {
    List<StoreModel> ctgList = areList
        .where((element) =>
            element.ctgstore.toLowerCase().contains(stoName.toLowerCase()))
        .toList();
    return ctgList;
  }

  final List<StoreModel> _Stores = [
    StoreModel(
        storeimg: AssetsManager.storemobiles,
        storename: "غرير",
        ctgstore: "جوالات",
        areastor: "الأشرفية"),
    StoreModel(
        storeimg: AssetsManager.storemobiles,
        storename: "الملاك",
        ctgstore: "جوالات",
        areastor: "شارع راجو"),
    StoreModel(
        storeimg: AssetsManager.storelaptop,
        storename: "شام",
        ctgstore: "لابتوبات",
        areastor: "المحمودية"),
    StoreModel(
        storeimg: AssetsManager.storeshoes,
        storename: "النور",
        ctgstore: "shoes",
        areastor: "شارع الفيلات"),
  ];
}
