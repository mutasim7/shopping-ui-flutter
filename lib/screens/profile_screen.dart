// ignore_for_file: use_build_context_synchronously

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/providers/auth_provider.dart';
import 'package:shopping_app/providers/cart_provider.dart';
import 'package:shopping_app/screens/auth/login.dart';
import 'package:shopping_app/screens/inner_screens/orders/orders_screen.dart';
import 'package:shopping_app/services/my_app_method.dart';
import 'package:shopping_app/widgets/app_name_text.dart';
import 'package:shopping_app/widgets/subtitle_text.dart';
import 'package:shopping_app/widgets/title_text.dart';

import '../providers/theme_provider.dart';
import '../services/assets_manager.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    MyAppMethods.onbackgroundclick(context);
    // TODO: implement initState
    super.initState();
  }

  // Map<String, dynamic> userData = {};
  // @override
  // void initState() {
  //   super.initState();
  //   final userDataProvider = Provider.of<AuthProvider>(context, listen: false);
  //   // استدعاء الميثود لاسترجاع البيانات عند تهيئة الحالة
  //   userDataProvider.getUserData().then((data) {
  //     setState(() {
  //       userData = data;
  //     });
  //   });
  // }
  static const userid = "id";
  static const userName = 'name';
  static const useremail = 'email';
  Future<Map<String, dynamic>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // استخراج البيانات من SharedPreferences باستخدام المفاتيح المستخدمة
    String name = prefs.getString(userName) ?? "";
    String email = prefs.getString(useremail) ?? "";
    int id = prefs.getInt(userid) ?? 0;

    // إعادة البيانات كماب يحتوي على القيم
    return {
      "name": name,
      "email": email,
      "id": id,
    };
  }

  Future<Map<String, dynamic>> fetchData() async {
    // هنا يمكنك استدعاء الميثود لاسترجاع البيانات
    // يتم استرجاع البيانات كـ Map<String, dynamic>
    return await getUserData();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
        appBar: AppBar(
          actions: [
            const Padding(
              padding: EdgeInsets.only(top: 5, right: 5),
              child: AppNameTextWidget(fontSize: 30),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(AssetsManager.shoppingCart),
            ),
          ],
        ),
        body: FutureBuilder<Map<String, dynamic>>(
            // تمرير الـ Future لـ FutureBuilder
            future: fetchData(),
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // إذا كان الـ Future قيد التحميل، يمكنك إظهار رسالة تحميل
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // إذا حدث خطأ أثناء تنفيذ الـ Future، يمكنك إظهار رسالة خطأ
                return Center(child: Text('حدث خطأ: ${snapshot.error}'));
              }
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // isLoading
                          //     ? Center(
                          //         child:
                          //             CircularProgressIndicator()) // عرض مؤشر التحميل
                          //     :
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TitlesTextWidget(label: snapshot.data!["name"]),
                              SubtitleTextWidget(
                                  label: snapshot.data!["email"]),
                            ],
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).cardColor,
                              border: Border.all(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  width: 3),
                              image: const DecorationImage(
                                image: NetworkImage(
                                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png",
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const TitlesTextWidget(
                            label: "عام",
                            fontSize: 25,
                          ),
                          CustomListTile(
                            imagePath: AssetsManager.orderSvg,
                            text: "كل الطلبات",
                            function: () async {
                              await Navigator.pushNamed(
                                context,
                                OrdersScreenFree.routeName,
                              );
                            },
                          ),

                          // CustomListTile(
                          //   imagePath: AssetsManager.recent,
                          //   text: "Viewed recently",
                          //   function: () async {
                          //     await Navigator.pushNamed(
                          //       context,
                          //       ViewedRecentlyScreen.routName,
                          //     );
                          //   },
                          // ),

                          const Divider(
                            thickness: 1,
                          ),

                          const TitlesTextWidget(label: "إعدادات"),
                          const SizedBox(
                            height: 7,
                          ),
                          SwitchListTile(
                            title: Text(
                                textAlign: TextAlign.right,
                                themeProvider.getIsDarkTheme
                                    ? "الوضع الداكن"
                                    : "الوضع الفاتح"),
                            secondary: Image.asset(
                              AssetsManager.theme,
                              height: 30,
                            ),
                            value: themeProvider.getIsDarkTheme,
                            onChanged: (value) {
                              themeProvider.setDarkTheme(themeValue: value);
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.login, color: Colors.white),
                        label: const Text(
                          "تسجيل الخروج",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        onPressed: () async {
                          await MyAppMethods.showErrorORWarningDialog(
                              context: context,
                              subtitle: "هل تريد تسجيل الخروج حقاً",
                              fct: () async {
                                FirebaseMessaging.instance
                                    .unsubscribeFromTopic('stores');

                                await authProvider.removeData();

                                Navigator.pushNamed(
                                  context,
                                  LoginScreen.routName,
                                );
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                int userId = prefs.getInt("id") ?? 0;
                                await cartProvider.fetchCart(userId.toString());
                              },
                              isError: false);
                        },
                      ),
                    ),
                  ],
                ),
              );
            }));
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile(
      {super.key,
      required this.imagePath,
      required this.text,
      required this.function});
  final String imagePath, text;
  final Function function;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        function();
      },
      leading: const Icon(IconlyLight.arrowLeft2),
      title: Text(
        textAlign: TextAlign.right,
        text,
        style: const TextStyle(fontSize: 18),
      ),
      trailing: Image.asset(
        imagePath,
        height: 30,
      ),
    );
  }
}
