import 'package:flutter/material.dart';
import 'package:bloom_and_bliss/sidenav.dart';
import 'package:bloom_and_bliss/main.dart';

void main() {
  runApp(const CartPage());
}

class CartPage extends StatelessWidget {
  const CartPage ({super.key});

  // This widget is the root of your application.
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
                ButtonFieldSection()
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
          Text("Your Cart Page",
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

class ButtonFieldSection extends StatelessWidget{
  const ButtonFieldSection({super.key});

  @override
  Widget build(BuildContext context){
    return Padding(padding: EdgeInsets.all(30),
      child: Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(child:
          ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp())),
              child: Text("Back"))
          ),
        ],
      ),
    );
  }
}