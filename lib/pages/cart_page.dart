import 'package:flutter/material.dart';
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
    const String apptitle = "Flower Shop";
    return MaterialApp(
      title: apptitle,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            centerTitle: true,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/flowers-header.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
        drawer: Sidenav(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              TextTitleSection(),
              SizedBox(height: 40),
              ImageInputSection(),
              SizedBox(height: 40),
              ButtonFieldSection(),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Your Cart Page",
            style: TextStyle(
              fontFamily: 'BreeSerif',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class ImageInputSection extends StatelessWidget {
  const ImageInputSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.black, width: 2),
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage("assets/flower-placeholder1.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 30),
              Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.black, width: 2),
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage("assets/flower-placeholder2.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Container(
            width: 800,
            child: TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "Enter address...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: AppColors.yellow, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: AppColors.yellow, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: AppColors.yellow, width: 3),
                ),
                filled: true,
                fillColor: AppColors.beige,
                contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 25),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 390,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Details 1",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: AppColors.yellow, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: AppColors.yellow, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: AppColors.yellow, width: 3),
                    ),
                    filled: true,
                    fillColor: AppColors.beige,
                    contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 25),
                  ),
                ),
              ),
              SizedBox(width: 30),
              Container(
                width: 390,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Details 2",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: AppColors.yellow, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: AppColors.yellow, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: AppColors.yellow, width: 3),
                    ),
                    filled: true,
                    fillColor: AppColors.beige,
                    contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 25),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 190,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.black,
                      fontFamily: 'BreeSerif',
                    ),
                  ),
                ),
              ),
              SizedBox(width: 50),
              SizedBox(
                width: 190,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.pink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  ),
                  child: Text(
                    "Back",
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.black,
                      fontFamily: 'BreeSerif',
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}

class ButtonFieldSection extends StatelessWidget {
  const ButtonFieldSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }
}
