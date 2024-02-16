// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/cart_provider.dart';
import 'package:shopping_app/providers/orders_provider.dart';
import 'package:shopping_app/providers/product_provider.dart';
import 'package:shopping_app/widgets/subtitle_text.dart';

class QuantityBottomSheetOrderWidget extends StatefulWidget {
  const QuantityBottomSheetOrderWidget(
      {super.key,
      required this.unit,
      required this.productId,
      required this.orderId,
      required this.userId});
  final String unit;
  final String productId;
  final String userId;
  final int orderId;

  @override
  State<QuantityBottomSheetOrderWidget> createState() =>
      _QuantityBottomSheetOrderWidgetState();
}

class _QuantityBottomSheetOrderWidgetState
    extends State<QuantityBottomSheetOrderWidget> {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final ordersProvider = Provider.of<OrdersProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SubtitleTextWidget(
            label: "تعديل كمية الطلب",
          ),
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
                itemCount: widget.unit == 'لتر' ||
                        widget.unit == 'كيلو' ||
                        widget.unit == 'متر' ||
                        widget.unit == 'طن'
                    ? 2 *
                        cartProvider.getTotalQuantity(
                            productProvider: productProvider,
                            productID: widget.productId)
                    : cartProvider.getTotalQuantity(
                        productProvider: productProvider,
                        productID: widget.productId),
                itemBuilder: (context, index) {
                  double helper = (index + 1) / 2;
                  double quantity = widget.unit == 'لتر' ||
                          widget.unit == 'كيلو' ||
                          widget.unit == 'متر' ||
                          widget.unit == 'طن'
                      ? (helper)
                      : (index + 1);
                  return InkWell(
                    onTap: () async {
                      await ordersProvider.updateQuantityforOrder(
                          context, widget.orderId, quantity);
                      await ordersProvider.getAllProducts(
                          userId: widget.userId);

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
