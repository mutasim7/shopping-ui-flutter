// ignore_for_file: unnecessary_string_interpolations

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
import 'package:shopping_app/screens/inner_screens/orders/orders_screen.dart';
import 'package:shopping_app/screens/search_screen.dart';
import 'package:shopping_app/services/my_app_method.dart';

class RootAppStoreScreen extends StatefulWidget {
  static const routeName = '/RootAppStoreScreen';

  @override
  RootAppStoreScreenState createState() => RootAppStoreScreenState();
}

class RootAppStoreScreenState extends State<RootAppStoreScreen> {
  bool isloading = true;

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
    MyAppMethods.onbackgroundclick(context);
    // TODO: implement initState
    super.initState();
  }

  var currentIndex = 0;
  List<Widget> screens = [
    const SearchScreen(),
    const CartScreen(),
    const OrdersScreenFree(),
  ];
  @override
  Widget build(BuildContext context) {
    // double displayWidth = MediaQuery.of(context).size.width;
    final cartProvider = Provider.of<CartProvider>(context);
    final orderProvider = Provider.of<OrdersProvider>(context);

    return Scaffold(
      body: screens.elementAt(currentIndex),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 10),
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
              padding: const EdgeInsets.all(6),
              onTabChange: (Index) {
                setState(() {
                  currentIndex = Index;
                });
              },
              tabs: [
                const GButton(
                  icon: Icons.store_outlined,
                  iconSize: 30,
                  text: 'المتجر',
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
                    backgroundColor: Colors.white,
                    textColor: Colors.purpleAccent,
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
                GButton(
                  icon: Icons.shop_2,
                  iconSize: 30,
                  leading: Badge(
                    backgroundColor: Colors.white,
                    textColor: Colors.purpleAccent,
                    label: Text(orderProvider.getOrders.length.toString()),
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  text: 'الطلبات',
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
              selectedIndex: currentIndex,
            ),
          ),
        ),
      ),
    );
  }
}
