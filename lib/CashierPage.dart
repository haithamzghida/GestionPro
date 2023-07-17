import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

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
  List<String> _orderItems = [];
  String _selectedCategory = 'café';

  List<Product> _getProductsByCategory(String category) {
    // Implement your logic to retrieve products based on the selected category
    // Return a list of products for the given category
    // Example implementation:
    if (category == 'café') {
      return [
        Product(name: 'Express', price: 2000, imageUrl:'assets/Express.png'),
        Product(name: 'American', price: 2600, imageUrl: 'assets/American.png'),
        Product(name: 'Grand tasse', price: 2900, imageUrl: 'assets/Grand tasse.png'),
        Product(name: 'Café crème', price: 3000, imageUrl: 'assets/Café crème.png'),
        Product(name: 'Capuccino', price: 5500, imageUrl: 'assets/Capuccino.png'),
        Product(name: 'chocolat aux lait', price: 2800, imageUrl: 'assets/chocolat aux lait.png'),

      ];
    } else if (category == 'Chocolat Chaud') {
      return [
        Product(name: 'Normal', price: 5000, imageUrl: 'assets/Normal.png'),
        Product(name: 'Fruit sec', price: 6000, imageUrl: 'assets/Fruit sec.png'),
        Product(name: 'Banane', price: 6000, imageUrl: 'assets/Banane.png'),
        Product(name: 'Nutella', price: 6500, imageUrl: 'assets/Nutella.png'),
        Product(name: 'The house', price: 9000, imageUrl: 'assets/The house.png'),
      ];
    }else if (category == 'Chocolat glacée') {
      return [
        Product(name: 'Chocolat glacée', price: 5000, imageUrl: 'assets/Chocolat glacée.png'),
      ];
    }else if (category == 'Ice coffee') {
      return [
        Product(name: 'Noisette', price: 5000, imageUrl: 'assets/Noisette.png'),
        Product(name: 'Cookies', price: 5000, imageUrl: 'assets/Cookies.png'),
        Product(name: 'Cramel', price: 5000, imageUrl: 'assets/Cramel.png'),
        Product(name: 'Vanille', price: 5000, imageUrl: 'assets/Vanille.png'),
        Product(name: 'Chckolat', price: 5000, imageUrl: 'assets/Chckolat.png'),
        Product(name: 'Brownies', price: 5000, imageUrl: 'assets/Brownies.png'),
      ];
    }else if (category == 'Eau minérale') {
      return [
        Product(name: 'Eau minérale 0.5 L', price: 1000, imageUrl: 'assets/Eau minérale 0.5 L.png'),
        Product(name: 'Eau minérale 1 L', price: 1800, imageUrl: 'assets/Eau minérale 1 L.png'),
      ];
    }else if (category == 'Thé') {
      return [
        Product(name: 'Thé', price: 1800, imageUrl: 'assets/The.png'),
        Product(name: 'Thé à la menthe', price: 2000, imageUrl: 'assets/Thé à la menthe.png'),
      ];
    }else if (category == 'Jus') {
      return [
        Product(name: 'Orange', price: 4000, imageUrl: 'assets/Orange.png'),
        Product(name: 'Citron', price: 4000, imageUrl: 'assets/Citron.png'),
        Product(name: 'Banane', price: 5500, imageUrl: 'assets/Banane.png'),
        Product(name: 'Fraise', price: 5500, imageUrl: 'assets/Fraise.png'),
        Product(name: 'Fruit', price: 6000, imageUrl: 'assets/Fruit.png'),
        Product(name: 'The house', price: 9000, imageUrl: 'assets/The house.png'),
      ];
    }else if (category == 'Mojito') {
      return [
        Product(name: 'Citron', price: 5000, imageUrl: 'assets/m-Citron.png'),
        Product(name: 'Blue', price: 5500, imageUrl: 'assets/Blue.png'),
        Product(name: 'Pomme', price: 5500, imageUrl: 'assets/Pomme.png'),
        Product(name: 'Fraise', price: 5500, imageUrl: 'assets/m-Fraise.png'),
        Product(name: 'Ananas', price: 5500, imageUrl: 'assets/Ananas.png'),
        Product(name: 'Grenadine', price: 6000, imageUrl: 'assets/Grenadine.png'),
        Product(name: 'Energétique', price: 6500, imageUrl: 'assets/Energétique.png'),
      ];
    }else if (category == 'Boisson') {
      return [
        Product(name: 'coca/fanta ...', price: 2500, imageUrl: 'assets/cocafanta.png'),
        Product(name: 'Enargitique', price: 5000, imageUrl: 'assets/Energetique.png'),
      ];
    }

    // Return an empty list if the category is not found
    return [];
  }

  final List<String> employeeNames = ['Haitham', 'Mhamed', 'Folan Folani'];

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _showEmployeeSelection();
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
  void _addItem(int amount) {
    setState(() {
      _totalAmount += amount;
    });
  }

  // Method to handle subtracting an item from the total amount
  void _subtractItem(int amount) {
    setState(() {
      _totalAmount -= amount;
    });
  }

  // Method to create a new bill
  void _createBill() {
    if (_selectedEmployee != null && _totalAmount > 0) {
      List<String> selectedProducts = _orderItems.toList();
      // Add the selected products to the bill
      // You can replace this with your logic to add the selected products

      Bill bill = Bill(
        serverName: _selectedEmployee!,
        dateTime: DateTime.now(),
        tableNumber: _selectedTable,
        products: selectedProducts,
        title: 'The House Coffee Shop',
        welcomeText: 'Welcome',
        footerText: 'We hope to see you again!',
      );

      setState(() {
        _bills.add(bill);
        _orderItems.clear();
      });

      // Reset the total amount and selected products
      _totalAmount = 0;
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

  Widget _buildProductItem(String name, int price, String imageUrl) {
    return InkWell(
      onTap: () {
        setState(() {
          _orderItems.add(name);
          _addItem(price);
        });
      },
      onLongPress: () {
        setState(() {
          _orderItems.remove(name);
          _subtractItem(price);
        });
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
            Image.network(
              imageUrl,
              height: 80,
            ),
            SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '\$$price',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
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
            SizedBox(height: 8),
            Text(
              bill.welcomeText,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              bill.footerText,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Menu Categories:',
                        style: TextStyle(fontSize: 20),
                      ),
                      Row(
                        children: [
                          _buildCategoryButton('café'),
                          SizedBox(width: 8),
                          _buildCategoryButton('Chocolat Chaud'),
                          SizedBox(width: 8),
                          _buildCategoryButton('Chocolat glacée'),
                          SizedBox(width: 8),
                          _buildCategoryButton('Ice coffee'),
                          SizedBox(width: 8),
                          _buildCategoryButton('Eau minérale'),
                          SizedBox(width: 8),
                          _buildCategoryButton('Thé'),
                          SizedBox(width: 8),
                          _buildCategoryButton('Jus'),
                          SizedBox(width: 8),
                          _buildCategoryButton('Mojito'),
                          SizedBox(width: 8),
                          _buildCategoryButton('Boisson'),
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
                        child: GridView.count(
                          crossAxisCount: 4,
                          children: _getProductsByCategory(_selectedCategory)
                              .map((product) => _buildProductItem(
                            product.name,
                            product.price,
                            product.imageUrl,
                          ))
                              .toList(),
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
                                  itemCount: _orderItems.length,
                                  itemBuilder: (context, index) {
                                    final orderItem = _orderItems[index];
                                    return ListTile(
                                      leading: Icon(Icons.circle, color: Colors.black),
                                      title: Text(orderItem),
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
                              ElevatedButton(
                                onPressed: _createBill,
                                child: Text('Order Now'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _createBill,
                      child: Text('Create New Bill'),
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
                      },
                      child: Text('View Bills'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftBarButton(String label, IconData icon, bool isSelected) {
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

  Widget _buildCategoryButton(String category) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: Text(
        category,
        style: TextStyle(fontSize: 16, color: _selectedCategory == category ? Colors.white : Colors.black),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(_selectedCategory == category ? Colors.black : Colors.white),
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

  Bill({
    required this.serverName,
    required this.dateTime,
    required this.tableNumber,
    required this.products,
    required this.title,
    required this.welcomeText,
    required this.footerText,
  });
}

class Product {
  final String name;
  final int price;
  final String imageUrl;

  Product({required this.name, required this.price, required this.imageUrl});
}
