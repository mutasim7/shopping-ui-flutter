// ignore_for_file: camel_case_types

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/consts/app_constants.dart';
import 'package:shopping_app/services/assets_manager.dart';
import 'package:shopping_app/widgets/app_name_text.dart';
import 'package:shopping_app/widgets/areas_widget.dart';
import 'package:shopping_app/widgets/title_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(
            left: 230,
            top: 10,
          ),
          child: AppNameTextWidget(fontSize: 35),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 18.0,
              top: 10,
            ),
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
                height: 10,
              ),
              SizedBox(
                height: size.height * 0.24,
                child: ClipRRect(
                  child: Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return Image.asset(
                        AppConstants.bannersImages[index],
                        fit: BoxFit.fill,
                      );
                    },
                    autoplay: true,
                    itemCount: AppConstants.bannersImages.length,
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
                height: 18,
              ),
              const TitlesTextWidget(
                label: "المناطق",
                fontSize: 40,
                color: Colors.purple,
              ),
              const SizedBox(
                height: 25,
              ),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                children: List.generate(AppConstants.areaslist.length, (index) {
                  return AreasWidget(
                    image: AppConstants.areaslist[index].image,
                    name: AppConstants.areaslist[index].name,
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
