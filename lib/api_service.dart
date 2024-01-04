import 'dart:convert';
import 'package:fe_app/model/barang.dart';
import 'package:fe_app/model/harga.dart';
import 'package:fe_app/model/pelabuhan.dart';
import 'package:http/http.dart' as http;
import 'model/negara.dart';

class ApiService {
  static String url = "https://insw-dev.ilcs.co.id/my/n";

  static Future<List<Negara>> fetchData(String query) async {
    final response = await http.get(Uri.parse("$url/negara?ur_negara=$query"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> data = responseData['data'];

      List<Negara> negaraList =
          data.map((item) => Negara.fromJson(item)).toList();

      return negaraList;
    } else {
      throw Exception('Gagal mengambil data dari API');
    }
  }

  static Future<List<Pelabuhan>> fetchPelabuhan(
      String startsWith, String countryCode) async {
    try {
      final response = await http.get(Uri.parse(
          "$url/pelabuhan?kd_negara=$countryCode&ur_pelabuhan=$startsWith"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];

        List<Pelabuhan> pelabuhanList =
            data.map((item) => Pelabuhan.fromJson(item)).toList();

        return pelabuhanList;
      } else {
        throw Exception('Gagal mengambil data dari API');
      }
    } catch (e) {
      throw Exception('Error decoding response: $e');
    }
  }

  static Future<List<Barang>> fetchDataBarang(int query) async {
    final response = await http.get(Uri.parse("$url/barang?hs_code=$query"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> data = responseData['data'];

      List<Barang> barangList =
          data.map((item) => Barang.fromJson(item)).toList();

      return barangList;
    } else {
      throw Exception('Gagal mengambil data dari API');
    }
  }

  static Future<List<String>> fetchDataBm(int query) async {
    final response = await http.get(Uri.parse("$url/tarif?hs_code=$query"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> data = responseData['data'];

      List<String> bmList = data.map((item) {
        Harga harga = Harga.fromJson(item);
        return harga.getBmValue();
      }).toList();

      return bmList;
    } else {
      throw Exception('Gagal mengambil data dari API');
    }
  }
}
