import 'package:bloom_and_bliss/models/user.dart';
import 'package:flutter/material.dart';
import 'package:bloom_and_bliss/sidenav.dart';
import 'constants/colors.dart';
import 'package:bloom_and_bliss/pages/cart_page.dart';
import 'package:bloom_and_bliss/pages/details_page.dart';
import 'package:bloom_and_bliss/pages/catalogue_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String apptitle = "Bloom & Bliss";

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: apptitle,
      home: Scaffold(
        body: StreamBuilder<firebase_auth.User?>(
          stream: firebase_auth.FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong!'));
            }

            if (snapshot.hasData) {
              // Logged-in user: fetch Firestore data
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(snapshot.data!.uid)
                    .get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (userSnapshot.hasError) {
                    return Center(child: Text('Something went wrong!'));
                  }

                  if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                    return Center(child: Text('User data not found.'));
                  }

                  var userData = userSnapshot.data!.data() as Map<String, dynamic>;
                  User user = User(
                    fullName: userData['fullName'] ?? '',
                    email: userData['email'] ?? '',
                    password: '',
                    phoneNumber: userData['phoneNumber'] ?? 0,
                  );

                  return MyHomePage(user: user);
                },
              );
            } else {
              // Guest user (not logged in)
              User guestUser = User(
                fullName: '',
                email: '',
                password: '',
                phoneNumber: 0,
              );
              return MyHomePage(user: guestUser);
            }
          },
        ),
      ),
    );
  }
}


class MyHomePage extends StatelessWidget {
  final User user;
  const MyHomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    const String apptitle = "Bloom & Bliss";

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: AppColors.beige,
          centerTitle: true,
          flexibleSpace: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 5),
              child: Image.asset("assets/sidenav/bnb-logo.png", height: 70),
            ),
          ),
          iconTheme: const IconThemeData(color: AppColors.pink),
        ),
      ),
      drawer: Sidenav(user: user),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: ImageCarousel(),
            ),
            Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: AppColors.yellow,
                    child: ButtonRow(user: user),
                  ),
                  Container(
                    color: AppColors.pink,
                    child: Column(
                      children: [
                        TextTitleSection(),
                        BodySection(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageCarousel extends StatefulWidget {
  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final PageController _pageController = PageController();
  final List<String> images = [
    "assets/homepage/image2.jpg",
    "assets/homepage/image1.jpg",
    "assets/homepage/image3.jpg",
  ];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: images.length,
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return Image.asset(
              images[index],
              fit: BoxFit.cover,
              width: double.infinity,
            );
          },
        ),

        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Text(
                  "Bloom & Bliss",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Recoleta',
                    color: Colors.white,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(1.0, 1.0),
                        blurRadius: 3.0,
                        color: Color.fromARGB(200, 0, 0, 0),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                "Happiness in Every Petal",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'PTSerif',
                  color: Colors.white,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(1.0, 1.0),
                      blurRadius: 3.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        Positioned(
          bottom: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(images.length, (index) {
              return GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    index,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                  setState(() {
                    currentIndex = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(4.0),
                  width: 10.0,
                  height: 10.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentIndex == index ? AppColors.pink : Colors.white,
                  ),
                ),
              );
            }),
          ),
        )
      ],
    );
  }}

class TextTitleSection extends StatelessWidget {
  const TextTitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(top: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
              Text("About Bloom & Bliss",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.beige,
                  fontFamily: 'Recoleta'
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
      padding: EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "At Bloom & Bliss, we believe that every bloom tells a story and every petal carries a feeling. Our flower shop is more than just a place to buy flowers—it’s a celebration of life’s most cherished moments. From vibrant bouquets that brighten your day to elegant arrangements that speak the words your heart cannot, we craft each creation with love, care, and an eye for beauty. \n\n  Whether you’re expressing love, gratitude, or sympathy, our carefully curated floral designs bring warmth and joy to every occasion. With fresh, high-quality flowers and a passion for artistry, Bloom & Bliss is here to make every moment blossom with meaning. Happiness truly blossoms here.",
            textAlign: TextAlign.justify,
            style: TextStyle(
                fontSize: 18,
                color: AppColors.black,
                fontFamily: 'PTSerif'
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonRow extends StatelessWidget {
  final User user;
  const ButtonRow({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: _buildButton(context, Icons.storefront, "Shop Now",  CataloguePage(user: user,))),
          const SizedBox(width: 20),
          Expanded(child: _buildButton(context, Icons.local_florist, "Our Flowers",  DetailsPage(user: user,))),
          const SizedBox(width: 20),
          Expanded(child: _buildButton(context, Icons.shopping_cart, "Your Cart",  CartPage(user: user,))),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, IconData icon, String label, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        height: 150,
        width: 110,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.beige,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: AppColors.pink),
            const SizedBox(height: 5),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.pink,
                fontSize: 14,
                fontFamily: 'Recoleta',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
