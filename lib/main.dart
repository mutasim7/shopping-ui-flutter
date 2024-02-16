import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/Root_App_Screen.dart';
import 'package:shopping_app/Root_App_Store_Screen.dart';
import 'package:shopping_app/providers/ads_provider.dart';
import 'package:shopping_app/providers/auth_provider.dart';
import 'package:shopping_app/providers/orders_provider.dart';
import 'package:shopping_app/providers/product_provider.dart';
import 'package:shopping_app/providers/store_provider.dart';
import 'package:shopping_app/providers/theme_provider.dart';
import 'package:shopping_app/screens/cart/send_orders.dart';
import 'package:shopping_app/screens/home_ctg_screen.dart';
import 'package:shopping_app/screens/home_screen.dart';
import 'package:shopping_app/screens/inner_screens/viewed_recently.dart';
import 'package:shopping_app/screens/stores_screen.dart';
import 'package:shopping_app/services/my_app_method.dart';

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

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  // تحقق من النقر على الإشعار عندما يكون التطبيق في ال foreground
  if (message.notification != null) {
    print(message.notification!.title);
    print(message.notification!.body);
    print(message.data['pageid']);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    MyAppMethods.onbackgroundclick(context);
    // TODO: implement initState
    super.initState();
  }

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
        ChangeNotifierProvider(
          create: (_) => OrdersProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AdsProvider(),
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
          home: const SplashScreen(),
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
            HomeScreen.routeName: (context) => const HomeScreen(),
            StoresScreen.routeName: (context) => const StoresScreen(),
            SendOrders.routeName: (context) => const SendOrders(),
            RootAppStoreScreen.routeName: (context) => RootAppStoreScreen()
          },
        );
      }),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? token;
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final storeProvider = Provider.of<StoreProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final adsProvider = Provider.of<AdsProvider>(context);

    return AnimatedSplashScreen.withScreenFunction(
      splash: "assets/images/bag/shopping_cart.png",
      screenFunction: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        int userId = prefs.getInt("id") ?? 0;
        String userIdStr = userId.toString();

        // Load all data in parallel
        await Future.wait([
          adsProvider.gatAllAds(),
          storeProvider.fetchData(),
          productProvider.getAllProducts(),
          cartProvider.fetchCart(userIdStr),
          ordersProvider.getAllProducts(userId: userIdStr),
        ]);

        token = authProvider.gettoken;
        return token == null ? const RegisterScreen() : RootAppScreen();
      },
      splashTransition: SplashTransition.scaleTransition,
      backgroundColor: Colors.white,
      splashIconSize: 250,
      duration: 500,
    );
  }
}
