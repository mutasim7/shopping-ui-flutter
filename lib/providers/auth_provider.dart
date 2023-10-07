// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/services/auth_services.dart';

class AuthProvider with ChangeNotifier {
  // late UserModel user;
  static const userid = "id";
  static const userName = 'name';
  static const useremail = 'email';
  String? _token;
  String? get gettoken => _token;
  static const TOKEN = "TOKEN";
  AuthProvider() {
    getToken();
  }
  Future<void> getuserdata(String token) async {
    try {
      final response = await http.get(
        Uri.parse(AuthServices.linkgetuserapi),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        setUserData(
          id: jsonData['user']['id'],
          email: jsonData['user']['email'],
          name: jsonData['user']['name'],
        );
      } else if (response.statusCode == 401) {
        final errorJson = json.decode(response.body);
        var errorMessage = errorJson['message'];
        print('Error: $errorMessage');
        print('Failed to load user data');
      } else {
        print('Failed to load user data');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> setToken({required String token}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(TOKEN, token);
    notifyListeners();
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(TOKEN) ;
    notifyListeners();
    return _token;
  }

  Future<void> setUserData(
      {required String name, required String email, required int id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(userName, name);
    prefs.setString(useremail, email);
    prefs.setInt(userid, id);
    notifyListeners();
  }

  // Future<Map<String, dynamic>> getUserData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   // استخراج البيانات من SharedPreferences باستخدام المفاتيح المستخدمة
  //   String name = prefs.getString(userName) ?? "";
  //   String email = prefs.getString(useremail) ?? "";
  //   int id = prefs.getInt(userid) ?? 0;

  //   // إعادة البيانات كماب يحتوي على القيم
  //   return {
  //     "name": name,
  //     "email": email,
  //     "id": id,
  //   };
  // }

  Future<void> removeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
