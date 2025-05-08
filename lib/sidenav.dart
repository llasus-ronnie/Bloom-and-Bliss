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
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

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
            onTap: (widget.user.fullName.isNotEmpty ?? false)
                ? () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage(user: widget.user)),
              );
            }
                : null,
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
                    (widget.user.fullName.isNotEmpty ?? false) ? widget.user.fullName : "Guest User",
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
  bool _isLoggingOut = false;

  bool get isGuest => widget.user.fullName.isEmpty;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedOpacity(
          opacity: _isLoggingOut ? 0.5 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: IgnorePointer(
            ignoring: _isLoggingOut,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  ListTile(
                    title: const Text("Home", style: TextStyle(color: AppColors.black, fontFamily: 'PTSerif')),
                    leading: const Icon(Icons.home, color: AppColors.pink),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MyApp())),
                  ),
                  if (isGuest)
                    ListTile(
                      title: const Text("Sign In", style: TextStyle(color: AppColors.black, fontFamily: 'PTSerif')),
                      leading: const Icon(Icons.login, color: AppColors.pink),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInPage())),
                    ),
                  ListTile(
                    title: const Text("Our Flowers", style: TextStyle(color: AppColors.black, fontFamily: 'PTSerif')),
                    leading: const Icon(Icons.local_florist, color: AppColors.pink),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsPage(user: widget.user))),
                  ),
                  if (!isGuest)
                    ListTile(
                      title: const Text("Shop Catalogue", style: TextStyle(color: AppColors.black, fontFamily: 'PTSerif')),
                      leading: const Icon(Icons.apps, color: AppColors.pink),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CataloguePage(user: widget.user))),
                    ),
                  if (!isGuest)
                    ListTile(
                      title: const Text("Your Cart", style: TextStyle(color: AppColors.black, fontFamily: 'PTSerif')),
                      leading: const Icon(Icons.shopping_cart, color: AppColors.pink),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage(user: widget.user))),
                    ),
                  const Spacer(),
                  if (!isGuest)
                    ListTile(
                      title: const Text("Logout", style: TextStyle(color: AppColors.black, fontFamily: 'PTSerif')),
                      leading: const Icon(Icons.logout, color: AppColors.pink),
                      onTap: () async {
                        setState(() {
                          _isLoggingOut = true;
                        });

                        await firebase_auth.FirebaseAuth.instance.signOut();

                        if (mounted) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const MyApp()),
                          );
                        }
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
        if (_isLoggingOut)
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: AppColors.pink),
                SizedBox(height: 10),
                Text(
                  'Logging out, please wait...',
                  style: TextStyle(fontFamily: 'PTSerif', color: AppColors.black),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
