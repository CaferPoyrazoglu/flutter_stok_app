// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_stok/delay_effect.dart';
import 'package:flutter_stok/splash.dart';
import 'package:flutter_stok/theme.dart';

import 'sql_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Stok App',
      theme: MyTheme.myTheme,
      home: const SplashScreen(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // All journals
  List<Map<String, dynamic>> _journals = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals(); // Loading the diary when the app starts
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();
  final TextEditingController _barkodController = TextEditingController();
  final TextEditingController _adetController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingJournal =
          _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['title'];
      _descriptionController.text = existingJournal['description'];
      _stokController.text = existingJournal['stok'].toString();
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                // this will prevent the soft keyboard from covering the text fields
                bottom: MediaQuery.of(context).viewInsets.bottom + 120,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(hintText: 'Marka'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(hintText: 'Ürün Adı'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _barkodController,
                    decoration: const InputDecoration(hintText: 'Barkod'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _stokController,
                    decoration: const InputDecoration(
                      hintText: 'Stok Adeti',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Save new journal
                      if (id == null) {
                        await _addItem();
                      }

                      if (id != null) {
                        await _updateItem(id);
                      }

                      // Clear the text fields
                      _titleController.text = '';
                      _descriptionController.text = '';
                      _stokController.text = '';
                      _barkodController.text = '';

                      // Close the bottom sheet
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    },
                    child: Text(id == null ? 'Ürünü Ekle' : 'Update'),
                  )
                ],
              ),
            ));
  }

  void _showSatis() async {
    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                // this will prevent the soft keyboard from covering the text fields
                bottom: MediaQuery.of(context).viewInsets.bottom + 120,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _barkodController,
                    decoration: const InputDecoration(hintText: 'Barkod'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                      controller: _adetController,
                      decoration:
                          const InputDecoration(hintText: 'Satış Adeti'),
                      keyboardType: TextInputType.number),
                  ElevatedButton(
                    onPressed: () async {
                      _urunSat(_barkodController.text,
                          int.parse(_adetController.text));
                    },
                    child: const Text('Satış Yap'),
                  )
                ],
              ),
            ));
  }

// Insert a new journal to the database
  Future<void> _addItem() async {
    await SQLHelper.createItem(
        _titleController.text,
        _descriptionController.text,
        _stokController.text,
        _barkodController.text);
    _refreshJournals();
  }

  // Update an existing journal
  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(
        id,
        _titleController.text,
        _descriptionController.text,
        int.parse(_stokController.text),
        _barkodController.text);
    _refreshJournals();
  }

  Future<void> _urunSat(String barkod, int adet) async {
    await SQLHelper.satisYap(barkod, adet);
    _refreshJournals();
    setState(() {});
  }

  // Delete an item
  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a journal!'),
    ));
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const DelayedDisplay(
          delay: Duration(milliseconds: 100),
          child: Text(
            'Stok Takip App',
            style: TextStyle(
                fontFamily: "Varela", color: Colors.black, fontSize: 26.0),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _journals.length,
              itemBuilder: (context, index) => DelayedDisplay(
                delay: Duration(milliseconds: 700),
                child: Container(
                  height: deviceHeight(context) * 0.18,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12, width: 2),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 205, 205, 205),
                          offset: Offset(0.0, 0.0), //(x,y)
                          blurRadius: 32.5,
                        )
                      ],
                      color: Colors.white),
                  margin: const EdgeInsets.all(15),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // ignore: prefer_interpolation_to_compose_strings

                            Row(
                              children: [
                                Text(_journals[index]['title'] + ": ",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                Text(_journals[index]['description'],
                                    style: const TextStyle(
                                        fontFamily: "Varela",
                                        color: Colors.black)),
                              ],
                            ),

                            // ignore: prefer_interpolation_to_compose_strings
                            Row(
                              children: [
                                const Text("Barkod: ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                Text(_journals[index]['barkod'],
                                    style: const TextStyle(
                                        fontFamily: "Varela",
                                        color: Colors.black)),
                              ],
                            ),

                            // ignore: prefer_interpolation_to_compose_strings
                            Row(
                              children: [
                                const Text(
                                    // ignore: prefer_interpolation_to_compose_strings
                                    "Stok Sayısı: ",
                                    style: TextStyle(
                                        fontFamily: "Varela",
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                    // ignore: prefer_interpolation_to_compose_strings

                                    _journals[index]['stok'].toString(),
                                    style:
                                        const TextStyle(color: Colors.black)),
                              ],
                            ),
                          ],
                        ),
                        // ignore: avoid_unnecessary_containers
                        Container(
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.black54,
                                ),
                                onPressed: () =>
                                    _showForm(_journals[index]['id']),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.black54,
                                ),
                                onPressed: () =>
                                    _deleteItem(_journals[index]['id']),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: DelayedDisplay(
        delay: const Duration(milliseconds: 400),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              right: 30,
              bottom: 20,
              child: FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: () => _showSatis(),
                // ignore: sort_child_properties_last
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  size: 32,
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              right: 30,
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: () => _showForm(null),
                // ignore: sort_child_properties_last
                child: const Icon(
                  Icons.add,
                  size: 32,
                ),
              ),
            ),
            // Add more floating buttons if you want
            // There is no limit
          ],
        ),
      ),
    );
  }
}
