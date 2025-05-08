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
      product: Product.fromFirestore(doc['product']),
      quantity: doc['quantity'] ?? 0,
    );
  }
}
