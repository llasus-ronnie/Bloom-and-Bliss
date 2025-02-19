import 'package:flutter/material.dart';
import 'package:bloom_and_bliss/sidenav.dart';
import 'constants/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String apptitle = "Flower Shop";
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: apptitle,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: AppBar(
            backgroundColor: AppColors.beige,
            centerTitle: true,
            flexibleSpace: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Image.asset("assets/bnb-logo.png", height: 70),
              ),
            ),
            iconTheme: const IconThemeData(color: AppColors.pink),
          ),
        ),
        drawer: Sidenav(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: ImageCarousel(),
              ),
              Container(
                alignment: Alignment.center,
                color: AppColors.pink,
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextTitleSection(),
                    BodySection(),
                  ],
                ),
              ),
            ],
          ),
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
    "assets/image1.jpg",
    "assets/image2.jpg",
    "assets/image3.jpg",
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
        Positioned(
          top: 100,
          left: 0,
          right: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Text(
                  "Bloom & Bliss",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(1.0, 1.0),
                        blurRadius: 3.0,
                        color: Color.fromARGB(64, 0, 0, 0),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                "Happiness Blossoms Here",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(1.0, 1.0),
                      blurRadius: 3.0,
                      color: Color.fromARGB(64, 0, 0, 0),
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
                    color: currentIndex == index ? AppColors.pink : Colors.grey,
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
                  color: AppColors.black,
                  fontFamily: 'PTSerif'
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