import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartProducts;

  const CartPage({Key? key, required this.cartProducts}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: widget.cartProducts.length,
        itemBuilder: (context, index) {
          final product = widget.cartProducts[index];
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
