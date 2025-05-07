class Product {
  final String id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});
  factory Product.fromFirestore(Map<String, dynamic> doc) {
    return Product(
      id: doc['id'] ?? '', // Make sure the Firestore field names match
      name: doc['name'] ??
          '', // 'name' is the field in Firestore that stores the product's name
      price: doc['price'] ??
          '', // 'price' is the field in Firestore that stores the product's price
    );
  }
}
