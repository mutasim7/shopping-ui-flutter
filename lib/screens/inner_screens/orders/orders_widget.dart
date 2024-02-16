import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/orders_provider.dart';
import 'package:shopping_app/screens/inner_screens/orders/quantity_btm_sheet_order.dart';
import 'package:shopping_app/services/auth_services.dart';
import 'package:shopping_app/services/my_app_method.dart';
import 'package:shopping_app/widgets/subtitle_text.dart';

import '../../../widgets/title_text.dart';

class OrdersWidgetFree extends StatefulWidget {
  const OrdersWidgetFree({super.key, required this.orderId});
  final String orderId;
  @override
  State<OrdersWidgetFree> createState() => _OrdersWidgetFreeState();
}

class _OrdersWidgetFreeState extends State<OrdersWidgetFree> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final getCurrorder = ordersProvider.findByorderId(widget.orderId);

    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            MyAppMethods.showErrorORWarningDialog(
                                isError: false,
                                context: context,
                                subtitle: "هل تريد حذف الطلب",
                                fct: () async {
                                  await ordersProvider.removeOneOrder(
                                      orderId:
                                          getCurrorder!.orderId.toString());
                                });
                          },
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.red,
                            size: 22,
                          )),
                      Flexible(
                        child: TitlesTextWidget(
                          label: getCurrorder!.productTitle,
                          maxLines: 2,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            getCurrorder.unit,
                            style: const TextStyle(
                                fontSize: 25, color: Colors.deepPurpleAccent),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          const Text(
                            ":الوحدة",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      // const SizedBox(
                      //   width: 10,
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: SubtitleTextWidget(
                              label:
                                  "${getCurrorder.currencyType} ${getCurrorder.price}",
                              fontSize: 20,
                              color: Colors.deepPurpleAccent,
                            ),
                          ),
                          const TitlesTextWidget(
                            label: ' :السعر',
                            fontSize: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [

                  //   ],
                  // ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () async {
                            await showModalBottomSheet(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0),
                                ),
                              ),
                              context: context,
                              builder: (context) {
                                return QuantityBottomSheetOrderWidget(
                                    unit: getCurrorder.unit,
                                    productId: getCurrorder.productId,
                                    userId: getCurrorder.userId.toString(),
                                    orderId: getCurrorder.orderId);
                              },
                            );
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.mode_edit,
                            color: Colors.deepPurpleAccent,
                          )),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: SubtitleTextWidget(
                          label: "${getCurrorder.quantity} :الكمية",
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FancyShimmerImage(
              height: size.width * 0.30,
              width: size.width * 0.30,
              imageUrl: AuthServices.linkStorage + getCurrorder.imageUrl,
            ),
          ),
        ],
      ),
    );
  }
}
