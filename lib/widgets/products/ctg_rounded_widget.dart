import 'package:flutter/material.dart';
import 'package:shopping_app/screens/stores_screen.dart';
import 'package:shopping_app/widgets/subtitle_text.dart';

class CategoryRoundedWidget extends StatelessWidget {
  const CategoryRoundedWidget({
    super.key,
    required this.image,
    required this.name,
    required this.passedArea,
  });

  final String image, name, passedArea;
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> arguments = {
      'name': name,
      'areastor': passedArea,
    };

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          StoresScreen.routeName,
          arguments: arguments,
        );
      },
      child: Column(
        children: [
          Image.asset(
            image,
            height: 75,
            width: 75,
          ),
          const SizedBox(
            height: 15,
          ),
          SubtitleTextWidget(
            label: name,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )
        ],
      ),
    );
  }
}
