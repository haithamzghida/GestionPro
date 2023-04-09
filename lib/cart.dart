import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartPage extends StatefulWidget {
  final int? customerId;

  CartPage({required this.customerId});
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> _cartProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchCartProducts();
  }

  void _fetchCartProducts() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/cart?customer_id=${widget.customerId}'));
      print('Cart response: ${response.body}');
      final cartData = json.decode(response.body);
      final cartProductIds = cartData['items'].map((item) => item['product_id']).toList();
      final productsResponse = await http.get(Uri.parse('http://localhost:3000/products?ids=${cartProductIds.join(',')}'));
      print('Products response: ${productsResponse.body}');
      final productsData = json.decode(productsResponse.body);
      final cartProducts = cartData['items'].map((item) {
        final product = productsData.firstWhere((product) => product['id'] == item['product_id']);
        return {
          'id': product['id'],
          'name': product['name'],
          'image_url': product['image_url'],
          'price': product['price'],
          'quantity': item['quantity'],
        };
      }).toList();

      setState(() {
        _cartProducts = cartProducts;
      });
    } catch (error) {
      print('Error fetching cart products: $error');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred while fetching cart products.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    if (_cartProducts.isEmpty) {
      return Center(
        child: Text('Your cart is empty'),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: _cartProducts.length,
        itemBuilder: (context, index) {
          final product = _cartProducts[index];
          return ListTile(
            leading: Image.network(product['image_url']),
            title: Text(product['name']),
            subtitle: Text('\$${product['price'].toString()}'),
          );
        },
      ),
    );
  }

}
