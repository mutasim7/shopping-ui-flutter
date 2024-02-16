// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/providers/auth_provider.dart';
import 'package:shopping_app/screens/cart/send_orders.dart';
import 'package:shopping_app/services/my_app_method.dart';
import 'package:shopping_app/widgets/subtitle_text.dart';
import 'package:shopping_app/widgets/title_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';

class CartBottomCheckout extends StatefulWidget {
  const CartBottomCheckout({
    super.key,
  });
  @override
  State<CartBottomCheckout> createState() => _CartBottomCheckoutState();
}

class _CartBottomCheckoutState extends State<CartBottomCheckout> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<void> _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      // await ordersProvider.sendCartItemsToServer(
      //     context: context,
      //     cartProvider: cartProvider,
      //     productProvider: productProvider,
      //     authProvider: authProvider,
      //     address: address,
      //     name: name,
      //     number: number);
    }
  }

  launchWhatsApp() async {
    // تكوين الرابط لفتح واتساب مع رقم الهاتف
    final Uri url = Uri.parse('https://wa.me/31637779510');

    // التحقق من إمكانية فتح الرابط
    if (await canLaunchUrl(url)) {
      // فتح واتساب
      await launchUrl(url);
    } else {
      // في حالة عدم القدرة على فتح الرابط، يمكنك تنفيذ سلوك بديل
      print('لا يمكن فتح واتساب');
    }
  }

  String? address;
  String? name;
  String? number;
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: const Border(
          top: BorderSide(width: 1, color: Colors.grey),
        ),
      ),
      child: SizedBox(
        height: kBottomNavigationBarHeight + 25,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              authProvider.isloading
                  ? Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.deepPurpleAccent,
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    )
                  : ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              Colors.deepPurpleAccent)),
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        int userId = prefs.getInt("id") ?? 0;
                        await authProvider.getCurrentState(id: userId);
                        await authProvider.getcurrentState;
                        if (authProvider.getcurrentState == 0) {
                          MyAppMethods.showErrorORWarningDialogWithWhatsapp(
                              context: context,
                              subtitle:
                                  'لم يتم تفعيل الطلبات في حسابك لتفعيل الطلبات في حسابك إضغط على زر الواتساب في الأسفل لتواصل ومعرفة التفاصيل',
                              fct: () {
                                launchWhatsApp();
                              });
                        } else {
                          Navigator.pushNamed(
                            context,
                            SendOrders.routeName,
                          );
                        }
                      },
                      child: const Text(
                        "طلب",
                        style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FittedBox(
                      child: TitlesTextWidget(
                          label:
                              " ${cartProvider.getQty()} المنتجات ${cartProvider.getCartItems.length} / العناصر"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: SubtitleTextWidget(
                        label:
                            "${cartProvider.getTotalTL(productProvider: productProvider)}TL + ${cartProvider.getTotalUSD(productProvider: productProvider)}\$",
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
