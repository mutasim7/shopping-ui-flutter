import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/models/cart_model.dart';
import 'package:shopping_app/providers/product_provider.dart';
import 'package:shopping_app/widgets/subtitle_text.dart';

import '../../providers/cart_provider.dart';

class QuantityBottomSheetWidget extends StatelessWidget {
  const QuantityBottomSheetWidget(
      {super.key, required this.cartModel, required this.unit});
  final CartModel cartModel;
  final String unit;
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    final cartProvider = Provider.of<CartProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 6,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(

                // shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics(),
                itemCount: unit == 'لتر' ||
                        unit == 'كيلو' ||
                        unit == 'متر' ||
                        unit == 'طن'
                    ? 2 *
                        cartProvider.getTotalQuantity(
                            productProvider: productProvider,
                            productID: cartModel.productId)
                    : cartProvider.getTotalQuantity(
                        productProvider: productProvider,
                        productID: cartModel.productId),
                itemBuilder: (context, index) {
                  double helper = (index + 1) / 2;
                  double quantity = unit == 'لتر' ||
                          unit == 'كيلو' ||
                          unit == 'متر' ||
                          unit == 'طن'
                      ? (helper)
                      : (index + 1);
                  return InkWell(
                    onTap: () {
                      cartProvider.updateQuantity(
                        productId: cartModel.productId,
                        quantity: quantity,
                      );
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Center(
                        child: SubtitleTextWidget(
                          label: "$quantity",
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
