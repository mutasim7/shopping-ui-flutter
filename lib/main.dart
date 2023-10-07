import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/auth_provider.dart';
import 'package:shopping_app/providers/product_provider.dart';
import 'package:shopping_app/providers/store_provider.dart';
import 'package:shopping_app/providers/theme_provider.dart';
import 'package:shopping_app/root_screen.dart';
import 'package:shopping_app/root_store_screen.dart';
import 'package:shopping_app/screens/home_ctg_screen.dart';
import 'package:shopping_app/screens/inner_screens/viewed_recently.dart';
import 'package:shopping_app/screens/stores_screen.dart';

import 'consts/theme_data.dart';
import 'providers/cart_provider.dart';
import 'providers/viewed_prod_provider.dart';
import 'providers/wishlist_provider.dart';
import 'screens/auth/forgot_password.dart';
import 'screens/auth/login.dart';
import 'screens/auth/register.dart';
import 'screens/inner_screens/orders/orders_screen.dart';
import 'screens/inner_screens/product_details.dart';
import 'screens/inner_screens/wishlist.dart';
import 'screens/search_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final themeProvider = Provider.of<ThemeProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => WishlistProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ViewedProdProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => StoreProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
      ],
      child: Consumer2<ThemeProvider, AuthProvider>(builder: (
        context,
        themeProvider,
        authProvider,
        child,
      ) {
        return MaterialApp(
          title: 'Shopping',
          debugShowCheckedModeBanner: false,
          theme: Styles.themeData(
              isDarkTheme: themeProvider.getIsDarkTheme, context: context),
          home: authProvider.gettoken == null
              ? const RegisterScreen()
              : const RootScreen(),
          // home: const RegisterScreen(),
          routes: {
            ProductDetails.routName: (context) => const ProductDetails(),
            WishlistScreen.routName: (context) => const WishlistScreen(),
            ViewedRecentlyScreen.routName: (context) =>
                const ViewedRecentlyScreen(),
            RegisterScreen.routName: (context) => const RegisterScreen(),
            LoginScreen.routName: (context) => const LoginScreen(),
            OrdersScreenFree.routeName: (context) => const OrdersScreenFree(),
            ForgotPasswordScreen.routeName: (context) =>
                const ForgotPasswordScreen(),
            SearchScreen.routeName: (context) => const SearchScreen(),
            HomeCtgScreen.routeName: (context) => const HomeCtgScreen(),
            StoresScreen.routeName: (context) => const StoresScreen(),
            RootStoreScreen.routeName: (context) => const RootStoreScreen(),
            RootScreen.routeName: (context) => const RootScreen(),
          },
        );
      }),
    );
  }
}
