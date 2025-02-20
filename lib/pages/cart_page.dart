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
                child: Image.asset("assets/bnb-logo.png", height: 70),
              ),
              ),
            iconTheme: IconThemeData(
                color: AppColors.pink
            ),
            ),
        ),
        drawer: Sidenav(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              TextTitleSection(),
              SizedBox(height: 40),
              CartSection(),
              SizedBox(height: 40),
              InputSection(),
              SizedBox(height: 40),
            ],
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CartItem(imagePath: "assets/flower-placeholder1.png", name: "Rose Bouquet", price: "\₱999.00"),
        SizedBox(width: 20),
        CartItem(imagePath: "assets/flower-placeholder2.png", name: "Assorted Arrangement", price: "\₱1299.00"),
      ],
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
    return Container(
      width: 300,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 375,
            height: 375,
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

class InputSection extends StatelessWidget {
  const InputSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 640,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Shipping Details",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Recoleta',
              ),
            ),
          ),
          SizedBox(height: 15),
          CustomTextField("Enter address...", 600, Icons.home),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField("Recipient Name", 290, Icons.person),
              SizedBox(width: 20),
              CustomTextField("Phone Number", 290, Icons.phone, isNumeric: true),
            ],
          ),
          SizedBox(height: 15),
          CustomTextField("Additional Information", 600, Icons.info),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: CustomTextField("Zip Code", 0, Icons.local_post_office, isNumeric: true)),
              SizedBox(width: 15),
              Expanded(child: CustomTextField("City", 0, Icons.location_city)),
              SizedBox(width: 15),
              Expanded(child: CustomTextField("Region", 0, Icons.map)),
            ],
          ),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton("Place Order", AppColors.green, () {}),
              SizedBox(width: 40),
              CustomButton("Back", AppColors.pink, () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              )),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String labelText;
  final double width;
  final IconData icon;
  final bool isNumeric;

  const CustomTextField(this.labelText, this.width, this.icon, {this.isNumeric = false, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextField(
        textAlign: TextAlign.start,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        inputFormatters: isNumeric ? [FilteringTextInputFormatter.digitsOnly] : null,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.pink),
          labelText: labelText,
          labelStyle: TextStyle(color: AppColors.pink),
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
      ),
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
      width: 190,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(fontSize: 20, color: AppColors.black, fontFamily: 'BreeSerif'),
        ),
      ),
    );
  }
}
