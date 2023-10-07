import 'package:flutter/material.dart';
import 'package:shopping_app/screens/home_ctg_screen.dart';
import 'package:shopping_app/widgets/subtitle_text.dart';

class AreasWidget extends StatelessWidget {
  const AreasWidget({
    super.key,
    required this.image,
    required this.name,
  });

  final String image, name;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          HomeCtgScreen.routeName,
          arguments: name,
        );
      },
      child: Column(
        children: [
          Image.asset(
            image,
            height: 85,
            width: 85,
          ),
          const SizedBox(
            height: 15,
          ),
          SubtitleTextWidget(
            label: name,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          )
        ],
      ),
    );
  }
}
