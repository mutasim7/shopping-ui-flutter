import 'package:flutter/material.dart';
import 'package:shopping_app/root_store_screen.dart';
import 'package:shopping_app/widgets/subtitle_text.dart';

class StoresWidget extends StatelessWidget {
  const StoresWidget({
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
          RootStoreScreen.routeName,
          arguments: name,
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 100,
            width: 100,
          ),
          const SizedBox(
            height: 10,
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
