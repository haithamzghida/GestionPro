import 'package:flutter/material.dart';
import 'ProductCatalog.dart';
import 'cart.dart';
import 'login.dart';
import 'main.dart';



class MyHomePage extends StatefulWidget {
  final int? customerId;

  MyHomePage({required this.customerId});



  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late int customerId = 0;
  int _selectedIndex = 0;
  late CartPage _cartPage; // Declare a variable to hold the CartPage instance

  @override
  void initState() {
    super.initState();
    _cartPage = CartPage(customerId: customerId);
    // Create the CartPage instance in initState()
  }

  static List<Widget> _widgetOptions = <Widget>[
    ProductCatalog(),
    Text(
      'Shop',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getSelectedWidget() {
    switch (_selectedIndex) {
      case 0:
      case 1:
        return _widgetOptions[_selectedIndex];
      case 2:
        return CartPage(customerId: widget.customerId); // Pass the customerId to CartPage
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer ${widget.customerId}'),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          CircleAvatar(
            backgroundImage: AssetImage('logo.png'),
            child: PopupMenuButton<String>(
              onSelected: (String choice) {
                if (choice == 'connection') {
                  Navigator.pushNamed(context, '/login'); // Navigate to the LoginPage
                }
                if (choice == 'registration') {
                  Navigator.pushNamed(context, '/registration'); // Navigate to the LoginPage
                }
              },

              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: 'profile',
                    child: Text('Profile'),
                  ),
                  PopupMenuItem<String>(
                    value: 'connection',
                    child: Text('Connection'),
                  ),
                  PopupMenuItem<String>(
                    value: 'registration',
                    child: Text('registration'),
                  ),
                ];
              },
            ),


          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search here',
                border: InputBorder.none,
                suffixIcon: Icon(Icons.loop),
              ),
            ),
          ),
        ),
      ),
      body: _getSelectedWidget(), // Use a helper function to determine the selected widget
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Cart',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}