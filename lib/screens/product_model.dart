class Product {
  final String name;
  final String category;
  final int quantity;

  Product({required this.name, required this.category, required this.quantity});
}
  // class with the name Category is created with a constructor that takes a string as a parameter and assigns it to the name property.

class Category {
  final String name;

  Category({required this.name});
}
// class category , only have the name as paremeter