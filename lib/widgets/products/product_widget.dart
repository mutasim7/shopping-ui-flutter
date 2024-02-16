// ignore_for_file: use_build_context_synchronously

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/auth_provider.dart';
import 'package:shopping_app/providers/store_provider.dart';
import 'package:shopping_app/screens/inner_screens/product_details.dart';
import 'package:shopping_app/services/auth_services.dart';
import 'package:shopping_app/services/my_app_method.dart';
import 'package:shopping_app/widgets/subtitle_text.dart';
import 'package:shopping_app/widgets/title_text.dart';

import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({
    super.key,
    required this.productId,
    required this.storeId,
  });

  final String productId;
  final int storeId;
  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    // final productModelProvider = Provider.of<ProductModel>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrProduct = productProvider.findByProdId(widget.productId);
    final cartProvider = Provider.of<CartProvider>(context);
    final storeProvider = Provider.of<StoreProvider>(context);

    // final viewedProvider = Provider.of<ViewedProdProvider>(context);
    Size size = MediaQuery.of(context).size;
    return getCurrProduct == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.all(3.0),
            child: GestureDetector(
              onTap: () async {
                // viewedProvider.addProductToHistory(
                //     productId: getCurrProduct.productId.toString());
                Navigator.pushNamed(
                  context,
                  ProductDetails.routName,
                  arguments: getCurrProduct.productId.toString(),
                );
                await productProvider.getViews(id: getCurrProduct.productId);
                int views = productProvider.getviews!;
                views += 1;
                productProvider.updateviews(
                    context, getCurrProduct.productId, views);
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: FancyShimmerImage(
                      imageUrl: AuthServices.linkStorage +
                          getCurrProduct.productImage,
                      width: double.infinity,
                      height: size.height * 0.22,
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 7,
                      ),
                      Flexible(
                        flex: 5,
                        child: TitlesTextWidget(
                          label: getCurrProduct.productTitle,
                          maxLines: 2,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 3,
                          child: SubtitleTextWidget(
                            label:
                                "${getCurrProduct.productPrice} ${getCurrProduct.productcurrencyType}",
                          ),
                        ),

                        Flexible(
                          child: Material(
                            borderRadius: BorderRadius.circular(16.0),
                            color: Colors.deepPurpleAccent,
                            child: InkWell(
                              splashColor:
                                  const Color.fromARGB(255, 98, 13, 255),
                              borderRadius: BorderRadius.circular(16.0),
                              onTap: () async {
                                int? userid = await authProvider.getUserId();
                                await storeProvider.getStoreOrderState(
                                    id: widget.storeId);
                                storeProvider.getStoreOrderStatus;
                                if (storeProvider.getStoreOrderStatus == 0) {
                                  MyAppMethods.showErrorORWarningDialog(
                                      context: context,
                                      subtitle: "لا يمكن الطلب من هذا المتجر",
                                      fct: () {});
                                } else {
                                  if (cartProvider.isProductInCart(
                                      productId: getCurrProduct.productId
                                          .toString())) {
                                    return;
                                  }
                                  setState(() {
                                    isLoading = true;
                                  });
                                  Map<String, dynamic> myData = {
                                    'user_id': userid.toString(),
                                    'storeId': getCurrProduct.storeId,
                                    'productId':
                                        getCurrProduct.productId.toString(),
                                    'quantity': 1,
                                  };
                                  await cartProvider.addProductToCart(myData);
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : Icon(
                                        cartProvider.isProductInCart(
                                          productId: getCurrProduct.productId
                                              .toString(),
                                        )
                                            ? Icons.check
                                            : Icons.add_shopping_cart_rounded,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   width: 1,
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "${getCurrProduct.views}",
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.remove_red_eye,
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
