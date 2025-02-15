import 'package:flutter/material.dart';
import 'package:bloom_and_bliss/sidenav.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
                BodySection()
              ]
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
    return Padding(padding: EdgeInsets.only(top: 70),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
              Text("Flower Shop Home Page",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
            ],
        ),
    );
  }
}

class BodySection extends StatelessWidget {
  const BodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "At our Flower Shop, we believe that every flower tells a story. Whether you're celebrating a special occasion, expressing love and gratitude, or simply brightening someone’s day, our carefully curated blooms are here to make every moment more beautiful. Explore our collection of fresh, hand-picked flowers arranged with love and care. From classic roses to vibrant sunflowers, elegant lilies, and delicate tulips, we have the perfect arrangement for any occasion. Let us help you share joy, warmth, and affection—one petal at a time. We're delighted to help make your special moments even more memorable!",
            textAlign: TextAlign.justify,
            style: TextStyle(
                fontSize: 18,
                color: Colors.black
            ),
          ),
        ],
      ),
    );
  }
}
