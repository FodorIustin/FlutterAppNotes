import 'package:flutter/material.dart';
import 'product_model.dart';
import '../common/strings.dart' as strings;
import 'category_products_screen.dart';

class CategoriesTab extends StatefulWidget {
  final Map<String, List<Product>> categories;

  const CategoriesTab({Key? key, required this.categories}) : super(key: key);

  @override
  _CategoriesTabState createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {
  TextEditingController categoryNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: categoryNameController,
            decoration: const InputDecoration(labelText: 'Category Name'),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              _addCategory();
            },
            child: const Text('Add Category'),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: widget.categories.keys.length,
              itemBuilder: (context, index) {
                final category = widget.categories.keys.elementAt(index);
                return Card(
                  child: ListTile(
                    title: Text(category),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryProductsScreen(
                            category: category,
                            products: widget.categories[category] ?? [],
                          ),
                        ),
                      );
                    },
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteCategory(category);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addCategory() {
    final categoryName = categoryNameController.text.trim();
    if (categoryName.isNotEmpty) {
      setState(() {
        widget.categories[categoryName] = [];
      });
      categoryNameController.clear();
    }
  }

  void _deleteCategory(String category) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Category'),
          content: const Text('Are you sure you want to delete this category?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _confirmDeleteCategory(category);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteCategory(String category) {
    setState(() {
      widget.categories.remove(category);
    });
  }
}
