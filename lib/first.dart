import 'CashierPage.dart';
import 'Inventory.dart';
import 'home_page.dart';
import 'package:flutter/material.dart';
import 'login_inventory.dart';
import 'menu.dart';
import 'splash_screen.dart';

class First extends StatefulWidget {
  @override
  _FirstState createState() => _FirstState();
}

class _FirstState extends State<First> {
  double opacity1 = 1.0;
  double opacity2 = 1.0;
  double opacity3 = 1.0;
  double opacity4 = 1.0; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(top: 50, bottom: 30),
              child: Column(
                children: [
                  Text(
                    'GestionPro',
                    style: TextStyle(
                      fontSize: 90,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'the application web is on development mode ...',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.spaceEvenly,
              children: [
                buildHoverContainer(
                  color: Colors.blue,
                  icon: Icons.apps,
                  text: 'Application Vitrine',
                  opacity: opacity1,
                  onTap: () {
                    // Navigate to splash_screen.dart when the button is clicked
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SplashScreenPage()),
                    );
                  },
                  onEnter: () {
                    setState(() {
                      opacity1 = 0.5;
                    });
                  },
                  onExit: () {
                    setState(() {
                      opacity1 = 1.0;
                    });
                  },
                ),
                buildHoverContainer(
                  color: Colors.green,
                  icon: Icons.shopping_cart,
                  text: 'Caisse Enregistreuse',
                  opacity: opacity2,
                  onEnter: () {
                    setState(() {
                      opacity2 = 0.5;
                    });
                  },
                  onExit: () {
                    setState(() {
                      opacity2 = 1.0;
                    });
                  },  onTap: () {
                  // Navigate to splash_screen.dart when the button is clicked
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CashierPage()),
                  );
                },
                ),
                buildHoverContainer(
                  color: Colors.orange,
                  icon: Icons.storage,
                  text: 'Gestion Stock',
                  opacity: opacity3,
                  onEnter: () {
                    setState(() {
                      opacity3 = 0.5;
                    });
                  },
                  onExit: () {
                    setState(() {
                      opacity3 = 1.0;
                    });
                  },  onTap: () {
                  // Navigate to splash_screen.dart when the button is clicked
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginInventoryPage()),
                  );
                },
                ),
                buildHoverContainer(
                  color: Colors.purple,
                  icon: Icons.menu,
                  text: 'Menu Tablette',
                  opacity: opacity4,
                  onEnter: () {
                    setState(() {
                      opacity4 = 0.5;
                    });
                  },
                  onExit: () {
                    setState(() {
                      opacity4 = 1.0;
                    });
                  },  onTap: () {
                  // Navigate to splash_screen.dart when the button is clicked
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MenuTablet()),
                  );
                },
                ),
              ],

            ),
          ],
        ),
      ),
    );
  }

  Widget buildHoverContainer({
    required Color color,
    required IconData icon,
    required String text,
    required double opacity,
    required Function() onTap,
    required Function() onEnter,
    required Function() onExit,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: opacity,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 70,
                ),
                SizedBox(height: 10),
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        onEnter: (event) {
          onEnter();
        },
        onExit: (event) {
          onExit();
        },
      ),
    );
  }
}