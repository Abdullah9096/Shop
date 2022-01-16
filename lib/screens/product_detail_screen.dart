import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  /* final String title;
  ProductDetailScreen(this.title);*/
  static const routeName = '/product_details';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadProduct = Provider.of<ProductProvider>(context, listen: false)
        .findById(productId);
    return Scaffold(
      /* appBar: AppBar(
        title: Text(loadProduct.title),
      ),*/
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                color: Colors.black54,
                child: Text(loadProduct.title),
              ),
              background: Hero(
                tag: loadProduct.id,
                child: Image.network(
                  loadProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 15,
                ),
                Text(
                  '\$${loadProduct.price}',
                  style: TextStyle(fontSize: 20, color: Colors.deepPurple),
                  textAlign: TextAlign.center,
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.all(10),
                  child: Text(
                    '${loadProduct.description}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17),
                    softWrap: true,
                  ),
                ),
                SizedBox(
                  height: 700,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
