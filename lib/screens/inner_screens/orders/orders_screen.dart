import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/models/orders_model.dart';
import 'package:shopping_app/providers/orders_provider.dart';
import 'package:shopping_app/services/my_app_method.dart';

import '../../../../widgets/empty_bag.dart';
import '../../../services/assets_manager.dart';
import '../../../widgets/title_text.dart';
import 'orders_widget.dart';

class OrdersScreenFree extends StatefulWidget {
  static const routeName = '/OrderScreen';

  const OrdersScreenFree({Key? key}) : super(key: key);

  @override
  State<OrdersScreenFree> createState() => _OrdersScreenFreeState();
}

class _OrdersScreenFreeState extends State<OrdersScreenFree> {
  bool isEmptyOrders = false;

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

    final ordersProvider = Provider.of<OrdersProvider>(context);
    final List<OrdersModel> ordertList = ordersProvider.getOrders;
    return LiquidPullToRefresh(
      onRefresh: () async {
        int userid = await getUserId();
        await ordersProvider.getAllProducts(userId: userid.toString());
        setState(() {});
      },
      showChildOpacityTransition: false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const TitlesTextWidget(
            label: 'الطلبات',
            fontSize: 23,
          ),
          actions: [
            ordertList.isEmpty
                ? const SizedBox()
                : IconButton(
                    onPressed: () {
                      MyAppMethods.showErrorORWarningDialog(
                          isError: false,
                          context: context,
                          subtitle: "هل تريد حذف كل الطلبات",
                          fct: () async {
                            int userid = await getUserId();
                            ordersProvider.removeAllOrders(userid: userid);
                          });
                    },
                    icon: const Icon(
                      Icons.delete_forever,
                      color: Colors.redAccent,
                    ),
                  )
          ],
        ),
        body: ordertList.isEmpty
            ? EmptyBagWidget(
                imagePath: AssetsManager.orderBag,
                title: "لم تقم بالطلب حتى الآن",
                subtitle: "",
                buttonText: "Shop now")
            : ListView.separated(
                itemCount: ordertList.length,
                itemBuilder: (ctx, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                    child: OrdersWidgetFree(
                      orderId: ordertList[index].orderId.toString(),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
              ),
      ),
    );
  }
}
