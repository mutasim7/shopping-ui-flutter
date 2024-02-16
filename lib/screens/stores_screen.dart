// ignore_for_file: unused_local_variable

import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shopping_app/models/store_model.dart';
import 'package:shopping_app/providers/store_provider.dart';
import 'package:shopping_app/services/assets_manager.dart';
import 'package:shopping_app/services/my_app_method.dart';
import 'package:shopping_app/widgets/stores_widget.dart';
import 'package:shopping_app/widgets/title_text.dart';

class StoresScreen extends StatefulWidget {
  static const routeName = '/StoresScreen';
  const StoresScreen({super.key});

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  @override
  void initState() {
    MyAppMethods.onbackgroundclick(context);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context);
    Map<String, dynamic> passedCategory =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Shimmer.fromColors(
            period: const Duration(seconds: 10),
            baseColor: Colors.deepPurpleAccent,
            highlightColor: Colors.red,
            child: TitlesTextWidget(
              label: passedCategory['name'] ?? "المتاجر",
              fontSize: 30,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0, top: 10),
            child: Image.asset(AssetsManager.shoppingCart),
          ),
        ],
      ),
      body: FutureBuilder<List<StoreModel>>(
        future: Provider.of<StoreProvider>(context).fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator()); // تظهر أثناء جلب البيانات
          } else if (snapshot.hasError) {
            return Text('حدث خطأ: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return const Text('لا توجد بيانات');
          } else {
            final List<StoreModel> areaList = passedCategory['areastor'] == null
                ? storeProvider.getStores
                : storeProvider.findByArea(areName: passedCategory['areastor']);

            final List<StoreModel> storeList = passedCategory['name'] == null
                ? storeProvider.getStores
                : storeProvider.findByCategory(stoName: passedCategory['name']);

            return storeList.isEmpty
                ? const Center(
                    child: TitlesTextWidget(label: "سيتم اضافة متجر قريبا"),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          DynamicHeightGridView(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: storeList.length,
                            builder: (context, index) {
                              return StoresWidget(
                                name: storeList[index].storename,
                                storeId: storeList[index].storeid,
                                storeaddress: storeList[index].storeaddress,
                                storeImage: storeList[index].storeImage,
                                status: storeList[index].status,
                              );
                            },
                            crossAxisCount: 1,
                          )
                        ],
                      ),
                    ),
                  );
          }
        },
      ),
    );
  }
}
