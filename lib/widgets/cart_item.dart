import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem(this.id, this.productId, this.price, this.quantity, this.title);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (DismissDirection direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('are you sure?'),
                  content: Text('do you wan to remove the item from the card'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('NO'),
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                    ),
                    FlatButton(
                      child: Text('YES'),
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                    )
                  ],
                ));
      },
      key: ValueKey(id),
      background: Container(
        color: Colors.black87,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 15,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.black,
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: FittedBox(
                      child: Text(
                    '\$ $price',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ))),
            ),
            title: Text(title),
            subtitle: Text('Total : \$ ${price * quantity}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
