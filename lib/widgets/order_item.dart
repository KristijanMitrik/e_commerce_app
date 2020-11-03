import 'package:flutter/material.dart';
import '../providers/orders.dart' as ord;
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: _expanded ?  min(widget.order.products.length * 20.0 + 110.0, 200) : 95,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('\$ ${widget.order.amount}'),
              subtitle: Text(
                  DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            
                 AnimatedContainer(
                   duration: Duration(milliseconds: 500),

                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                    height: _expanded ?
                        min(widget.order.products.length * 20.0 + 10, 100) : 0,
                    child: ListView.builder(
                      itemCount: widget.order.products.length,
                      itemBuilder: (ctx, i) {
                        widget.order.products.toString();
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              widget.order.products[i].title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${widget.order.products[i].quantity}x \$ ${widget.order.products[i].price}',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            )
                          ],
                        );
                      },
                    ),
                  )
                
          ],
        ),
      ),
    );
  }
}
