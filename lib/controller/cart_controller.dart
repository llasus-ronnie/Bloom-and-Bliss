import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/user.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CartController {
  final Cart cart;
  final User user;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CartController(this.cart, this.user);

Stream<List<CartItem>> getCartItems() {
  final cartCollection = firestore
      .collection('carts')
      .doc(user.id)
      .collection('cart');

  return cartCollection.snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();

      final product = Product(
        id: data['productId'] ?? '',
        name: data['name'] ?? '',
        price: (data['price'] ?? 0).toDouble(),
      );

      return CartItem(
        product: product,
        quantity: data['quantity'] ?? 0,
      );
    }).toList();
  });
}



void addProduct(Product product) async {
  final existingProductIndex =
      cart.items.indexWhere((item) => item.product.id == product.id);

  final cartRef = firestore
      .collection('carts')
      .doc(cart.user.id)
      .collection('cart')
      .doc(product.id); 

  if (existingProductIndex >= 0) {
    cart.items[existingProductIndex].quantity++;

    await cartRef.update({
      'quantity': cart.items[existingProductIndex].quantity,
    });

    print("Firestore write completed");
    Fluttertoast.showToast(
      msg: "Product quantity updated in cart",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  } else {
    final newCartItem = CartItem(product: product, quantity: 1);
    cart.items.add(newCartItem);

    await cartRef.set({
      'productId': product.id,
      'name': product.name,
      'price': product.price,
      'quantity': 1,
    });

    Fluttertoast.showToast(
      msg: "Product added to cart",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

}
