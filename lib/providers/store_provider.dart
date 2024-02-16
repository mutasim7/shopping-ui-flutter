// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/models/store_model.dart';
import 'package:shopping_app/services/auth_services.dart';

class StoreProvider with ChangeNotifier {
  List<StoreModel> get getStores {
    return _Stores;
  }

  List<StoreModel> get getStoresAddress {
    return _Stores;
  }

  int? _StoreOrderState;
  int? get getStoreOrderStatus => _StoreOrderState;

  List<StoreModel> areList = [];
  List<StoreModel> findByArea({required String areName}) {
    areList = _Stores.where((element) =>
            element.storearea.toLowerCase().contains(areName.toLowerCase()))
        .toList();
    return areList;
  }

  List<StoreModel> findByStoreid({required int id}) {
    List<StoreModel> storeIdList =
        _Stores.where((element) => element.storeid == id).toList();

    String address = storeIdList.isNotEmpty ? storeIdList[0].storeaddress : '';
    return storeIdList;
  }

  List<StoreModel> findByCategory({required String stoName}) {
    List<StoreModel> ctgList = areList
        .where((element) =>
            element.storectg.toLowerCase().contains(stoName.toLowerCase()))
        .toList();
    return ctgList;
  }

  final List<StoreModel> _Stores = [];
  Future<List<StoreModel>> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse(AuthServices.linkfetchStoreapi));

      if (response.statusCode == 200) {
        // تم استقبال البيانات بنجاح
        final jsonData = json.decode(response.body);
        _Stores.clear();
        for (var userData in jsonData) {
          // قم بإنشاء نموذج UserModel لكل مستخدم وأضفه إلى قائمة المستخدمين
          _Stores.add(StoreModel.fromjson(userData));
        }

        print(_Stores);

        return areList;
      } else if (response.statusCode == 404) {
        // في حالة حدوث خطأ في الطلب
        print('خطأ في الطلب: ${response.statusCode}');
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
    return [];
  }

  Future<int?> getStoreOrderState({required int id}) async {
    try {
      final response = await http
          .get(Uri.parse('${AuthServices.linkgetStoreOrderStatus}/$id'));

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        _StoreOrderState = jsonData['orderstatus'];

        return _StoreOrderState;
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
