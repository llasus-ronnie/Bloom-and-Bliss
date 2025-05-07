import './product.dart';

class CartItem {
  final Product product;
   int quantity; 

  CartItem({
    required this.product,
    required this.quantity,
  });

    factory CartItem.fromFirestore(Map<String, dynamic> doc) {
    return CartItem(
      product: Product.fromFirestore(doc['product']), // Assuming you have a Product.fromFirestore method
      quantity: doc['quantity'] ?? 0,
    );
  }
}