import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/services/my_app_method.dart';
import 'package:shopping_app/widgets/products/product_widget.dart';

import '../models/product_model.dart';
import '../providers/product_provider.dart';
import '../widgets/title_text.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/SearchScreen';
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchTextController;

  @override
  void initState() {
    searchTextController = TextEditingController();

    MyAppMethods.onbackgroundclick(context);

    super.initState();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  String address = ': العنوان ';

  // late List<ProductModel> products;
  List<ProductModel> productListSearch = [];
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    Map<String, dynamic> passedMap =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    // int? passedstoreid = ModalRoute.of(context)!.settings.arguments as int?;
    final List<ProductModel> productList = passedMap['storeId'] == null
        ? productProvider.getProducts
        : productProvider.findByStoreid(id: passedMap['storeId']);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: LiquidPullToRefresh(
        color: Colors.deepPurpleAccent,
        onRefresh: () async {
          await productProvider.getAllProducts();
          productProvider.findByStoreid(id: passedMap['storeId']);
          setState(() {});
        },
        showChildOpacityTransition: false,
        animSpeedFactor: 2,
        child: Scaffold(
          appBar: AppBar(
            // centerTitle: true,
            // title: const Padding(
            //   padding: EdgeInsets.only(top: 7.0),
            //   child: TitlesTextWidget(
            //     label: "المنتجات",
            //     fontSize: 25,
            //   ),
            // ),
            actions: const [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: TitlesTextWidget(
                  label: "المنتجات",
                  fontSize: 25,
                  color: Colors.deepPurpleAccent,
                ),
              ),
            ],
            // leading: Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Image.asset(AssetsManager.shoppingCart),
            // ),
          ),
          body: productList.isEmpty
              ? const Center(
                  child: TitlesTextWidget(label: "لايوجد منتجات"),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ${passedMap['storeAddress']}
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                child: Text(
                                  maxLines: 5,
                                  textAlign: TextAlign.right,
                                  "${passedMap['storeAddress']}",
                                  style: const TextStyle(
                                    fontSize: 23,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 3),
                              child: Text(
                                maxLines: 5,
                                textAlign: TextAlign.right,
                                address,
                                style: const TextStyle(
                                    fontSize: 23,
                                    color: Colors.deepPurpleAccent),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      TextField(
                        textAlign: TextAlign.right,
                        controller: searchTextController,
                        decoration: InputDecoration(
                            hintText: "البحث",
                            filled: true,
                            prefixIcon: GestureDetector(
                              onTap: () {
                                // setState(() {
                                searchTextController.clear();
                                FocusScope.of(context).unfocus();
                                // });
                              },
                              child: const Icon(
                                Icons.clear,
                                color: Colors.red,
                              ),
                            ),
                            suffixIcon: const Icon(Icons.search)),
                        onChanged: (value) {
                          // setState(() {
                          //   productListSearch = productProvider.searchQuery(
                          //       searchText: searchTextController.text);
                          // });
                        },
                        onSubmitted: (value) {
                          setState(() {
                            productListSearch = productProvider.searchQuery(
                                searchText: searchTextController.text,
                                passedList: productList);
                          });
                        },
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      if (searchTextController.text.isNotEmpty &&
                          productListSearch.isEmpty) ...[
                        const Center(
                            child: TitlesTextWidget(
                          label: "لايوجد نتائج",
                          fontSize: 30,
                        ))
                      ],
                      Expanded(
                        child: DynamicHeightGridView(
                          itemCount: searchTextController.text.isNotEmpty
                              ? productListSearch.length
                              : productList.length,
                          builder: ((context, index) {
                            return ProductWidget(
                              storeId: passedMap['storeId'],
                              productId: searchTextController.text.isNotEmpty
                                  ? productListSearch[index]
                                      .productId
                                      .toString()
                                  : productList[index].productId.toString(),
                            );
                          }),
                          crossAxisCount: 2,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
