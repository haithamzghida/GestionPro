import 'package:flutter/material.dart';
void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InventoryPage(),
    );
  }
}
class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}
class _InventoryPageState extends State<InventoryPage> {
  List<Product> _products = [
    Product(name: "Product 1", stock: 10, deliveryStatus: "Not Delivered"),
    Product(name: "Product 2", stock: 5, deliveryStatus: "Not Delivered"),
    Product(name: "Product 3", stock: 2, deliveryStatus: "Not Delivered"),
  ];
  TextEditingController _nameController = TextEditingController();
  TextEditingController _stockController = TextEditingController();
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  void _addProduct() {
    String name = _nameController.text;
    int stock = int.parse(_stockController.text);
    setState(() {
      _products.add(Product(
          name: name, stock: stock, deliveryStatus: "Not Delivered"));
    });
    _nameController.clear();
    _stockController.clear();
  }
  void _deleteProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
  }
  void _updateDeliveryStatus(int index) {
    setState(() {
      if (_products[index].deliveryStatus == "Not Delivered") {
        _products[index].deliveryStatus = "In Delivery Process";
      } else if (_products[index].deliveryStatus == "In Delivery Process") {
        _products[index].deliveryStatus = "Delivered";
      } else {
        _products[index].deliveryStatus = "Not Delivered";
      }
    });
  }
  void _showUpdateStockDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _updateStockController = TextEditingController();
        return AlertDialog(
          title: Text("Update Stock"),
          content: TextField(
            controller: _updateStockController,
            decoration: InputDecoration(
              labelText: "New Stock",
            ),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _updateStock(index, int.parse(_updateStockController.text));
                Navigator.of(context).pop();
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }
  void _updateStock(int index, int newStock) {
    setState(() {
      _products[index].stock = newStock;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inventory Management"),
      ),
      body: Column(
        children: [
          Expanded(
            child: _selectedIndex == 0
                ? ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_products[index].name),
                  subtitle: Text(
                      "Stock: ${_products[index].stock}\nDelivery Status: ${_products[index].deliveryStatus}"),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showUpdateStockDialog(index);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteProduct(index);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    _updateDeliveryStatus(index);
                  },
                );
              },
            )
                : Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Product Name",
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _stockController,
                    decoration: InputDecoration(
                      labelText: "Stock",
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      _addProduct();
                    },
                    child: Text("Add Product"),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.grey.withOpacity(0.1),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Product Name')),
                  DataColumn(label: Text('Delivered')),
                  DataColumn(label: Text('Returned')),
                ],
                rows: _products
                    .map(
                      (product) => DataRow(cells: [
                    DataCell(Text(product.name)),
                    DataCell(Text(
                        product.deliveryStatus == "Delivered" ? "Yes" : "No")),
                    DataCell(Text("No")), // Replace this with actual return status
                  ]),
                )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Product',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
class Product {
  String name;
  int stock;
  String deliveryStatus;
  Product(
      {required this.name, required this.stock, required this.deliveryStatus});
}

