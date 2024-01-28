import 'package:flutter/material.dart';
import 'product_model.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String category;
  final List<Product> products;

  const CategoryProductsScreen({Key? key, required this.category, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('Quantity: ${product.quantity}'),
          );
        },
      ),
    );
  }
}
