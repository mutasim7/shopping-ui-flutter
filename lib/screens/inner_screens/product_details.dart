// ignore_for_file: use_build_context_synchronously

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/auth_provider.dart';
import 'package:shopping_app/providers/store_provider.dart';
import 'package:shopping_app/services/auth_services.dart';
import 'package:shopping_app/services/my_app_method.dart';

import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/app_name_text.dart';
import '../../widgets/subtitle_text.dart';
import '../../widgets/title_text.dart';

class ProductDetails extends StatefulWidget {
  static const routName = '/ProductDetails';
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  void initState() {
    MyAppMethods.onbackgroundclick(context);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    Size size = MediaQuery.of(context).size;

    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final storeProvider = Provider.of<StoreProvider>(context);

    final getCurrProduct = productProvider.findByProdId(productId);
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const AppNameTextWidget(fontSize: 30),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.canPop(context) ? Navigator.pop(context) : null;
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 18,
            )),
        // automaticallyImplyLeading: false,
      ),
      body: getCurrProduct == null
          ? const SizedBox.shrink()
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  FancyShimmerImage(
                    imageUrl:
                        AuthServices.linkStorage + getCurrProduct.productImage,
                    height: size.height * 0.38,
                    width: double.infinity,
                    boxFit: BoxFit.contain,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SubtitleTextWidget(
                              label:
                                  "${getCurrProduct.productPrice} ${getCurrProduct.productcurrencyType}",
                              color: Colors.deepPurpleAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Flexible(
                              // flex: 5,
                              child: Text(
                                getCurrProduct.productTitle,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              getCurrProduct.productUnit,
                              style: const TextStyle(
                                  fontSize: 25, color: Colors.deepPurpleAccent),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            const Text(
                              "الوحدة",
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: kBottomNavigationBarHeight - 10,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurpleAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          30,
                                        ),
                                      ),
                                    ),
                                    onPressed: () async {
                                      await storeProvider.getStoreOrderState(
                                          id: getCurrProduct.storeId);
                                      storeProvider.getStoreOrderStatus;
                                      if (storeProvider.getStoreOrderStatus ==
                                          0) {
                                        MyAppMethods.showErrorORWarningDialog(
                                            context: context,
                                            subtitle:
                                                "لا يمكن الطلب من هذا المتجر",
                                            fct: () {});
                                      } else {
                                        if (cartProvider.isProductInCart(
                                            productId: getCurrProduct.productId
                                                .toString())) {
                                          return;
                                        }
                                        int? userid =
                                            await authProvider.getUserId();

                                        Map<String, dynamic> myData = {
                                          'user_id': userid.toString(),
                                          'storeId':
                                              getCurrProduct.storeId.toString(),
                                          'productId': getCurrProduct.productId
                                              .toString(),
                                          'quantity': 1,
                                        };
                                        await cartProvider
                                            .addProductToCart(myData);
                                      }
                                    },
                                    icon: Icon(
                                      cartProvider.isProductInCart(
                                        productId:
                                            getCurrProduct.productId.toString(),
                                      )
                                          ? Icons.check
                                          : Icons.add_shopping_cart_rounded,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      cartProvider.isProductInCart(
                                        productId:
                                            getCurrProduct.productId.toString(),
                                      )
                                          ? "موجود في السلة"
                                          : "إضافة إلى السلة",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TitlesTextWidget(
                                label: "وصف عن المنتج",
                                fontSize: 23,
                              ),
                              // SubtitleTextWidget(
                              //     label: "In ${getCurrProduct.productCategory}")
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        SubtitleTextWidget(
                          label: getCurrProduct.productDescription,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
