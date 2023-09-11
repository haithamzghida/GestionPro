import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(TailwindPOSApp());
}

class TailwindPOSApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tailwind POS',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: CashierPage(),
    );
  }
}

class OrderItem {
  final Product product;
  int quantity;

  OrderItem({required this.product, required this.quantity});
}


class CashierPage extends StatefulWidget {
  @override
  _CashierPageState createState() => _CashierPageState();
}

class _CashierPageState extends State<CashierPage> with TickerProviderStateMixin {
  int _totalAmount = 0;
  String _selectedSalon = 'Salon 1';
  int _selectedTable = 1;
  String? _selectedEmployee;
  String _pinCode = '';
  List<Bill> _bills = [];

  List<OrderItem> _selectedProducts = [];
  int _selectedCategory = 1;
  List<Map<String, dynamic>> _categories = [];
  Map<String, int> _productQuantities = {};

  Future<List<Product>> _fetchProductsByCategory(int categoryId) async {
    final response = await http.get(Uri.parse('http://localhost:3000/products/category/$categoryId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse.containsKey('products')) {
        final List<dynamic> productsJson = jsonResponse['products'];
        List<Product> products = productsJson.map((productJson) {
          return Product(
            name: productJson['name'] ?? '', // Provide default value for 'name'
            price: (productJson['price'] ?? 0).toString(), // Provide default value for 'price'
            imageUrl: (productJson['image_url'] ?? 'assets/Express.png').toString(),

          );
        }).toList();

        return products;
      } else {
        // Handle the case where 'products' key is not present in the response
        throw Exception('Products key not found in response');
      }
    } else {
      throw Exception('Failed to fetch products');
    }
  }







