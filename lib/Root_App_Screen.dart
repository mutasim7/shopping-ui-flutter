// ignore_for_file: unnecessary_string_interpolations, use_build_context_synchronously

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/providers/ads_provider.dart';
import 'package:shopping_app/providers/cart_provider.dart';
import 'package:shopping_app/providers/orders_provider.dart';
import 'package:shopping_app/providers/product_provider.dart';
import 'package:shopping_app/providers/store_provider.dart';
import 'package:shopping_app/screens/cart/cart_screen.dart';
import 'package:shopping_app/screens/home_screen.dart';
import 'package:shopping_app/screens/profile_screen.dart';
import 'package:shopping_app/screens/search_screen.dart';

class RootAppScreen extends StatefulWidget {
  @override
  RootAppScreenState createState() => RootAppScreenState();
}

class RootAppScreenState extends State<RootAppScreen> {
  bool isloading = true;

  // gettoken() async {
  //   String? mytoken = await FirebaseMessaging.instance.getToken();
  //   print(mytoken);
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     print('Got a message whilst in the foreground!');
  //     print('Message data: ${message.data}');

  //     if (message.notification != null) {
  //       Map<String, dynamic> arguments = {
  //         'storeId': int.parse(message.data['pageid'].toString()),
  //         'storeAddress': message.data['pagename'],
  //       };
  //       print(
  //           'Message also contained a notification: ${message.notification!.title}');
  //       print(
  //           'Message also contained a notification: ${message.notification!.body}');

  //       Navigator.pushNamed(context, SearchScreen.routeName,
  //           arguments: arguments);
  //     }
  //   });
  // }

  onbackgroundclick(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Map<String, dynamic> arguments = {
        'storeId': int.parse(message.data['pageid'].toString()),
        'storeAddress': message.data['pagename'],
      };
      if (message.notification != null) {
        Navigator.pushNamed(context, SearchScreen.routeName,
            arguments: arguments);
      }
    });
  }

  ontirmenetdclick(BuildContext context) async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    Map<String, dynamic> arguments = {
      'storeId': int.parse(message!.data['pageid'].toString()),
      'storeAddress': message.data['pagename'],
    };
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: arguments);
  }

  Future<void> fetchWithMethod() async {
    final productProvider = Provider.of<ProductProvider>(context);
    final storeProvider = Provider.of<StoreProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final adsProvider = Provider.of<AdsProvider>(context);

    try {
      await adsProvider.gatAllAds();
      await storeProvider.fetchData();
      await productProvider.getAllProducts();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int userId = prefs.getInt("id") ?? 0;
      await cartProvider.fetchCart(userId.toString());
      await ordersProvider.getAllProducts(userId: userId.toString());
    } catch (e) {
      print(e.toString());
      isloading = false;
    } finally {
      isloading = false;
    }
  }

  @override
  void didChangeDependencies() {
    if (isloading) {
      fetchWithMethod();
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    ontirmenetdclick(context);
    onbackgroundclick(context);
    super.initState();
  }

  var currentIndex = 0;
  List<Widget> screens = [
    const HomeScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    // double displayWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: screens.elementAt(currentIndex),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.deepPurpleAccent,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: GNav(
              gap: 8,
              color: Colors.white,
              tabBackgroundColor: const Color.fromARGB(158, 151, 113, 255),
              activeColor: const Color.fromARGB(255, 218, 206, 255),
              padding: const EdgeInsets.all(8),
              onTabChange: (Index) {
                setState(() {
                  currentIndex = Index;
                });
              },
              tabs: [
                const GButton(
                  icon: Icons.home,
                  iconSize: 30,
                  text: 'الصفحة الرئيسية',
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                GButton(
                  icon: IconlyBold.bag2,
                  iconSize: 30,
                  leading: Badge(
                    backgroundColor: Colors.purpleAccent,
                    label: Text(cartProvider.getCartItems.length.toString()),
                    child: const Icon(
                      IconlyLight.bag2,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  text: 'السلة',
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const GButton(
                  icon: Icons.person,
                  iconSize: 30,
                  text: 'الملف الشخصي',
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              ],
              selectedIndex: currentIndex,
            ),
          ),
        ),
      ),
    );
  }
}
