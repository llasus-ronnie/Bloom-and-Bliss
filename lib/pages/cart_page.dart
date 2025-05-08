import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bloom_and_bliss/sidenav.dart';
import 'package:bloom_and_bliss/main.dart';
import 'package:bloom_and_bliss/constants/colors.dart';
import '../../models/user.dart';
import '../../models/cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import "../controller/cart_controller.dart";
import '../../models/cart_item.dart';

void main() {
  runApp(CartPage(
      user: User(fullName: '', email: '', password: '', phoneNumber: 0)));
}

class CartPage extends StatelessWidget {
  final User user;
  const CartPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Bloom & Bliss - Your Cart",
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBar(
            backgroundColor: AppColors.beige,
            centerTitle: true,
            flexibleSpace: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 10, bottom: 5),
                child: Image.asset("assets/sidenav/bnb-logo.png", height: 70),
              ),
            ),
            iconTheme: IconThemeData(color: AppColors.pink),
          ),
        ),
        drawer: Sidenav(user: user),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: double.infinity,
              color: AppColors.beige,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  TextTitleSection(),
                  SizedBox(height: 40),
                  Center(child: CartSection(user: user)),
                  SizedBox(height: 40),
                  InputSection(user: user),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TextTitleSection extends StatelessWidget {
  const TextTitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(
        "Your Cart",
        style: TextStyle(
          fontFamily: 'Recoleta',
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}

class CartSection extends StatelessWidget {
  final User user;
  const CartSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final cart = Cart(user: user);
    final cartController = CartController(cart, user);

    return StreamBuilder<List<CartItem>>(
      stream: cartController.getCartItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Your cart is empty 🥀',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'Recoleta',
            ),));
        }

        var cartItems = snapshot.data!;

        double totalPrice = cartItems.fold(
          0.0,
              (sum, item) => sum + (item.product.price * item.quantity),
        );

        return Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: cartItems.map((cartItem) {
                    return CartItemWidget(
                      cartItem: cartItem,
                      cartController: cartController,
                    );
                  }).toList(),
                );
              },
            ),
            SizedBox(height: 30),
            Divider(thickness: 1),
            Text(
              "Total: ₱${totalPrice.toStringAsFixed(2)}",
              style: TextStyle(
                fontFamily: 'Recoleta',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      },
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final CartController cartController;

  CartItemWidget({required this.cartItem, required this.cartController});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.product.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Recoleta',
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "₱${cartItem.product.price.toStringAsFixed(2)} each",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontFamily: 'PTSerif',
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove_circle_outline),
                    onPressed: () => cartController.decreaseQuantity(cartItem),
                  ),
                  Text(
                    cartItem.quantity.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'PTSerif',
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    onPressed: () => cartController.increaseQuantity(cartItem),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₱${(cartItem.product.price * cartItem.quantity).toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Recoleta',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class InputSection extends StatefulWidget {
  final User user;

  const InputSection({
    super.key,
    required this.user
  });

  @override
  _InputSectionState createState() => _InputSectionState();
}

class _InputSectionState extends State<InputSection> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController additionalInfoController = TextEditingController();
  final TextEditingController zipController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController regionController = TextEditingController();

  Map<String, String> submittedData = {};
  String? submittedDocId;
  String? hoveredId;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    nameController.text = widget.user.fullName;
  }

  Future<void> _fetchUserData() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.id)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        nameController.text = userData?['fullName'] ?? '';
        phoneController.text = userData?['phoneNumber']?.toString() ?? '';
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red));
  }

  void placeOrder() async {
    if ([
      addressController.text,
      nameController.text,
      phoneController.text,
      zipController.text
    ].any((t) => t.isEmpty)) {
      showError("All fields are required");
      return;
    }

    if (phoneController.text.length < 9) {
      showError("Phone number must be at least 9 digits");
      return;
    }

    if (zipController.text.length > 4) {
      showError("Zip code cannot exceed 4 characters");
      return;
    }

    final cart = Cart(user: widget.user);
    final cartController = CartController(cart, widget.user);
    final cartItems = await cartController.getCartItems().first;
    final totalPrice = cartItems.fold(
      0.0,
          (sum, item) => sum + (item.product.price * item.quantity),
    );

    final orderData = {
      'address': addressController.text,
      'name': nameController.text,
      'phone': phoneController.text,
      'additionalInfo': additionalInfoController.text,
      'zip': zipController.text,
      'city': cityController.text,
      'region': regionController.text,
      'items': cartItems.map((item) => {
        'productId': item.product.id,
        'name': item.product.name,
        'price': item.product.price,
        'quantity': item.quantity,
      }).toList(),
      'total': totalPrice,
      'timestamp': FieldValue.serverTimestamp(),
      'userId': widget.user.id,
    };

    bool? shouldProceed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actionsAlignment: MainAxisAlignment.center,
        title: Text("Confirm Order",
            style: TextStyle(
                fontFamily: 'Recoleta',
                fontSize: 20,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        content: Text("Are you sure you want to place the order?",
            style: TextStyle(fontFamily: 'Recoleta', fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text("Cancel",
                style: TextStyle(fontFamily: 'Recoleta', fontSize: 16)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.pink,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: Text("Confirm",
                style: TextStyle(
                    fontFamily: 'Recoleta',
                    fontSize: 16,
                    color: Colors.white)),
          ),
        ],
      ),
    );

    if (shouldProceed == true) {
      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return Center(child: CircularProgressIndicator());
          },
        );

        // Place order
        final docRef = await FirebaseFirestore.instance
            .collection('orders')
            .add(orderData);

        Navigator.of(context, rootNavigator: true).pop();

        setState(() {
          submittedData = orderData.map((k, v) => MapEntry(k, v.toString()));
          submittedDocId = docRef.id;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Center(
                child: Text(
                  "Order Placed!",
                  style: TextStyle(
                    fontFamily: 'Recoleta',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              content: Text(
                "Thank you for choosing Bloom & Bliss!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'PTSerif',
                  fontSize: 16,
                ),
              ),
              actions: [
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(color: Colors.pink),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      } catch (e) {
        Navigator.of(context, rootNavigator: true).pop();
        showError("Failed to place order: $e");
      }
    }
  }

  void updateOrder() async {
    if (submittedDocId == null) {
      showError("No order to update.");
      return;
    }
    final updatedData = {
      'address': addressController.text,
      'name': nameController.text,
      'phone': phoneController.text,
      'additionalInfo': additionalInfoController.text,
      'zip': zipController.text,
      'city': cityController.text,
      'region': regionController.text,
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(submittedDocId)
          .update(updatedData);
      setState(() {
        submittedData = updatedData.map((k, v) => MapEntry(k, v.toString()));
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Order updated successfully!",
              style: TextStyle(fontFamily: 'Recoleta')),
          backgroundColor: Colors.blue));
    } catch (e) {
      showError("Failed to update order: $e");
    }
  }

  void removeOrder() async {
    if (submittedDocId == null) return;
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(submittedDocId)
          .delete();
      setState(() {
        submittedData = {};
        submittedDocId = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Order removed successfully!",
              style: TextStyle(fontFamily: 'Recoleta')),
          backgroundColor: Colors.red));
    } catch (e) {
      showError("Failed to remove order: $e");
    }
  }

  void handleOrderSelect(Map<String, dynamic> data, String docId) {
    setState(() {
      addressController.text = data['address'] ?? '';
      nameController.text = data['name'] ?? '';
      phoneController.text = data['phone'] ?? '';
      additionalInfoController.text = data['additionalInfo'] ?? '';
      zipController.text = data['zip'] ?? '';
      cityController.text = data['city'] ?? '';
      regionController.text = data['region'] ?? '';
      submittedDocId = docId;
      submittedData = data.map((k, v) => MapEntry(k, v.toString()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, blurRadius: 12, offset: Offset(0, 6))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Text("Shipping Details",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Recoleta'))),
              SizedBox(height: 15),
              CustomTextField("Home Address", Icons.home,
                  controller: addressController),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: IgnorePointer(
                      child: CustomTextField(
                        "Recipient Name",
                        Icons.person,
                        controller: nameController,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                      child: CustomTextField("Phone Number", Icons.phone,
                          controller: phoneController,
                          isNumeric: true,
                          maxLength: 12)
                  ),
                ],
              ),
              SizedBox(height: 15),
              CustomTextField("Additional Information", Icons.info,
                  controller: additionalInfoController),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                      child: CustomTextField(
                          "ZIP", Icons.local_post_office,
                          controller: zipController,
                          isNumeric: true,
                          maxLength: 4)),
                  SizedBox(width: 15),
                  Expanded(
                      child: CustomTextField("City", Icons.location_city,
                          controller: cityController)),
                  SizedBox(width: 15),
                  Expanded(
                      child: CustomTextField("Region", Icons.map,
                          controller: regionController)),
                ],
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                      "Back",
                      AppColors.green,
                          () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MyApp()))),
                  SizedBox(width: 20),
                  CustomButton("Place Order", AppColors.pink, placeOrder),

                ],
              ),
              if (submittedData.isNotEmpty) ...[
                SizedBox(height: 30),
                Text(
                  "Submitted Data:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    displayField("Name", submittedData['name']),
                    displayField("Region", submittedData['region']),
                    displayField("Address", submittedData['address']),
                    displayField("Phone", submittedData['phone']),
                    displayField("City", submittedData['city']),
                    displayField("Zip", submittedData['zip']),
                    displayField(
                        "Additional Info", submittedData['additionalInfo']),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.edit,
                          size: 18, color: Colors.grey.shade600),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton("Remove Order", Colors.red, removeOrder),
                    SizedBox(width: 20),
                    CustomButton("Update Order", AppColors.pink, updateOrder),

                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

Widget displayField(String label, dynamic value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 14, color: Colors.black),
        children: [
          TextSpan(
            text: "$label: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: value?.toString() ?? '',
          ),
        ],
      ),
    ),
  );
}

class CustomTextField extends StatelessWidget {
  final String labelText;
  final IconData icon;
  final bool isNumeric;
  final TextEditingController controller;
  final int? maxLength;
  final bool restrictSpecial;

  const CustomTextField(this.labelText, this.icon,
      {required this.controller,
        this.isNumeric = false,
        this.maxLength,
        this.restrictSpecial = false,
        super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      inputFormatters: [
        if (isNumeric) FilteringTextInputFormatter.digitsOnly,
        if (restrictSpecial)
          FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9 ]+$')),
        if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
      ],
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.pink),
        labelText: labelText,
        labelStyle: TextStyle(color: AppColors.pink, fontFamily: 'Recoleta', fontSize: 14),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: AppColors.pink, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: AppColors.black, width: 0.5),
        ),
        filled: true,
        fillColor: AppColors.beige,
      ),
      cursorColor: AppColors.black,
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const CustomButton(this.text, this.color, this.onPressed, {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(
            horizontal: 24, vertical: 16),
      ),
      child: SizedBox(
        width: 110,
        child: Text(
          text,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Recoleta',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

