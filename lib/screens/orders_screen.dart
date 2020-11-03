import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_app/widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    print('building orders');
    return Scaffold(
        appBar: AppBar(
          title: Text('your orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).fetchAndset(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapshot.error != null) {
                return Center(
                  child: Text('error occured'),
                );
              } else {
                return Consumer<Orders>(
                    builder: (ctx, orderData, child) => ListView.builder(
                          itemCount: orderData.orders.length,
                          itemBuilder: (ctx, i) {
                            return OrderItem(orderData.orders[i]);
                          },
                        ));
              }
            }
          },
        )
        // ? Center(
        //     child: CircularProgressIndicator(),
        //   )
        // :
        );
  }
}
