import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: MenuTablet(),
  ));
}

class MenuTablet extends StatefulWidget {
  @override
  _MenuTabletState createState() => _MenuTabletState();
}

class _MenuTabletState extends State<MenuTablet> {
  List<Product> _products = [];
  bool _callServerButtonVisible = true;
  bool _isCallingServer = false;
  Map<String, Product> _selectedProductsMap = {};
  Set<int> _selectedProductIndices = {};
  Map<int, String> _productNotes = {};
  List<Product> _allSelectedProducts = [];
  List<Map<String, dynamic>> _categories = []; // Added _categories list

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<String> fetchDisponibiliteStatus(int productId) async {
    final response = await http.get(Uri.parse('http://localhost:3000/products/disponibilite/$productId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final String disponibilite = data['disponibilite'];

      return disponibilite;
    } else {
      print('Error fetching disponibilite: ${response.statusCode}');
      return ''; // Handle the error case here
    }
  }


  Future<void> fetchCategories() async {
    final response = await http.get(Uri.parse('http://localhost:3000/categories'));

    if (response.statusCode == 200) {
      List<dynamic> categories = json.decode(response.body)['categories'];
      setState(() {
        _categories = categories.map<Map<String, dynamic>>((category) {
          return {
            'name': category['name'],
            'id': category['id'],
          };
        }).toList();
      });

      if (_categories.isNotEmpty) {
        fetchProductsByCategory(_categories[0]['id']); // Automatically fetch products for the first category
      }
    } else {
      print('Error fetching categories: ${response.statusCode}');
    }
  }


  Future<void> fetchProductsByCategory(int categoryId) async {
    final response = await http.get(Uri.parse('http://localhost:3000/products/category/$categoryId'));

    if (response.statusCode == 200) {
      final List<dynamic> productsJson = json.decode(response.body)['products'];
      List<Product> products = productsJson.map((productJson) {
        return Product(
          name: productJson['name'] ?? '',
          price: productJson['price'] != null ? productJson['price'].toString() : '',
          imageUrl: productJson['image_url'] ?? '',
          description: productJson['description'] ?? '',
          disponibilite: productJson['disponibilite'] ?? '', // Fetch disponibilite status
        );
      }).toList();

      setState(() {
        _products = products;
      });
    } else {
      print('Error fetching products: ${response.statusCode}');
    }

    for (var product in _products) {
      if (_selectedProductsMap.containsKey(product.name)) {
        product.selected = true;
      } else {
        product.selected = false;
      }
    }
  }


  Widget _buildCategoryButton(Map<String, dynamic> category) {
    final categoryName = category['name'];
    final categoryId = category['id'];

    return Container(
      width: double.infinity, // Set a fixed width for all buttons
      child: ElevatedButton(
        onPressed: () {
          fetchProductsByCategory(categoryId);
        },
        child: Text(
          categoryName,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
          padding: MaterialStateProperty.all<EdgeInsets>(
            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: Colors.grey[300]!,
                width: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildProductItem(Product product, int index) {
    final isSelected = _selectedProductIndices.contains(index);

    // Determine the text color based on disponibilite status
    final textColor = product.disponibilite == 'Disponible' ? Colors.green : Colors.red;

    return GestureDetector(
      onTap: () {
        setState(() {
          product.selected = !product.selected;

          if (product.selected) {
            _selectedProductsMap[product.name] = product;
            _allSelectedProducts.add(product);
          } else {
            _selectedProductsMap.remove(product.name);
            _allSelectedProducts.removeWhere((selectedProduct) => selectedProduct.name == product.name);
          }

          // Reset the quantity to 1 for deselected products
          if (!product.selected) {
            product.quantity = 1;
          }
        });
      },


      onLongPress: () {
        _showLargeImageDialog(product);
      },
      child: Container(
        height: 350,
        child: Card(
          color: product.selected ? Colors.grey.withOpacity(0.7) : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.network(
                    product.imageUrl,
                    fit: BoxFit.contain,
                    height: 100,
                  ),
                  if (product.selected)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 30,
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  product.name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor), // Set text color
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Price: ${product.price}',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  product.description,
                  style: TextStyle(fontSize: 14),
                ),
              ),
              if (product.selected)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Quantity: ${product.quantity}'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            product.quantity++;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (product.quantity > 1) {
                              product.quantity--;
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.note),
                        onPressed: () {
                          _showAddNoteDialog(product, index);
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddNoteDialog(Product product, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    product.note = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Enter your note...',
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _productNotes[index] = product.note; // Update the notes map
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Save Note'),
              ),
            ],
          ),
        );
      },
    );
  }



  void _showLargeImageDialog(Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }


// Function to toggle the visibility of the "Call the Server" button
  void toggleCallServerButton() {
    setState(() {
      _callServerButtonVisible = !_callServerButtonVisible;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[350],

      body: Row(
        children: [

          SingleChildScrollView(
            child: Container(
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/logo.png', // Replace with the actual path to your logo image

                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Menu :',
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                  SizedBox(height: 8),

                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ElevatedButton.icon(
                      onPressed: _resetSelections,
                      icon: Icon(Icons.refresh),
                      label: Text(''),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showWifiQRCodeDialog('123456789M');
                      },
                      icon: Icon(Icons.wifi),
                      label: Text('Show WiFi QR Code'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),



                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        _callServer();
                      },
                      child: Text('Call the Server'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        _showSmileyRatingDialog();
                      },
                      child: Text('Rate the Service'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Column(
                    children: [
                      for (Map<String, dynamic> category in _categories) // Iterate through _categories as maps
                        _buildCategoryButton(category), // Pass the category map to the function
                    ],
                  ),

                ],
              ),
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Products:',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: MediaQuery.of(context).size.width > 1200 ? 4 : 2,
                        ),
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          return _buildProductItem(_products[index], index);
                        },
                      )

                  ),
                ),
                Container(
                  color: Colors.grey[350],
                  padding: EdgeInsets.all(16),
                  child: SelectedProductsSummary(
                    selectedProducts: _allSelectedProducts,
                    allSelectedProducts: _allSelectedProducts, // Pass the same list
                    context: context,
                  ),
                ),



              ],
            ),
          ),
        ],
      ),
    );
  }




  void _resetSelections() {
    setState(() {
      _selectedProductsMap.clear();
      _selectedProductIndices.forEach((index) {
        _products[index].quantity = 1; // Reset quantity to 1
      });
      _selectedProductIndices.clear();
      _productNotes.clear();
      _allSelectedProducts.clear(); // Clear the global selected products list
      for (var product in _products) {
        product.selected = _selectedProductsMap.containsKey(product.name);
      }
    });
  }



  void _showWifiQRCodeDialog(String qrCodeData) {
    final double qrCodeSize = 200.0;

    // Create a widget that paints the QR code-like image
    Widget qrCodeWidget = CustomPaint(
      size: Size(qrCodeSize, qrCodeSize),
      painter: QrCodePainter(qrCodeSize, qrCodeData),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('WiFi QR Code'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('WiFi Password: $qrCodeData'),
              SizedBox(height: 16),
              Center(child: qrCodeWidget),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }





  void _showSmileyRatingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SmileyRatingDialog(
          onRatingSelected: (rating) {
            Navigator.of(context).pop();
            _showRatingThankYouMessage();
          },
        );
      },
    );
  }

  void _showRatingThankYouMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thank You for Rating'),
          content: Text('We appreciate your feedback.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Function to simulate calling the server
  void _callServer() {
    setState(() {
      _isCallingServer = true;
    });

    // Show the dialog with a timer to close it after 5 seconds
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Use a Timer to close the dialog after 5 seconds
        Timer(Duration(seconds: 5), () {
          setState(() {
            _isCallingServer = false;
          });
          Navigator.pop(context); // Close the dialog
        });

        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(), // Display a loading indicator
              SizedBox(height: 16),
              Text('Calling the server...'),
            ],
          ),
        );
      },
    );
  }



}

