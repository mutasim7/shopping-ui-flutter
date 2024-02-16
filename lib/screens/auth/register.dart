// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/Root_App_Screen.dart';
import 'package:shopping_app/consts/my_validators.dart';
import 'package:shopping_app/models/user_model.dart';
import 'package:shopping_app/providers/auth_provider.dart';
import 'package:shopping_app/providers/cart_provider.dart';
import 'package:shopping_app/screens/auth/login.dart';
import 'package:shopping_app/services/auth_services.dart';
import 'package:shopping_app/widgets/app_name_text.dart';
import 'package:shopping_app/widgets/title_text.dart';

class RegisterScreen extends StatefulWidget {
  static const routName = '/RegisterScreen';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController _nameController,
      _emailController,
      _passwordController;

  late final FocusNode _nameFocusNode, _emailFocusNode, _passwordFocusNode;
  late final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  bool isLoading = false;
  late String token;
  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    // Focus Nodes
    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    // Focus Nodes
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    Future<UserModel?> sendDataRegisterToLaravelAPI(
      Map<String, dynamic> data,
    ) async {
      final isValid = _formKey.currentState!.validate();
      FocusScope.of(context).unfocus();
      if (isValid) {
        try {
          setState(() {
            isLoading = true;
          });

          final response = await http.post(
            Uri.parse(AuthServices
                .linkregisterapi), // استبدل بعنوان النقطة النهائية الخاصة بك
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: jsonEncode(data), // تحويل البيانات إلى JSON
          );

          if (response.statusCode == 200) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            int userId = prefs.getInt("id") ?? 0;
            await cartProvider.clearLocalCart(userid: userId);
            FirebaseMessaging.instance.subscribeToTopic('users');
            setState(() {
              isLoading = false;
            });
            final jsonData = json.decode(response.body);
            String token = jsonData['token'];
            authProvider.setToken(token: token);
            authProvider.getuserdata(token);
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) =>  RootAppScreen(),
              ),
              (route) => false,
            );
          } else if (response.statusCode == 302) {
            setState(() {
              isLoading = false;
            });
            // final jsonData = json.decode(response.body);

            // String errorMessage = jsonData['message']['errors'];
            // print('حدثت مشكلة: $errorMessage');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Center(
                  child: Text(
                    "هذا البريد الإلكتروني مستخدم من قبل",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                backgroundColor: Colors.red,
              ),
            );
          } else {
            setState(() {
              isLoading = false; // تم إيقاف مؤشر التحميل بعد الانتهاء
            });
            print('حدثت مشكلة: ${response.statusCode}');
          }
        } catch (e) {
          setState(() {
            isLoading = false; // تم إيقاف مؤشر التحميل بعد الانتهاء
          });
          print(e.toString());
        }
      }

      return null;
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 60.0,
                ),
                const AppNameTextWidget(
                  fontSize: 40,
                ),
                const SizedBox(
                  height: 40.0,
                ),
                const Align(
                  alignment: Alignment.topRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TitlesTextWidget(
                        label: " أهلاً وسهلاً",
                        fontSize: 26,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        focusNode: _nameFocusNode,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          hintText: "الاسم الكامل",
                          prefixIcon: Icon(
                            IconlyLight.message,
                          ),
                        ),
                        validator: (value) {
                          return MyValidators.displayNamevalidator(value);
                        },
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(_emailFocusNode);
                        },
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: "البريد الإلكتروني",
                          prefixIcon: Icon(
                            IconlyLight.message,
                          ),
                        ),
                        validator: (value) {
                          return MyValidators.emailValidator(value);
                        },
                        onFieldSubmitted: (value) {
                          FocusScope.of(context)
                              .requestFocus(_passwordFocusNode);
                        },
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: obscureText,
                        decoration: InputDecoration(
                          hintText: "*********",
                          prefixIcon: const Icon(
                            IconlyLight.lock,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                            icon: Icon(
                              obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        validator: (value) {
                          return MyValidators.passwordValidator(value);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, LoginScreen.routName);
                              },
                              child: const Text(
                                'سجل الدخول',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              'لديك حساب؟',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: isLoading == true
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(12),
                                  // backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                  ),
                                ),
                                icon: const Icon(IconlyLight.addUser),
                                label: const Text(
                                  "إنشاء حساب",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                onPressed: () async {
                                  Map<String, dynamic> myData = {
                                    'name': _nameController.text.trim(),
                                    'email': _emailController.text.trim(),
                                    'password': _passwordController.text.trim(),
                                  };
                                  await sendDataRegisterToLaravelAPI(myData);
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
