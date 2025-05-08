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
    return firestore.collection('carts').snapshots().map((snapshot) {
      // Filter only the documents that belong to the current user
      final docs = snapshot.docs.where((doc) => doc.data()['userId'] == user.id);

      return docs.map((doc) {
        final data = doc.data();

        // Ensure 'imageUrl' is also retrieved from Firestore
        final product = Product(
          id: data['productId'] ?? '',
          name: data['name'] ?? '',
          price: (data['price'] ?? 0).toDouble(),
          imageUrl: data['imageUrl'] ?? '', // Add the 'imageUrl' field here
        );

        return CartItem(
          product: product,
          quantity: data['quantity'] ?? 0,
        );
      }).toList();
    });
  }


  // Add a product to the cart
  void addProduct(Product product) async {
    final existingProductIndex = cart.items.indexWhere((item) => item.product.id == product.id);

    if (existingProductIndex >= 0) {
      cart.items[existingProductIndex].quantity++;
      await _updateFirestoreQuantity(cart.items[existingProductIndex]);
    } else {
      final newCartItem = CartItem(product: product, quantity: 1);
      cart.items.add(newCartItem);
      await _addNewProductToFirestore(newCartItem);
    }
  }

  // Increase the quantity of an existing product in the cart
  void increaseQuantity(CartItem cartItem) async {
    cartItem.quantity++;
    await _updateFirestoreQuantity(cartItem);
  }

  // Decrease the quantity of an existing product in the cart
  void decreaseQuantity(CartItem cartItem) async {
    if (cartItem.quantity > 1) {
      cartItem.quantity--;
      await _updateFirestoreQuantity(cartItem);
    } else {
      // Remove the item from the cart if the quantity is 1
      await _deleteCartItemFromFirestore(cartItem);
    }
  }

  // Update the quantity of a product in Firestore
  Future<void> _updateFirestoreQuantity(CartItem cartItem) async {
    final cartDocId = '${user.id}_${cartItem.product.id}';
    await firestore.collection('carts').doc(cartDocId).update({
      'quantity': cartItem.quantity,
    });
    Fluttertoast.showToast(
      msg: "Quantity updated",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // Add a new product to Firestore
  Future<void> _addNewProductToFirestore(CartItem cartItem) async {
    await firestore.collection('carts').doc('${user.id}_${cartItem.product.id}').set({
      'userId': user.id,
      'productId': cartItem.product.id,
      'name': cartItem.product.name,
      'price': cartItem.product.price,
      'quantity': cartItem.quantity,
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

  // Remove the product from Firestore
  Future<void> _deleteCartItemFromFirestore(CartItem cartItem) async {
    final cartDocId = '${user.id}_${cartItem.product.id}';
    await firestore.collection('carts').doc(cartDocId).delete();
    Fluttertoast.showToast(
      msg: "Product removed from cart",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // Get the total cost of all products in the cart
  double getTotalCost() {
    return cart.items.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));
  }
}
