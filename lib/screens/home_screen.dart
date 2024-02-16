// ignore_for_file: camel_case_types

import 'package:card_swiper/card_swiper.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/consts/app_constants.dart';
import 'package:shopping_app/providers/ads_provider.dart';
import 'package:shopping_app/services/assets_manager.dart';
import 'package:shopping_app/services/auth_services.dart';
import 'package:shopping_app/widgets/app_name_text.dart';
import 'package:shopping_app/widgets/areas_widget.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/HomeScreen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final adsProvider = Provider.of<AdsProvider>(context);
    List<String> bannersImages = [
      AssetsManager.shoppingBasket,
      AssetsManager.shoppingCart,
    ];

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: AppNameTextWidget(fontSize: 25),
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 18.0,
              top: 10,
            ),
            child: Image.asset(AssetsManager.shoppingCart),
          ),
        ],
      ),
      body: LiquidPullToRefresh(
        animSpeedFactor: 5,
        backgroundColor: Colors.white,
        color: const Color.fromARGB(255, 159, 124, 255),
        onRefresh: () async {
          await adsProvider.gatAllAds();
          setState(() {});
        },
        showChildOpacityTransition: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                adsProvider.bannersImagesList.isEmpty
                    ? SizedBox(
                        height: size.height * 0.40,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Swiper(
                            itemBuilder: (BuildContext context, int index) {
                              return Image.asset(
                                bannersImages[index],
                                fit: BoxFit.fill,
                              );
                            },
                            autoplay: bannersImages.length == 1 ? false : true,
                            itemCount: bannersImages.length,
                            pagination: const SwiperPagination(
                              alignment: Alignment.bottomCenter,
                              builder: DotSwiperPaginationBuilder(
                                color: Colors.white,
                                activeColor: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: size.height * 0.35,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Swiper(
                            itemBuilder: (BuildContext context, int index) {
                              return FancyShimmerImage(
                                imageUrl: AuthServices.linkStorage +
                                    adsProvider
                                        .bannersImagesList[index].imageUrl,
                                width: double.infinity,
                                height: size.height * 0.22,
                              );
                            },
                            autoplay: adsProvider.bannersImagesList.length == 1
                                ? false
                                : true,
                            itemCount: adsProvider.bannersImagesList.length,
                            pagination: const SwiperPagination(
                              alignment: Alignment.bottomCenter,
                              builder: DotSwiperPaginationBuilder(
                                color: Colors.white,
                                activeColor: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 15,
                ),
                DynamicHeightGridView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: AppConstants.areaslist.length,
                  builder: (context, index) {
                    return AreasWidget(
                      image: AppConstants.areaslist[index].image,
                      name: AppConstants.areaslist[index].name,
                    );
                  },
                  crossAxisCount: 1,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
