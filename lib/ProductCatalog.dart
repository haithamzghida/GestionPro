import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'CategoryPage.dart';
import 'main.dart';

class ProductCatalog extends StatefulWidget {
  const ProductCatalog({Key? key}) : super(key: key);

  @override
  _ProductCatalogState createState() => _ProductCatalogState();
}

class _ProductCatalogState extends State<ProductCatalog> {
  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('http://localhost:3000/products'));
    final data = json.decode(response.body);
    setState(() {
      products = data['products'];
    });
  }

  @override
  Widget build(BuildContext context) {
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    var screenWidth = MediaQuery.of(context).size.width;
    var crossAxisCount = screenWidth < 600 ? 2 : 3; // Adjust the breakpoint as needed

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider.builder(
            itemCount: 3,
            itemBuilder: (BuildContext context, int index, int realIndex) {
              List<String> images = [
                'assets/HR.png',
                'assets/vape.png',
                'assets/vector.jpg',
              ];
              final image = images[index];
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ],
              );
            },
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 1.4,
              viewportFraction: 0.6,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
            child: Text(
              'Shop by category',
              style: TextStyle(
                fontSize: 35 * textScaleFactor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GridView.count(
            crossAxisCount: 5,
            childAspectRatio: 1.0,
            padding: const EdgeInsets.all(4.0),
            mainAxisSpacing: 7.0,
            crossAxisSpacing: 7.0,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              CategoryTile(
                imageUrl: 'assets/coffee.png',
                title: 'Café',
                id: 1,
              ),
              CategoryTile(
                imageUrl: 'assets/Cookies.png',
                title: 'Chocolat Chaud',
                id: 2,
              ),
              CategoryTile(
                imageUrl: 'assets/Chocolat glacée.png',
                title: 'Chocolat glacée',
                id: 3,
              ),
              CategoryTile(
                imageUrl: 'assets/ice.png',
                title: 'Ice coffee',
                id: 4,
              ),
              CategoryTile(
                imageUrl: 'assets/Tiramisu.png',
                title: 'Tiramisu',
                id: 5,
              ),
              CategoryTile(
                imageUrl: 'assets/the.png',
                title: 'Thé',
                id: 6,
              ),
              CategoryTile(
                imageUrl: 'assets/jus.png',
                title: 'Jus',
                id: 7,
              ),
              CategoryTile(
                imageUrl: 'assets/mojito.png',
                title: 'mojito',
                id: 8,
              ),
              CategoryTile(
                imageUrl: 'cocafanta.png',
                title: 'Soda',
                id: 9,
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
            child: Text(
              'Our products',
              style: TextStyle(
                fontSize: 35 * textScaleFactor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              childAspectRatio: 0.7,
            ),
            itemCount: products.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final product = products[index];
              return Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Image.network(product['image_url']),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              product['name'],
                              style: TextStyle(
                                fontSize: 15 * textScaleFactor,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              '\$${product['price'].toString()}',
                              style: TextStyle(
                                fontSize: 13 * textScaleFactor,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String imageUrl;
  final String title;
  final int id;

  const CategoryTile({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryPage(
              categoryId: id,
              customerId: 0,
              category: '',
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              imageUrl,
              width: 90,
              height: 90,
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16 * textScaleFactor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
