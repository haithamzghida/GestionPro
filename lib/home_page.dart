import 'package:flutter/material.dart';
import 'Inventory.dart';
import 'ProductCatalog.dart';
import 'cart.dart';
import 'login.dart';
import 'main.dart';
import 'about.dart';
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
  // Add a new variable to hold the menu options
  List<String> _menuOptions = [
    'Profile',
    'Connection',
    'Registration',
    'About Us',
    'Contact'
  ];
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
  // Add a new method to handle the selection of menu options
  void _onMenuOptionSelected(String option) {
    switch (option) {
      case 'Profile':
      // Navigate to the ProfilePage
        break;
      case 'Connection':
        Navigator.pushNamed(context, '/login'); // Navigate to the LoginPage
        break;
      case 'Registration':
        Navigator.pushNamed(context, '/registration'); // Navigate to the RegistrationPage
        break;
      case 'About Us':
      // Show the AboutUsPage
        Navigator.pushNamed(context, '/about');
        break;
      case 'Contact':
      // Show the ContactPage
        break;
    }
  }
  Widget _getSelectedWidget() {
    switch (_selectedIndex) {
      case 0:
      case 1:
        return _widgetOptions[_selectedIndex];
      case 2:
        return CartPage(customerId: widget.customerId);
      case 3:
        return InventoryPage(); // Add a case for index 3 to return the InventoryPage
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
              onSelected: _onMenuOptionSelected,
              itemBuilder: (BuildContext context) {
                return _menuOptions.map((String option) {
                  return PopupMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList();
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Menu'),
              decoration: BoxDecoration(
                color: Colors.black,
              ),
            ),
            ListTile(
              title: Text('About Us'),
              onTap: () {
                // Show the AboutUsPage
                Navigator.pushNamed(context, '/about');
              },
            ),
            ListTile(
              title: Text('Contact'),
              onTap: () {
                // Show the ContactPage
              },
            ),
          ],
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
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventory',
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