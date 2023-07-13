import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

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
      List<String> selectedProducts = [];
      // Add the selected products to the bill
      // You can replace this with your logic to add the selected products
      selectedProducts = ['Coffee', 'Tea'];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cashier'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            child: GridView.count(
              crossAxisCount: 3,
              children: [
                _buildProductItem('Coffee', 5, Icons.local_cafe),
                _buildProductItem('Tea', 3, Icons.local_drink),
                _buildProductItem('Burger', 10, Icons.fastfood),
                _buildProductItem('Pizza', 12, Icons.local_pizza),
                _buildProductItem('Salad', 8, Icons.local_dining),
                _buildProductItem('Ice Cream', 4, Icons.icecream),
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
    );
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

  Widget _buildProductItem(String name, int price, IconData icon) {
    return InkWell(
      onTap: () {
        _addItem(price);
      },
      onLongPress: () {
        _subtractItem(price);
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
            Icon(
              icon,
              size: 40,
              color: Colors.grey[600],
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

void main() {
  runApp(MaterialApp(
    home: CashierPage(),
  ));
}
