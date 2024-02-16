import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/theme_provider.dart';
import 'package:shopping_app/screens/home_ctg_screen.dart';

class AreasWidget extends StatelessWidget {
  const AreasWidget({
    super.key,
    required this.image,
    required this.name,
  });

  final String image, name;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    Size size = MediaQuery.of(context).size;

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
          // ClipRRect(
          //   borderRadius: const BorderRadius.all(
          //     Radius.circular(25),
          //   ),
          //   child: Image.asset(
          //     image,
          //     width: double.infinity,
          //   ),
          // ),
          // const SizedBox(
          //   height: 10,
          // ),
          // const Text(
          //   "دولني",
          //   style: TextStyle(
          //       fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
          // ),
          // const SizedBox(
          //   height: 15,
          // ),
          Container(
            // height: size.height * 0.80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: themeProvider.getIsDarkTheme
                  ? const Color.fromARGB(113, 93, 43, 230)
                  : const Color.fromARGB(214, 182, 156, 255),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  child: Image.asset(
                    image,
                    width: double.infinity,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  name,
                  style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
