import 'package:flutter/material.dart';
import 'package:bloom_and_bliss/main.dart';
import 'package:bloom_and_bliss/pages/signin_page.dart';
import 'package:bloom_and_bliss/pages/signup_page.dart';
import 'package:bloom_and_bliss/pages/cart_page.dart';
import 'package:bloom_and_bliss/pages/details_page.dart';
import 'package:bloom_and_bliss/pages/catalogue_page.dart';
import 'package:bloom_and_bliss/pages/profile_page.dart';
import 'package:bloom_and_bliss/constants/colors.dart';
import './models/user.dart';

void main() {
  runApp(Sidenav(user: User(fullName: '', email: '', password: '', phoneNumber: 0)));
}

class Sidenav extends StatelessWidget {
  final User user;
  const Sidenav({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.beige,
      child: Column(
        children: [
          DrwHeader(user: user),
          Expanded(child: DrwListView(user: user)),
        ],
      ),
    );
  }
}

class DrwHeader extends StatefulWidget {
  final User user;
  const DrwHeader({super.key, required this.user});

  @override
  _DrwHeaderState createState() => _DrwHeaderState();
}

class _DrwHeaderState extends State<DrwHeader> {
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
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage(user: widget.user)),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/sidenav/guest-icon.png'),
                    radius: 40,
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${(widget.user.fullName?.isNotEmpty ?? false) ? widget.user.fullName : "Guest User"}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PTSerif',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DrwListView extends StatefulWidget {
  final User user;
  const DrwListView({super.key, required this.user});

  @override
  _DrwListViewState createState() => _DrwListViewState();
}

class _DrwListViewState extends State<DrwListView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        child: Column(
          children: [
            ListTile(
              title: Text("Home", style: TextStyle(color: AppColors.black, fontFamily: 'PTSerif')),
              leading: Icon(Icons.home, color: AppColors.pink),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp(user: widget.user,))),
            ),
            ListTile(
              title: Text("Sign In", style: TextStyle(color: AppColors.black, fontFamily: 'PTSerif')),
              leading: Icon(Icons.login, color: AppColors.pink),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInPage())),
            ),
            ListTile(
              title: Text("Sign Up", style: TextStyle(color: AppColors.black, fontFamily: 'PTSerif')),
              leading: Icon(Icons.person, color: AppColors.pink),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage(user: widget.user))),
            ),
            ListTile(
              title: Text("Your Cart", style: TextStyle(color: AppColors.black, fontFamily: 'PTSerif')),
              leading: Icon(Icons.shopping_cart, color: AppColors.pink),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage(user: widget.user)),
              ),
            ),
            ListTile(
              title: Text("Our Flowers", style: TextStyle(color: AppColors.black, fontFamily: 'PTSerif')),
              leading: Icon(Icons.local_florist, color: AppColors.pink),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsPage(user: widget.user,))),
            ),
            ListTile(
              title: Text("Shop Catalogue", style: TextStyle(color: AppColors.black, fontFamily: 'PTSerif')),
              leading: Icon(Icons.apps, color: AppColors.pink),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CataloguePage(user: widget.user)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}