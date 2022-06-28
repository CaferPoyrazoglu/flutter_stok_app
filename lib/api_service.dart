import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'urun_model.dart';

class ApiService {
  Future<List<UrunModel>?> getUrunler() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<UrunModel> _model = urunModelFromJson(response.body);

        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<List<UrunModel>?> deleteUrun(deleteUrun) async {
    http.post(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.deleteEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'barkod': deleteUrun,
      }),
    );
    return null;
  }

  Future<List<UrunModel>?> addUrun(marka, urunAd, barkod, stok) async {
    print(marka + urunAd + barkod + stok);
    http.post(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.addEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'marka': marka,
        'urunAd': urunAd,
        'barkod': barkod,
        'stok': stok,
      }),
    );
    return null;
  }

  Future<List<UrunModel>?> sellUrun(barkod, satis, int stok) async {
    http.post(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.satEndPoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'barkod': barkod,
        'satis': satis.toString(),
        'stok': stok.toString()
      }),
    );
    return null;
  }
}
