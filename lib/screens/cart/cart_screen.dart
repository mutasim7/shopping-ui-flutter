import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/models/cart_model.dart';
import 'package:shopping_app/screens/cart/cart_widget.dart';
import 'package:shopping_app/services/assets_manager.dart';
import 'package:shopping_app/services/my_app_method.dart';
import 'package:shopping_app/widgets/empty_bag.dart';
import 'package:shopping_app/widgets/title_text.dart';

import '../../providers/cart_provider.dart';
import 'bottom_checkout.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final bool isEmpty = false;

  @override
  void initState() {
    MyAppMethods.onbackgroundclick(context);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<int> getUserId() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      int userid = prefs.getInt("id") ?? 0;
      print(userid);
      return userid;
    }

    final cartProvider = Provider.of<CartProvider>(context);

    final Map<String, CartModel> carttList = cartProvider.getCartItems;

    return carttList.isEmpty
        ? LiquidPullToRefresh(
            onRefresh: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              int userId = prefs.getInt("id") ?? 0;
              await cartProvider.fetchCart(userId.toString());
              setState(() {});
            },
            showChildOpacityTransition: false,
            child: Scaffold(
              body: EmptyBagWidget(
                imagePath: AssetsManager.shoppingBasket,
                title: "عربة التسوق فارغة",
                subtitle:
                    'يبدو أنك لم تقم بإضافة أي شيء بعد إلى سلة التسوق الخاصة بك  تابع وابدأ التسوق الآن',
                buttonText: "تسوق الآن",
              ),
            ),
          )
        : LiquidPullToRefresh(
            onRefresh: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              int userId = prefs.getInt("id") ?? 0;
              await cartProvider.fetchCart(userId.toString());
            },
            showChildOpacityTransition: false,
            child: Scaffold(
              bottomSheet: const CartBottomCheckout(),
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () async {
                    MyAppMethods.showErrorORWarningDialog(
                        isError: false,
                        context: context,
                        subtitle: "هل تريد تفريغ السلة",
                        fct: () async {
                          int userid = await getUserId();
                          await cartProvider.clearLocalCart(userid: userid);
                        });
                  },
                  icon: const Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.red,
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TitlesTextWidget(
                      label: "السلة (${cartProvider.getCartItems.length})",
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(AssetsManager.shoppingCart),
                  ),
                ],
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartProvider.getCartItems.length,
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                          value: cartProvider.getCartItems.values
                              .toList()
                              .reversed
                              .toList()[index],
                          child: const CartWidget(),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: kBottomNavigationBarHeight + 10,
                  )
                ],
              ),
            ),
          );
  }
}
