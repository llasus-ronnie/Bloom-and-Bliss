import 'package:flutter/material.dart';
import 'package:bloom_and_bliss/main.dart';
import 'package:bloom_and_bliss/pages/signup_page.dart';
import 'package:bloom_and_bliss/pages/cart_page.dart';
import 'package:bloom_and_bliss/pages/details_page.dart';
import 'package:bloom_and_bliss/pages/catalogue_page.dart';
import 'package:bloom_and_bliss/constants/colors.dart';

void main() {
  runApp(const Sidenav());
}

class Sidenav extends StatelessWidget {
  const Sidenav({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.beige,
      child: Column(
        children: [
          DrwHeader(),
          Expanded(child:
            DrwListView()),
        ],
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
      decoration: BoxDecoration(color: AppColors.pink),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/guest-icon.png'),
                  radius: 40,
                ),
                SizedBox(height: 10),
                Text(
                  "Guest User",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
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
    child: Container(
      child: Column(
        children: [
          ListTile(
            title: Text("Home", style: TextStyle(color: AppColors.black)),
            leading: Icon(Icons.home, color: AppColors.pink),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp())),
          ),
          ListTile(
            title: Text("Sign Up", style: TextStyle(color: AppColors.black)),
            leading: Icon(Icons.person, color: AppColors.pink),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage())),
          ),
          ListTile(
            title: Text("Your Cart", style: TextStyle(color: AppColors.black)),
            leading: Icon(Icons.shopping_cart, color: AppColors.pink),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage())),
          ),
          ListTile(
            title: Text("Our Flowers", style: TextStyle(color: AppColors.black)),
            leading: Icon(Icons.local_florist, color: AppColors.pink),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsPage())),
          ),
          ListTile(
            title: Text("Shop Catalogue", style: TextStyle(color: AppColors.black)),
            leading: Icon(Icons.apps, color: AppColors.pink),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CataloguePage())),
          ),
        ],
      ),
    ),
    );
  }
}