  final List<String> employeeNames = ['Haitham', 'Mhamed', 'Folan Folani'];

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _showEmployeeSelection();
      fetchCategories();
    });


    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }
  Future<void> fetchCategories() async {
    List<Map<String, dynamic>> categoryInfoList = await _fetchCategories();
    setState(() {
      _categories = categoryInfoList;
    });
  }


  // Fetch categories from the Node.js backend
  Future<List<Map<String, dynamic>>> _fetchCategories() async {
    final response = await http.get(Uri.parse('http://localhost:3000/categories'));

    if (response.statusCode == 200) {
      final List<dynamic> categories = json.decode(response.body)['categories'];

      List<Map<String, dynamic>> categoryInfoList = categories.map((category) {
        return {
          'id': category['id'],
          'name': category['name'],
        };
      }).toList();

      return categoryInfoList;
    } else {
      // Handle error here
      print('Error fetching categories: ${response.statusCode}');
      throw Exception('Failed to fetch categories');
    }
  }


  void _showEmployeeSelection() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Employee'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (String employeeName in employeeNames)
                ListTile(
                  title: Text(employeeName),
                  onTap: () {
                    Navigator.pop(context);
                    _showPasswordPopup(employeeName);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _showPasswordPopup(String employeeName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FocusScope(
          autofocus: true,
          child: Dialog(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Employee: $employeeName',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  _buildPinCodePoints(),
                  SizedBox(height: 16),
                  RawKeyboardListener(
                    focusNode: FocusNode(),
                    onKey: (event) {
                      if (event is RawKeyDownEvent) {
                        final keyEvent = event.logicalKey.keyLabel;
                        if (keyEvent != null && keyEvent.isNotEmpty && _pinCode.length < 4) {
                          setState(() {
                            _pinCode += keyEvent;
                            _animationController.reset();
                            _animationController.forward();
                          });
                        }
                      }
                    },
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int i = 1; i <= 3; i++) _buildNumberButton(i),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int i = 4; i <= 6; i++) _buildNumberButton(i),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int i = 7; i <= 9; i++) _buildNumberButton(i),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildNumberButton(0),
                            _buildNumberButton(-1), // Erase button
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_pinCode == '0000') {
                        setState(() {
                          _selectedEmployee = employeeName;
                        });
                        Navigator.pop(context);
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Invalid Pin Code'),
                              content: Text('Please enter the correct pin code.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _showEmployeeSelection();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNumberButton(int number) {
    if (number == -1) {
      return GestureDetector(
        onTap: () {
          setState(() {
            _pinCode = _pinCode.substring(0, _pinCode.length - 1);
            _animationController.reset();
          });
        },
        child: InkResponse(
          splashColor: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(32),
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
            child: Center(
              child: Icon(
                Icons.backspace,
                size: 24,
                color: Colors.grey[600],
              ),
            ),
          ),
        ),
      );
    } else {
      return InkResponse(
        onTap: () {
          setState(() {
            _pinCode += number.toString();
            _animationController.reset();
            _animationController.forward();
          });
        },
        splashColor: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(32),
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[200],
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildPinCodePoints() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < _pinCode.length; i++)
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: 16,
                height: 16,
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(_animation.value), // Use the animation value to control opacity
                ),
              ),
          ],
        );
      },
    );
  }

  // Method to handle adding an item to the total amount
  void _addItem(Product product) {
    setState(() {
      _totalAmount += int.parse(product.price);

      int index = _selectedProducts.indexWhere((item) => item.product.name == product.name);

      if (index != -1) {
        _selectedProducts[index].quantity++;
      } else {
        _selectedProducts.add(OrderItem(product: product, quantity: 1));
      }

      // Update product quantities map
      _productQuantities[product.name] = (_productQuantities[product.name] ?? 0) + 1;
    });
  }

  void _subtractItem(OrderItem orderItem) {
    setState(() {
      _totalAmount -= int.parse(orderItem.product.price);
      orderItem.quantity--;

      if (orderItem.quantity == 0) {
        _selectedProducts.remove(orderItem);
      }

      // Update product quantities map
      _productQuantities[orderItem.product.name] = (_productQuantities[orderItem.product.name] ?? 0) - 1;
    });
  }



  // Method to create a new bill
  void _createBill() {
    if (_selectedEmployee != null && _totalAmount > 0) {
      List<String> selectedProducts = [];
      int totalBillAmount = 0; // Initialize the total bill amount

      // Add the selected products with quantities and prices to the bill
      _selectedProducts.forEach((orderItem) {
        int itemTotal = int.parse(orderItem.product.price) * orderItem.quantity;
        totalBillAmount += itemTotal; // Increment the total bill amount
        selectedProducts.add('${orderItem.product.name} (x${orderItem.quantity}) - \$${itemTotal}');
      });

      if (selectedProducts.isNotEmpty) {
        Bill bill = Bill(
          serverName: _selectedEmployee!,
          dateTime: DateTime.now(),
          tableNumber: _selectedTable,
          products: selectedProducts,
          title: 'The House Coffee Shop',
          welcomeText: 'Welcome',
          footerText: 'We hope to see you again!',
          totalAmount: totalBillAmount, // Pass the total bill amount to the Bill object
        );

        setState(() {
          _bills.add(bill);
          _selectedProducts.clear(); // Clear the selected products list
          _productQuantities.clear(); // Clear the product quantities map
        });

        // Reset the total amount
        _totalAmount = 0;
      }
    }
  }



  // Method to print a bill
  void _printBill(Bill bill) {
    // Implement your logic to print the bill
    print('Printing Bill: ${bill.dateTime}');
  }

  Widget _buildSalonDropdown() {
    return DropdownButton<String>(
      value: _selectedSalon,
      onChanged: (String? newValue) {
        setState(() {
          _selectedSalon = newValue!;
        });
      },
      items: <String>['Salon 1', 'Salon 2', 'Salon 3', 'Salon 4']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildTableDropdown() {
    return DropdownButton<int>(
      value: _selectedTable,
      onChanged: (int? newValue) {
        setState(() {
          _selectedTable = newValue!;
        });
      },
      items: <int>[1, 2, 3, 4, 5, 6]
          .map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text('Table $value'),
        );
      }).toList(),
    );
  }

  Widget _buildProductItem(Product product, int selectedQuantity) {
    return InkWell(
      onTap: () {
        _addItem(product);
      },
      onLongPress: () {
        OrderItem orderItem = _selectedProducts.firstWhere((item) => item.product.name == product.name);
        _subtractItem(orderItem);
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              product.imageUrl,
              height: 80,
            ),
            SizedBox(height: 8),
            Text(
              product.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '\$${product.price}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Quantity: $selectedQuantity', // Display product quantity
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
            ),
            if (selectedQuantity > 0)
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  OrderItem orderItem = _selectedProducts.firstWhere((item) => item.product.name == product.name);
                  _subtractItem(orderItem);
                },
              ),
          ],
        ),
      ),
    );
  }



  Widget _buildBillItem(Bill bill) {
    return Card(
      elevation: 2,
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bill.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            Text(
              'Welcome',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Server Name: ${bill.serverName}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Date: ${DateFormat.yMd().add_jm().format(bill.dateTime)}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Table Number: ${bill.tableNumber}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Products:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (String product in bill.products)
                  Text(
                    product,
                    style: TextStyle(fontSize: 16),
                  ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Total: \$${bill.totalAmount}', // Display total amount
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8), // Add some spacing
            Text(
              'we hope you enjoyed the service',
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _printBill(bill);
              },
              child: Text('Print'),
            ),
          ],
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cashier'),
        backgroundColor: Colors.black,
      ),
      body: Row(
        children: [
          Container(
            width: 180,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(-2, 0),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/logo.png',
                            height: 80,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'The House Coffee Shop Cashier',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 0),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(height: 16),
                    _buildLeftBarButton('Cashier', Icons.money, true),
                    SizedBox(height: 16),
                    _buildLeftBarButton('Dashboard', Icons.dashboard, false),
                    SizedBox(height: 16),
                    _buildLeftBarButton('Message', Icons.message, false),
                  ],
                ),
                Column(
                  children: [
                    Divider(height: 0),
                    SizedBox(height: 16),
                    _buildLeftBarButton('Logout', Icons.logout, false),
                    SizedBox(height: 16),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 16), // Add spacing between the left bar and content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Menu Categories:',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          for (Map<String, dynamic> categoryInfo in _categories)
                            _buildCategoryButton(categoryInfo['name'], categoryInfo['id']),
                        ],
                      ),

                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Total Amount: \$$_totalAmount',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Employee: $_selectedEmployee',
                        style: TextStyle(fontSize: 16),
                      ),
                      _buildSalonDropdown(),
                      _buildTableDropdown(),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: FutureBuilder<List<Product>>(
                          future: _fetchProductsByCategory(_selectedCategory),
                          builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else {
                              return GridView.count(
                                crossAxisCount: 4,
                                children: snapshot.data!.map<Widget>((product) {
                                  int selectedQuantity = _productQuantities[product.name] ?? 0;
                                  return _buildProductItem(product, selectedQuantity);
                                }).toList(),
                              );
                            }
                          },
                        ),
                      ),

                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  'Order',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Divider(),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: _selectedProducts.length,
                                  itemBuilder: (context, index) {
                                    final orderItem = _selectedProducts[index];
                                    return ListTile(
                                      leading: Icon(Icons.circle, color: Colors.black),
                                      title: Text('${orderItem.product.name} (x${orderItem.quantity}) ${int.parse(orderItem.product.price) * orderItem.quantity} DT'),

                                    );
                                  },
                                ),
                              ),


                              Divider(),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  'Total: $_totalAmount DT',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),


                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: _createBill,
                                    child: Text('Order Now'),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Bills'),

                                            content: Container(
                                              width: MediaQuery.of(context).size.width * 0.3,
                                              height: 300,
                                              child: ListView.builder(
                                                itemCount: _bills.length,
                                                itemBuilder: (context, index) {
                                                  return _buildBillItem(_bills[index]);
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Text('View Bills'),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),



              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftBarButton(String label, IconData icon, bool isSelected) {
    if (label == 'View Bills' || label == 'Message') {
      return TextButton.icon(
        onPressed: () {
          if (label == 'View Bills') {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Bills'),
                  content: Container(
                    width: double.maxFinite,
                    height: 300,
                    child: ListView.builder(
                      itemCount: _bills.length,
                      itemBuilder: (context, index) {
                        return _buildBillItem(_bills[index]);
                      },
                    ),
                  ),
                );
              },
            );
          } else if (label == 'Message') {
            // Implement the behavior for the "Message" button here
          }
        },
        icon: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.black,
        ),
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            isSelected ? Colors.black : Colors.white,
          ),
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
      );
    } else {
      // For other buttons, return the standard ElevatedButton.icon
      return ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.black,
        ),
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            isSelected ? Colors.black : Colors.white,
          ),
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
      );
    }
  }


  Widget _buildCategoryButton(String category, int categoryId) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedCategory = categoryId;
        });
      },
      child: Text(
        category,
        style: TextStyle(fontSize: 16, color: _selectedCategory == categoryId ? Colors.white : Colors.black),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(_selectedCategory == categoryId ? Colors.black : Colors.white),
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
    );
  }



}

class Bill {
  final String serverName;
  final DateTime dateTime;
  final int tableNumber;
  final List<String> products;
  final String title;
  final String welcomeText;
  final String footerText;
  final int totalAmount;

  Bill({
    required this.serverName,
    required this.dateTime,
    required this.tableNumber,
    required this.products,
    required this.title,
    required this.welcomeText,
    required this.footerText,
    required this.totalAmount,
  });
}

class Product {
  final String name;
  final String price; // Change the type to String
  final String imageUrl;

  Product({required this.name, required this.price, required this.imageUrl});
}