import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('your card'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$ ${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.black87,
                  ),
                  AddOrderButton(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (ctx, index) {
                return CartItem(
                  cart.items.values.toList()[index].id,
                  cart.items.keys.toList()[index],
                  cart.items.values.toList()[index].price,
                  cart.items.values.toList()[index].quantity,
                  cart.items.values.toList()[index].title,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class AddOrderButton extends StatefulWidget {
  const AddOrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _AddOrderButtonState createState() => _AddOrderButtonState();
}

class _AddOrderButtonState extends State<AddOrderButton> {
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: isLoading
          ? CircularProgressIndicator()
          : Text(
              "Order Now",
              style: TextStyle(color: Colors.black87),
            ),
      onPressed: (widget.cart.totalAmount <= 0 || isLoading)
          ? null
          : () async {
              setState(() {
                isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );
              setState(() {
                isLoading = false;
              });
              widget.cart.clearCart();
            },
      textColor: Theme.of(context).primaryColor,
    );
  }
}
