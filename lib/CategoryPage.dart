import 'package:flutter/material.dart';
import 'ProductCatalog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


Future<List<dynamic>> fetchCategoryProducts(int categoryId) async {
  final response = await http.get(Uri.parse('http://192.168.1.17:3000/products/category/$categoryId'));
  final data = json.decode(response.body);
  return data['products'];
}


class CategoryPage extends StatelessWidget {
  final int categoryId;

  const CategoryPage({Key? key, required this.categoryId, required String category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Category $categoryId')),
      body: FutureBuilder<List<dynamic>>(
        future: fetchCategoryProducts(categoryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<dynamic> products = snapshot.data!;
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 7.0,
                  crossAxisSpacing: 7.0,
                  childAspectRatio: 1.0,
                ),
                itemCount: products.length,
                itemBuilder: (BuildContext context, int index) {
                  final product = products[index];
                  return Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 3,
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
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  product['description'],
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  '\$${product['price'].toString()}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    cartProducts.add(product);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("${product['name']} added to cart"),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Add to cart',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );

                },
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

List<Map<String, dynamic>> cartProducts = [];

