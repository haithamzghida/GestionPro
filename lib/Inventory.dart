import 'dart:convert';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';




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
      } else if (page == 'gestion_stock/facteur') {
        // Load the Facteur page
        // You can use Navigator to push a new page or any other approach you prefer
      } else if (page == 'gestion_stock/fournisseur') {
        // Load the Fournisseur page
      } else if (page == 'gestion_stock/livraison') {
        // Load the Livraison page
      } else if (page == 'gestion_stock/users') {
        // Load the users page
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

                ListTile(
                  title: Text(
                    'Facteur',
                    style: TextStyle(
                      color: _selectedPage == 'gestion_stock/facteur' ? Colors.white : Colors.grey,
                    ),
                  ),
                  onTap: () {
                    _selectPage('gestion_stock/facteur');
                  },
                ),

                ListTile(
                  title: Text(
                    'Fournisseur',
                    style: TextStyle(
                      color: _selectedPage == 'gestion_stock/fournisseur' ? Colors.white : Colors.grey,
                    ),
                  ),
                  onTap: () {
                    _selectPage('gestion_stock/fournisseur');
                  },
                ),

                ListTile(
                  title: Text(
                    'Livraison',
                    style: TextStyle(
                      color: _selectedPage == 'gestion_stock/livraison' ? Colors.white : Colors.grey,
                    ),
                  ),
                  onTap: () {
                    _selectPage('gestion_stock/livraison');
                  },
                ),

                ListTile(
                  title: Text(
                    'users',
                    style: TextStyle(
                      color: _selectedPage == 'gestion_stock/users' ? Colors.white : Colors.grey,
                    ),
                  ),
                  onTap: () {
                    _selectPage('gestion_stock/users');
                  },
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
                :  _selectedPage == 'gestion_stock/fournisseur'
                ? GestionStockFournisseurPage()
                :  _selectedPage == 'gestion_stock/users'
                ? GestionStockUsersPage()
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

class GestionStockFournisseurPage extends StatefulWidget {
  @override
  _GestionStockFournisseurPageState createState() =>
      _GestionStockFournisseurPageState();
}

class _GestionStockFournisseurPageState
    extends State<GestionStockFournisseurPage> {
  List<Fournisseur> fournisseurs = [];
  TextEditingController soldeController = TextEditingController();
  TextEditingController avanceController = TextEditingController();
  String selectedFournisseurName = '';
  List<String> fournisseurNames = [];
  Widget? detailsTableWidget;

  // Function to show the dialog for adding a new fournisseur
  Future<void> _showAddFournisseurDialog() async {
    String nom = '';
    String tel = '';
    String email = '';
    double solde = 0.0;
    double avance = 0.0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) { // Use StatefulBuilder to update the dialog's state
          return AlertDialog(
            title: Text('Ajouter Nouveau Fournisseur'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  _buildInputRow(
                    'Nom', 'Entrez le nom',
                        (value) {
                      nom = value;
                    },
                  ),
                  _buildInputRow(
                    'Téléphone', 'Entrez le téléphone',
                        (value) {
                      tel = value;
                    },
                  ),
                  _buildInputRow(
                    'Email', 'Entrez l\'email',
                        (value) {
                      email = value;
                    },
                  ),
                  _buildInputRow(
                    'Solde', 'Entrez le solde',
                        (value) {
                      solde = double.tryParse(value) ?? 0.0;
                      setState(() {}); // Update the dialog to reflect changes
                    },
                  ),
                  _buildInputRow(
                    'Avance', 'Entrez l\'avance',
                        (value) {
                      avance = double.tryParse(value) ?? 0.0;
                      setState(() {}); // Update the dialog to reflect changes
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Reste: ${(solde - avance).toStringAsFixed(2)}', // Display 'Reste' value
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Annuler'),
              ),
              TextButton(
                onPressed: () async {
                  // Send the data to your server here
                  // You can use a POST request to add the new fournisseur
                  final response = await http.post(
                    Uri.parse('http://localhost:3000/fournisseurs'),
                    body: json.encode({
                      'nom': nom,
                      'tel': tel,
                      'email': email,
                      'solde': solde,
                      'avance': avance,
                      'reste': solde - avance, // Calculate 'Reste'
                    }),
                    headers: {'Content-Type': 'application/json'},
                  );

                  if (response.statusCode == 200) {
                    // Successfully added fournisseur
                    Navigator.of(context).pop();
                    setState(() {});
                  } else {
                    // Handle error here
                    print('Failed to add fournisseur: ${response.statusCode}');
                  }
                },
                child: Text('Enregistrer'),
              ),
            ],
          );
        });
      },
    );
  }

  Widget _buildInputRow(
      String label,
      String hintText,
      Function(String) onChanged,
      ) {
    return TextFormField(
      decoration: InputDecoration(labelText: label, hintText: hintText),
      onChanged: onChanged,
    );
  }

  // Function to show the historique popup with dropdown
  Future<void> _showHistoriquePopup() async {
    final fournisseurNames = await fetchFournisseurNames();

    if (fournisseurNames.isEmpty) {
      return;
    }

    // Initialize selectedFournisseurName with the first supplier name as a default
    selectedFournisseurName = fournisseurNames.first;

    // Fetch the fournisseur ID for the selected fournisseur name
    final fournisseurId = await fetchFournisseurId(selectedFournisseurName);

    // Fetch fournisseur details data based on the fournisseur ID
    final fournisseurDetails = await fetchFournisseurDetails(fournisseurId);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Historique'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: selectedFournisseurName,
                    hint: Text('Sélectionnez un fournisseur'),
                    items: fournisseurNames.map((String name) {
                      return DropdownMenuItem<String>(
                        value: name,
                        child: Text(name),
                      );
                    }).toList(),
                    onChanged: (String? newValue) async {
                      setState(() {
                        selectedFournisseurName = newValue!;
                      });

                      final selectedId = await fetchFournisseurId(selectedFournisseurName);
                      final details = await fetchFournisseurDetails(selectedId);

                      setState(() {
                        detailsTableWidget = _buildDetailsTable(details); // Update the detailsTableWidget
                      });
                    },
                  ),

                  SizedBox(height: 16),
                  detailsTableWidget ?? SizedBox(), // Display the updated detailsTableWidget
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Fermer'),
                ),
                // Add other actions here
              ],
            );
          },
        );
      },
    );
  }



  // Function to fetch supplier ID based on their name
  Future<int> fetchFournisseurId(String fournisseurName) async {
    final response = await http.get(Uri.parse('http://localhost:3000/fournisseurs/names'));

    if (response.statusCode == 200) {
      final dynamic parsed = json.decode(response.body);

      if (parsed is Map<String, dynamic> && parsed.containsKey('fournisseurs')) {
        final fournisseurs = List<dynamic>.from(parsed['fournisseurs']);
        final fournisseur = fournisseurs.firstWhere(
              (fournisseur) => fournisseur['nom'] == fournisseurName,
          orElse: () => null,
        );

        if (fournisseur != null && fournisseur.containsKey('id')) {
          return fournisseur['id'];
        }
      } else {
        print('Invalid data format: Missing fournisseurs key');
      }
    } else {
      print('Failed to fetch fournisseur names: ${response.statusCode}');
    }

    // Return -1 or another suitable default value if the ID is not found
    return -1;
  }

  void updateDetails() async {
    final selectedId = await fetchFournisseurId(selectedFournisseurName);
    final details = await fetchFournisseurDetails(selectedId);

    setState(() {
      detailsTableWidget = _buildDetailsTable(details);
    });
  }


  // Function to fetch supplier details based on their ID
  Future<Map<String, dynamic>> fetchFournisseurDetails(int fournisseurId) async {
    final response = await http.get(Uri.parse('http://localhost:3000/fournisseurs/$fournisseurId/details'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to fetch fournisseur details: ${response.statusCode}');
      return {};
    }
  }

  // Function to build the fournisseur details table widget
// Function to build the fournisseur details table widget
  Widget fournisseurDetailsTableWidget(Map<String, dynamic> fournisseurDetails) {
    // Create a list of rows based on the fournisseur details
    final rows = fournisseurDetails.entries.map((entry) {
      return DataRow(
        cells: [
          DataCell(Text(entry.key)),
          DataCell(Text(entry.value.toString())),
        ],
      );
    }).toList();

    return DataTable(
      columns: [
        DataColumn(label: Text('Champ')),
        DataColumn(label: Text('Valeur')),
      ],
      rows: rows,
    );
  }

  Widget _buildDetailsTable(Map<String, dynamic> fournisseurDetails) {
    final List<DataRow> rows = [];

    // Loop through the fournisseur details and add them to the table
    fournisseurDetails.forEach((key, value) {
      rows.add(
        DataRow(
          cells: [
            DataCell(Text(key)),
            DataCell(Text(value.toString())),
          ],
        ),
      );
    });

    return DataTable(
      columns: [
        DataColumn(label: Text('Champ')),
        DataColumn(label: Text('Valeur')),
      ],
      rows: rows,
    );
  }
// Function to build the details table widget based on fournisseur details
// Function to build the fournisseur details table widget
  Widget buildDetailsTable(Map<String, dynamic> fournisseurDetails) {
    final List<DataRow> rows = [];

    // Loop through the fournisseur details and add them to the table
    fournisseurDetails.forEach((key, value) {
      rows.add(
        DataRow(
          cells: [
            DataCell(Text(key)),
            DataCell(Text(value.toString())),
          ],
        ),
      );
    });

    return DataTable(
      columns: [
        DataColumn(label: Text('Champ')),
        DataColumn(label: Text('Valeur')),
      ],
      rows: rows,
    );
  }

  // Fetch fournisseur names from your Node.js server
  Future<List<String>> fetchFournisseurNames() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/fournisseurs/names'));

      if (response.statusCode == 200) {
        final dynamic parsed = json.decode(response.body);

        if (parsed is Map<String, dynamic> && parsed.containsKey('fournisseurs')) {
          final fournisseurs = List<dynamic>.from(parsed['fournisseurs']);
          final names = fournisseurs.map((fournisseur) => fournisseur['nom'].toString()).toList();
          return names;
        } else {
          print('Invalid data format: Missing fournisseurs key');
        }
      } else {
        print('Failed to fetch fournisseur names: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching fournisseur names: $e');
    }

    // Return an empty list if there was an error
    return [];
  }




  Future<List<Fournisseur>> fetchFournisseurs() async {
    try {
      final response =
      await http.get(Uri.parse('http://localhost:3000/fournisseurs'));

      if (response.statusCode == 200) {
        final dynamic parsed = json.decode(response.body);

        if (parsed is List<dynamic>) {
          // The response is already a list, so we can directly parse it
          final suppliers =
          parsed.map((json) => Fournisseur.fromJson(json)).toList();
          return suppliers;
        } else if (parsed is Map<String, dynamic> &&
            parsed.containsKey('suppliers')) {
          // Check if 'suppliers' key is present and contains a list
          final supplierList = parsed['suppliers'];

          if (supplierList is List<dynamic>) {
            // If supplierList is a list, parse it
            final suppliers =
            supplierList.map((json) => Fournisseur.fromJson(json)).toList();
            return suppliers;
          } else {
            print('Invalid data format: suppliers key is not a list');
          }
        } else {
          print(
              'Invalid data format: Missing suppliers key or unsupported format');
        }
      } else {
        print('Failed to fetch fournisseurs: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching fournisseurs: $e');
    }

    // Return an empty list if there was an error
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Gestion de Fournisseur',
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Search Bar and Button
        Container(
          color: Colors.black, // Background color
          child: Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.white, // Background color
                  child: TextField(
                    style: TextStyle(
                      color: Colors.black, // Text color
                    ),
                    decoration: InputDecoration(
                      hintText: 'Rechercher...',
                      hintStyle: TextStyle(
                        color: Colors.black, // Hint text color
                      ),
                      prefixIcon: Icon(
                        Icons.search, // Search icon
                        color: Colors.black, // Icon color
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.refresh, // Reload icon
                          color: Colors.black, // Icon color
                        ),
                        onPressed: () {
                          // Reload action
                          // You can add your reload logic here
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0), // Adjust the space as needed
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white, // Button background color
                    onPrimary: Colors.black, // Button text color
                  ),
                  onPressed: _showAddFournisseurDialog, // Show dialog on button press
                  child: Text('Ajouter nouveau fournisseur'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.0), // Adjust the space as needed
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white, // Button background color
                    onPrimary: Colors.black, // Button text color
                  ),
                  onPressed: () {
                    _showHistoriquePopup(); // Call the method to open the popup
                  },
                  child: Text('Historique'),
                ),

              ),
            ],
          ),
        ),

        // Centered DataTable with Shadow and Borders
        Expanded(
          child: Container(
            margin: EdgeInsets.all(16.0), // Add margin for spacing
            decoration: BoxDecoration(
              color: Colors.white, // Background color
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // Shadow color
                  blurRadius: 5, // Spread radius
                  offset: Offset(0, 3), // Offset in x and y
                ),
              ],
              borderRadius: BorderRadius.circular(10.0), // Border radius
            ),
            child: FutureBuilder<List<Fournisseur>>(
              future: fetchFournisseurs(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final fournisseurs = snapshot.data ?? [];
                  return DataTable(
                    columnSpacing: 20.0, // Adjust spacing between columns
                    columns: [
                      DataColumn(label: Text('Nom')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Téléphone')),
                      DataColumn(label: Text('Solde')),
                      DataColumn(label: Text('Avance')),
                      DataColumn(label: Text('Reste')),
                      DataColumn(label: Text('Créé le')),
                      DataColumn(label: Text('Modifié le')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: fournisseurs.asMap().entries.map((entry) {
                      final index = entry.key;
                      final fournisseur = entry.value;
                      final isEvenRow = index % 2 == 0;
                      final color = isEvenRow ? Colors.grey[200]! : Colors.white; // Invert colors

                      return DataRow(
                        color: MaterialStateProperty.all<Color>(color), // Gray for even rows, white for odd rows
                        cells: [
                          DataCell(Text(fournisseur.nom)),
                          DataCell(Text(fournisseur.email)),
                          DataCell(Text(fournisseur.tel)),
                          DataCell(Text(fournisseur.solde.toString())),
                          DataCell(Text(fournisseur.avance.toString())),
                          DataCell(Text(fournisseur.reste.toString())),
                          DataCell(Text(fournisseur.created_at)),
                          DataCell(Text(fournisseur.updated_at)),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    // Show a dialog to edit fournisseur details
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        // Create controllers for the input fields
                                        final TextEditingController nomController =
                                        TextEditingController(text: fournisseur.nom);
                                        final TextEditingController telController =
                                        TextEditingController(text: fournisseur.tel);
                                        final TextEditingController emailController =
                                        TextEditingController(text: fournisseur.email);
                                        final TextEditingController soldeController =
                                        TextEditingController(text: fournisseur.solde.toString());
                                        final TextEditingController avanceController =
                                        TextEditingController(text: fournisseur.avance.toString());
                                        final TextEditingController resteController =
                                        TextEditingController(text: fournisseur.reste.toString());

                                        return AlertDialog(
                                          title: Text('Modifier Fournisseur'),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                TextField(
                                                  controller: nomController,
                                                  decoration: InputDecoration(labelText: 'Nom'),
                                                ),
                                                TextField(
                                                  controller: telController,
                                                  decoration: InputDecoration(labelText: 'Téléphone'),
                                                ),
                                                TextField(
                                                  controller: emailController,
                                                  decoration: InputDecoration(labelText: 'Email'),
                                                ),
                                                TextField(
                                                  controller: soldeController,
                                                  decoration: InputDecoration(labelText: 'Solde'),
                                                  keyboardType: TextInputType.number,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      // Handle Solde change and update Reste
                                                      // Calculate Reste based on the current values of Solde and Avance
                                                      final solde = double.tryParse(value) ?? 0.0;
                                                      final avance = double.tryParse(avanceController.text) ?? 0.0;
                                                      resteController.text = (solde - avance).toStringAsFixed(2);
                                                    });
                                                  },
                                                ),
                                                TextField(
                                                  controller: avanceController,
                                                  decoration: InputDecoration(labelText: 'Avance'),
                                                  keyboardType: TextInputType.number,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      // Handle Avance change and update Reste
                                                      // Calculate Reste based on the current values of Solde and Avance
                                                      final avance = double.tryParse(value) ?? 0.0;
                                                      final solde = double.tryParse(soldeController.text) ?? 0.0;
                                                      resteController.text = (solde - avance).toStringAsFixed(2);
                                                    });
                                                  },
                                                ),
                                                TextField(
                                                  controller: resteController,
                                                  decoration: InputDecoration(labelText: 'Reste'),
                                                  keyboardType: TextInputType.number,
                                                  readOnly: true, // Make it read-only
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Annuler'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                final updatedFournisseur = {
                                                  'nom': nomController.text,
                                                  'tel': telController.text,
                                                  'email': emailController.text,
                                                  'solde': double.parse(soldeController.text),
                                                  'avance': double.parse(avanceController.text),
                                                  'reste': double.parse(resteController.text),
                                                };

                                                final response = await http.put(
                                                  Uri.parse('http://localhost:3000/fournisseurs/${fournisseur.id}'),
                                                  headers: <String, String>{
                                                    'Content-Type': 'application/json; charset=UTF-8',
                                                  },
                                                  body: jsonEncode(updatedFournisseur),
                                                );

                                                if (response.statusCode == 200) {
                                                  // Successful update, refresh the data
                                                  setState(() {
                                                    // Add the updated fournisseur to the list
                                                    fournisseurs[index] = Fournisseur.fromJson(jsonDecode(response.body));
                                                  });

                                                  Navigator.of(context).pop(); // Close the dialog
                                                } else {
                                                  print('Failed to update fournisseur: ${response.statusCode}');
                                                }
                                              },
                                              child: Text('Enregistrer'),
                                            ),
                                          ],
                                        );

                                      },
                                    );
                                  },
                                ),

                                IconButton(
                                  icon: Icon(Icons.info), // Info action
                                  onPressed: () {
                                    // Add your info action logic here
                                    // For example, show a dialog with fournisseur details
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Détails du Fournisseur'),
                                          content: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Nom: ${fournisseur.nom}'),
                                              Text('Email: ${fournisseur.email}'),
                                              Text('Téléphone: ${fournisseur.tel}'),
                                              Text('Solde: ${fournisseur.solde}'),
                                              Text('Avance: ${fournisseur.avance}'),
                                              Text('Reste: ${fournisseur.reste}'),
                                              Text('Créé le: ${fournisseur.created_at}'),
                                              Text('Modifié le: ${fournisseur.updated_at}'),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Fermer'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete), // Delete action
                                  onPressed: () async {
                                    await deleteFournisseur(fournisseur.id);
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  );

                }
              },
            ),
          ),
        ),
      ],
    );
  }

  // Function to calculate Reste based on Solde and Avance
  String calculateReste() {
    final solde = double.tryParse(soldeController.text) ?? 0.0;
    final avance = double.tryParse(avanceController.text) ?? 0.0;
    final reste = solde - avance;
    return reste.toStringAsFixed(2);
  }

  // Function to update the Reste value displayed
  void updateReste() {
    final reste = calculateReste();
    setState(() {
      soldeController.text = soldeController.text; // Rebuild the widget
      avanceController.text = avanceController.text; // Rebuild the widget
    });
  }




  Future<void> deleteFournisseur(int fournisseurId) async {
    final response = await http.delete(
      Uri.parse('http://localhost:3000/fournisseurs/$fournisseurId'),
    );

    if (response.statusCode == 200) {
      print('Fournisseur deleted successfully.');
    } else {
      print('Failed to delete fournisseur: ${response.statusCode}');
    }
  }
}

