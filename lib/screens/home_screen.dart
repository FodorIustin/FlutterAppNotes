import 'package:flutter/material.dart';
import '../common/strings.dart' as strings;
import 'categories_tab.dart';
import 'category_products_screen.dart';
import 'product_model.dart';

// Define the main HomeScreen class as a StatefulWidget
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Initialize lists and keys
  List<Product> products = [];
  Map<String, List<Product>> categories = {};
  final GlobalKey<ShoppingListTabState> shoppingListTabKey = GlobalKey();

  // Build the main UI using DefaultTabController
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
            // Display the Shopping List Tab
            ShoppingListTab(
              key: shoppingListTabKey,
              products: products,
              onDelete: (product) {
                _deleteProduct(product);
              },
            ),
            // Display the Categories Tab
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

  // Show a dialog for adding a new product
  void _showAddProductDialog(BuildContext context) async {
    String productName = '';
    int productQuantity = 1;
    String selectedCategory = categories.keys.first;

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
                    // Text field for product name
                    TextField(
                      decoration: const InputDecoration(labelText: 'Product Name'),
                      onChanged: (value) {
                        setState(() {
                          productName = value;
                        });
                      },
                    ),
                    // Text field for product quantity
                    TextField(
                      decoration: const InputDecoration(labelText: 'Quantity'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          productQuantity = int.tryParse(value) ?? 1;
                        });
                      },
                    ),
                    // Dropdown for selecting product category
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
                // Cancel button
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                // Add button
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

  // Delete a product from the list
  void _deleteProduct(Product product) {
    setState(() {
      products.remove(product);
      if (categories.containsKey(product.category)) {
        categories[product.category]?.remove(product);
      }
    });
  }
}

// Define ShoppingListTab widget
class ShoppingListTab extends StatefulWidget {
  final List<Product> products;
  final Function(Product) onDelete;

  ShoppingListTab({Key? key, required this.products, required this.onDelete})
      : super(key: key);

  @override
  ShoppingListTabState createState() => ShoppingListTabState();
}

// Define the state for ShoppingListTab widget
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

  // Update the widget to reflect changes in the products list
  void updateProducts() {
    setState(() {});
  }

  // Delete a product from the list
  void _deleteProduct(Product product) {
    setState(() {
      widget.products.remove(product);
    });
  }
}
