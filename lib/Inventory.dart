import 'dart:convert';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InventoryManagementPage(),
    );
  }
}

class InventoryManagementPage extends StatefulWidget {
  @override
  _InventoryManagementPageState createState() => _InventoryManagementPageState();
}

class _InventoryManagementPageState extends State<InventoryManagementPage> {
  String _selectedPage = 'dashboard';
  List<Product> products = [];
  List<Category> categories = [];
  Category? _selectedCategory;
  bool _isDropdownOpen = false;


  void _selectPage(String page) {
    setState(() {
      _selectedPage = page;
      if (page == 'gestion_stock/produits') {
        fetchProducts();
      }
    });
  }




  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/products'));
      if (response.statusCode == 200) {
        final dynamic parsed = json.decode(response.body);

        if (parsed is List<dynamic>) {
          // The response is already a list, so we can directly parse it
          setState(() {
            products = parsed.map((json) => Product.fromJson(json)).toList();
          });
        } else if (parsed is Map<String, dynamic> &&
            parsed.containsKey('products')) {
          // Check if 'products' key is present and contains a list
          final productList = parsed['products'];

          if (productList is List<dynamic>) {
            // If productList is a list, parse it
            setState(() {
              products = productList.map((json) => Product.fromJson(json)).toList();
            });
          } else {
            print('Invalid data format: products key is not a list');
          }
        } else {
          print('Invalid data format: Missing products key or unsupported format');
        }
      } else {
        print('Failed to fetch products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }




  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('http://localhost:3000/categories'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['categories'];
      return data.map((category) => Category.fromJson(category)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }



  @override
  void initState() {
    super.initState();
    fetchCategories().then((fetchedCategories) {
      setState(() {
        categories = fetchedCategories;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('The House Stock'),
        backgroundColor: Colors.black,
      ),
      body: Row(
        children: <Widget>[
          Container(
            color: Colors.black,
            width: 250,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start, // Align content at the top
                    crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
                    children: <Widget>[
                      Container( // Wrap the logo in a Container
                        
                        child: Image.asset(
                          'assets/logo.png',
                          width: 200, // Adjust the width as needed
                          height: 100, // Adjust the height as needed
                          fit: BoxFit.contain, // Fit the image within the container
                        ),
                      ),
                      SizedBox(height: 10), // Add some spacing between the logo and text
                      Text(
                        'The House Stock',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),

                ListTile(
                  title: Text(
                    'Dashboard',
                    style: TextStyle(
                      color: _selectedPage == 'dashboard' ? Colors.white : Colors.grey,
                    ),
                  ),
                  onTap: () {
                    _selectPage('dashboard');
                  },
                ),
                ListTile(
                  title: Text(
                    'Gestion Stock',
                    style: TextStyle(
                      color: _selectedPage == 'gestion_stock' ? Colors.white : Colors.grey,
                    ),
                  ),
                  onTap: () {
                    _selectPage('gestion_stock');
                  },
                ),
                ExpansionTile(
                  title: Text(
                    'Gestion de Stock',
                    style: TextStyle(
                      color: _selectedPage.startsWith('gestion_stock/') ? Colors.white : Colors.grey,
                    ),
                  ),
                  initiallyExpanded: _selectedPage.startsWith('gestion_stock/'),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Produits',
                        style: TextStyle(
                          color: _selectedPage == 'gestion_stock/produits' ? Colors.white : Colors.grey,
                        ),
                      ),
                      onTap: () {
                        _selectPage('gestion_stock/produits');
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Matière Première',
                        style: TextStyle(
                          color: _selectedPage == 'gestion_stock/matiere_premiere'
                              ? Colors.white
                              : Colors.grey,
                        ),
                      ),
                      onTap: () {
                        _selectPage('gestion_stock/matiere_premiere');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _selectedPage == 'dashboard'
                ? DashboardPage()
                : _selectedPage == 'gestion_stock/produits'
                ? GestionStockProduitsPage(
              products: products,
              categories: categories,
              selectedCategory: _selectedCategory,
              onCategoryChanged: (Category? category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            )

                : _selectedPage == 'gestion_stock/matiere_premiere'
                ? GestionStockMatierePremierePage()
                : _selectedPage == 'gestion_stock'
                ? GestionStockPage()
                : Container(),
          ),
        ],
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Dashboard Page Content'),
    );
  }
}

class GestionStockPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Gestion de Stock Page Content'),
    );
  }
}

class GestionStockProduitsPage extends StatefulWidget {
  final List<Product> products;
  final List<Category> categories;
  final Category? selectedCategory;
  final void Function(Category?) onCategoryChanged;

  GestionStockProduitsPage({
    required this.products,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  _GestionStockProduitsPageState createState() => _GestionStockProduitsPageState(categories: []);
}

class _GestionStockProduitsPageState extends State<GestionStockProduitsPage> {
  int _currentPage = 1;
  int _productsPerPage = 10;
  bool isDropdownOpen = false;

  final List<Category> categories;
  _GestionStockProduitsPageState({required this.categories});

  @override
  Widget build(BuildContext context) {
    final filteredProducts = widget.selectedCategory == null
        ? widget.products
        : widget.products.where((product) => product.categoryId == widget.selectedCategory!.id).toList();

    final startIndex = (_currentPage - 1) * _productsPerPage;
    final endIndex = min(startIndex + _productsPerPage, filteredProducts.length);

    final displayedProducts = filteredProducts.sublist(startIndex, endIndex);

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: SingleChildScrollView( // Wrap the Column with a SingleChildScrollView
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildCategoryDropdown(),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection:
                            Axis.horizontal, // Scroll horizontally
                            child: DataTable(
                              columns: [
                                DataColumn(
                                  label: Text(
                                    'Name',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Price',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Description',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Image',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Actions',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
                                  ),
                                ),
                              ],
                              rows: displayedProducts.map((product) {
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Text(product.name, style: TextStyle(color: Colors.black, fontSize: 16)),
                                    ),
                                    DataCell(
                                      Text(product.price.toStringAsFixed(2), style: TextStyle(color: Colors.black, fontSize: 16)),
                                    ),
                                    DataCell(
                                      Text(product.description, style: TextStyle(color: Colors.black, fontSize: 16)),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: constraints.maxWidth * 0.15,
                                        height: constraints.maxWidth * 0.15,
                                        child: Image.network(product.imageUrl),
                                      ),
                                    ),
                                    DataCell(
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () {
                                              // Handle edit action here
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              // Handle delete action here
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.info),
                                            onPressed: () {
                                              // Handle "More Information" action here
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      (filteredProducts.length / _productsPerPage).ceil(),
                          (page) {
                        final pageNumber = page + 1;
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _currentPage = pageNumber;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _currentPage == pageNumber ? Colors.black : Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(5),
                              color: _currentPage == pageNumber ? Colors.black : Colors.white,
                            ),
                            child: Text(
                              pageNumber.toString(),
                              style: TextStyle(
                                color: _currentPage == pageNumber ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),




          Expanded(
            flex: 0,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: buildCategoryStatistics(),
              ),
            ),
          ),
        ],
      ),
    );
  }




  List<Widget> buildCategoryStatistics() {
    final categoryStatistics = calculateCategoryStatistics(widget.products);

    return [
      Align(
        alignment: Alignment.bottomLeft, // Align the statistics boxes at the bottom
        child: Column(
          children: categoryStatistics.entries.map((entry) {
            final category = entry.key;
            final count = entry.value;
            final randomColor = Color(0xFF000000 + Random().nextInt(0xFFFFFF)).withOpacity(1.0);

            return Container(
              width: 200, // Adjust the width as needed for smaller boxes
              height: 100, // Adjust the height as needed
              color: Colors.black, // Set the background color of the container to black
              margin: EdgeInsets.all(10), // Add margin between boxes
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      category.name,
                      style: TextStyle(
                        color: randomColor, // Use a random color for text
                        fontSize: 16, // Smaller font size
                      ),
                    ),
                    Text(
                      count.toString(),
                      style: TextStyle(
                        color: randomColor, // Use a random color for text
                        fontSize: 16, // Smaller font size
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    ];
  }

  Future<void> _showRemoveCategoryDialog(Category category) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevent dialog dismissal by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove Category'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to remove the category:'),
                SizedBox(height: 8.0),
                Text(
                  category.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Perform the removal action here
                await _removeCategory(category);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Remove',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

// Function to remove the selected category
  Future<void> _removeCategory(Category category) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:3000/categories/${category.id}'),
      );
      if (response.statusCode == 200) {
        // Category removed successfully
        setState(() {
          widget.categories.remove(category);
        });
      } else {
        // Handle errors
        print('Failed to remove category: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Failed to remove category: $e');
    }
  }


  Future<void> _showCategoryCreationDialog() async {
    Category newCategory = Category(id: -1, name: '', description: '');

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Category'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Name'),
                  onChanged: (value) {
                    newCategory.name = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Description (optional)'),
                  onChanged: (value) {
                    newCategory.description = value;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (newCategory.name.isNotEmpty) {
                  try {
                    // Ensure that description is not null
                    if (newCategory.description == null) {
                      newCategory.description = ''; // Set it to an empty string if it's null
                    }

                    final response = await http.post(
                      Uri.parse('http://localhost:3000/categories'),
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode(newCategory.toJson()),
                    );
                    if (response.statusCode == 200) {
                      // Category added successfully
                      final dynamic parsed = json.decode(response.body);
                      final addedCategory = Category.fromJson(parsed);
                      setState(() {
                        categories.add(addedCategory);
                      });
                    } else {
                      // Handle errors
                      print('Failed to add category: ${response.statusCode}');
                    }
                  } catch (e) {
                    // Handle exceptions
                    print('Failed to add category: $e');
                  }
                }

                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }



  Widget buildCategoryDropdown() {
    return Container(
      margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        children: [
          DropdownButton<Category>(
            iconEnabledColor: Colors.white,
            dropdownColor: Colors.black,
            style: TextStyle(color: Colors.white),
            hint: Text('Select a category'),
            value: widget.selectedCategory,
            onChanged: (Category? category) {
              widget.onCategoryChanged(category);
            },
            items: [
              DropdownMenuItem<Category>(
                value: null, // Represents "All categories"
                child: Text('All Categories'),
              ),
              ...widget.categories.map<DropdownMenuItem<Category>>((category) {
                return DropdownMenuItem<Category>(
                  value: category,
                  child: Text(category.name),
                );
              }).toList(),
            ],
          ),
          PopupMenuButton<Category>(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            itemBuilder: (BuildContext context) {
              return widget.categories.map((Category category) {
                return PopupMenuItem<Category>(
                  value: category,
                  child: Row(
                    children: [
                      Text(category.name),
                      Spacer(),
                      Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ],
                  ),
                );
              }).toList();
            },
            onSelected: (Category category) {
              // Handle the selected category for removal here
              if (category != null) {
                // Show a confirmation dialog or perform the removal action
                _showRemoveCategoryDialog(category);
              }
            },
          ),
          Expanded(
            child: TextField(
              onChanged: (value) {
                // Handle search text changes here
                // You can filter the products based on the search text.
              },
              decoration: InputDecoration(
                hintText: 'Search...',
                filled: true,
                fillColor: Colors.white, // Background color for the search bar
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                prefixIcon: Icon(Icons.search, color: Colors.black),
                suffixIcon: Icon(Icons.loop, color: Colors.black), // Add loop icon
              ),
            ),
          ),
          SizedBox(width: 10.0), // Add spacing between dropdown and buttons
          ElevatedButton(
            onPressed: () {
              // Handle the "Add Product" button's action here
            },
            child: Text(
              'Add Product',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
          ),
          SizedBox(width: 5.0), // Add spacing between buttons
          ElevatedButton(
            onPressed: () {
              _showCategoryCreationDialog();
            },
            child: Text(
              'Add Category',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
          ),
          PopupMenuButton<Category>(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            itemBuilder: (BuildContext context) {
              return widget.categories.map((Category category) {
                return PopupMenuItem<Category>(
                  value: category,
                  child: Row(
                    children: [
                      Text(category.name),
                      Spacer(),
                      Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ],
                  ),
                );
              }).toList();
            },
            onSelected: (Category category) {
              // Handle the selected category for removal here
              if (category != null) {
                // Show a confirmation dialog or perform the removal action
                _showRemoveCategoryDialog(category);
              }
            },
          ),
        ],
      ),
    );
  }








  Map<Category, int> calculateCategoryStatistics(List<Product> products) {
    final categoryStatistics = <Category, int>{};

    for (final product in products) {
      final category = widget.categories.firstWhere(
            (cat) => cat.id == product.categoryId,
        orElse: () => Category(id: -1, name: 'Uncategorized'), // Default category if not found
      );

      categoryStatistics.update(category, (count) => count + 1, ifAbsent: () => 1);
    }

    return categoryStatistics;
  }


}

class GestionStockMatierePremierePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Matière Première Page Content'),
    );
  }
}

class Product {
  final int id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final String createdAt;
  final String updatedAt;
  final int categoryId;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.categoryId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      description: json['description'],
      imageUrl: json['image_url'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      categoryId: json['category_id'],
    );
  }
}

class Category {
  final int id;
  String name;
  String? description;

  Category({
    required this.id,
    required this.name,
    this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}