class Fournisseur {
  final int id;
  final String nom;
  final String tel;
  final String email;
  final double solde;
  final double avance;
  final double reste;
  final String created_at;
  final String updated_at;

  Fournisseur({
    required this.id,
    required this.nom,
    required this.tel,
    required this.email,
    required this.solde,
    required this.avance,
    required this.reste,
    required this.created_at,
    required this.updated_at,
  });

  factory Fournisseur.fromJson(Map<String, dynamic> json) {
    return Fournisseur(
      id: json['id'] ?? 0,  // Provide a default value (e.g., 0) for id if it's null
      nom: json['nom'] ?? '',
      tel: json['tel'] ?? '',
      email: json['email'] ?? '',
      solde: (json['solde'] as num?)?.toDouble() ?? 0.0,  // Handle null and convert to double
      avance: (json['avance'] as num?)?.toDouble() ?? 0.0,
      reste: (json['reste'] as num?)?.toDouble() ?? 0.0,
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
    );
  }

}

class GestionStockLivraisonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Livraison Page Content'),
    );
  }
}



class GestionStockUsersPage extends StatefulWidget {
  @override
  _GestionStockUsersPageState createState() => _GestionStockUsersPageState();
}

class _GestionStockUsersPageState extends State<GestionStockUsersPage> {
  List<Map<String, dynamic>> _loginInventoryData = [];
  String selectedRole = 'Super_admin'; // Default role

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String editUserId = ''; // Stores the ID of the user being edited

