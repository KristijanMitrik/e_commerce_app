import 'package:e_commerce_app/screens/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_app/helpers/custom_route.dart';
import 'package:e_commerce_app/screens/cart_screen.dart';
import 'package:e_commerce_app/screens/product_detail_screen.dart';
import 'screens/product_overview_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './providers/auth.dart';
import './screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final Map<int, Color> color = {
    50: Color.fromRGBO(136, 14, 79, .1),
    100: Color.fromRGBO(136, 14, 79, .2),
    200: Color.fromRGBO(136, 14, 79, .3),
    300: Color.fromRGBO(136, 14, 79, .4),
    400: Color.fromRGBO(136, 14, 79, .5),
    500: Color.fromRGBO(136, 14, 79, .6),
    600: Color.fromRGBO(136, 14, 79, .7),
    700: Color.fromRGBO(136, 14, 79, .8),
    800: Color.fromRGBO(136, 14, 79, .9),
    900: Color.fromRGBO(136, 14, 79, 1),
  };
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
              create: null,
              update: (ctx, auth, previousProducts) {
                return Products(
                    auth.token,
                    previousProducts == null ? [] : previousProducts.items,
                    auth.userId);
              }),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
              create: null,
              update: (ctx, auth, previousOrders) {
                return Orders(
                    auth.token,
                    previousOrders == null ? [] : previousOrders.orders,
                    auth.userId);
              })
        ],
        child: Consumer<Auth>(
          builder: (ctx, authData, child) => MaterialApp(
            title: 'Kristijan\'s Shop',
            theme: ThemeData(
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: CustomPageTransitionBuilder(),
                  TargetPlatform.iOS: CustomPageTransitionBuilder(),
                }),
                primarySwatch: MaterialColor(0xFFFFFFFF, color),
                // primaryColor: Colors.deepOrange,
                accentColor: Colors.deepPurpleAccent,
                fontFamily: 'Lato'),
            home: authData.isAuth
                ? ProductsOverviewScreen()
                : FutureBuilder(
                    future: authData.tryAutoLogin(),
                    builder: (ctx, authResultSnap) =>
                        authResultSnap.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen()),
            routes: {
              DetailScreen.routeName: (ctx) => DetailScreen(),
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
            },
          ),
        ));
  }
}
