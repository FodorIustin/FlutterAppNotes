import 'package:flutter/material.dart';
import '../common/strings.dart' as strings;
import 'categories_tab.dart';
import 'category_products_screen.dart';
import 'product_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> products = [];
  Map<String, List<Product>> categories = {};
  final GlobalKey<ShoppingListTabState> shoppingListTabKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(strings.homeScrrenTitle),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Shopping List'),
              Tab(text: 'Categories'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ShoppingListTab(
              key: shoppingListTabKey,
              products: products,
              onDelete: (product) {
                _deleteProduct(product);
              },
            ),
            CategoriesTab(categories: categories),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddProductDialog(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) async {
    String productName = '';
    int productQuantity = 1;
    String selectedCategory = categories.keys.first; // Choose a default category

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Product'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: 'Product Name'),
                      onChanged: (value) {
                        setState(() {
                          productName = value;
                        });
                      },
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Quantity'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          productQuantity = int.tryParse(value) ?? 1;
                        });
                      },
                    ),
                    DropdownButton<String>(
                      value: selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                      },
                      items: categories.keys.map<DropdownMenuItem<String>>((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    final product = Product(
                      name: productName,
                      category: selectedCategory,
                      quantity: productQuantity,
                    );

                    setState(() {
                      categories.putIfAbsent(selectedCategory, () => []);
                      categories[selectedCategory]?.add(product);
                      products.add(product);
                    });

                    // Trigger a rebuild of the ShoppingListTab widget
                    shoppingListTabKey.currentState?.updateProducts();

                    Navigator.pop(context);
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteProduct(Product product) {
    setState(() {
      products.remove(product);
      if (categories.containsKey(product.category)) {
        categories[product.category]?.remove(product);
      }
    });
  }
}

class ShoppingListTab extends StatefulWidget {
  final List<Product> products;
  final Function(Product) onDelete;

  ShoppingListTab({Key? key, required this.products, required this.onDelete})
      : super(key: key);

  @override
  ShoppingListTabState createState() => ShoppingListTabState();
}

class ShoppingListTabState extends State<ShoppingListTab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: widget.products.length,
        itemBuilder: (context, index) {
          final product = widget.products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('Quantity: ${product.quantity}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                widget.onDelete(product);
                _deleteProduct(product);
              },
            ),
          );
        },
      ),
    );
  }

  void updateProducts() {
    setState(() {});
  }

  void _deleteProduct(Product product) {
    setState(() {
      widget.products.remove(product);
    });
  }
}