  @override
  void initState() {
    super.initState();
    fetchLoginInventoryData();
  }

  Future<void> fetchLoginInventoryData() async {
    final response = await http.get(Uri.parse('http://localhost:3000/login_inventory'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _loginInventoryData = List<Map<String, dynamic>>.from(data['login_inventory']);
      });
    } else {
      // Handle errors
      print('Failed to fetch login inventory data: ${response.statusCode}');
    }
  }

  Future<void> addLoginUser() async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/login_inventory'),
      body: {
        'email': emailController.text,
        'password': passwordController.text,
        'role': selectedRole,
      },
    );

    if (response.statusCode == 200) {
      // Successfully added the login user, fetch updated data
      fetchLoginInventoryData();
      print('Login user added successfully');
    } else {
      // Handle errors
      print('Failed to add login user: ${response.statusCode}');
    }
  }

  Future<void> editLoginUser() async {
    final response = await http.put(
      Uri.parse('http://localhost:3000/edit_login/$editUserId'),
      body: {
        'email': emailController.text,
        'password': passwordController.text,
        'role': selectedRole,
      },
    );

    if (response.statusCode == 200) {
      // Successfully edited the login user, fetch updated data
      fetchLoginInventoryData();
      print('Login user edited successfully');
    } else {
      // Handle errors
      print('Failed to edit login user: ${response.statusCode}');
    }
  }

  void showAddUserDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Login User'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  items: ['Super_admin', 'Gérant', 'Responsable', 'Employee']
                      .map((String role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedRole = newValue!;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Select Role'),
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                addLoginUser();
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void showEditUserDialog(Map<String, dynamic> userData) {
    // Populate the dialog fields with the user's data
    emailController.text = userData['email'];
    passwordController.text = userData['password'];
    selectedRole = userData['role'];
    editUserId = userData['id'].toString(); // Store the user's ID being edited

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Login User'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  items: ['Super_admin', 'Gérant', 'Responsable', 'Employee']
                      .map((String role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedRole = newValue!;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Select Role'),
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                editLoginUser(); // Call the edit function when the "Edit" button is pressed
                Navigator.of(context).pop();
              },
              child: Text('Edit'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteLoginUser(String id) async {
    final response = await http.delete(Uri.parse('http://localhost:3000/delete_login/$id'));

    if (response.statusCode == 200) {
      // Successfully deleted the login user, fetch updated data
      fetchLoginInventoryData();
      print('Login user deleted successfully');
    } else {
      // Handle errors
      print('Failed to delete login user: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 16.0), // Add space above the button
          Align(
            alignment: Alignment.centerLeft, // Align the button to the left
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0), // Add left padding for the text
                  child: Text(
                    'Gestion Utilisateur',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20.0,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(2.0, 2.0),
                          blurRadius: 2.0,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: ElevatedButton(
                    onPressed: showAddUserDialog,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      elevation: 5.0,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Ajouter un compte"),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: Card(
              elevation: 5.0,
              margin: EdgeInsets.all(16.0),
              child: DataTable(
                columnSpacing: 16.0,
                headingRowColor: MaterialStateColor.resolveWith((states) => Colors.black.withOpacity(0.1)),
                dataRowHeight: 60.0,
                headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                columns: [
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Password')),
                  DataColumn(label: Text('Role')),
                  DataColumn(label: Text('Created_at')),
                  DataColumn(label: Text('Updated_at')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: _loginInventoryData.map((item) {
                  final id = item['id'].toString();
                  return DataRow(cells: [
                    DataCell(Text(item['email'])),
                    DataCell(Text(item['password'])),
                    DataCell(Text(item['role'])),
                    DataCell(Text(item['created_at'])),
                    DataCell(Text(item['updated_at'])),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Call the edit function with the user's data when the edit icon is pressed
                            showEditUserDialog(item);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            // Call the delete function when the delete icon is pressed
                            deleteLoginUser(item['id'].toString());
                          },
                        ),
                  IconButton(
                  icon: Icon(Icons.info),
                  onPressed: () {
                  //
                    
                  },
                  ),

                      ],
                    )),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
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
                                    'Cout de Production', // Add the new column header
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Profit', // Add the new column header
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
                                      Text(product.coutDeProduction.toStringAsFixed(2), style: TextStyle(color: Colors.black, fontSize: 16)),
                                    ),
                                    DataCell(
                                      Text(product.profit.toStringAsFixed(2), style: TextStyle(color: Colors.black, fontSize: 16)),
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
                                              _showEditProductDialog(context, product);
                                            },
                                          ),

                                          GestureDetector(
                                            onTap: () {
                                              // Show a confirmation dialog before deleting
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text('Confirm Deletion'),
                                                    content: Text('Are you sure you want to delete this product?'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: Text('Cancel'),
                                                        onPressed: () {
                                                          Navigator.of(context).pop(); // Close the dialog
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Text('Delete'),
                                                        onPressed: () {
                                                          Navigator.of(context).pop(); // Close the dialog
                                                          // Send DELETE request to delete the product
                                                          deleteProduct(product.id);
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              color: Colors.white, // Set the color of the container to black
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.black, // Set the color of the icon to white (or any desired color)
                                                ),
                                                onPressed: null, // The actual deletion is handled in the onTap callback
                                              ),
                                            ),
                                          ),



                                          GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return SimpleDialog(
                                                    title: Text('Product Information'),
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Image.network(product.imageUrl),
                                                          SizedBox(height: 16.0),
                                                          Text('Name: ${product.name}'),
                                                          Text('Price: \$${product.price.toStringAsFixed(2)}'),
                                                          Text('Description: ${product.description}'),
                                                          // Add more product information here
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: IconButton(
                                              icon: Icon(Icons.info),
                                              onPressed: null,
                                            ),
                                          ),

                                          Switch(
                                            value: product.isAvailable,
                                            onChanged: (newValue) {
                                              // Update the local state
                                              setState(() {
                                                product.isAvailable = newValue;
                                              });

                                              // Send a PUT request to update the "disponibilite" column on the server
                                              updateProductAvailability(product.id, newValue);
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

  Future<void> updateProductAvailability(int productId, bool isAvailable) async {
    final url = 'http://localhost:3000/products/$productId/disponibilite';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'isToggled': isAvailable}),
      );

      if (response.statusCode == 200) {
        // Success, you can handle it as needed
        print('Product availability updated successfully');
      } else {
        // Handle errors
        print('Failed to update product availability: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Failed to update product availability: $e');
    }
  }


  Future<void> _showEditProductDialog(BuildContext context, Product product) async {
    final TextEditingController nameController = TextEditingController(text: product.name);
    final TextEditingController priceController = TextEditingController(text: product.price.toStringAsFixed(2));
    final TextEditingController descriptionController = TextEditingController(text: product.description);
    final TextEditingController imageUrlController = TextEditingController(text: product.imageUrl);
    final TextEditingController coutDeProductionController = TextEditingController(text: product.coutDeProduction.toStringAsFixed(2));
    final TextEditingController profitController = TextEditingController(text: (product.price - product.coutDeProduction).toStringAsFixed(2));

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Product'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: imageUrlController,
                  decoration: InputDecoration(labelText: 'Image URL'),
                ),
                TextField(
                  controller: coutDeProductionController,
                  decoration: InputDecoration(labelText: 'Coût de Production'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final double price = double.tryParse(priceController.text) ?? 0.0;
                    final double coutDeProduction = double.tryParse(value) ?? 0.0;
                    profitController.text = (price - coutDeProduction).toStringAsFixed(2);
                  },
                ),
                TextField(
                  controller: profitController,
                  decoration: InputDecoration(labelText: 'Profit'),
                  keyboardType: TextInputType.number,
                  readOnly: true, // Make it read-only
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Extract data from controllers
                    final String name = nameController.text;
                    final double price = double.tryParse(priceController.text) ?? 0.0;
                    final String description = descriptionController.text;
                    final String imageUrl = imageUrlController.text;
                    final double coutDeProduction = double.tryParse(coutDeProductionController.text) ?? 0.0;

                    // Check for valid input
                    if (name.isEmpty || price <= 0.0 || description.isEmpty || imageUrl.isEmpty) {
                      // Show an error message or handle validation as needed
                      return;
                    }

                    // Calculate profit
                    final double profit = double.tryParse(profitController.text) ?? 0.0;

                    // Create a map with the updated product data
                    final Map<String, dynamic> updatedProductData = {
                      'name': name,
                      'price': price,
                      'description': description,
                      'image_url': imageUrl,
                      'cout_de_production': coutDeProduction,
                      'profit': profit,
                    };

                    // Update the product on the server
                    try {
                      final response = await http.put(
                        Uri.parse('http://localhost:3000/products/${product.id}'),
                        headers: {'Content-Type': 'application/json'},
                        body: jsonEncode(updatedProductData),
                      );

                      if (response.statusCode == 200) {
                        // Product updated successfully
                        print('Product updated successfully.');
                      } else {
                        // Handle errors
                        print('Failed to update product: ${response.statusCode}');
                      }
                    } catch (e) {
                      // Handle exceptions
                      print('Failed to update product: $e');
                    }

                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: Text('Update'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  Future<void> deleteProduct(int productId) async {
    final response = await http.delete(
      Uri.parse('http://localhost:3000/products/$productId'),
    );

    if (response.statusCode == 200) {
      // Product deleted successfully
      // You can update your UI or show a confirmation message
    } else {
      // Handle errors or show an error message
      print('Failed to delete product. Status code: ${response.statusCode}');
    }
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image, // Restrict to image files
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      if (file.bytes != null) {
        // You can access the selected image bytes using 'file.bytes'
        // Now you can work with the selected image bytes as needed.
        print('Selected file bytes length: ${file.bytes!.length}');
      } else {
        // Handle the case where 'file.bytes' is null
        print('Selected file does not have bytes.');
      }
    } else {
      // User canceled the file picker
      print('User canceled image selection.');
    }
  }


  Future<void> _showRemoveCategoryDialog(Category category) async {
    // Check if the category has associated products
    final hasProducts = widget.products.any((product) => product.categoryId == category.id);

    if (hasProducts) {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Cannot Remove Category'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('The category "${category.name}" cannot be removed because it has associated products.'),
                  SizedBox(height: 8.0),
                  Text('Delete the associated products first.'),
                ],
              ),
            ),
            actions: <Widget>[
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
    } else {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
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
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  // Perform the removal action here
                  await _removeCategory(category);
                  Navigator.of(context).pop();
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
  }

  Future<void> _showAddProductPopup(BuildContext context) async {
    Category? selectedCategory;
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController imageUrlController = TextEditingController();
    final TextEditingController coutDeProductionController = TextEditingController();
    final TextEditingController profitController = TextEditingController();

    // Create a listener to calculate profit when Price or Cout de Production changes
    priceController.addListener(() {
      final double price = double.tryParse(priceController.text) ?? 0.0;
      final double coutDeProduction = double.tryParse(coutDeProductionController.text) ?? 0.0;
      final double profit = price - coutDeProduction;
      // Update the profitController text
      profitController.text = profit.toStringAsFixed(2);
    });

    coutDeProductionController.addListener(() {
      final double price = double.tryParse(priceController.text) ?? 0.0;
      final double coutDeProduction = double.tryParse(coutDeProductionController.text) ?? 0.0;
      final double profit = price - coutDeProduction;
      profitController.text = profit.toStringAsFixed(2);
    });

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Product'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DropdownButton<Category>(
                  value: selectedCategory,
                  hint: Text('Select a category'),
                  onChanged: (Category? category) {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  items: [
                    DropdownMenuItem<Category>(
                      value: null,
                      child: Text('Select a category'),
                    ),
                    ...widget.categories.map<DropdownMenuItem<Category>>((category) {
                      return DropdownMenuItem<Category>(
                        value: category,
                        child: Text(category.name),
                      );
                    }).toList(),
                  ],
                ),

                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: imageUrlController,
                  decoration: InputDecoration(labelText: 'Image URL'),
                ),
                TextField(
                  controller: coutDeProductionController,
                  decoration: InputDecoration(labelText: 'Coût de Production'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: profitController,
                  decoration: InputDecoration(labelText: 'Profit'),
                  keyboardType: TextInputType.number,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final String name = nameController.text;
                    final double price = double.tryParse(priceController.text) ?? 0.0;
                    final String description = descriptionController.text;
                    final String imageUrl = imageUrlController.text;
                    final double coutDeProduction = double.tryParse(coutDeProductionController.text) ?? 0.0;
                    final double profit = double.tryParse(profitController.text) ?? 0.0;

                    // Check for valid input and create the product data
                    if (selectedCategory == null ||
                        name.isEmpty ||
                        price <= 0.0 ||
                        description.isEmpty ||
                        imageUrl.isEmpty) {
                      // Show an error message or handle validation as needed
                      return;
                    }

                    // Create a map with the product data
                    final Map<String, dynamic> productData = {
                      'name': name,
                      'price': price,
                      'description': description,
                      'image_url': imageUrl,
                      'category_id': selectedCategory?.id ?? -1,
                      'cout_de_production': coutDeProduction,
                      'profit': profit,
                    };

                    try {
                      final response = await http.post(
                        Uri.parse('http://localhost:3000/products'),
                        headers: {'Content-Type': 'application/json'},
                        body: jsonEncode(productData),
                      );

                      if (response.statusCode == 200) {
                        // Product added successfully
                        final dynamic parsed = json.decode(response.body);
                        final productId = parsed['productId'];
                        print('Product added successfully. Product ID: $productId');
                      } else {
                        // Handle errors
                        print('Failed to add product: ${response.statusCode}');
                      }
                    } catch (e) {
                      // Handle exceptions
                      print('Failed to add product: $e');
                    }

                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: Text('Add'),
                ),
              ],
            ),
          ),
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
              _showAddProductPopup(context); // Call the function to show the popup
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
  bool isAvailable;
  double coutDeProduction; // Added property
  double profit; // Added property

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.categoryId,
    required this.isAvailable,
    required this.coutDeProduction, // Initialize the property
    required this.profit, // Initialize the property
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'] != null ? json['price'].toDouble() : 0.0,
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      categoryId: json['category_id'] != null ? json['category_id'] : -1,
      isAvailable: json['isAvailable'] ?? false,
      coutDeProduction: json['cout_de_production'] != null ? json['cout_de_production'].toDouble() : 0.0,
      profit: json['profit'] != null ? json['profit'].toDouble() : 0.0,
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







