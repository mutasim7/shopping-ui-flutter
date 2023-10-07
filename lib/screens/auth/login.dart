// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shopping_app/consts/my_validators.dart';
import 'package:shopping_app/providers/auth_provider.dart';
import 'package:shopping_app/root_screen.dart';
import 'package:shopping_app/screens/auth/register.dart';
import 'package:shopping_app/services/auth_services.dart';
import 'package:shopping_app/widgets/app_name_text.dart';
import 'package:shopping_app/widgets/auth/google_btn.dart';
import 'package:shopping_app/widgets/subtitle_text.dart';
import 'package:shopping_app/widgets/title_text.dart';

class LoginScreen extends StatefulWidget {
  static const routName = '/LoginScreen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  late final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  bool isLoading = false;
  

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    // Focus Nodes
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    // Focus Nodes
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loginFct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {}
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    Future<void> sendDataLoginToLaravelAPI(Map<String, dynamic> data) async {
      final isValid = _formKey.currentState!.validate();
      FocusScope.of(context).unfocus();
      if (isValid) {
        try {
          setState(() {
            isLoading = true;
          });
          final response = await http.post(
            Uri.parse(AuthServices.linkloginapi),
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: jsonEncode(data),
          );

          if (response.statusCode == 200) {
            setState(() {
              isLoading = false;
            });
            final jsonData = json.decode(response.body);
            String token = jsonData['token'];
            print(token);
            authProvider.setToken(token: token);
            authProvider.getuserdata(token);
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const RootScreen(),
              ),
              (route) => false,
            );
          } else if (response.statusCode == 401) {
            final errorJson = json.decode(response.body);
            var errorMessage = errorJson['message'];
            print('Error: $errorMessage');
          } else {
            setState(() {
              isLoading = false;
            });
            // في حالة حدوث خطأ غير متوقع
            print('Unexpected error: ${response.statusCode}');
          }
        } catch (e) {
          setState(() {
            isLoading = false;
          });
          print(e.toString());
        }
      }
      return;
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
                  child: TitlesTextWidget(
                    label: "أهلاً وسهلاً بعودتك",
                    fontSize: 26,
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
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
                        textInputAction: TextInputAction.done,
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
                        onFieldSubmitted: (value) {
                          _loginFct();
                        },
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      const SizedBox(
                        height: 16.0,
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
                                icon: const Icon(Icons.login),
                                label: const Text(
                                  "تسجيل الدخول",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                onPressed: () async {
                                  Map<String, dynamic> myData = {
                                    'email': _emailController.text.trim(),
                                    'password': _passwordController.text.trim(),
                                  };
                                  await sendDataLoginToLaravelAPI(myData);
                                },
                              ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: kBottomNavigationBarHeight + 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                flex: 2,
                                child: SizedBox(
                                  height: kBottomNavigationBarHeight,
                                  child: FittedBox(
                                    child: GoogleButton(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            child: const SubtitleTextWidget(
                              label: "إنشاء حساب",
                              textDecoration: TextDecoration.underline,
                              fontStyle: FontStyle.italic,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, RegisterScreen.routName);
                            },
                          ),
                          const SubtitleTextWidget(
                            label: "إذا كنت لا تملك حساب؟",
                          ),
                        ],
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
