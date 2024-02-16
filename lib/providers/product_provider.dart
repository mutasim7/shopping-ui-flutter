import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/services/auth_services.dart';

import '../models/product_model.dart';

class ProductProvider with ChangeNotifier {
  List<ProductModel> get getProducts {
    return _products;
  }

  int? _views;
  int? get getviews => _views;

  final List<ProductModel> _products = [];

  ProductModel? findByProdId(String productId) {
    if (_products
        .where((element) => element.productId == int.parse(productId))
        .isEmpty) {
      return null;
    }
    return _products
        .firstWhere((element) => element.productId == int.parse(productId));
  }

  List<ProductModel> findByStoreid({required int id}) {
    List<ProductModel> storeIdList =
        _products.where((element) => element.storeId == id).toList();
    return storeIdList;
  }

  List<ProductModel> searchQuery(
      {required String searchText, required List<ProductModel> passedList}) {
    List<ProductModel> searchList = passedList
        .where((element) => element.productTitle
            .toLowerCase()
            .contains(searchText.toLowerCase()))
        .toList();
    return searchList;
  }

  Future<List<ProductModel>> getAllProducts() async {
    try {
      final response =
          await http.get(Uri.parse(AuthServices.linkfetchProductapi));

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        _products.clear();
        for (var item in jsonData['products']) {
          _products.add(ProductModel.fromJeson(item));
        }
        return _products;
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }

    notifyListeners();
    return [];
  }

  Future<int?> getViews({required int id}) async {
    try {
      final response =
          await http.get(Uri.parse('${AuthServices.linkgetviews}/$id'));

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        _views = jsonData['views'];
        print(_views);

        return _views;
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateviews(BuildContext context, int id, int views) async {
    try {
      print(id);
      print(views);
      // isLoading = true;
      final response = await http.post(
        Uri.parse('${AuthServices.linkupdateviews}/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'views': views}),
      );

      if (response.statusCode == 200) {
        // isLoading = false;
        final jsonData = json.decode(response.body);
        var message = jsonData['message'];

        print(message);
      } else if (response.statusCode == 404) {
        final jsonData = json.decode(response.body);
        var message = jsonData['message'];

        print('Error: لايوجد اتصال');

        // isLoading = false;
      } else {
        // isLoading = false;
      }
    } catch (e) {
      // isLoading = false;

      print(e.toString());
    }
    notifyListeners();
  }
}
