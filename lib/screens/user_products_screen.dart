import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/appDrawer.dart';
import '../providers/product_provider.dart';
import '../widgets/user_Product.dart';
import '../screens/edit_product_Screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/userPoductScreen';

  Future<void> _refreshProducts(BuildContext ctx) async {
    await Provider.of<ProductProvider>(ctx, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your product'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapShot) =>
            snapShot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<ProductProvider>(
                      builder: (ctx, productProvider, _) => Padding(
                        padding: EdgeInsets.all(10),
                        child: ListView.builder(
                          itemBuilder: (_, index) => Column(
                            children: [
                              UserProduct(
                                id: productProvider.items[index].id,
                                title: productProvider.items[index].title,
                                imageUrl: productProvider.items[index].imageUrl,
                              ),
                              Divider(),
                            ],
                          ),
                          itemCount: productProvider.items.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
