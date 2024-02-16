import 'package:shopping_app/models/areas_model.dart';
import 'package:shopping_app/models/categories_model.dart';

import '../services/assets_manager.dart';

class AppConstants {
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
      id: "مطاعم",
      image: AssetsManager.restaurants,
      name: "مطاعم",
    ),
    CategoryModel(
      id: "غذائيات",
      image: AssetsManager.dietetics,
      name: "غذائيات",
    ),
    CategoryModel(
      id: "خضراوات",
      image: AssetsManager.vig,
      name: "خضراوات",
    ),
    CategoryModel(
      id: "محامص",
      image: AssetsManager.pistachioroaster,
      name: "محامص",
    ),
    CategoryModel(
      id: 'بزورية',
      image: AssetsManager.spices,
      name: 'بزورية',
    ),
    CategoryModel(
      id: "لحومات",
      image: AssetsManager.meats,
      name: "لحومات",
    ),
    CategoryModel(
      id: "حلويات",
      image: AssetsManager.hlwiat,
      name: "حلويات",
    ),
    CategoryModel(
      id: "ألبسة",
      image: AssetsManager.fashion,
      name: "ألبسة",
    ),
    CategoryModel(
      id: "أحذية",
      image: AssetsManager.shoes,
      name: "أحذية",
    ),
    CategoryModel(
      id: "مستحضرات التجميل",
      image: AssetsManager.cosmetics,
      name: "مستحضرات التجميل",
    ),
    CategoryModel(
      id: "ساعات",
      image: AssetsManager.watch,
      name: "ساعات",
    ),
    CategoryModel(
      id: "منظفات",
      image: AssetsManager.detergent,
      name: "منظفات",
    ),
    CategoryModel(
      id: 'أدوات منزلية',
      image: AssetsManager.houseware,
      name: 'أدوات منزلية',
    ),
    CategoryModel(
      id: "مطبعة",
      image: AssetsManager.printing,
      name: "مطبعة",
    ),
    CategoryModel(
      id: "دهانات",
      image: AssetsManager.paints,
      name: "دهانات",
    ),
    CategoryModel(
      id: "اكسسوارات",
      image: AssetsManager.accessories,
      name: "اكسسوارات",
    ),
    CategoryModel(
      id: "عطورات",
      image: AssetsManager.perfumes,
      name: "عطورات",
    ),
    CategoryModel(
      id: "مكتبات",
      image: AssetsManager.book,
      name: "مكتبات",
    ),
    CategoryModel(
      id: "كهربائيات",
      image: AssetsManager.electronics,
      name: "كهربائيات",
    ),
    CategoryModel(
      id: "ذهب",
      image: AssetsManager.gold,
      name: "ذهب",
    ),
    CategoryModel(
      id: "الأثاث",
      image: AssetsManager.furniture,
      name: "الأثاث",
    ),
    CategoryModel(
      id: 'الألعاب والترفيه',
      image: AssetsManager.gams,
      name: 'الألعاب والترفيه',
    ),
    CategoryModel(
      id: 'الألعاب',
      image: AssetsManager.toydoll,
      name: 'الألعاب',
    ),
    CategoryModel(
      id: 'اللوازم المدرسية',
      image: AssetsManager.schoolSupplies,
      name: 'اللوازم المدرسية',
    ),
    CategoryModel(
      id: 'قطع موتورات',
      image: AssetsManager.motorcycleparts,
      name: 'قطع موتورات',
    ),
    CategoryModel(
      id: 'بلاستيك',
      image: AssetsManager.plastic,
      name: 'بلاستيك',
    ),
    CategoryModel(
      id: 'الأثاث المستعمل',
      image: AssetsManager.oldfurniture,
      name: 'الأثاث المستعمل',
    ),
    CategoryModel(
      id: 'قطع سيارات',
      image: AssetsManager.carparts,
      name: 'قطع سيارات',
    ),
    CategoryModel(
      id: 'فئات أخرى',
      image: AssetsManager.othercategories,
      name: 'فئات أخرى',
    ),
  ];

  static List<AreasModel> areaslist = [
    AreasModel(
      image: AssetsManager.afrinImg,
      name: "عفرين",
    ),
    // AreasModel(
    //   image: AssetsManager.mapmark5,
    //   name: "أعزاز",
    // ),
    // AreasModel(
    //   image: AssetsManager.mapmark5,
    //   name: "مارع",
    // ),
    // AreasModel(
    //   image: AssetsManager.mapmark5,
    //   name: "الراعي",
    // ),
    // AreasModel(
    //   image: AssetsManager.mapmark5,
    //   name: "الباب",
    // ),
    // AreasModel(
    //   image: AssetsManager.mapmark5,
    //   name: 'جرابلس',
    // ),
    // AreasModel(
    //   image: AssetsManager.mapmark5,
    //   name: 'مدينة إدلب',
    // ),
    // AreasModel(
    //   image: AssetsManager.mapmark5,
    //   name: 'أريحا',
    // ),
    // AreasModel(
    //   image: AssetsManager.mapmark5,
    //   name: 'سرمدا',
    // ),
    // AreasModel(
    //   image: AssetsManager.mapmark5,
    //   name: 'الدانا',
    // ),
    // AreasModel(
    //   image: AssetsManager.mapmark5,
    //   name: 'معرة مصرين',
    // ),
    // AreasModel(
    //   image: AssetsManager.mapmark5,
    //   name: 'الأتارب',
    // ),
    // AreasModel(
    //   image: AssetsManager.mapmark5,
    //   name: 'أطمة',
    // ),
    // AreasModel(
    //   image: AssetsManager.mapmark5,
    //   name: 'سلقين',
    // ),
    // AreasModel(
    //   image: AssetsManager.mapmark5,
    //   name: 'حارم',
    // ),
  ];
}
