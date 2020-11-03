import 'package:e_commerce_app/screens/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/providers/auth.dart';
import '../models/product.dart';
import 'package:e_commerce_app/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        header: Container(
          margin: EdgeInsets.only(left: 15, top: 15),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: product.title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(DetailScreen.routeName, arguments: product.id);
            },
            child: Hero(
              tag: product.id,
              child: FadeInImage(
                placeholder:
                    AssetImage('assets/images/product-placeholder.png'),
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
              ),
            )),
        footer: Container(
          height: 35,
          child: GridTileBar(
            backgroundColor: Colors.black45,
            leading: IconButton(
              icon: Icon(
                product.isFavourite ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: () {
                product.toggleFavouriteStatus(authData.token, authData.userId);
              },
              color: Colors.white,
            ),
            trailing: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  cart.addItem(product.id, product.price, product.title);
                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(SnackBar(
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
                color: Colors.white),
            title: Text(
              '',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
