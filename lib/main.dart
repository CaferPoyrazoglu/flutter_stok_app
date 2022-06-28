// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_stok/delay_effect.dart';
import 'package:flutter_stok/splash.dart';
import 'package:flutter_stok/theme.dart';
import 'package:flutter_stok/urun_model.dart';
import 'api_service.dart';

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
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _getData() async {
    _urunModel = (await ApiService().getUrunler())!;
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  late List<UrunModel>? _urunModel = [];
  @override
  void initState() {
    super.initState();
    _getData();
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();
  final TextEditingController _barkodController = TextEditingController();
  final TextEditingController _adetController = TextEditingController();

  void _showForm(bool check,
      [marka, String? urunAd, String? barkod, String? stok]) async {
    if (check) {
      _titleController.text = marka;
      _descriptionController.text = urunAd!;
      _barkodController.text = barkod!;
      _stokController.text = stok.toString();
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
                  if (!check)
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
                      if (!check) {
                        await addUrun(
                            _titleController.text,
                            _descriptionController.text,
                            _barkodController.text,
                            _stokController.text);
                      }

                      if (check) {
                        await editUrun(
                            _titleController.text,
                            _descriptionController.text,
                            _barkodController.text,
                            _stokController.text);
                      }

                      Navigator.of(context).pop();
                    },
                    child: Text(!check ? 'Ürünü Ekle' : 'Update'),
                  )
                ],
              ),
            ));
  }

  void _showSatis(int stok, String barkod) async {
    _barkodController.text = barkod;

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
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
                      satUrun(_barkodController.text,
                          int.parse(_adetController.text), stok);
                      _titleController.text = '';
                      _descriptionController.text = '';
                      _stokController.text = '';
                      _barkodController.text = '';

                      Navigator.of(context).pop();
                    },
                    child: const Text('Satış Yap'),
                  )
                ],
              ),
            ));
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
      body: _urunModel == null || _urunModel!.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _urunModel![0].urunler.length,
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
                            Row(
                              children: [
                                Text(_urunModel![0].urunler[index].marka + ": ",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                Text(_urunModel![0].urunler[index].urunAd,
                                    style: const TextStyle(
                                        fontFamily: "Varela",
                                        color: Colors.black)),
                              ],
                            ),
                            Row(
                              children: [
                                const Text("Barkod: ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                Text(_urunModel![0].urunler[index].barkod,
                                    style: const TextStyle(
                                        fontFamily: "Varela",
                                        color: Colors.black)),
                              ],
                            ),
                            Row(
                              children: [
                                const Text("Stok Sayısı: ",
                                    style: TextStyle(
                                        fontFamily: "Varela",
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                    _urunModel![0]
                                        .urunler[index]
                                        .stok
                                        .toString(),
                                    style:
                                        const TextStyle(color: Colors.black)),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.money,
                                  color: Colors.black54,
                                ),
                                onPressed: () => _showSatis(
                                    _urunModel![0].urunler[index].stok,
                                    _urunModel![0].urunler[index].barkod),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.black54,
                                ),
                                onPressed: () => _showForm(
                                    true,
                                    _urunModel![0].urunler[index].marka,
                                    _urunModel![0].urunler[index].urunAd,
                                    _urunModel![0].urunler[index].barkod,
                                    _urunModel![0]
                                        .urunler[index]
                                        .stok
                                        .toString()),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.black54,
                                ),
                                onPressed: () async {
                                  getData(_urunModel![0].urunler[index].barkod);
                                },
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
      floatingActionButton: DelayedDisplay(
        delay: const Duration(milliseconds: 400),
        child: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () => _showForm(false),
          child: const Icon(
            Icons.add,
            size: 32,
          ),
        ),
      ),
    );
  }

  Future getData(urunNo) async {
    await ApiService().deleteUrun(urunNo);
    _urunModel = (await ApiService().getUrunler())!;
    setState(() {
      _urunModel = _urunModel;
    });
  }

  Future addUrun(marka, urunAd, barkod, stok) async {
    await ApiService().addUrun(marka, urunAd, barkod, stok);
    _urunModel = (await ApiService().getUrunler())!;
    setState(() {
      _urunModel = _urunModel;
    });
  }

  Future satUrun(barkod, satis, int stok) async {
    print(barkod + satis.toString() + stok.toString());
    await ApiService().sellUrun(barkod, satis, stok);
    _urunModel = (await ApiService().getUrunler())!;
    setState(() {
      _urunModel = _urunModel;
    });
  }

  Future editUrun(marka, urunAd, barkod, stok) async {
    await ApiService().updateUrun(marka, urunAd, barkod, stok);
    _urunModel = (await ApiService().getUrunler())!;
    setState(() {
      _urunModel = _urunModel;
    });
  }
}
