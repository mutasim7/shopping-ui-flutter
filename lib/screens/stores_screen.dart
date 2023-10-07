// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shopping_app/models/store_model.dart';
import 'package:shopping_app/providers/store_provider.dart';
import 'package:shopping_app/services/assets_manager.dart';
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
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context);
    Map<String, dynamic> passedCategory =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final List<StoreModel> areaList = passedCategory['areastor'] == null
        ? storeProvider.getStores
        : storeProvider.findByArea(areName: passedCategory['areastor']);

    final List<StoreModel> storeList = passedCategory['name'] == null
        ? storeProvider.getStores
        : storeProvider.findByCategory(stoName: passedCategory['name']);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Shimmer.fromColors(
            period: const Duration(seconds: 10),
            baseColor: Colors.purple,
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
      body: storeList.isEmpty
          ? const Center(
              child: TitlesTextWidget(label: "سيتم اضافة متجر قريبا"),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 18,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 10, bottom: 10),
                      child: TitlesTextWidget(
                        label: "المتاجر",
                        fontSize: 30,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      children: List.generate(storeList.length, (index) {
                        return StoresWidget(
                          image: storeList[index].storeimg,
                          name: storeList[index].storename,
                        );
                      }),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