double calculateTotalSum(List<Product> products) {
  double totalSum = 0;
  for (var product in products) {
    totalSum += double.parse(product.price) * product.quantity;
  }
  return totalSum;
}

class QrCodePainter extends CustomPainter {
  final double qrCodeSize;
  final String qrCodeData;

  QrCodePainter(this.qrCodeSize, this.qrCodeData);

  @override
  void paint(Canvas canvas, Size size) {
    // Replace this with your QR code generation logic
    // You can draw any shape or text on the canvas
    final Paint blackPaint = Paint()..color = Colors.black;
    final Paint whitePaint = Paint()..color = Colors.white;

    canvas.drawRect(Rect.fromLTWH(0, 0, qrCodeSize, qrCodeSize), whitePaint);
    canvas.drawRect(Rect.fromLTWH(10, 10, qrCodeSize - 20, qrCodeSize - 20), blackPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}


class SelectedProductsSummary extends StatelessWidget {
  final List<Product> selectedProducts;
  final List<Product> allSelectedProducts;
  final BuildContext context;

  SelectedProductsSummary({
    required this.selectedProducts,
    required this.allSelectedProducts,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    double totalSum = calculateTotalSum(selectedProducts);

    return Container(
      color: Colors.grey[200],
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected Products:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: selectedProducts
                .map(
                  (product) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${product.name} x${product.quantity}'),
                  if (product.note.isNotEmpty)
                    Text(
                      'Note: ${product.note}',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  SizedBox(height: 8),

                ],
              ),
            )
                .toList(),
          ),
          SizedBox(height: 8),
          Text(
            'Total Sum: ${totalSum.toStringAsFixed(2)} DT',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showAddNoteDialog(Product product, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  product.note = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your note...',
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Save Note'),
              ),
            ],
          ),
        );
      },
    );
  }
}




class SmileyRatingDialog extends StatelessWidget {
  final Function(int) onRatingSelected;

  SmileyRatingDialog({required this.onRatingSelected});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Rate the Service'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  onRatingSelected(1);
                },
                child: Icon(
                  Icons.sentiment_very_dissatisfied,
                  color: Colors.red,
                  size: 50,
                ),
              ),
              GestureDetector(
                onTap: () {
                  onRatingSelected(2);
                },
                child: Icon(
                  Icons.sentiment_dissatisfied,
                  color: Colors.orange,
                  size: 50,
                ),
              ),
              GestureDetector(
                onTap: () {
                  onRatingSelected(3);
                },
                child: Icon(
                  Icons.sentiment_neutral,
                  color: Colors.yellow,
                  size: 50,
                ),
              ),
              GestureDetector(
                onTap: () {
                  onRatingSelected(4);
                },
                child: Icon(
                  Icons.sentiment_satisfied,
                  color: Colors.green,
                  size: 50,
                ),
              ),
              GestureDetector(
                onTap: () {
                  onRatingSelected(5);
                },
                child: Icon(
                  Icons.sentiment_very_satisfied,
                  color: Colors.blue,
                  size: 50,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}




class Product {
  final String name;
  final String price;
  final String imageUrl;
  final String description;
  final String disponibilite; // Add disponibilite property
  bool selected;
  int quantity;
  String note;

  Product({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    this.selected = false,
    this.quantity = 1,
    this.note = '',
    required this.disponibilite, // Initialize disponibilite property
  });
}
