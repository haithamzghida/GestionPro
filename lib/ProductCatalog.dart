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
    final response =
    await http.get(Uri.parse('http://localhost:3000/products'));
    final data = json.decode(response.body);
    setState(() {
      products = data['products'];
    });
  }
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    var isLandscape = screenSize.width > screenSize.height;
    var isTablet = screenSize.shortestSide >= 600;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      Center(
      child: Container(
      constraints: BoxConstraints(maxWidth: 1200),
      child: CarouselSlider.builder(
        itemCount: 4,
        itemBuilder: (BuildContext context, int index, int realIndex) {
          List<String> images = [
            'https://img.freepik.com/photos-premium/cafe-internet-modele-promotion-medias-sociaux-publicite-banniere-publicitaire-marketing-produit-eps-10_182292-232.jpg?w=1060',
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
          viewportFraction: 0.6, // change the viewportFraction value to make the images smaller
        ),
      ),
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
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: GridView.count(
              crossAxisCount: isTablet ? 4 : 3,
              childAspectRatio: 1.0,
              padding: const EdgeInsets.all(4.0),
              mainAxisSpacing: 7.0,
              crossAxisSpacing: 7.0,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                CategoryTile(
                  icon: Icons.local_cafe,
                  title: 'Café',
                  id: 1,
                ),
                CategoryTile(
                  icon: Icons.local_drink,
                  title: 'Thé',
                  id: 2,
                ),
                CategoryTile(
                  icon: Icons.local_bar,
                  title: 'Mojito',
                  id: 3,
                ),
                CategoryTile(
                  icon: Icons.cake,
                  title: 'Cheesecake',
                  id: 4,
                ),
                CategoryTile(
                  icon: Icons.icecream,
                  title: 'Tiramisu',
                  id: 5,
                ),
                CategoryTile(
                  icon: Icons.local_drink,
                  title: 'Jus',
                  id: 6,
                ),
                CategoryTile(
                  icon: Icons.local_bar,
                  title: 'Frappe',
                  id: 7,
                ),
                CategoryTile(
                  icon: Icons.smoking_rooms,
                  title: 'Vape',
                  id: 8,
                ),
                CategoryTile(
                  icon: Icons.liquor,
                  title: 'Liquide',
                  id: 9,
                ),
              ],
            ),
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
              crossAxisCount: isTablet ? 4 : 3,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              childAspectRatio: 0.5,
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
  final IconData icon;
  final String title;
  final int id;
  const CategoryTile({
    Key? key,
    required this.icon,
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
            Icon(icon, size: 50),
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