import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        body: SingleChildScrollView(
          child: Column(
              children: [
                TextTitleSection(),
                BodySection()
              ]
          ),
        ),
        drawer: Drawer (
          child: ListView(
            children: [
              DrwHeader(),
              DrwListView()
            ],
          ),
        ),
      ),
    );
  }
}

class DrwHeader extends StatefulWidget {
  @override
  _Drwheader createState() => _Drwheader();
}
class _Drwheader extends State<DrwHeader> {
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
          color: Colors.grey
      ),
      child: Column(
        children: [
          SizedBox(height: 10),
          CircleAvatar(
            backgroundImage: AssetImage('assets/id-icon.jpg'),
            radius: 40,
          ),
          SizedBox(height: 10),
          Text(
              "Guest User",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold
              )
          ),
        ],
      ),
    );
  }
}
class DrwListView extends StatefulWidget {
  @override
  _DrwListView createState() => _DrwListView();
}
class _DrwListView extends State<DrwListView> {
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text("Home"),
            leading: Icon(Icons.home),
            onTap: null,
            // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => main_page())),
          ),
          ListTile(
            title: Text("Sign Up"),
            leading: Icon(Icons.person),
            onTap: null,
          ),
          ListTile(
            title: Text("Your Cart"),
            leading: Icon(Icons.shopping_cart),
            onTap: null,
          ),
          ListTile(
            title: Text("Our Flowers"),
            leading: Icon(Icons.local_florist),
            onTap: null,
          ),
          ListTile(
            title: Text("Shop Catalogue"),
            leading: Icon(Icons.apps),
            onTap: null,
          ),
        ],
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
              Text("Welcome to our Flower Shop!",
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
