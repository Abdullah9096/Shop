import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  OrderItem({this.order});

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expand = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height:
          _expand ? min(widget.order.oproducts.length * 20.0 + 110, 280) : 95,
      //curve: Curves.easeIn,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.order.oamount}'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy   hh:mm').format(widget.order.odate),
              ),
              trailing: IconButton(
                icon:
                    _expand ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expand = !_expand;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              height: _expand
                  ? min(widget.order.oproducts.length * 20.0 + 10, 180)
                  : 0,
              child: ListView(
                children: [
                  ...widget.order.oproducts
                      .map((prod) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                prod.cTitle,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${prod.cQuantity}x \$${prod.cPrice}',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              )
                            ],
                          ))
                      .toList(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
