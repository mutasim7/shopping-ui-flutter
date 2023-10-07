import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/screens/search_screen.dart';

import 'providers/cart_provider.dart';
import 'screens/cart/cart_screen.dart';

class RootStoreScreen extends StatefulWidget {
  static const routeName = '/RootStoreScreen';
  const RootStoreScreen({super.key});

  @override
  State<RootStoreScreen> createState() => _RootStoreScreenState();
}

class _RootStoreScreenState extends State<RootStoreScreen> {
  late PageController controller;
  int currentScreen = 0;
  List<Widget> screens = [
    const SearchScreen(),
    const CartScreen(),
  ];
  @override
  void initState() {
    super.initState();
    controller = PageController(
      initialPage: currentScreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      body: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentScreen,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 2,
        height: kBottomNavigationBarHeight,
        onDestinationSelected: (index) {
          setState(() {
            currentScreen = index;
          });
          controller.jumpToPage(currentScreen);
        },
        destinations: [
          const NavigationDestination(
            selectedIcon: Icon(IconlyBold.search),
            icon: Icon(IconlyLight.search),
            label: "المتحر",
          ),
          NavigationDestination(
            selectedIcon: const Icon(IconlyBold.bag2),
            icon: Badge(
                backgroundColor: Colors.blue,
                label: Text(cartProvider.getCartItems.length.toString()),
                child: const Icon(IconlyLight.bag)),
            label: "السلة",
          ),
        ],
      ),
    );
  }
}
