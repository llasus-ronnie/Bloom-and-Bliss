import 'package:flutter/material.dart';
import 'package:bloom_and_bliss/sidenav.dart';
import 'package:bloom_and_bliss/main.dart';

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
              TextTitleSection(),
              ImageInputSection(),
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
      padding: EdgeInsets.only(top: 70),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Your Cart Page",
            style: TextStyle(
              fontSize: 24,
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
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.image, size: 80, color: Colors.grey[600]),
              ),
              SizedBox(width: 15),
              Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.image, size: 80, color: Colors.grey[600]),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            width: 800,
            child: TextField(
              decoration: InputDecoration(
                hintText: "Enter details...",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 390,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Additional Input 1",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(width: 20),
              Container(
                width: 390,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Additional Input 2",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 180,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                  },
                  child: Text("Submit", style: TextStyle(fontSize: 18)),
                ),
              ),
              SizedBox(width: 10),
              SizedBox(
                width: 180,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  ),
                  child: Text("Back", style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
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
    return SizedBox.shrink();
  }
}
