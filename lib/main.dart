import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:fe_app/api_service.dart';
import 'package:fe_app/model/barang.dart';
import 'package:fe_app/model/negara.dart';
import 'package:fe_app/model/pelabuhan.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AutoCompleteTextField<Negara>? autoCompleteTextField;
  AutoCompleteTextField<Pelabuhan>? autoCompleteTextFieldPelabuhan;

  String selectedCountryCode =
      ''; // Menyimpan kode negara dari negara yang dipilih

  final TextEditingController _negaraController = TextEditingController();
  final TextEditingController _pelabuhanController = TextEditingController();

  final TextEditingController _queryController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _beaMasuk = TextEditingController();
  final TextEditingController _tarif = TextEditingController();
  List<Barang> _barangList = [];

  bool isInputAngkaVisible = true;

  Negara? selectedNegara;
  Pelabuhan? selectedPelabuhan;

  void handleNegaraSubmitted(Negara suggestion) async {
    // Handle when a Negara item is selected
    print('Selected Negara: ${suggestion.kdNegara} - ${suggestion.urNegara}');
    // Fetch additional details based on the selected Negara
    selectedCountryCode = suggestion.kdNegara;
    // Setel nilai controller untuk negara
    _negaraController.text = suggestion.urNegara;

    List<Negara> result = await ApiService.fetchData(suggestion.kdNegara);
    print('Details: $result');

    // Simpan nilai yang dipilih
    selectedNegara = suggestion;
  }

  void handlePelabuhanSubmitted(Pelabuhan suggestion) async {
    // Handle when a Pelabuhan item is selected
    print(
        'Selected Pelabuhan: ${suggestion.kdPelabuhan} - ${suggestion.urPelabuhan}');
    // Setel nilai controller untuk pelabuhan
    _pelabuhanController.text = suggestion.urPelabuhan;
    // Fetch additional details based on the selected Pelabuhan
    List<Pelabuhan> result = await ApiService.fetchPelabuhan(
        suggestion.kdPelabuhan, suggestion.urPelabuhan);
    print('Details: $result');

    // Simpan nilai yang dipilih
    selectedPelabuhan = suggestion;
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<AutoCompleteTextFieldState<Negara>> negaraKey = GlobalKey();
    GlobalKey<AutoCompleteTextFieldState<Pelabuhan>> pelabuhanKey = GlobalKey();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('TEST FE ILCS'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              autoCompleteTextField = AutoCompleteTextField<Negara>(
                key: negaraKey,
                clearOnSubmit: false,
                controller: _negaraController,
                suggestions: const [],
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title:
                        Text('${suggestion.kdNegara} - ${suggestion.urNegara}'),
                  );
                },
                itemSorter: (a, b) {
                  return a.urNegara.compareTo(b.urNegara);
                },
                itemFilter: (suggestion, query) {
                  return suggestion.matchesQuery(query);
                },
                itemSubmitted: (suggestion) {
                  handleNegaraSubmitted(suggestion);
                },
                decoration: const InputDecoration(
                  labelText: 'Cari Negara',
                  hintText: 'Masukkan tiga huruf pertama',
                ),
                textChanged: (query) async {
                  // Check if the length of the entered text is at least three characters
                  if (query.length >= 3) {
                    // Update suggestions based on the current query

                    List<Negara> suggestions =
                        await ApiService.fetchData(query);
                    autoCompleteTextField!.updateSuggestions(suggestions);
                  }
                },
              ),
              autoCompleteTextFieldPelabuhan = AutoCompleteTextField<Pelabuhan>(
                key: pelabuhanKey,
                clearOnSubmit: false,
                controller: _pelabuhanController,
                suggestions: const [],
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(
                        '${suggestion.kdPelabuhan} - ${suggestion.urPelabuhan}'),
                  );
                },
                itemSorter: (a, b) {
                  return a.urPelabuhan.compareTo(b.urPelabuhan);
                },
                itemFilter: (suggestion, query) {
                  return suggestion.matchesQuery(query);
                },
                itemSubmitted: (suggestion) {
                  handlePelabuhanSubmitted(suggestion);
                },
                decoration: const InputDecoration(
                  labelText: 'Cari Pelabuhan',
                  hintText: 'Masukkan tiga huruf pertama',
                ),
                textChanged: (query) async {
                  // Check if the length of the entered text is at least three characters
                  if (query.length >= 3) {
                    // Update suggestions based on the current query
                    List<Pelabuhan> suggestions =
                        await ApiService.fetchPelabuhan(
                            query, selectedCountryCode);
                    autoCompleteTextFieldPelabuhan!
                        .updateSuggestions(suggestions);
                  }
                },
              ),
              TextField(
                controller: _queryController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Barang',
                ),
                onChanged: (query) {
                  fetchData();
                },
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _barangList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_barangList[index].uraianId),
                    subtitle: Text(_barangList[index].subHeader),
                  );
                },
              ),
              TextField(
                controller: _hargaController,
                keyboardType: TextInputType.number,
                onChanged: (harga) {
                  updateTarif(); // Panggil metode updateTarif saat nilai harga berubah
                },
                decoration: const InputDecoration(
                  labelText: 'Harga',
                ),
              ),
              TextField(
                controller: _beaMasuk,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Tarif Bea Masuk',
                  suffixText: '%',
                ),
                readOnly: true,
              ),
              TextField(
                controller: _tarif,
                keyboardType: TextInputType.number,
                // decoration: const InputDecoration(
                //   labelText: 'Tarif Bea Masuk',
                //   suffixText: '%',
                // ),
                readOnly: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    try {
      int query = int.tryParse(_queryController.text) ?? 0;

      // Mengambil data barang
      List<Barang> result = await ApiService.fetchDataBarang(query);
      List<String> bm = await ApiService.fetchDataBm(query);

      setState(() {
        _barangList = result;
        _beaMasuk.text = bm.isNotEmpty ? bm.first : '';
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        _barangList = [];
      });
    }
  }

  // Metode untuk melakukan perhitungan dan memperbarui tarif
  void updateTarif() {
    double harga = double.tryParse(_hargaController.text) ?? 0;
    double tarifBeaMasuk = double.tryParse(_beaMasuk.text) ?? 0;
    double tarif = (harga * tarifBeaMasuk) / 100;
    _tarif.text = tarif.toStringAsFixed(0);
  }
}
