import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bloom_and_bliss/sidenav.dart';
import 'package:bloom_and_bliss/main.dart';
import 'package:bloom_and_bliss/constants/colors.dart';
import '../../models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(CartPage(user: User(fullName: '', email: '', password: '', phoneNumber: 0)));
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
                  Center(child: CartSection()),
                  SizedBox(height: 40),
                  InputSection(),
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
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        "Your Cart Page",
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
  const CartSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: [
            CartItem(imagePath: "assets/cart/flower-placeholder1.png", name: "Rose Bouquet", price: "PHP999.00"),
            CartItem(imagePath: "assets/cart/flower-placeholder2.png", name: "Assorted Arrangement", price: "PHP1299.00"),
          ],
        );
      },
    );
  }
}

class CartItem extends StatelessWidget {
  final String imagePath;
  final String name;
  final String price;

  const CartItem({required this.imagePath, required this.name, required this.price, super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = screenWidth * 0.4;
    if (itemWidth > 400) itemWidth = 400;


    return Container(
      width: itemWidth,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.beige,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(imagePath, width: itemWidth, height: itemWidth, fit: BoxFit.cover),
          ),
          SizedBox(height: 10),
          Text(name, style: TextStyle(fontFamily: "Recoleta", fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          SizedBox(height: 5),
          Text(price, style: TextStyle(fontSize: 16, color: Colors.green, fontFamily: 'Recoleta')),
        ],
      ),
    );
  }
}

class InputSection extends StatefulWidget {
  const InputSection({super.key});

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

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
  }

  void placeOrder() async {
    if ([addressController.text, nameController.text, phoneController.text, zipController.text].any((t) => t.isEmpty)) {
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

    final orderData = {
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
      final docRef = await FirebaseFirestore.instance.collection('orders').add(orderData);
      setState(() {
        submittedData = orderData.map((k, v) => MapEntry(k, v.toString()));
        submittedDocId = docRef.id;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          actionsAlignment: MainAxisAlignment.center,
          title: Text("Confirm Order", style: TextStyle(fontFamily: 'Recoleta', fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          content: Text("Are you sure you want to place the order?", style: TextStyle(fontFamily: 'Recoleta', fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text("Cancel", style: TextStyle(fontFamily: 'Recoleta', fontSize: 16)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Order placed successfully!", style: TextStyle(fontFamily: 'Recoleta')), backgroundColor: Colors.green));
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.pink, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: Text("Confirm", style: TextStyle(fontFamily: 'Recoleta', fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      );
    } catch (e) {
      showError("Failed to place order: $e");
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
      await FirebaseFirestore.instance.collection('orders').doc(submittedDocId).update(updatedData);
      setState(() {
        submittedData = updatedData.map((k, v) => MapEntry(k, v.toString()));
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Order updated successfully!", style: TextStyle(fontFamily: 'Recoleta')), backgroundColor: Colors.blue));
    } catch (e) {
      showError("Failed to update order: $e");
    }
  }

  void removeOrder() async {
    if (submittedDocId == null) return;
    try {
      await FirebaseFirestore.instance.collection('orders').doc(submittedDocId).delete();
      setState(() {
        submittedData = {};
        submittedDocId = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Order removed successfully!", style: TextStyle(fontFamily: 'Recoleta')), backgroundColor: Colors.red));
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
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 6))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Text("Shipping Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Recoleta'))),
              SizedBox(height: 15),
              CustomTextField("Enter address...", Icons.home, controller: addressController),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: CustomTextField("Recipient Name", Icons.person, controller: nameController)),
                  SizedBox(width: 20),
                  Expanded(child: CustomTextField("Phone Number", Icons.phone, controller: phoneController, isNumeric: true, maxLength: 12)),
                ],
              ),
              SizedBox(height: 15),
              CustomTextField("Additional Information", Icons.info, controller: additionalInfoController),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: CustomTextField("Zip Code", Icons.local_post_office, controller: zipController, isNumeric: true, maxLength: 4)),
                  SizedBox(width: 15),
                  Expanded(child: CustomTextField("City", Icons.location_city, controller: cityController)),
                  SizedBox(width: 15),
                  Expanded(child: CustomTextField("Region", Icons.map, controller: regionController)),
                ],
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton("Place Order", AppColors.pink, placeOrder),
                  SizedBox(width: 20),
                  CustomButton("Back", AppColors.green, () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()))),
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
                    displayField("Additional Info", submittedData['additionalInfo']),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.edit, size: 18, color: Colors.grey.shade600),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton("Update Order", AppColors.pink, updateOrder),
                    SizedBox(width: 20),
                    CustomButton("Remove Order", Colors.red, removeOrder),
                  ],
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: 30),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('orders').orderBy('timestamp', descending: true).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            final docs = snapshot.data!.docs;
            return SubmittedOrdersSection(onSelect: handleOrderSelect, docs: docs);
          },
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

  const CustomTextField(this.labelText, this.icon, {required this.controller, this.isNumeric = false, this.maxLength, this.restrictSpecial = false, super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      inputFormatters: [
        if (isNumeric) FilteringTextInputFormatter.digitsOnly,
        if (restrictSpecial) FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9 ]+$')),
        if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
      ],
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.pink),
        labelText: labelText,
        labelStyle: TextStyle(color: AppColors.pink, fontFamily: 'Recoleta'),
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
        contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 25),
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
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16), // keep consistent size
      ),
      child: SizedBox(
        width: 110, // fixed width to prevent wrapping
        child: Text(
          text,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Recoleta',
            fontSize: 14, // reduced font size
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}


class SubmittedOrdersSection extends StatefulWidget {
  final List<QueryDocumentSnapshot> docs;
  final Function(Map<String, dynamic>, String) onSelect;

  const SubmittedOrdersSection({super.key, required this.docs, required this.onSelect});

  @override
  _SubmittedOrdersSectionState createState() => _SubmittedOrdersSectionState();
}

class _SubmittedOrdersSectionState extends State<SubmittedOrdersSection> {
  String? hoveredId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Submitted Orders:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 10),
        ...widget.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final docId = doc.id;
          return MouseRegion(
            onEnter: (_) => setState(() => hoveredId = docId),
            onExit: (_) => setState(() => hoveredId = null),
            child: GestureDetector(
              onTap: () => widget.onSelect(data, docId),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                margin: EdgeInsets.symmetric(vertical: 8),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: hoveredId == docId ? Colors.grey.shade100 : Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    displayField("Name", data['name']),
                    displayField("Region", data['region']),
                    displayField("Address", data['address']),
                    displayField("Phone", data['phone']),
                    displayField("City", data['city']),
                    displayField("Zip", data['zip']),
                    displayField("Additional Info", data['additionalInfo']),
                    displayField("Timestamp", data['timestamp'] is Timestamp
                        ? DateFormat('yyyy-MM-dd hh:mm a').format((data['timestamp'] as Timestamp).toDate())
                        : data['timestamp']?.toString()),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.edit, size: 18, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget displayField(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 15, fontFamily: '', color: Colors.black),
          children: [
            TextSpan(
              text: "$label: ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value?.toString() ?? 'N/A'),
          ],
        ),
      ),
    );
  }
}




