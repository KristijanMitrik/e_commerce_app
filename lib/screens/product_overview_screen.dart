import 'package:e_commerce_app/widgets/carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/screens/cart_screen.dart';
import 'package:e_commerce_app/widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import '../providers/products.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';

enum FilterOptions { Favourites, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavourties = false;
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Products>(context).fetchProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kristijan\'s Shop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favourites) {
                  _showFavourties = true;
                } else {
                  _showFavourties = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) {
              return [
                PopupMenuItem(
                  child: Text('only favourites'),
                  value: FilterOptions.Favourites,
                ),
                PopupMenuItem(
                  child: Text('show all'),
                  value: FilterOptions.All,
                )
              ];
            },
          ),
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
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                CarouselWithIndicatorDemo(),
                Container(
                  margin: const EdgeInsets.only(
                    top: 15.0,
                    bottom: 15.0,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          'Products:',
                          style: TextStyle(
                              fontSize: 19,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        )),
                  ),
                ),
                Expanded(child: ProductsGrid(_showFavourties))
              ],
            ),

      // :
    );
  }
}
