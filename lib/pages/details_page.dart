import 'package:flutter/material.dart';
import 'package:bloom_and_bliss/sidenav.dart';
import 'package:bloom_and_bliss/main.dart';
import 'package:bloom_and_bliss/constants/colors.dart';

void main() {
  runApp(const DetailsPage());
}

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flower Shop",
      home: Scaffold(
        backgroundColor: AppColors.beige,
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
            elevation: 0,
          ),
        ),
        drawer: Sidenav(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              TextTitleSection(),
              BodySection(),
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
      padding: EdgeInsets.only(top: 50),
      child: Text(
        "Our Flowers",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontFamily: 'PTSerif'
        ),
      ),
    );
  }
}

class BodySection extends StatelessWidget {
  const BodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.pink, width: 10),
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage('assets/sample-flower.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Beautiful Red Rose",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'PTSerif'
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            "This vibrant red rose symbolizes love and passion. Perfect for any occasion!",
            style: TextStyle(
              fontSize: 16,
              color: AppColors.black,
              fontFamily: 'PTSerif'
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            "Price: \$12.99",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.green,
              fontFamily: 'PTSerif'
            ),
          ),
          Text(
            "Availability: In Stock",
            style: TextStyle(
              fontSize: 16,
              color: AppColors.black,
              fontFamily: 'PTSerif'
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonFieldSection extends StatelessWidget {
  const ButtonFieldSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(30),
      child: Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(child:
          ElevatedButton(
              onPressed: () =>
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyApp())),
              child: Text("Back"))
          ),
        ],
      ),
    );
  }
}
