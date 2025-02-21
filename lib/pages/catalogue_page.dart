import 'package:flutter/material.dart';
import 'package:bloom_and_bliss/sidenav.dart';
import 'package:bloom_and_bliss/main.dart';
import 'dart:ui';
import 'package:bloom_and_bliss/constants/colors.dart';


void main() {
  runApp(const CataloguePage());
}

class CataloguePage extends StatelessWidget {
  const CataloguePage ({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const String apptitle = "Bloom & Bliss - Catalogue";
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
                child: Image.asset("assets/bnb-logo.png", height: 70),
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
          color: AppColors.beige,
          child: Column(
              children: [
                SizedBox(height: 20),
                CarouselView(),
                SizedBox(height: 20),
                ButtonRowFilter(),
                SizedBox(height: 20),
                FlowerGrid(),
                ButtonFieldSection()
              ]
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
    return Padding(padding: EdgeInsets.only(top: 70),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Catalogue Page",
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

class FlowerGrid extends StatelessWidget {
  FlowerGrid({super.key});

  final List<Map<String, dynamic>> flowers = [
    {
      "image": "https://www.redflowersngifts.com/cdn/shop/products/roses-bouquet-3-675845.jpg?v=1638706779",
      "title": "Rose Bouquet",
      "rating": 4.5,
      "price": "PHP550.00"
    },
    {
      "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSw7eCN14BX6Te1LHvLKdSLTsLSdJoWgDMdQ&s",
      "title": "Tulip Mix",
      "rating": 4.2,
      "price": "PHP480.00"
    },
    {
      "image": "https://assets.florista.ph/uploads/product-pics/5005_88_5005.webp",
      "title": "Sunflower Set",
      "rating": 4.8,
      "price": "PHP450.00"
    },
    {
      "image": "https://www.fnp.com/images/pr/philippines/l/v20220111163039/white-oriental-lilies-bouquet_1.jpg",
      "title": "Lily Collection",
      "rating": 4.3,
      "price": "PHP390.00"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: flowers.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7, // Adjusted to keep proportions right
        ),
        itemBuilder: (context, index) {
          final flower = flowers[index];

          return Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: SizedBox(
                    width: double.infinity,
                    height: 80,
                    child: Image.network(
                      flower["image"],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                /// Content Section (Fixed Layout)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    /// Title (Fixed Position)
                    Text(
                    flower["title"],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Recoleta'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 5),

                  /// Rating Row (Fixed Position)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 5),
                      Text("${flower["rating"]}", style: TextStyle(fontSize: 14, fontFamily: 'PTSerif')),
                    ],
                  ),

                  SizedBox(height: 5),

                  /// Price (Fixed Position)
                  Text(
                    flower["price"],
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.green, fontFamily: 'Recoleta'),
                  ),

                  SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.pink,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 8), // Fixed closing parenthesis
                          ),
                          child: Text("Add to Cart", style: TextStyle(fontSize: 12, fontFamily: 'Recoleta')),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ButtonRowFilter extends StatelessWidget {
  const ButtonRowFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50, // Increase height as needed
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton("Your Favorites"),
            SizedBox(width: 10),
            _buildButton("New Arrivals"),
            SizedBox(width: 10),
            _buildButton("Best Sellers"),
            SizedBox(width: 10),
            _buildButton("Trending"),
            SizedBox(width: 10),
            _buildButton("Limited Edition"),
          ],
        ),
      ),
    );

  }

  Widget _buildButton(String text) {
    return SizedBox(
      height: 40,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.yellow,
            foregroundColor: AppColors.black,
            padding: EdgeInsets.symmetric(horizontal: 20),
            textStyle: TextStyle(fontSize: 16, fontFamily: 'Recoleta'),
            elevation: 2,
          ),
          child: Text(text),
        ),
      ),
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

class CarouselView extends StatefulWidget {
  const CarouselView({super.key});

  @override
  _CarouselViewState createState() => _CarouselViewState();
}

class _CarouselViewState extends State<CarouselView> {
  final PageController _pageController = PageController(viewportFraction: 0.8);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: PageView.builder(
        controller: _pageController,
        itemCount: ImageInfo.values.length,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double scale = 1.0;
              if (_pageController.position.haveDimensions) {
                double page = _pageController.page ?? 0;
                scale = (1 - (page - index).abs() * 0.2).clamp(0.8, 1.0);
              }
              return Transform.scale(
                scale: scale,
                child: HeroLayoutCard(imageInfo: ImageInfo.values[index]),
              );
            },
          );
        },
      ),
    );
  }
}

enum ImageInfo {
  image0('Valentines', 'Pink and white are the season colors', 'https://images.pexels.com/photos/4499854/pexels-photo-4499854.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'),
  image1('Spring Sale', 'Spring Season is coming, Bulk orders are being accepted!', 'https://images.pexels.com/photos/27871590/pexels-photo-27871590/free-photo-of-a-person-holding-a-bouquet-of-pink-tulips.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'),
  image2('Custom Bouquets', 'Made for you, by you.', 'https://images.pexels.com/photos/4270151/pexels-photo-4270151.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load'),
  image3('Floral Photo-shoots', 'Because you are as pretty as our flowers', 'https://images.pexels.com/photos/15762173/pexels-photo-15762173/free-photo-of-a-woman-sitting-on-a-couch-holding-a-bouquet-of-flowers.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'),
  image4('Dried Flowers','Gorgeous even withered', 'https://images.pexels.com/photos/4273434/pexels-photo-4273434.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2');

  const ImageInfo(this.title, this.subtitle, this.url);
  final String title;
  final String subtitle;
  final String url;
}

class HeroLayoutCard extends StatelessWidget {
  const HeroLayoutCard({super.key, required this.imageInfo});

  final ImageInfo imageInfo;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            imageInfo.url,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.1), // 0.3 opacity
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      imageInfo.title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Recoleta'
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      imageInfo.subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontFamily: 'PTSerif'
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}