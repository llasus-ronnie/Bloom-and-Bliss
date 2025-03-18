import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bloom_and_bliss/sidenav.dart';
import 'package:bloom_and_bliss/main.dart';
import 'package:bloom_and_bliss/constants/colors.dart';

void main() {
  runApp(const CartPage());
}

class CartPage extends StatelessWidget {
  const CartPage({super.key});

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
        drawer: Sidenav(),
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
                  Center(child: CartSection()), // Ensure CartSection is centered
                  SizedBox(height: 40),
                  Center(child: InputSection()), // Ensure InputSection is centered
                  SizedBox(height: 40),
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
    double itemWidth = screenWidth > 600 ? 300 : screenWidth * 0.8;

    return Container(
      width: itemWidth,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: itemWidth * 1.25,
            height: itemWidth * 1.25,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.black, width: 1),
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            name,
            style: TextStyle(fontFamily: "Recoleta", fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            price,
            style: TextStyle(fontSize: 16, color: Colors.green),
          ),
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

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void placeOrder() {
    if (addressController.text.isEmpty ||
        nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        zipController.text.isEmpty) {
      showError("All fields are required");
      return;
    }

    if (phoneController.text.length < 12) {
      showError("Phone number must be at least 12 digits");
      return;
    }

    if (zipController.text.length > 4) {
      showError("Zip code cannot exceed 4 characters");
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actionsAlignment: MainAxisAlignment.center,
        title: Text(
          "Confirm Order",
          style: TextStyle(fontFamily: 'Recoleta', fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: Text(
          "Are you sure you want to place the order?",
          style: TextStyle(fontFamily: 'Recoleta', fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(
              "Cancel",
              style: TextStyle(fontFamily: 'Recoleta', fontSize: 16),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Order placed successfully!", style: TextStyle(fontFamily: 'Recoleta')), backgroundColor: Colors.green),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.pink,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              "Confirm",
              style: TextStyle(fontFamily: 'Recoleta', fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Shipping Details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Recoleta'),
            ),
          ),
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
        ],
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String labelText;
  final IconData icon;
  final bool isNumeric;
  final TextEditingController controller;
  final int? maxLength;
  final bool restrictSpecial;



  const CustomTextField(
      this.labelText,
      this.icon, {required this.controller, this.isNumeric = false, this.maxLength, this.restrictSpecial = false, super.key});

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
    return SizedBox(
      width: 140,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: 'Recoleta', fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
