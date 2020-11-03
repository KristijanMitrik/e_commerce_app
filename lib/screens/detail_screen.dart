import 'dart:ui';

import 'package:e_commerce_app/providers/cart.dart';
import 'package:e_commerce_app/screens/cart_screen.dart';
import 'package:e_commerce_app/widgets/badge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/products.dart';

class DetailScreen extends StatelessWidget {
  static final String routeName = '/DetailsProd';
  DetailScreen();

  @override
  Widget build(BuildContext context) {
    final String productId =
        ModalRoute.of(context).settings.arguments as String;
    final Product product =
        Provider.of<Products>(context, listen: false).findById(productId);
    final cart = Provider.of<Cart>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            'Product Details',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            Consumer<Cart>(
              builder: (_, cartData, ch) => Badge(
                child: ch,
                value: cartData.itemCount.toString(),
              ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            )
          ],
        ),
        body: Builder(
          builder: (ctx) => Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: 250, minWidth: double.infinity),
                    child: Container(
                      margin: EdgeInsets.all(17),
                      child: Hero(
                        tag: product.id,
                        child: Image.network(
                          product.imageUrl,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    product.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 28,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    '\$ ${product.price}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 23),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      product.description,
                      style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                  bottom: 50,
                ),
                child: FlatButton(
                    height: 45,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    minWidth: double.infinity,
                    textColor: Colors.white,
                    // icon: Icon(Icons.shopping_cart),
                    child: Text(
                      'Add To Card',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      cart.addItem(product.id, product.price, product.title);
                      Scaffold.of(ctx).hideCurrentSnackBar();
                      Scaffold.of(ctx).showSnackBar(SnackBar(
                        content: Text(
                          'added item to card',
                          textAlign: TextAlign.center,
                        ),
                        duration: Duration(seconds: 5),
                        action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {
                            cart.removeSingleItem(product.id);
                          },
                        ),
                      ));
                    },
                    color: Colors.black87),
              )
            ],
          ),
        ));
  }
}
