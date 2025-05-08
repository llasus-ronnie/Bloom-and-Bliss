class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;  // Add imageUrl here

  // Modify the constructor to include imageUrl
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,  // Add imageUrl as a required parameter
  });

  factory Product.fromFirestore(Map<String, dynamic> doc) {
    return Product(
      id: doc['id'] ?? '', // Make sure the Firestore field names match
      name: doc['name'] ?? '', // 'name' is the field in Firestore that stores the product's name
      price: (doc['price'] ?? 0).toDouble(), // 'price' is the field in Firestore that stores the product's price
      imageUrl: doc['imageUrl'] ?? '', // Assuming 'imageUrl' is the field in Firestore for product images
    );
  }
}
