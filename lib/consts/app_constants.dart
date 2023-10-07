import 'package:shopping_app/models/areas_model.dart';
import 'package:shopping_app/models/categories_model.dart';

import '../services/assets_manager.dart';

class AppConstants {
  static const String productImageUrl =
      'https://i.ibb.co/8r1Ny2n/20-Nike-Air-Force-1-07.png';
  static List<String> bannersImages = [
    AssetsManager.banner1,
    AssetsManager.banner2,
    AssetsManager.banner4,
  ];
  static List<CategoryModel> categoriesList = [
    CategoryModel(
      id: "جوالات",
      image: AssetsManager.mobiles,
      name: "جوالات",
    ),
    CategoryModel(
      id: "لابتوبات",
      image: AssetsManager.pc,
      name: "لابتوبات",
    ),
    CategoryModel(
      id: "Electronics",
      image: AssetsManager.electronics,
      name: "Electronics",
    ),
    CategoryModel(
      id: "Watches",
      image: AssetsManager.watch,
      name: "Watches",
    ),
    CategoryModel(
      id: "Clothes",
      image: AssetsManager.fashion,
      name: "Clothes",
    ),
    CategoryModel(
      id: "Shoes",
      image: AssetsManager.shoes,
      name: "Shoes",
    ),
    CategoryModel(
      id: "Books",
      image: AssetsManager.book,
      name: "Books",
    ),
    CategoryModel(
      id: "Cosmetics",
      image: AssetsManager.cosmetics,
      name: "Cosmetics",
    ),
  ];

  static List<AreasModel> areaslist = [
    AreasModel(image: AssetsManager.mapmarknavy, name: "الأشرفية"),
    AreasModel(image: AssetsManager.mapmarkgreen, name: "شارع راجو"),
    AreasModel(image: AssetsManager.mapmarkred, name: "شارع الفيلات"),
    AreasModel(image: AssetsManager.mapmark, name: "المحمودية"),
  ];
}
