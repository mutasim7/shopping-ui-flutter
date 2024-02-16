import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/models/ads_model.dart';
import 'package:shopping_app/services/auth_services.dart';

class AdsProvider with ChangeNotifier {
  List<AdsModel> bannersImagesList = [];
  Future<List<AdsModel>> gatAllAds() async {
    try {
      final response = await http.get(Uri.parse(AuthServices.linkgetAllAds));

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        bannersImagesList.clear();
        for (var item in jsonData['ads']) {
          bannersImagesList.add(AdsModel.fromjson(item));
        }
        return bannersImagesList;
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }

    notifyListeners();
    return [];
  }
}
