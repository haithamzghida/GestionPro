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
      final response = await http.get(Uri.parse('http://localhost:3000/panier/${widget.customerId}'));
      print('Cart response: ${response.body}');
      final cartData = json.decode(response.body) as Map<String, dynamic>;
      final cartProductsData = cartData['panier'] as List<dynamic>;

      final cartProductIds = cartProductsData.map((item) => item['id']).toList(); // Update this line

      final productsResponse = await http.get(
          Uri.parse('http://localhost:3000/products?ids=${cartProductIds.join(',')}'));
      print('Products response: ${productsResponse.body}');
      final productsData = json.decode(productsResponse.body)['products'] as List<dynamic>;

      final cartProducts = cartProductsData.map((item) {
        final product = productsData.firstWhere(
              (product) => product['id'] == item['id'], // Update this line
          orElse: () => null,
        );
        if (product != null) {
          return {
            'id': product['id'],
            'name': product['name'],
            'image_url': product['image_url'],
            'price': product['price'],
            'quantity': item['quantity'],
          };
        }
        return null;
      }).where((product) => product != null).toList();

      setState(() {
        _cartProducts = cartProducts.whereType<Map<String, dynamic>>().toList();
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


  void _updateQuantity(int cartItemId, int newQuantity) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:3000/panier/$cartItemId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'quantity': newQuantity}),
      );
      print('Update quantity response: ${response.body}');

      if (response.statusCode == 200) {
        _fetchCartProducts();
      } else {
        throw Exception('Failed to update quantity');
      }
    } catch (error) {
      print('Error updating quantity: $error');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to update quantity.'),
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


  void _deleteCartItem(int index) async {
    final product = _cartProducts[index];
    final cartItemId = product['id'];

    try {
      final response = await http.delete(Uri.parse('http://localhost:3000/panier/$cartItemId'));
      print('Delete item response: ${response.body}');
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (responseData.containsKey('success') && responseData['success']) {
        setState(() {
          _cartProducts.removeAt(index);
        });
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to delete item. Please try again.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
        );
      }
    } catch (error) {
      print('Error deleting item: $error');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred while deleting item.'),
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
            subtitle: Text('Price: \$${product['price'].toString()}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    if (product['quantity'] > 1) {
                      _updateQuantity(index, product['quantity'] - 1);
                    }
                  },
                ),
                Text(product['quantity'].toString()),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _updateQuantity(index, product['quantity'] + 1);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Confirm Deletion'),
                        content: Text('Are you sure you want to delete this item from your cart?'),
                        actions: [
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          TextButton(
                            child: Text('Delete'),
                            onPressed: () {
                              _deleteCartItem(index);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
