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
    const String apptitle = "Bloom & Bliss - Flowers";
    return MaterialApp(
      title: apptitle,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBar(
            backgroundColor: AppColors.beige,
            centerTitle: true,
            flexibleSpace: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 10, bottom: 5),
                child: Image.asset("assets/sidenav/bnb-logo.png", height: 70),
              ),
            ),
            iconTheme: IconThemeData(
                color: AppColors.pink
            ),
          ),
        ),
        drawer: Sidenav(),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  color: AppColors.beige,
                  child: Column(
                    children: [
                      TextTitleSection(),
                      BodySection(),
                      ButtonFieldSection()
                    ],
                  )
                )
              ],
            ),
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
      padding: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Our Flowers",
            style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'Recoleta',
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Discover a variety of fresh and beautiful flowers for every occasion.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontFamily: 'PTSerif',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BodySection extends StatefulWidget {
  const BodySection({super.key});

  @override
  _BodySectionState createState() => _BodySectionState();
}

class _BodySectionState extends State<BodySection> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int currentIndex = 0;

  final List<Map<String, String>> flowers = [
    {
      "image": "assets/details/sample-flower.jpg",
      "name": "Beautiful Red Rose",
      "description": "This vibrant red rose symbolizes love and passion.",
      "price": "PHP550.00",
      "availability": "In Stock"
    },
    {
      "image": "assets/details/sample-flower2.jpg",
      "name": "Elegant White Lily",
      "description": "A graceful white lily that represents purity.",
      "price": "PHP670.00",
      "availability": "In Stock"
    },
    {
      "image": "assets/details/sample-flower3.jpg",
      "name": "Charming Sunflower",
      "description": "Bright sunflowers to bring joy to any space!",
      "price": "PHP450.00",
      "availability": "Limited Stock"
    }
  ];

  void _nextFlower() {
    if (currentIndex < flowers.length - 1) {
      setState(() {
        currentIndex++;
      });
      _pageController.animateToPage(currentIndex, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _previousFlower() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
      _pageController.animateToPage(currentIndex, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 450,
          child: PageView.builder(
            controller: _pageController,
            itemCount: flowers.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final flower = flowers[index];
              return Padding(
                padding: EdgeInsets.only(top: 40),
                child: SizedBox(
                  height: 250,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 250,
                        height: 240,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.yellow, width: 10),
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: AssetImage(flower["image"]!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        flower["name"]!,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Recoleta',
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          flower["description"]!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            fontFamily: 'PTSerif',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Price: ${flower["price"]!}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.green,
                          fontFamily: 'Recoleta',
                        ),
                      ),
                      Text(
                        "Availability: ${flower["availability"]!}",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.black,
                          fontFamily: 'PTSerif',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _previousFlower,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.pink),
              child: Text("Previous", style: TextStyle(fontFamily: 'Recoleta', color: Colors.white)),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: _nextFlower,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.pink),
              child: Text("Next", style: TextStyle(fontFamily: 'Recoleta', color: Colors.white)),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

class ButtonFieldSection extends StatelessWidget {
  const ButtonFieldSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 140,
            height: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.yellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              ),
              child: Text(
                "Back",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontFamily: 'Recoleta',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
