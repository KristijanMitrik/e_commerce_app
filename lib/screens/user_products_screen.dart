import 'package:flutter/material.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';
import '../widgets/user_productitem.dart';
import '../widgets/app_drawer.dart';
import '../screens/edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //final data = Provider.of<Products>(context);
    print('rebuilding..');
    return Scaffold(
      appBar: AppBar(
        title: const Text('your products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (ctx, data, child) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemBuilder: (ctx, i) {
                            return Column(
                              children: <Widget>[
                                UserProductItem(
                                  data.items[i].title,
                                  data.items[i].imageUrl,
                                  data.items[i].id,
                                ),
                                Divider()
                              ],
                            );
                          },
                          itemCount: data.items.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
