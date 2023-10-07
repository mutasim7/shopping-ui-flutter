import 'package:flutter/material.dart';
import 'package:shopping_app/consts/app_constants.dart';
import 'package:shopping_app/widgets/products/ctg_rounded_widget.dart';
import 'package:shopping_app/widgets/title_text.dart';

import '../services/assets_manager.dart';
import '../widgets/app_name_text.dart';

class HomeCtgScreen extends StatelessWidget {
  static const routeName = '/HomeCtgScreen';
  const HomeCtgScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String passedArea = ModalRoute.of(context)!.settings.arguments as String;

    // final List<StoreModel> arealist = passedArea == null
    //     ? storeProvider.getStores
    //     : storeProvider.findByArea(areName: passedArea);

    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 180.0, top: 10),
          child: AppNameTextWidget(fontSize: 35),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0, top: 10),
            child: Image.asset(AssetsManager.shoppingCart),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 18,
              ),
              const SizedBox(
                height: 18,
              ),
              const Padding(
                padding: EdgeInsets.only(right: 10, bottom: 10),
                child: TitlesTextWidget(
                  label: "الفئات",
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  children: List.generate(AppConstants.categoriesList.length,
                      (index) {
                    return CategoryRoundedWidget(
                      passedArea: passedArea,
                      image: AppConstants.categoriesList[index].image,
                      name: AppConstants.categoriesList[index].name,
                    );
                  }))
            ],
          ),
        ),
      ),
    );
  }
}
